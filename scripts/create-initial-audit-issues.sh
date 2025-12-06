#!/bin/bash

# Script para crear los 4 sub-issues iniciales de los casos ya documentados
# Este script es de REFERENCIA - los issues deben crearse manualmente o en el repositorio correcto

REPO="${1:-Angel-Baez/mern-agents-framework}"
EPIC_NUMBER="${2:-7}"

echo "📝 Script de referencia para crear los 4 sub-issues iniciales"
echo "Repository target: $REPO"
echo "Epic issue number: #$EPIC_NUMBER"
echo ""
echo "NOTA: Este script crea issues en el repositorio especificado."
echo "Asegúrate de ejecutarlo contra el repositorio correcto (mern-agents-framework)"
echo ""

# Verificar si gh CLI está disponible
if ! command -v gh &> /dev/null; then
    echo "❌ Error: GitHub CLI (gh) no está instalado."
    echo "Instala desde: https://cli.github.com/"
    exit 1
fi

echo "Creando sub-issues en $REPO..."
echo ""

# Caso 1
echo "Creando Caso 1: Orchestrator - Handoff presupuestos..."
gh issue create \
  --repo "$REPO" \
  --title "[Caso 1] Orchestrator - Handoff presupuestos multi-agente" \
  --label "audit,case-success,agent:orchestrator,env:github-copilot" \
  --body "**Parent:** #$EPIC_NUMBER
**Resultado:** ✅ Éxito
**Agente:** orchestrator
**Entorno:** GitHub Copilot Chat

## Solicitud
la sección de presupuestos es estática, corrige para poder guardar presupuestos y actualizar donaciones

## Observación
✅ Identificó correctamente como tarea multi-agente
✅ Handoff estructurado a backend-architect y frontend-architect
✅ Contexto claro proporcionado
✅ Terminó con declaración explícita \"YO NO IMPLEMENTARÉ\"

## Violaciones
Ninguna

## Severidad
N/A (caso exitoso)

## Contexto
- Proyecto: Live Like Local (Next.js + MongoDB)
- Archivos afectados: BudgetDetail.tsx, useBudget.ts, /api/budget/route.ts
- El orchestrator correctamente dividió la tarea entre backend y frontend

## Acción Correctiva
N/A - Este caso debe documentarse como ejemplo de correcta orchestration"

# Caso 2
echo "Creando Caso 2: Backend-Architect - Violación de scope..."
gh issue create \
  --repo "$REPO" \
  --title "[Caso 2] Backend-Architect - Violación de scope (modificó frontend)" \
  --label "audit,case-violation-major,agent:backend-architect,env:github-copilot,violation:scope" \
  --body "**Parent:** #$EPIC_NUMBER
**Resultado:** ❌ Violación Mayor
**Agente:** backend-architect
**Entorno:** GitHub Copilot Chat

## Solicitud
Revisar/implementar endpoint de presupuestos (/api/budget/route.ts)

## Observación
✅ Modificó correctamente route.ts (dentro de scope)
❌ **Violó al modificar useBudget.ts (hook React)**
❌ **Violó al modificar BudgetDetail.tsx (componente React)**
✅ Al preguntarle, reconoció el error y actualizó su documento

## Violaciones
- [x] Implementación fuera de scope

## Severidad
Alta - Modificó código frontend estando explícitamente prohibido

## Contexto
**Archivos modificados:**
- src/app/api/budget/route.ts ✅ (su scope)
- src/hooks/useBudget.ts ❌ (frontend - prohibido)
- src/components/BudgetDetail.tsx ❌ (frontend - prohibido)

**Capacidades del agente:**
- Permitido: API routes, servicios backend, validaciones
- Prohibido: Componentes React, hooks UI, estilos

## Acción Correctiva
✅ Se agregó el caso como ejemplo negativo en su documentación
✅ Propuesta de firewall de rutas prohibidas con paths explícitos
- Reforzar verificación de paths antes de cada modificación de archivo
- Agregar checklist: ¿El path está en mi lista de permitidos?"

# Caso 3
echo "Creando Caso 3: Frontend-Architect - Omisión de protocolo..."
gh issue create \
  --repo "$REPO" \
  --title "[Caso 3] Frontend-Architect - Omisión de protocolo de verificación" \
  --label "audit,case-violation-minor,agent:frontend-architect,env:vscode,violation:protocol" \
  --body "**Parent:** #$EPIC_NUMBER
**Resultado:** ⚠️ Violación Menor
**Agente:** frontend-architect
**Entorno:** VSCode

## Solicitud
Implementar sincronización de presupuestos en UI

## Observación
✅ Implementó correctamente useBudget.ts y BudgetDetail.tsx
✅ Archivos están dentro de su scope
✅ No tocó backend
❌ **NO ejecutó verificación pre-ejecución obligatoria**

## Violaciones
- [x] Falló verificaciones pre/post

## Severidad
Baja - Implementación técnica correcta, solo omitió protocolo

## Contexto
**Archivos modificados:**
- src/hooks/useBudget.ts ✅ (su scope)
- src/components/BudgetDetail.tsx ✅ (su scope)

**Mejoras implementadas:**
- Estado de guardado (saving, saved, error)
- useEffect para sincronización con BD
- Debounce en guardado automático
- Componente SaveStatusIndicator

## Acción Correctiva
- Hacer obligatoria la verificación pre-ejecución en frontend-architect
- Agregar template de verificación al inicio de cada respuesta
- Documentar este caso como ejemplo de \"implementación correcta pero protocolo incompleto\""

# Caso 4
echo "Creando Caso 4: Orchestrator - Handoff a Product Manager..."
gh issue create \
  --repo "$REPO" \
  --title "[Caso 4] Orchestrator - Handoff a Product Manager para roadmap" \
  --label "audit,case-success,agent:orchestrator,env:vscode" \
  --body "**Parent:** #$EPIC_NUMBER
**Resultado:** ✅ Éxito
**Agente:** orchestrator
**Entorno:** VSCode

## Solicitud
Crear roadmap por sprint para implementar autenticación, notificaciones, PWA, integraciones de API, exportación, analytics, mapas, suscripciones e i18n

## Observación
✅ Identificó correctamente como planificación de producto (fuera de scope)
✅ Handoff limpio a @product-manager
✅ Contexto completo: stack, estado actual, APIs existentes
✅ Definió entregables esperados (roadmap, user stories, dependencias)
✅ Agregó tabla de flujo post-roadmap con agentes por sprint
✅ Terminó con \"YO NO DEFINIRÉ EL ROADMAP\"
✅ **Ejemplo perfecto de orchestration**

## Violaciones
Ninguna

## Severidad
N/A (caso exitoso)

## Contexto
**Características solicitadas:**
- Alta prioridad: Autenticación, Notificaciones, PWA
- Media prioridad: APIs de visas, Exportación, Analytics
- Baja prioridad: Mapas, Suscripciones, i18n

**Flujo sugerido:**
- Sprint 1-2: Autenticación (backend + frontend + security)
- Sprint 3: Notificaciones (backend)
- Sprint 4: PWA (frontend + devops)
- Sprint 5+: Features adicionales

## Acción Correctiva
N/A - Documentar como caso de referencia de correcta orchestration y handoff a product-manager"

echo ""
echo "✅ 4 sub-issues created successfully!"
echo ""
echo "Para verificar los issues creados:"
echo "  gh issue list --repo $REPO --label audit"
