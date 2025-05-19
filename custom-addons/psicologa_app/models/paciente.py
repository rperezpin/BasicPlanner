from odoo import models, fields

class PsicologaPaciente(models.Model):
    _name = 'psicologa.paciente'
    _description = 'Paciente de psicóloga'

    name = fields.Char(string='Nombre', required=True)
    age = fields.Integer(string='Edad')
    email = fields.Char(string='Correo electrónico')
