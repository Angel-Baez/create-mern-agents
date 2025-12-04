# Guía de Agentes - MERN Agents Framework

Esta guía te ayuda a entender qué agentes están disponibles, cuándo usarlos y cómo seleccionarlos para tu proyecto.

## 📋 Tabla de Contenidos

1. [Descripción de Agentes](#descripción-de-agentes)
2. [Guía de Selección por Tipo de Proyecto](#guía-de-selección-por-tipo-de-proyecto)
3. [Guía de Selección por Características](#guía-de-selección-por-características)
4. [Ejemplos de Comandos](#ejemplos-de-comandos)

---

## Descripción de Agentes

### 🎯 Agentes Core (Siempre Recomendados)

#### orchestrator
**Cuándo es necesario:** Siempre. Es el agente principal que coordina el trabajo de todos los demás agentes.

**Funcionalidad:** 
- Coordina y distribuye tareas entre agentes
- Gestiona el flujo de trabajo del proyecto
- Resuelve conflictos entre agentes
- Toma decisiones de alto nivel sobre arquitectura

**Ejemplo de uso:**
```
@orchestrator Necesito crear un sistema de autenticación con Google y email/password
```

---

#### solution-architect
**Cuándo es necesario:** Siempre. Fundamental para diseñar la arquitectura del proyecto.

**Funcionalidad:**
- Define la arquitectura general del sistema
- Diseña patrones de integración
- Establece estándares y convenciones
- Documenta decisiones arquitectónicas

**Ejemplo de uso:**
```
@solution-architect ¿Cómo debería estructurar mi proyecto para soportar multi-tenancy?
```

---

#### code-reviewer
**Cuándo es necesario:** Siempre. Asegura la calidad del código.

**Funcionalidad:**
- Revisa código siguiendo best practices
- Identifica problemas de seguridad
- Sugiere mejoras de rendimiento
- Valida adherencia a estándares del proyecto

**Ejemplo de uso:**
```
@code-reviewer Revisa el código del componente UserProfile
```

---

#### documentation-engineer
**Cuándo es necesario:** Siempre. Mantiene la documentación actualizada.

**Funcionalidad:**
- Genera y mantiene documentación técnica
- Crea README y guías de usuario
- Documenta APIs y componentes
- Actualiza changelog

**Ejemplo de uso:**
```
@documentation-engineer Documenta la nueva API de productos
```

---

### 🏗️ Agentes de Arquitectura

#### backend-architect
**Cuándo es necesario:** Proyectos con backend o APIs.

**Funcionalidad:**
- Diseña APIs RESTful o GraphQL
- Define modelos de datos
- Implementa servicios y repositorios
- Gestiona autenticación y autorización en backend

**Ejemplo de uso:**
```
@backend-architect Crea una API para gestionar órdenes de compra con Stripe
```

---

#### frontend-architect
**Cuándo es necesario:** Todos los proyectos con interfaz de usuario.

**Funcionalidad:**
- Diseña arquitectura de componentes
- Define estado global y local
- Implementa routing y navegación
- Optimiza rendimiento frontend

**Ejemplo de uso:**
```
@frontend-architect Diseña la estructura de componentes para un dashboard administrativo
```

---

### 🔒 Agentes de Seguridad y Datos

#### security-guardian
**Cuándo es necesario:** 
- Proyectos con autenticación/autorización
- Manejo de datos sensibles
- Requisitos de cumplimiento (GDPR, HIPAA)
- E-commerce con pagos

**Funcionalidad:**
- Implementa autenticación segura
- Gestiona sesiones y tokens
- Valida permisos y roles
- Audita vulnerabilidades de seguridad
- Implementa cifrado de datos

**Ejemplo de uso:**
```
@security-guardian Implementa autenticación con JWT y refresh tokens
```

---

#### data-engineer
**Cuándo es necesario:**
- Bases de datos complejas
- Múltiples fuentes de datos
- ETL o procesamiento de datos
- Analytics o reporting

**Funcionalidad:**
- Diseña esquemas de base de datos
- Optimiza queries y índices
- Implementa migraciones
- Gestiona seeds y fixtures
- Configura ORMs (Prisma, Mongoose, etc.)

**Ejemplo de uso:**
```
@data-engineer Optimiza el esquema de base de datos para manejar 1M de usuarios
```

---

### 🧪 Agentes de Calidad

#### test-engineer
**Cuándo es necesario:** Siempre recomendado (incluido en modo minimal).

**Funcionalidad:**
- Crea tests unitarios
- Implementa tests de integración
- Configura frameworks de testing
- Asegura cobertura de código

**Ejemplo de uso:**
```
@test-engineer Crea tests para el servicio de pagos
```

---

#### qa-lead
**Cuándo es necesario:**
- Proyectos medianos a grandes
- Equipos con múltiples desarrolladores
- Requisitos estrictos de calidad

**Funcionalidad:**
- Define estrategia de testing
- Crea planes de QA
- Implementa tests E2E
- Gestiona reportes de bugs

**Ejemplo de uso:**
```
@qa-lead Crea un plan de testing E2E para el flujo de checkout
```

---

### 🚀 Agentes de DevOps y Deployment

#### devops-engineer
**Cuándo es necesario:**
- Proyectos con CI/CD
- Múltiples ambientes (dev, staging, prod)
- Necesidad de automatización

**Funcionalidad:**
- Configura pipelines CI/CD
- Automatiza deployments
- Gestiona variables de entorno
- Implementa GitHub Actions, GitLab CI, etc.

**Ejemplo de uso:**
```
@devops-engineer Configura un pipeline CI/CD para deployar en Vercel
```

---

#### release-manager
**Cuándo es necesario:**
- Proyectos con releases frecuentes
- Necesidad de versionado semántico
- Gestión de changelogs

**Funcionalidad:**
- Gestiona versiones y releases
- Genera changelogs automáticos
- Coordina deployments
- Maneja rollbacks

**Ejemplo de uso:**
```
@release-manager Prepara el release v2.0.0 con el nuevo dashboard
```

---

### 📊 Agentes de Observabilidad

#### observability-engineer
**Cuándo es necesario:**
- Aplicaciones en producción
- Necesidad de monitoreo
- Debug de problemas en producción
- Optimización de rendimiento

**Funcionalidad:**
- Implementa logging estructurado
- Configura métricas y alertas
- Integra APM (Sentry, New Relic, etc.)
- Implementa distributed tracing

**Ejemplo de uso:**
```
@observability-engineer Configura Sentry para tracking de errores
```

---

### 🤖 Agentes Especializados

#### ai-integration-engineer
**Cuándo es necesario:**
- Integración con OpenAI, Anthropic, Google AI
- Funcionalidades de ML/AI
- Chatbots o asistentes virtuales
- Generación de contenido con IA

**Funcionalidad:**
- Integra APIs de IA (OpenAI, Anthropic, etc.)
- Implementa prompt engineering
- Gestiona contexto y memoria
- Optimiza costos de API

**Ejemplo de uso:**
```
@ai-integration-engineer Crea un chatbot con OpenAI GPT-4
```

---

#### product-manager
**Cuándo es necesario:**
- Proyectos medianos a grandes
- Necesidad de priorización
- Roadmap complejo

**Funcionalidad:**
- Define features y requisitos
- Prioriza backlog
- Crea user stories
- Documenta flujos de usuario

**Ejemplo de uso:**
```
@product-manager Define los requisitos para el módulo de reportes
```

---

## Guía de Selección por Tipo de Proyecto

### 🚀 MVP / Proyecto Básico
**Agentes recomendados (6):**
- orchestrator
- solution-architect
- backend-architect
- frontend-architect
- code-reviewer
- test-engineer

**Comando:**
```bash
npx create-mern-agents --minimal
```

**Cuándo agregar más:**
- Agrega `security-guardian` cuando implementes autenticación
- Agrega `devops-engineer` cuando necesites CI/CD
- Agrega `ai-integration-engineer` cuando integres IA

---

### 💼 Aplicación SaaS
**Agentes recomendados (11):**
- orchestrator
- solution-architect
- backend-architect
- frontend-architect
- security-guardian (autenticación multi-tenant)
- data-engineer (base de datos compleja)
- test-engineer
- qa-lead
- devops-engineer
- release-manager
- documentation-engineer

**Comando:**
```bash
npx create-mern-agents
# El script detectará automáticamente las características
```

---

### 🛒 E-commerce
**Agentes recomendados (12):**
- orchestrator
- solution-architect
- backend-architect
- frontend-architect
- security-guardian (pagos y datos sensibles)
- data-engineer (productos, órdenes, inventario)
- test-engineer
- qa-lead
- devops-engineer
- observability-engineer (monitoreo de transacciones)
- release-manager
- documentation-engineer

**Comando:**
```bash
npx create-mern-agents
# Responde "Sí" a autenticación y pagos durante la configuración
```

---

### 📊 Admin Dashboard
**Agentes recomendados (10):**
- orchestrator
- solution-architect
- backend-architect
- frontend-architect
- security-guardian (control de acceso)
- data-engineer (reportes y analytics)
- test-engineer
- qa-lead
- code-reviewer
- documentation-engineer

**Comando:**
```bash
npx create-mern-agents
```

---

### 📱 PWA Offline-First
**Agentes recomendados (11):**
- orchestrator
- solution-architect
- backend-architect
- frontend-architect
- security-guardian
- data-engineer (sincronización)
- test-engineer
- qa-lead (testing offline)
- code-reviewer
- documentation-engineer
- + pwa-specialist (template)

**Comando:**
```bash
npx create-mern-agents --template=pwa-offline
```

---

### 🔌 API Backend (sin frontend)
**Agentes recomendados (9):**
- orchestrator
- solution-architect
- backend-architect
- security-guardian
- data-engineer
- test-engineer
- devops-engineer
- code-reviewer
- documentation-engineer (documentación de API)

**Comando:**
```bash
npx create-mern-agents
# El script detectará que no hay componentes frontend
```

---

### 🏢 Microservicios
**Agentes recomendados (todos - 15):**
- Todos los agentes son útiles en arquitecturas complejas
- Especialmente importantes: solution-architect, devops-engineer, observability-engineer

**Comando:**
```bash
npx create-mern-agents
# Considera no usar --minimal para proyectos grandes
```

---

## Guía de Selección por Características

### 🔐 Con Autenticación
**Agentes adicionales necesarios:**
- `security-guardian` (implementación de auth)

**Detección automática:**
El script detecta automáticamente si tienes:
- Dependencies: next-auth, passport, jsonwebtoken, bcrypt
- Variables: JWT_SECRET, SESSION_SECRET en .env.example
- Archivos: middleware.ts con lógica de auth

**Agregar manualmente:**
```bash
./add-agent.sh security-guardian
```

---

### 🔄 Con Pipeline CI/CD
**Agentes adicionales necesarios:**
- `devops-engineer` (configuración de pipelines)
- `release-manager` (gestión de releases)

**Detección automática:**
El script detecta:
- Directorio `.github/workflows/`
- Archivos `.gitlab-ci.yml`, `azure-pipelines.yml`, etc.

**Agregar manualmente:**
```bash
./add-agent.sh devops-engineer release-manager
```

---

### 🤖 Con Integración de IA
**Agentes adicionales necesarios:**
- `ai-integration-engineer`

**Detección automática:**
El script detecta:
- Dependencies: openai, @anthropic-ai/sdk, @google/generative-ai, langchain
- Variables: OPENAI_API_KEY, ANTHROPIC_API_KEY en .env.example

**Agregar manualmente:**
```bash
./add-agent.sh ai-integration-engineer
```

---

### 📊 Con Monitoreo/Observabilidad
**Agentes adicionales necesarios:**
- `observability-engineer`

**Detección automática:**
El script detecta:
- Dependencies: @sentry/nextjs, newrelic, @datadog, pino, winston
- Archivos: sentry.client.config.js, newrelic.js

**Agregar manualmente:**
```bash
./add-agent.sh observability-engineer
```

---

### 🗄️ Con Manejo de Datos Complejos
**Agentes adicionales necesarios:**
- `data-engineer`

**Detección automática:**
El script detecta:
- Dependencies: prisma, mongoose, typeorm, sequelize
- Archivos: prisma/schema.prisma, models/, src/models/

**Agregar manualmente:**
```bash
./add-agent.sh data-engineer
```

---

### 🔒 Con Requisitos de Seguridad Altos
**Agentes recomendados:**
- `security-guardian` (obligatorio)
- `qa-lead` (testing de seguridad)
- `code-reviewer` (auditoría de código)
- `observability-engineer` (monitoreo de amenazas)

**Comando:**
```bash
npx create-mern-agents
./add-agent.sh security-guardian qa-lead observability-engineer
```

---

## Ejemplos de Comandos

### Instalación Inicial

#### Proyecto MVP básico
```bash
npx create-mern-agents --minimal
```
Instala solo 6 agentes core esenciales.

---

#### Proyecto completo con detección automática
```bash
npx create-mern-agents
```
El script detecta características y selecciona agentes automáticamente.

---

#### Proyecto sin pipeline CI/CD
```bash
npx create-mern-agents --no-pipeline
```
Omite devops-engineer y release-manager.

---

#### Proyecto sin autenticación
```bash
npx create-mern-agents --no-auth
```
Omite security-guardian.

---

#### Proyecto sin IA ni observabilidad
```bash
npx create-mern-agents --no-ai --no-observability
```
Omite agentes especializados.

---

### Agregar Agentes Después

#### Agregar seguridad después
```bash
cd tu-proyecto
./add-agent.sh security-guardian
```

---

#### Agregar DevOps y Release Management
```bash
./add-agent.sh devops-engineer release-manager
```

---

#### Agregar IA, Observabilidad y Datos
```bash
./add-agent.sh ai-integration-engineer observability-engineer data-engineer
```

---

#### Agregar todos los agentes faltantes
```bash
./add-agent.sh product-manager qa-lead observability-engineer ai-integration-engineer data-engineer
```

---

### Casos de Uso Comunes

#### Caso 1: Empezar con MVP y escalar
```bash
# Fase 1: MVP
npx create-mern-agents --minimal

# Fase 2: Agregar autenticación
./add-agent.sh security-guardian

# Fase 3: Agregar CI/CD
./add-agent.sh devops-engineer release-manager

# Fase 4: Agregar observabilidad para producción
./add-agent.sh observability-engineer
```

---

#### Caso 2: E-commerce desde cero
```bash
# Instalación con todas las características
npx create-mern-agents
# Durante la configuración:
# - Autenticación: Sí
# - Pagos: Sí (Stripe)
# - IA: No
# Esto instalará automáticamente los agentes necesarios
```

---

#### Caso 3: Migrar proyecto existente
```bash
# En tu proyecto existente
npx create-mern-agents

# El script detectará:
# - package.json existente ✓
# - Características de autenticación ✓
# - Pipeline CI/CD existente ✓
# Y descargará solo los agentes necesarios
```

---

#### Caso 4: API backend sin frontend
```bash
npx create-mern-agents
# El script detectará que no hay componentes de React
# y omitirá frontend-architect automáticamente
```

---

## 🎯 Recomendaciones

### Para Principiantes
Empieza con `--minimal` y agrega agentes conforme los necesites:
```bash
npx create-mern-agents --minimal
```

### Para Proyectos Medianos
Usa la detección automática:
```bash
npx create-mern-agents
```

### Para Proyectos Enterprise
Instala todos los agentes relevantes desde el inicio:
```bash
npx create-mern-agents
# No uses --minimal
```

---

## 📚 Recursos Adicionales

- **Documentación completa:** [mern-agents-framework](https://github.com/Angel-Baez/mern-agents-framework)
- **Ejemplos de uso:** Ver la carpeta `examples/` en el repositorio
- **Issues y soporte:** [GitHub Issues](https://github.com/Angel-Baez/mern-agents-framework/issues)

---

## 🆘 ¿Necesitas Ayuda?

Si no estás seguro qué agentes necesitas:

1. Empieza con `--minimal`
2. Usa los agentes instalados
3. Cuando encuentres limitaciones, agrega agentes específicos con `./add-agent.sh`

**Ejemplo:**
```bash
# Empiezas con minimal
npx create-mern-agents --minimal

# Luego decides agregar autenticación
./add-agent.sh security-guardian

# Más tarde necesitas CI/CD
./add-agent.sh devops-engineer release-manager
```

Este enfoque incremental es ideal para aprender y evitar complejidad innecesaria al inicio.
