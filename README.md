<h1 align="center">
    UNLaM Calendar [WIP]
</h1>

<p align="center">
    <strong>Proyecto que autogenera y publica calendarios a partir de los eventos <br />del <a href="https://www.unlam.edu.ar/calendario-academico/" target="_blank">calendario oficial</a> de la <a href="https://www.unlam.edu.ar/" target="_blank">Universidad Nacional de La Matanza</a>.</strong>
</p>

<p align="center">
    <a href="#qué-es">Qué es</a> •
		<a href="#cómo-contribuir">Cómo contribuir</a> •
    <a href="#estructura-del-proyecto">Estructura del proyecto</a> •
		<a href="#material-adicional">Material adicional</a> •
    <a href="#licencia">Licencia</a> •
    <a href="#contacto">Contacto</a>
</p>

<p align="center">
		<!-- TODO: agregar link a la página oficial cuando esté disponible -->
    <a href="#" target="_blank">
			<img src="./.github/docs/assets/unlam-calendar-logo.png" alt='Logo de "UNLaM Calendar"' width="800">
			<br />
			Página oficial
		</a>
</p>

## Qué es

UNLaM Calendar es un proyecto compuesto por un [Backend](./backend/) que extrae automáticamente los eventos del [calendario oficial](https://www.unlam.edu.ar/calendario-academico/) de la [Universidad Nacional de La Matanza (UNLaM)](https://www.unlam.edu.ar/) para generar calendarios en diferentes servicios, cómo [Google Calendar](https://calendar.google.com/), con los eventos de los departamentos de la universidad. Además, posee un [Frontend](./frontend/) que permite a los estudiantes suscribirse a dichos calendarios en base al departamento al cual pertenece su carrera.

> [!NOTE]
> Si el calendario ya había sido generado, el Backend añade los nuevos eventos y modifica los existentes (si es necesario).

### Servicios soportados

- [Google Calendar](https://calendar.google.com/)

### Beneficios para los estudiantes

- Suprime la redundancia de agendar alertas a mano para cada evento que consideren importante.
- Evita que tengan que ingresar manualmente las fechas importantes en sus calendarios personales.
- Automatiza el proceso de actualización de los calendarios, asegurando que siempre tengan la información más reciente.

## Cómo contribuir

Para contribuir a este proyecto, lee la [guía de contribución](./CONTRIBUTING.md) en donde se detallan: los pasos para instalarlo localmente, la guía de cómo debes realizar una Pull Request y cómo la misma puede ser integrada al proyecto.

## Estructura del proyecto

```bash
UNLaM-Calendar/
│
├── .devcontainer/                # Archivos de configuración del DevContainer.
│
├── .github/
│   ├── CODEOWNERS                # Archivo para asignar a los responsables de revisión de Pull Request(s) e Issue(s).
│   ├── dependabot.yml            # Configuración del Dependabot (actualizaciones automáticas de dependencias).
│   ├── PULL_REQUEST_TEMPLATE.md  # Plantilla para Pull Request(s).
│   │
│   ├── docs/                     # Documentación técnica y archivos multimedia del proyecto.
│   ├── ISSUE_TEMPLATE/           # Plantillas para Issue(s).
│   └── workflows/                # Flujos de trabajo de GitHub Actions (CI/CD).
│
├── .vscode/
│   └── launch.json               # Configuraciones de depuración.
│
├── backend/                      # Código del Backend.
├── frontend/                     # Código del Frontend.
│
├── scripts/
│   ├── health-check.sh           # Script para comprobar que las herramientas necesarias estén instaladas.
│   ├── run-tests.sh              # Script para ejecutar los tests del Frontend y Backend.
│   └── setup-local-env.sh        # Script para configurar el entorno de desarrollo local.
│
├── .editorconfig                 # Configuración para estandarizar el estilo de código entre diferentes IDEs.
├── .gitattributes                # Configuración para los atributos de Git.
├── .gitignore                    # Listado con todos los archivos y carpetas que Git debe ignorar.
├── .gitleaks.toml                # Configuración de Gitleaks (herramienta para detectar filtración de secretos).
├── .prettierignore               # Listado con todos los archivos y carpetas que Prettier debe ignorar.
├── .prettierrc                   # Configuración de Prettier (formateador de código).
├── biome.json                    # Configuración de Biome (linter y formateador de código).
├── CONTRIBUTING.md               # Guía para contribuir al proyecto.
├── cspell.json                   # Configuración de la extensión Code Spell Checker.
├── lefthook.yml                  # Configuración de Lefthook (Git hooks manager).
├── LICENSE                       # Licencia del proyecto.
├── README.md                     # Este archivo.
└── zizmor.yml                    # Configuración de Zizmor (linter de `dependabot.yml` y GitHub Actions).
```

> [!TIP]
> Si deseas conocer más información sobre las arquitecturas y tecnologías utilizadas en el Frontend y Backend, consulta la [documentación del Frontend](./frontend/) o la [documentación del Backend](./backend/) respectivamente.

## Material adicional

- [Guía de contribución](./CONTRIBUTING.md)
- [Documentación técnica (relevamiento de requerimientos, diagramas, etc.)](./.github/docs/)

## Licencia

Este proyecto está bajo la [licencia GNU AGPLv3](./LICENSE). Para más información sobre lo que está permitido hacer con el contenido de este proyecto, visita [choosealicense.com](https://choosealicense.com/licenses/).

## Contacto

Si deseas contactarme, consulta mis [redes sociales](https://github.com/hozlucas28) en mi perfil de GitHub.
