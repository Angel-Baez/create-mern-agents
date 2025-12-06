# 🤖 Guía de Agentes MERN

Esta guía explica qué agentes se descargan según el tamaño y características de tu proyecto.

## 📊 Categorías de Agentes

### 🎯 CORE (Siempre necesarios)

Estos agentes se instalan en **todos los proyectos**, sin importar el tamaño:

| Agente | Descripción | ¿Por qué es CORE? |
|--------|-------------|-------------------|
| `orchestrator.md` | Coordina todos los agentes del equipo | Necesario para organizar el trabajo entre agentes |
| `product-manager.md` | Define requerimientos y prioridades | Todo proyecto necesita gestión de requerimientos |
| `solution-architect.md` | Diseño de arquitectura general | Define la estructura y decisiones técnicas |
| `backend-architect.md` | Arquitectura backend y APIs | Necesario para cualquier aplicación MERN |
| `frontend-architect.md` | Arquitectura frontend y UI | Necesario para la interfaz de usuario |
| `test-engineer.md` | Estrategia de testing y tests | Testing básico es esencial en todo proyecto |

**Total CORE: 6 agentes**

> **Nota:** En modo minimal (`--minimal`), se instalan los 6 agentes CORE más `security-guardian.md` (por auth habilitado por defecto), resultando en 7 agentes totales.

---

## 📏 Agentes por Tamaño de Proyecto

### 🌱 Proyecto Pequeño/MVP
**Tamaño:** Prototipo o proyecto personal  
**Equipo:** 1-2 desarrolladores  
**CI/CD:** No configurado

**Agentes instalados:**
- ✅ Los 6 agentes CORE

**Total: 6 agentes**

---

### 🚀 Proyecto Mediano
**Tamaño:** Startup o producto en crecimiento  
**Equipo:** 3-10 desarrolladores  
**CI/CD:** Opcional

**Agentes instalados:**
- ✅ Los 6 agentes CORE
- ✅ `qa-lead.md` - Testing de integración y E2E
- ✅ `code-reviewer.md` - Revisión de código y calidad

**Total: 8 agentes base** (+ opcionales según features y CI/CD)

---

### 🏢 Proyecto Grande/Empresa
**Tamaño:** Equipo grande, CI/CD completo  
**Equipo:** 10+ desarrolladores  
**CI/CD:** Obligatorio

**Agentes instalados:**
- ✅ Los 8 agentes de Proyecto Mediano
- ✅ `documentation-engineer.md` - Documentación técnica completa
- ✅ `observability-engineer.md` - Monitoring, logging y métricas

**Total: 10 agentes base** (+ opcionales según features y CI/CD)

---

## ⚙️ Agentes por Features

### 🔐 Autenticación o Pagos
**Trigger:** `FEAT_AUTH=true` OR `FEAT_PAYMENTS=true`

**Agentes adicionales:**
- ✅ `security-guardian.md` - Seguridad, autenticación y validación

**¿Por qué?** Autenticación y pagos requieren medidas de seguridad estrictas.

---

### 🤖 Integración con IA
**Trigger:** `FEAT_AI=true`

**Agentes adicionales:**
- ✅ `ai-integration-engineer.md` - Integración con APIs de IA

**¿Por qué?** Requiere conocimiento especializado en APIs de OpenAI, Anthropic, etc.

---

### 🗄️ Base de Datos Compleja
**Trigger:** Más de 3 entidades en el dominio

**Agentes adicionales:**
- ✅ `data-engineer.md` - Modelado de datos y optimización

**¿Por qué?** Bases de datos complejas requieren optimización y diseño cuidadoso.

---

### 🔄 CI/CD Habilitado
**Trigger:** `FEAT_CICD=true`

**Agentes adicionales:**
- ✅ `devops-engineer.md` - CI/CD y automatización
- ✅ `release-manager.md` - Gestión de releases y deploys

**¿Por qué?** CI/CD requiere configuración especializada de GitHub Actions, deploys, etc.

---

## 📋 Tabla de Decisión Completa

| Condición | Agente(s) añadidos |
|-----------|-------------------|
| **Siempre** | orchestrator, product-manager, solution-architect, backend-architect, frontend-architect, test-engineer |
| Tamaño: Mediano o Grande | qa-lead, code-reviewer |
| Tamaño: Grande | documentation-engineer, observability-engineer |
| Auth = true | security-guardian |
| Payments = true | security-guardian |
| AI = true | ai-integration-engineer |
| Entidades > 3 | data-engineer |
| CI/CD = true | devops-engineer, release-manager |

---

## 🎯 Ejemplos de Configuración

### Ejemplo 1: MVP Simple
```
Tamaño: Pequeño
Features: Auth = true
Entidades: User, Product
CI/CD: No

Agentes instalados (7):
- orchestrator
- product-manager
- solution-architect
- backend-architect
- frontend-architect
- test-engineer
- security-guardian ← Por Auth
```

### Ejemplo 2: Startup en Crecimiento
```
Tamaño: Mediano
Features: Auth = true, Payments = true, AI = true
Entidades: User, Product, Order, Payment
CI/CD: Sí

Agentes instalados (13):
- orchestrator
- product-manager
- solution-architect
- backend-architect
- frontend-architect
- test-engineer
- qa-lead ← Por tamaño mediano
- code-reviewer ← Por tamaño mediano
- security-guardian ← Por Auth + Payments
- ai-integration-engineer ← Por AI
- data-engineer ← Por 4 entidades
- devops-engineer ← Por CI/CD
- release-manager ← Por CI/CD
```

### Ejemplo 3: Aplicación Empresarial
```
Tamaño: Grande
Features: Auth = true, Payments = true, AI = true
Entidades: User, Product, Order, Payment, Invoice, Analytics
CI/CD: Sí

Agentes instalados (15 - TODOS):
- orchestrator
- product-manager
- solution-architect
- backend-architect
- frontend-architect
- test-engineer
- qa-lead ← Por tamaño mediano+
- code-reviewer ← Por tamaño mediano+
- documentation-engineer ← Por tamaño grande
- observability-engineer ← Por tamaño grande
- security-guardian ← Por Auth + Payments
- ai-integration-engineer ← Por AI
- data-engineer ← Por 6 entidades
- devops-engineer ← Por CI/CD
- release-manager ← Por CI/CD
```

---

## 🔧 Agregar Agentes Después

Si tu proyecto crece y necesitas más agentes, puedes agregarlos individualmente:

```bash
# Ver lista de agentes disponibles
npx create-mern-agents list

# Agregar un agente específico
npx create-mern-agents add security-guardian
npx create-mern-agents add devops-engineer
npx create-mern-agents add ai-integration-engineer
```

---

## 💡 Modo Minimal

Para proyectos MVP que quieren empezar rápido:

```bash
npx create-mern-agents --minimal
```

Esto instala 7 agentes: los 6 CORE más security-guardian (por autenticación habilitada por defecto).

---

## 📚 Referencias

- [Documentación completa](https://github.com/Angel-Baez/mern-agents-framework)
- [Plantillas de proyecto](https://github.com/Angel-Baez/mern-agents-framework/tree/main/templates)
- [Contribuir agentes](https://github.com/Angel-Baez/mern-agents-framework/blob/main/CONTRIBUTING.md)
