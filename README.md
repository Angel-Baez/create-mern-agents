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

## 📦 Agregar Agentes Después

Si tu proyecto crece, puedes agregar agentes individuales:

```bash
# Ver agentes disponibles
./src/add-agent.sh --list

# Agregar un agente específico
./src/add-agent.sh security-guardian
./src/add-agent.sh devops-engineer
```

## 📚 Documentación

- [Guía de Agentes](./AGENTS.md) - Qué agentes se instalan según tu proyecto
- [MERN Agents Framework](https://github.com/Angel-Baez/mern-agents-framework) - Repositorio principal
