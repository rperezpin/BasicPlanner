{
    'name': 'Gestión Psicóloga',
    'version': '1.0',
    'category': 'Healthcare',
    'summary': 'Gestión de pacientes, sesiones e historiales para psicólogos',
    'author': 'TuNombre',
    'depends': ['base', 'contacts', 'account'],
    'data': [
        'security/ir.model.access.csv',
        'views/paciente_views.xml',        # Primero las vistas con acciones
        'views/psicologa_views.xml',       # Luego los menús que las usan
    ],
    'installable': True,
    'application': True,
}