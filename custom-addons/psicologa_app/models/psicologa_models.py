# -*- coding: utf-8 -*-
from odoo import models, fields, api
from datetime import timedelta, datetime
from dateutil.parser import parse as parse_date

class PsicologaPaciente(models.Model):
    _inherit = 'res.partner'

    es_paciente = fields.Boolean(string="¿Es paciente?", default=True)
    edad = fields.Integer(string='Edad')
    genero = fields.Selection([
        ('masculino', 'Masculino'),
        ('femenino', 'Femenino'),
        ('otro', 'Otro')
    ], string='Género')
    antecedentes = fields.Text(string='Antecedentes')
    historial_ids = fields.One2many('psicologa.historial', 'paciente_id', string='Historial Clínico')
    sesion_ids = fields.One2many('psicologa.sesion', 'paciente_id', string='Sesiones')


class PsicologaSesion(models.Model):
    _name = 'psicologa.sesion'
    _description = 'Sesión de Psicología'
    _order = 'fecha desc'

    paciente_id = fields.Many2one(
        'res.partner',
        domain="[('es_paciente', '=', True)]",
        string='Paciente',
        required=True,
        ondelete='restrict'
    )
    fecha = fields.Datetime(string='Fecha', default=fields.Datetime.now)
    duracion = fields.Float(string='Duración (horas)', default=1.0)
    notas = fields.Text(string='Notas de la sesión')
    factura_id = fields.Many2one('account.move', string='Factura asociada')
    evento_id = fields.Many2one('calendar.event', string='Evento en Calendario', ondelete='set null')

    @api.model
    def create(self, vals):
        # Evitar crear el evento si viene del evento
        if self.env.context.get('from_calendar_event'):
            return super().create(vals)

        sesion = super().create(vals)

        # Crear evento en calendario
        if sesion.fecha and sesion.paciente_id:
            evento = self.env['calendar.event'].with_context(from_psicologa_sesion=True).create({
                'name': f"Sesión con {sesion.paciente_id.name}",
                'start': sesion.fecha,
                'stop': sesion.fecha + timedelta(hours=sesion.duracion or 1.0),
                'partner_ids': [(6, 0, [sesion.paciente_id.id])],
                'description': sesion.notas,
                'psicologa_sesion_id': sesion.id,
            })

            # 🔥 Eliminar al usuario actual si fue agregado automáticamente
            current_user_partner = self.env.user.partner_id
            if current_user_partner and current_user_partner.id != sesion.paciente_id.id:
                evento.partner_ids = [(3, current_user_partner.id)]
            sesion.evento_id = evento.id

        return sesion


class CalendarEvent(models.Model):
    _inherit = 'calendar.event'

    psicologa_sesion_id = fields.Many2one('psicologa.sesion', string="Sesión vinculada", ondelete='set null')

    @api.model
    def create(self, vals):
        # Evitar crear sesión si viene desde la sesión
        if self.env.context.get('from_psicologa_sesion'):
            return super().create(vals)

        event = super().create(vals)

        if vals.get('name') and vals.get('partner_ids'):
            partner_ids = []
            for cmd in vals.get('partner_ids', []):
                if cmd[0] == 6:
                    partner_ids = cmd[2]
                elif cmd[0] == 4:
                    partner_ids.append(cmd[1])

            if partner_ids:
                paciente_id = partner_ids[1]
                start = vals.get('start')
                stop = vals.get('stop')

                # Convertir a datetime si vienen como string
                if isinstance(start, str):
                    start = parse_date(start)
                if isinstance(stop, str):
                    stop = parse_date(stop)

                duracion = ((stop - start).total_seconds() / 3600) if start and stop else 1.0

                sesion = self.env['psicologa.sesion'].with_context(from_calendar_event=True).create({
                    'paciente_id': paciente_id,
                    'fecha': start,
                    'duracion': duracion,
                    'notas': vals.get('description', ''),
                    'evento_id': event.id
                })
                event.psicologa_sesion_id = sesion.id

        return event


    def write(self, vals):
        res = super().write(vals)

        for event in self:
            sesion = event.psicologa_sesion_id
            if sesion:
                sesion_vals = {}
                start = vals.get('start')
                stop = vals.get('stop')

                if start:
                    sesion_vals['fecha'] = start
                if start and stop:
                    # Asegúrate de que ambos sean datetime
                    if isinstance(start, str):
                        start = parse_date(start)
                    if isinstance(stop, str):
                        stop = parse_date(stop)
                    sesion_vals['duracion'] = ((stop - start).total_seconds()) / 3600

                if 'description' in vals:
                    sesion_vals['notas'] = vals['description']

                if 'partner_ids' in vals:
                    partner_ids = []
                    for cmd in vals.get('partner_ids', []):
                        if cmd[0] == 6:
                            partner_ids = cmd[2]
                        elif cmd[0] == 4:
                            partner_ids.append(cmd[1])

                    if partner_ids:
                        sesion_vals['paciente_id'] = partner_ids[1]

                if sesion_vals:
                    sesion.write(sesion_vals)

        return res


class PsicologaHistorial(models.Model):
    _name = 'psicologa.historial'
    _description = 'Historial Clínico'
    _order = 'fecha desc'

    paciente_id = fields.Many2one(
        'res.partner',
        domain="[('es_paciente', '=', True)]",
        string='Paciente',
        required=True,
        ondelete='restrict'
    )
    fecha = fields.Date(string='Fecha', default=fields.Date.today)
    descripcion = fields.Text(string='Descripción')
    documento = fields.Binary(string='Adjunto')
    nombre_documento = fields.Char(string='Nombre del documento')
