# create-mern-agents

CLI oficial para inicializar el **MERN Agents Framework**, un sistema de agentes para acelerar el desarrollo de proyectos MERN + Next.js + TypeScript mediante GitHub Copilot.

## 🚀 Instalación

No requiere instalación global.  
Ejecuta:

```bash
npx create-mern-agents
```

### Opciones disponibles

```bash
# Instalación estándar (interactiva)
npx create-mern-agents

# Modo minimal - Solo agentes CORE para MVP (6-7 agentes)
npx create-mern-agents --minimal

# Con template específico
npx create-mern-agents --template=pwa-offline
npx create-mern-agents --template=saas-platform
npx create-mern-agents --template=ecommerce
```

## 🤖 Selección Inteligente de Agentes

El script ahora descarga **solo los agentes necesarios** según:

- **Tamaño del proyecto** (Pequeño/Mediano/Grande)
- **Features habilitadas** (Auth, Payments, AI, PWA)
- **Complejidad de datos** (número de entidades)
- **CI/CD** (GitHub Actions)

### Ejemplos:

- **MVP pequeño**: 6-7 agentes
- **Startup mediana**: 8-13 agentes  
- **Empresa grande**: 10-15 agentes

Ver [AGENTS.md](./AGENTS.md) para detalles completos.

## 📦 Gestión de Agentes

### Agregar agentes individuales

Si tu proyecto crece, puedes agregar agentes específicos sin reinstalar todo:

```bash
# Ver agentes disponibles
npx create-mern-agents list

# Agregar un agente específico
npx create-mern-agents add security-guardian

# Agregar múltiples agentes a la vez
npx create-mern-agents add devops-engineer release-manager

# Ver información detallada de un agente
npx create-mern-agents info orchestrator
```

### Comandos disponibles

| Comando | Descripción |
|---------|-------------|
| `npx create-mern-agents` | Inicializar proyecto con agentes (interactivo) |
| `npx create-mern-agents --minimal` | Instalar solo agentes CORE |
| `npx create-mern-agents add <agente> [...]` | Agregar uno o más agentes específicos |
| `npx create-mern-agents list` | Listar todos los agentes disponibles |
| `npx create-mern-agents info <agente>` | Ver información de un agente |
| `npx create-mern-agents --help` | Mostrar ayuda |

### Ejemplo de uso

```bash
$ npx create-mern-agents list

📋 Agentes disponibles:

Core
  ✓ orchestrator         - Coordina todos los agentes del equipo
  ✓ product-manager      - Define requerimientos y prioridades
    solution-architect   - Diseño de arquitectura general

Arquitectura
    backend-architect    - Arquitectura backend y APIs
    frontend-architect   - Arquitectura frontend y UI
...

✓ = instalado en este proyecto
```

```bash
$ npx create-mern-agents add security-guardian

ℹ Descargando security-guardian...
✓ Agente 'security-guardian' instalado correctamente
  Ahora puedes usar: @security-guardian <tu pregunta>
```

```bash
$ npx create-mern-agents info orchestrator

🎯 orchestrator

Categoría: Core
Descripción: Coordina todos los agentes del equipo
Estado: Instalado ✓
```

## 📚 Documentación

- [Guía de Agentes](./AGENTS.md) - Qué agentes se instalan según tu proyecto
- [MERN Agents Framework](https://github.com/Angel-Baez/mern-agents-framework) - Repositorio principal
