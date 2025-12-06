# create-mern-agents

CLI oficial para inicializar el **MERN Agents Framework**, un sistema de agentes inteligentes para acelerar el desarrollo de proyectos MERN + Next.js + TypeScript mediante GitHub Copilot.

## 🚀 Características

- ✅ **Selección inteligente de agentes** - Detecta automáticamente las características de tu proyecto
- 🎯 **Modo minimal** - Instala solo lo esencial para MVPs
- 🔧 **Agentes modulares** - Agrega solo los agentes que necesitas
- 📦 **15 agentes especializados** - Desde arquitectura hasta DevOps
- 🤖 **Compatible con GitHub Copilot** - Diseñado para trabajar con @mentions

## 📥 Instalación

No requiere instalación global.  
Ejecuta:

```bash
npx create-mern-agents
```

### Opciones disponibles

#### Instalación básica (recomendado para MVPs)
```bash
npx create-mern-agents --minimal
```
Instala solo 6 agentes core esenciales:
- orchestrator
- solution-architect
- backend-architect
- frontend-architect
- code-reviewer
- test-engineer

#### Instalación con detección automática
```bash
npx create-mern-agents
```
El script detecta automáticamente:
- ✅ Autenticación (next-auth, passport, JWT)
- ✅ Pipeline CI/CD (.github/workflows, etc.)
- ✅ Integración de IA (OpenAI, Anthropic)
- ✅ Observabilidad (Sentry, New Relic)
- ✅ Base de datos (Prisma, Mongoose)
- ✅ Tamaño del proyecto

Y descarga solo los agentes necesarios.

#### Instalación con flags personalizados
```bash
# Omitir agentes de CI/CD
npx create-mern-agents --no-pipeline

# Omitir agentes de autenticación
npx create-mern-agents --no-auth

# Omitir agentes de IA
npx create-mern-agents --no-ai

# Omitir agentes de observabilidad
npx create-mern-agents --no-observability

# Combinar múltiples flags
npx create-mern-agents --no-pipeline --no-ai
```

#### Ver ayuda
```bash
npx create-mern-agents --help
```

## 🧩 Agregar agentes después

Si instalaste con `--minimal` o quieres agregar agentes específicos después:

```bash
# Agregar un agente
npx create-mern-agents add security-guardian

# Agregar múltiples agentes
npx create-mern-agents add devops-engineer release-manager

# Ver agentes disponibles
npx create-mern-agents list

# Ver información de un agente
npx create-mern-agents info orchestrator
```

### Comandos disponibles

- **`add <agente...>`** - Agrega uno o más agentes al proyecto
  - Descarga agentes desde el repositorio remoto
  - Pregunta si deseas reemplazar agentes existentes
  - Soporta múltiples agentes en un solo comando
  
- **`list`** - Lista todos los agentes disponibles
  - Organizado por categoría
  - Muestra cuáles están instalados (✓)
  
- **`info <agente>`** - Muestra información detallada de un agente
  - Descripción, rol y categoría
  - Estado de instalación

## 📋 Agentes disponibles

### 🎯 Agentes Core (siempre instalados)
- **orchestrator** - Coordina todos los demás agentes
- **solution-architect** - Diseña la arquitectura del sistema
- **code-reviewer** - Revisa código y sugiere mejoras
- **documentation-engineer** - Mantiene documentación actualizada

### 🏗️ Agentes de Arquitectura
- **backend-architect** - Diseña APIs y servicios backend
- **frontend-architect** - Diseña arquitectura de componentes y UI

### 🔒 Agentes de Seguridad y Datos
- **security-guardian** - Implementa autenticación y seguridad
- **data-engineer** - Diseña esquemas de BD y optimiza queries

### 🧪 Agentes de Calidad
- **test-engineer** - Crea tests unitarios e integración
- **qa-lead** - Define estrategia de testing y QA

### 🚀 Agentes de DevOps
- **devops-engineer** - Configura CI/CD y automatización
- **release-manager** - Gestiona versiones y releases

### 📊 Agentes de Observabilidad
- **observability-engineer** - Implementa logging, métricas y alertas

### 🤖 Agentes Especializados
- **ai-integration-engineer** - Integra APIs de IA (OpenAI, Anthropic, etc.)
- **product-manager** - Define features y prioriza backlog

Para más detalles sobre cada agente, consulta la [**Guía de Agentes**](./AGENTS_GUIDE.md).

## 📖 Guía completa

Ver [**AGENTS_GUIDE.md**](./AGENTS_GUIDE.md) para:
- Descripción detallada de cada agente
- Cuándo usar cada agente
- Guía de selección por tipo de proyecto
- Guía de selección por características
- Ejemplos de comandos

## 🎯 Casos de uso comunes

### Proyecto MVP
```bash
npx create-mern-agents --minimal
```

### E-commerce con pagos
```bash
npx create-mern-agents
# Durante la configuración:
# - Autenticación: Sí
# - Pagos: Sí (Stripe/PayPal)
```

### SaaS con CI/CD
```bash
npx create-mern-agents
# El script detectará automáticamente tu pipeline CI/CD
# y descargará devops-engineer y release-manager
```

### API Backend sin frontend
```bash
npx create-mern-agents
# El script detectará la ausencia de componentes frontend
```

### Migración incremental
```bash
# 1. Empezar con minimal
npx create-mern-agents --minimal

# 2. Agregar autenticación cuando la implementes
npx create-mern-agents add security-guardian

# 3. Agregar CI/CD cuando lo configures
npx create-mern-agents add devops-engineer release-manager

# 4. Agregar observabilidad para producción
npx create-mern-agents add observability-engineer
```

## 🔧 Cómo funciona

1. **Detección automática:** El script analiza tu `package.json`, archivos de configuración, y estructura del proyecto para detectar características.

2. **Selección inteligente:** Basado en la detección, descarga solo los agentes necesarios:
   - Proyectos pequeños (< 50 archivos): Agentes core + básicos
   - Proyectos medianos (50-200 archivos): Core + gestión + QA
   - Proyectos grandes (> 200 archivos): Todos los agentes relevantes

3. **Instalación modular:** Puedes agregar agentes específicos en cualquier momento con `./add-agent.sh`

## 📂 Estructura creada

```
tu-proyecto/
├── .github/
│   ├── agents/                    # Ubicación estándar
│   │   ├── _core/                # Contexto compartido
│   │   ├── project-context.yml   # Configuración del proyecto
│   │   └── *.md                  # Archivos de agentes
│   └── copilot/
│       └── agents/               # Ubicación alternativa (compatibilidad)
│           ├── _core/
│           ├── project-context.yml
│           └── *.md
├── package.json
└── ...
```

## 🤖 Uso con GitHub Copilot

Después de la instalación, usa los agentes en GitHub Copilot Chat:

```
@orchestrator ¿Cómo empiezo a desarrollar mi aplicación?
@backend-architect Crea una API REST para gestionar productos
@frontend-architect Diseña la arquitectura de componentes para el dashboard
@security-guardian Implementa autenticación con JWT
@test-engineer Crea tests para el servicio de pagos
```

## 🔄 Actualizar agentes

Para actualizar los agentes a la última versión:

```bash
# Volver a ejecutar el script mantendrá tu project-context.yml
npx create-mern-agents

# O actualizar agentes específicos (responde "y" para reemplazar cuando se pregunte)
npx create-mern-agents add security-guardian
```

## 🆘 Solución de problemas

### El script no detecta características
Asegúrate de que:
- Tienes un `package.json` válido
- Las dependencias están listadas correctamente
- Archivos de configuración (.env.example, etc.) existen

### Agregar agentes manualmente
Si la detección automática falla, usa flags o el comando `add`:

```bash
# Forzar omisión de agentes
npx create-mern-agents --no-pipeline --no-auth

# Agregar manualmente después
npx create-mern-agents add security-guardian devops-engineer
```

## 📚 Recursos adicionales

- **Framework completo:** [mern-agents-framework](https://github.com/Angel-Baez/mern-agents-framework)
- **Guía de agentes:** [AGENTS_GUIDE.md](./AGENTS_GUIDE.md)
- **Documentación de GitHub Copilot:** [docs.github.com/copilot](https://docs.github.com/en/copilot)

## 🤝 Contribuir

Las contribuciones son bienvenidas. Por favor abre un issue o PR en el repositorio.

## 🚀 Publicación automatizada via GitHub Actions

Este paquete utiliza GitHub Actions para automatizar la publicación en npm cuando se crean tags de release.

### Configuración inicial (solo para mantenedores)

#### 1. Crear token de automatización en npm

1. Ve a [npmjs.com](https://www.npmjs.com) e inicia sesión
2. Click en tu avatar → **Access Tokens**
3. Click en **Generate New Token** → **Automation**
4. Copia el token generado (solo se muestra una vez)

> **Nota sobre 2FA:** Los tokens de tipo "Automation" funcionan incluso si tienes 2FA habilitado en tu cuenta npm. No necesitas ingresar códigos 2FA durante la publicación automatizada.

#### 2. Agregar el token como secret en GitHub

1. Ve al repositorio en GitHub
2. Ve a **Settings** → **Secrets and variables** → **Actions**
3. Click en **New repository secret**
4. Nombre: `NPM_TOKEN`
5. Valor: Pega el token que copiaste de npmjs.com
6. Click en **Add secret**

### Publicar una nueva versión

Para publicar una nueva versión del paquete:

```bash
# 1. Actualiza la versión en package.json
npm version patch  # o minor, o major

# 2. Crea un tag de release
git tag v1.1.0

# 3. Haz push del tag a GitHub
git push origin v1.1.0
```

El workflow de GitHub Actions se disparará automáticamente y:
- ✅ Descargará el código del tag
- ✅ Instalará las dependencias
- ✅ Ejecutará el build (si existe un script `build`)
- ✅ Publicará el paquete en npm con acceso público

### Ver el estado de la publicación

1. Ve a la pestaña **Actions** en el repositorio de GitHub
2. Busca el workflow "Publish package to npm"
3. Click en la ejecución correspondiente a tu tag para ver los detalles

## 🔍 Sistema de Auditoría

Este repositorio incluye infraestructura para un sistema de auditoría híbrido que permite rastrear y analizar el comportamiento de los agentes del framework.

### Características del Sistema de Auditoría

- **Issue Templates**: Template estructurado para registrar casos de auditoría individuales
- **Labels Automáticos**: Sistema de etiquetas para clasificar casos por agente, entorno, resultado y tipo de violación
- **GitHub Actions**: Workflow automático que actualiza métricas en tiempo real
- **Epic Tracking**: Issue Epic que agrega todas las métricas de los sub-issues
- **Dashboard**: Visualización de tendencias y rendimiento por agente

### Documentación Completa

Para más información sobre cómo usar el sistema de auditoría, consulta [**AUDIT_SYSTEM.md**](./AUDIT_SYSTEM.md).

Incluye:
- Configuración inicial
- Crear casos de auditoría
- Filtrar y buscar casos
- Tipos de violaciones
- Niveles de severidad
- Ejemplos de uso completo

## 📄 Licencia

MIT © Angel Baez

---

**¿Dudas?** Consulta la [Guía de Agentes](./AGENTS_GUIDE.md) o abre un [issue](https://github.com/Angel-Baez/create-mern-agents/issues).