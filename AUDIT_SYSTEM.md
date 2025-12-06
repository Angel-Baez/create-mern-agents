# Sistema de Auditoría Híbrido para MERN Agents Framework

Este directorio contiene la infraestructura para el sistema de auditoría híbrido que permite rastrear y analizar el comportamiento de los agentes del framework.

## 📁 Estructura

```
.github/
├── ISSUE_TEMPLATE/
│   └── audit-case.yml          # Template para crear casos de auditoría individuales
└── workflows/
    └── update-audit-epic.yml   # GitHub Action que auto-actualiza el Epic

scripts/
├── create-audit-labels.sh          # Crea labels de auditoría en GitHub
└── create-initial-audit-issues.sh  # Script de referencia para crear sub-issues
```

## 🚀 Configuración Inicial

### 1. Crear Labels de Auditoría

Ejecuta el script para crear todos los labels necesarios en tu repositorio:

```bash
./scripts/create-audit-labels.sh Angel-Baez mern-agents-framework
```

Esto creará:
- **Labels de resultado**: `case-success`, `case-violation-major`, `case-violation-minor`
- **Labels de agentes**: `agent:orchestrator`, `agent:backend-architect`, etc.
- **Labels de entorno**: `env:vscode`, `env:github-copilot`
- **Labels de violación**: `violation:scope`, `violation:protocol`, etc.
- **Labels de estado**: `needs-review`, `validated`, `disputed`
- **Label padre**: `audit`

### 2. Crear Issue Epic (#7)

Crea manualmente el Issue #7 en el repositorio `mern-agents-framework` que servirá como Epic principal. Este issue será auto-actualizado por el workflow.

### 3. Activar GitHub Action

El workflow `.github/workflows/update-audit-epic.yml` se activa automáticamente cuando:
- Se crea/edita un issue con label `audit`
- Se agregan/eliminan labels a un issue de auditoría
- Se ejecuta manualmente desde la pestaña Actions

## 📝 Uso del Sistema

### Crear un Nuevo Caso de Auditoría

1. Ve a **Issues** → **New Issue**
2. Selecciona el template **"Caso de Auditoría Individual"**
3. Completa todos los campos requeridos:
   - Epic Parent (ejemplo: #7)
   - Número de caso (1-100)
   - Agente evaluado
   - Entorno (VSCode o GitHub Copilot)
   - Resultado (Éxito, Violación Menor, Violación Mayor)
   - Solicitud original del usuario
   - Observación del comportamiento
   - Tipos de violación (si aplica)
   - Severidad
   - Contexto adicional
   - Acción correctiva
4. El sistema automáticamente:
   - Asigna el label `audit`
   - Agrega el caso al Epic #7
   - Actualiza las métricas del Epic

### Filtrar y Buscar Casos

```bash
# Ver todos los casos de auditoría
gh issue list --label audit

# Ver solo casos exitosos
gh issue list --label case-success

# Ver violaciones del orchestrator
gh issue list --label "agent:orchestrator,case-violation-major"

# Ver casos en VSCode que necesitan revisión
gh issue list --label "env:vscode,needs-review"

# Ver violaciones de scope
gh issue list --label violation:scope
```

## 🔧 Estructura del Epic

El Epic #7 se actualiza automáticamente con:

### Métricas Globales
- Casos completados / 100
- Éxitos totales y porcentaje
- Violaciones mayores y menores
- Tasa de cumplimiento perfecto

### Rendimiento por Agente
Tabla con:
- Casos evaluados por agente
- Éxitos y violaciones
- Porcentaje de éxito
- Emoji indicador (🏆 100%, ⚠️ 50%+, ❌ <50%)

### Rendimiento por Entorno
Estadísticas separadas para:
- VSCode Chat
- GitHub Copilot Chat

### Listado de Sub-issues
Agrupados por resultado:
- ✅ Casos Exitosos
- ❌ Violaciones Mayores
- ⚠️ Violaciones Menores

### Clasificación
Sistema de calificación automático:
- **A+ Perfecto**: 0 fallos
- **Ajuste menor**: 1-3 fallos
- **Ajuste moderado**: 4-10 fallos
- **Revisión profunda**: 11+ fallos

## 📊 Tipos de Violaciones

### Violaciones Mayores (case-violation-major)
- Implementación fuera de scope
- Uso de herramientas prohibidas
- Router ejecutó código directamente
- Violaciones críticas de límites

### Violaciones Menores (case-violation-minor)
- Omisión de protocolos de verificación
- Handoff incompleto (pero correcto)
- Documentación insuficiente

## 🎯 Niveles de Severidad

- **N/A**: Caso exitoso
- **Baja**: Protocolo omitido, resultado correcto
- **Media**: Violación menor de scope
- **Alta**: Violación crítica de scope
- **Crítica**: Comportamiento peligroso/destructivo

## 🔄 Workflow Automático

El workflow `update-audit-epic.yml`:
1. Se activa con cada cambio en issues de auditoría
2. Recopila todos los sub-issues con label `audit`
3. Calcula métricas agregadas
4. Genera tablas y clasificaciones
5. Actualiza el body del Epic #7
6. Registra el timestamp de actualización

## 📖 Ejemplo de Uso Completo

```bash
# 1. Configurar el sistema (una sola vez)
./scripts/create-audit-labels.sh Angel-Baez mern-agents-framework

# 2. Crear casos de auditoría (interfaz web o CLI)
gh issue create --repo Angel-Baez/mern-agents-framework \
  --template audit-case.yml

# 3. El Epic se actualiza automáticamente ✨

# 4. Consultar métricas
gh issue view 7 --repo Angel-Baez/mern-agents-framework

# 5. Filtrar por criterios
gh issue list --repo Angel-Baez/mern-agents-framework \
  --label "agent:orchestrator,case-success"
```

## 🤝 Contribuir al Sistema

Para mejorar el sistema de auditoría:
1. Propón mejoras al template en `.github/ISSUE_TEMPLATE/audit-case.yml`
2. Sugiere nuevos labels en `scripts/create-audit-labels.sh`
3. Optimiza el workflow en `.github/workflows/update-audit-epic.yml`
4. Documenta patrones en casos de auditoría

## 📚 Recursos

- [GitHub Issue Templates](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/configuring-issue-templates-for-your-repository)
- [GitHub Actions](https://docs.github.com/en/actions)
- [GitHub CLI](https://cli.github.com/)
- [MERN Agents Framework](https://github.com/Angel-Baez/mern-agents-framework)

## 📄 Licencia

MIT © Angel Baez
