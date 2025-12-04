#!/bin/bash

# =============================================================================
# MERN Agents Framework - Init Script
# =============================================================================
# Script para inicializar los agentes de GitHub Copilot en un proyecto MERN
# 
# Uso:
#   curl -fsSL https://raw.githubusercontent.com/Angel-Baez/mern-agents-framework/main/init-agents.sh | bash
#   
#   O localmente:
#   ./init-agents.sh [--template=<template>]
#
# Templates disponibles:
#   - pwa-offline
#   - saas-platform
#   - ecommerce
#   - admin-dashboard
# =============================================================================

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuración
REPO_URL="https://raw.githubusercontent.com/Angel-Baez/mern-agents-framework/main"
AGENTS_DIR_STANDARD=".github/agents"
AGENTS_DIR_COMPAT=".github/copilot/agents"

# Variables globales para flags
MINIMAL_MODE=false
NO_PIPELINE=false
NO_AUTH=false
NO_AI=false
NO_OBSERVABILITY=false

# Variables de detección
HAS_AUTH=false
HAS_PIPELINE=false
HAS_AI=false
HAS_OBSERVABILITY=false
HAS_DATABASE=false
PROJECT_SIZE="small"

# =============================================================================
# FUNCIONES DE UTILIDAD
# =============================================================================

print_banner() {
    echo ""
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}           ${PURPLE}🤖 MERN Agents Framework Installer${NC}                     ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}     ${YELLOW}Framework de agentes para MERN + Next.js + TypeScript${NC}        ${CYAN}║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}➤${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

check_requirements() {
    print_step "Verificando requisitos..."
    
    # Verificar que estamos en un directorio de proyecto
    if [ ! -f "package.json" ]; then
        print_error "No se encontró package.json en el directorio actual"
        print_warning "Ejecuta este script desde la raíz de tu proyecto MERN/Next.js"
        exit 1
    fi
    
    print_success "package.json encontrado"
    
    # Verificar curl o wget
    if command -v curl &> /dev/null; then
        DOWNLOAD_CMD="curl -fsSL"
    elif command -v wget &> /dev/null; then
        DOWNLOAD_CMD="wget -qO-"
    else
        print_error "Se requiere curl o wget para descargar los archivos"
        exit 1
    fi
    
    print_success "Herramienta de descarga disponible"
}

# =============================================================================
# DETECCIÓN DE CARACTERÍSTICAS DEL PROYECTO
# =============================================================================

detect_authentication() {
    # Buscar dependencias relacionadas con autenticación en package.json
    if grep -qE '"(next-auth|passport|jsonwebtoken|bcrypt|bcryptjs|express-session|cookie-session|auth0|clerk)"' package.json 2>/dev/null; then
        HAS_AUTH=true
        return
    fi
    
    # Buscar archivos de configuración de auth
    if [ -f "middleware.ts" ] || [ -f "middleware.js" ]; then
        if grep -qE "(auth|session|token)" middleware.ts middleware.js 2>/dev/null; then
            HAS_AUTH=true
            return
        fi
    fi
    
    # Buscar en archivos .env.example
    if [ -f ".env.example" ]; then
        if grep -qE "(AUTH|SESSION|JWT|TOKEN)_SECRET" .env.example 2>/dev/null; then
            HAS_AUTH=true
            return
        fi
    fi
}

detect_pipeline() {
    # Buscar archivos de CI/CD
    if [ -d ".github/workflows" ] && [ "$(ls -A .github/workflows 2>/dev/null)" ]; then
        HAS_PIPELINE=true
        return
    fi
    
    if [ -f ".gitlab-ci.yml" ] || [ -f ".circleci/config.yml" ] || [ -f "azure-pipelines.yml" ] || [ -f "bitbucket-pipelines.yml" ]; then
        HAS_PIPELINE=true
        return
    fi
}

detect_ai_integration() {
    # Buscar dependencias de IA
    if grep -qE '"(openai|@anthropic-ai/sdk|@google/generative-ai|langchain|llamaindex|replicate)"' package.json 2>/dev/null; then
        HAS_AI=true
        return
    fi
    
    # Buscar variables de entorno de IA
    if [ -f ".env.example" ]; then
        if grep -qE "(OPENAI|ANTHROPIC|GOOGLE_AI|REPLICATE)_API_KEY" .env.example 2>/dev/null; then
            HAS_AI=true
            return
        fi
    fi
}

detect_observability() {
    # Buscar herramientas de monitoreo y observabilidad
    if grep -qE '"(newrelic|@sentry/nextjs|@datadog|pino|winston|elastic-apm-node|@opentelemetry)"' package.json 2>/dev/null; then
        HAS_OBSERVABILITY=true
        return
    fi
    
    # Buscar archivos de configuración
    if [ -f "newrelic.js" ] || [ -f "sentry.client.config.js" ] || [ -f "datadog.yml" ]; then
        HAS_OBSERVABILITY=true
        return
    fi
}

detect_database() {
    # Buscar dependencias de bases de datos
    if grep -qE '"(mongoose|prisma|@prisma/client|mongodb|pg|mysql2|sequelize|typeorm|drizzle-orm)"' package.json 2>/dev/null; then
        HAS_DATABASE=true
        return
    fi
    
    # Buscar archivos de configuración de DB
    if [ -f "prisma/schema.prisma" ] || [ -d "models" ] || [ -d "src/models" ]; then
        HAS_DATABASE=true
        return
    fi
}

detect_project_size() {
    # Contar archivos de código (excluyendo node_modules, dist, etc.)
    local code_files=$(find . -type f \( -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" \) \
        -not -path "*/node_modules/*" \
        -not -path "*/dist/*" \
        -not -path "*/.next/*" \
        -not -path "*/build/*" 2>/dev/null | wc -l)
    
    # Leer package.json para ver número de dependencias
    local deps_count=0
    if command -v jq &> /dev/null; then
        deps_count=$(jq '(.dependencies // {} | length) + (.devDependencies // {} | length)' package.json 2>/dev/null || echo 0)
    else
        # Contar solo en las secciones dependencies y devDependencies
        deps_count=$(grep -A 9999 '"dependencies"' package.json 2>/dev/null | grep -B 9999 '^  }' | grep -c '":' || echo 0)
        local dev_deps=$(grep -A 9999 '"devDependencies"' package.json 2>/dev/null | grep -B 9999 '^  }' | grep -c '":' || echo 0)
        deps_count=$((deps_count + dev_deps))
    fi
    
    # Determinar tamaño del proyecto
    if [ "$code_files" -lt 50 ] && [ "$deps_count" -lt 30 ]; then
        PROJECT_SIZE="small"
    elif [ "$code_files" -lt 200 ] && [ "$deps_count" -lt 60 ]; then
        PROJECT_SIZE="medium"
    else
        PROJECT_SIZE="large"
    fi
}

run_auto_detection() {
    if [ "$MINIMAL_MODE" = true ]; then
        print_step "Modo minimal activado - omitiendo detección automática"
        return
    fi
    
    print_step "Detectando características del proyecto..."
    
    # Aplicar overrides manuales
    if [ "$NO_AUTH" = true ]; then
        HAS_AUTH=false
    else
        detect_authentication
    fi
    
    if [ "$NO_PIPELINE" = true ]; then
        HAS_PIPELINE=false
    else
        detect_pipeline
    fi
    
    if [ "$NO_AI" = true ]; then
        HAS_AI=false
    else
        detect_ai_integration
    fi
    
    if [ "$NO_OBSERVABILITY" = true ]; then
        HAS_OBSERVABILITY=false
    else
        detect_observability
    fi
    
    detect_database
    detect_project_size
    
    # Mostrar resultados de detección
    echo ""
    echo -e "${CYAN}Características detectadas:${NC}"
    echo -e "  Tamaño del proyecto: ${YELLOW}$PROJECT_SIZE${NC}"
    [ "$HAS_AUTH" = true ] && echo -e "  ${GREEN}✓${NC} Autenticación detectada" || echo -e "  ${RED}✗${NC} Sin autenticación"
    [ "$HAS_PIPELINE" = true ] && echo -e "  ${GREEN}✓${NC} Pipeline CI/CD detectado" || echo -e "  ${RED}✗${NC} Sin pipeline CI/CD"
    [ "$HAS_AI" = true ] && echo -e "  ${GREEN}✓${NC} Integración de IA detectada" || echo -e "  ${RED}✗${NC} Sin integración de IA"
    [ "$HAS_OBSERVABILITY" = true ] && echo -e "  ${GREEN}✓${NC} Observabilidad detectada" || echo -e "  ${RED}✗${NC} Sin observabilidad"
    [ "$HAS_DATABASE" = true ] && echo -e "  ${GREEN}✓${NC} Base de datos detectada" || echo -e "  ${RED}✗${NC} Sin base de datos"
    echo ""
}

# =============================================================================
# RECOLECCIÓN DE INFORMACIÓN DEL PROYECTO
# =============================================================================

collect_project_info() {
    echo ""
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}                    CONFIGURACIÓN DEL PROYECTO${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    # Nombre del proyecto (default: nombre del directorio)
    DEFAULT_NAME=$(basename "$(pwd)")
    read -p "Nombre del proyecto [$DEFAULT_NAME]: " PROJECT_NAME
    PROJECT_NAME=${PROJECT_NAME:-$DEFAULT_NAME}
    
    # Descripción
    read -p "Descripción del proyecto: " PROJECT_DESCRIPTION
    PROJECT_DESCRIPTION=${PROJECT_DESCRIPTION:-"Proyecto MERN Stack con Next.js y TypeScript"}
    
    # Repositorio
    DEFAULT_REPO="usuario/$PROJECT_NAME"
    read -p "Repositorio GitHub [$DEFAULT_REPO]: " PROJECT_REPO
    PROJECT_REPO=${PROJECT_REPO:-$DEFAULT_REPO}
    
    # Tipo de proyecto
    echo ""
    echo "Tipo de proyecto:"
    echo "  1) web-app (Aplicación web estándar)"
    echo "  2) pwa (Progressive Web App)"
    echo "  3) saas (Software as a Service)"
    echo "  4) ecommerce (Tienda online)"
    echo "  5) admin-dashboard (Panel administrativo)"
    read -p "Selecciona [1-5, default: 1]: " PROJECT_TYPE_CHOICE
    
    case $PROJECT_TYPE_CHOICE in
        2) PROJECT_TYPE="pwa" ;;
        3) PROJECT_TYPE="saas" ;;
        4) PROJECT_TYPE="ecommerce" ;;
        5) PROJECT_TYPE="admin-dashboard" ;;
        *) PROJECT_TYPE="web-app" ;;
    esac
    
    # Features
    echo ""
    echo -e "${CYAN}Selecciona las features a habilitar:${NC}"
    
    read -p "¿Autenticación de usuarios? [Y/n]: " AUTH_CHOICE
    FEAT_AUTH=$([[ "$AUTH_CHOICE" =~ ^[Nn]$ ]] && echo "false" || echo "true")
    
    read -p "¿PWA con soporte offline? [y/N]: " PWA_CHOICE
    FEAT_PWA=$([[ "$PWA_CHOICE" =~ ^[Yy]$ ]] && echo "true" || echo "false")
    
    read -p "¿Integración de pagos? [y/N]: " PAYMENTS_CHOICE
    FEAT_PAYMENTS=$([[ "$PAYMENTS_CHOICE" =~ ^[Yy]$ ]] && echo "true" || echo "false")
    
    read -p "¿Integración con IA (OpenAI/Anthropic/etc)? [y/N]: " AI_CHOICE
    FEAT_AI=$([[ "$AI_CHOICE" =~ ^[Yy]$ ]] && echo "true" || echo "false")
    
    # Provider de pagos si está habilitado
    if [ "$FEAT_PAYMENTS" = "true" ]; then
        echo ""
        echo "Provider de pagos:"
        echo "  1) stripe"
        echo "  2) mercadopago"
        echo "  3) paypal"
        read -p "Selecciona [1-3, default: 1]: " PAYMENT_CHOICE
        
        case $PAYMENT_CHOICE in
            2) PAYMENT_PROVIDER="mercadopago" ;;
            3) PAYMENT_PROVIDER="paypal" ;;
            *) PAYMENT_PROVIDER="stripe" ;;
        esac
    else
        PAYMENT_PROVIDER=""
    fi
    
    # Provider de IA si está habilitado
    if [ "$FEAT_AI" = "true" ]; then
        echo ""
        echo "Provider de IA:"
        echo "  1) openai"
        echo "  2) anthropic"
        echo "  3) google"
        read -p "Selecciona [1-3, default: 1]: " AI_PROVIDER_CHOICE
        
        case $AI_PROVIDER_CHOICE in
            2) AI_PROVIDER="anthropic" ;;
            3) AI_PROVIDER="google" ;;
            *) AI_PROVIDER="openai" ;;
        esac
    else
        AI_PROVIDER=""
    fi
    
    # Entidades del dominio
    echo ""
    read -p "Entidades principales del dominio (separadas por coma) [User,Product]: " ENTITIES
    ENTITIES=${ENTITIES:-"User,Product"}
}

# =============================================================================
# CREACIÓN DE ESTRUCTURA
# =============================================================================

create_directory_structure() {
    print_step "Creando estructura de directorios..."
    
    # Crear directorios principales para ambas ubicaciones
    mkdir -p "$AGENTS_DIR_STANDARD/_core"
    mkdir -p "$AGENTS_DIR_COMPAT/_core"
    
    print_success "Directorios creados: $AGENTS_DIR_STANDARD y $AGENTS_DIR_COMPAT"
}

download_core_files() {
    print_step "Descargando archivos core..."
    
    local core_files=(
        "_framework-context.md"
        "_shared-solid-principles.md"
        "_shared-data-modeling.md"
        "_shared-workflows.md"
        "_conflict-resolution.md"
    )
    
    for file in "${core_files[@]}"; do
        # Descargar a ubicación estándar
        $DOWNLOAD_CMD "$REPO_URL/_core/$file" > "$AGENTS_DIR_STANDARD/_core/$file" 2>/dev/null || {
            print_warning "No se pudo descargar $file, creando placeholder..."
            echo "# $file - Placeholder" > "$AGENTS_DIR_STANDARD/_core/$file"
        }
        # Copiar a ubicación alternativa (compatibilidad)
        cp "$AGENTS_DIR_STANDARD/_core/$file" "$AGENTS_DIR_COMPAT/_core/$file"
        print_success "  $file"
    done
}

download_agents() {
    print_step "Descargando agentes seleccionados..."
    
    # Lista de agentes a descargar
    local agents_to_download=()
    
    if [ "$MINIMAL_MODE" = true ]; then
        # Modo minimal: solo agentes core esenciales
        print_warning "Modo MINIMAL: instalando solo agentes core esenciales"
        agents_to_download=(
            "orchestrator.md"
            "solution-architect.md"
            "backend-architect.md"
            "frontend-architect.md"
            "code-reviewer.md"
            "test-engineer.md"
        )
    else
        # Agentes core (siempre se descargan)
        agents_to_download=(
            "orchestrator.md"
            "solution-architect.md"
            "code-reviewer.md"
            "documentation-engineer.md"
        )
        
        # Agentes según tamaño del proyecto
        if [ "$PROJECT_SIZE" = "small" ]; then
            agents_to_download+=("backend-architect.md" "frontend-architect.md" "test-engineer.md")
        elif [ "$PROJECT_SIZE" = "medium" ]; then
            agents_to_download+=("backend-architect.md" "frontend-architect.md" "test-engineer.md" "qa-lead.md" "product-manager.md")
        else
            # Large project - agregar más agentes base
            agents_to_download+=("backend-architect.md" "frontend-architect.md" "test-engineer.md" "qa-lead.md" "product-manager.md")
        fi
        
        # Agentes condicionales según características
        if [ "$HAS_AUTH" = true ]; then
            agents_to_download+=("security-guardian.md")
        fi
        
        if [ "$HAS_PIPELINE" = true ]; then
            agents_to_download+=("devops-engineer.md" "release-manager.md")
        fi
        
        if [ "$HAS_AI" = true ]; then
            agents_to_download+=("ai-integration-engineer.md")
        fi
        
        if [ "$HAS_OBSERVABILITY" = true ]; then
            agents_to_download+=("observability-engineer.md")
        fi
        
        if [ "$HAS_DATABASE" = true ]; then
            agents_to_download+=("data-engineer.md")
        fi
    fi
    
    # Mostrar qué agentes se van a instalar
    echo ""
    echo -e "${CYAN}Agentes a instalar (${#agents_to_download[@]}):${NC}"
    for agent in "${agents_to_download[@]}"; do
        echo "  • ${agent%.md}"
    done
    echo ""
    
    # Descargar cada agente
    for agent in "${agents_to_download[@]}"; do
        # Descargar a ubicación estándar
        $DOWNLOAD_CMD "$REPO_URL/agents/$agent" > "$AGENTS_DIR_STANDARD/$agent" 2>/dev/null || {
            print_warning "No se pudo descargar $agent"
        }
        # Copiar a ubicación alternativa (compatibilidad)
        cp "$AGENTS_DIR_STANDARD/$agent" "$AGENTS_DIR_COMPAT/$agent" 2>/dev/null || true
        print_success "  $agent"
    done
    
    # Mostrar agentes omitidos si no estamos en modo minimal
    if [ "$MINIMAL_MODE" = false ]; then
        local all_agents=("orchestrator.md" "product-manager.md" "solution-architect.md" "backend-architect.md" 
                         "frontend-architect.md" "data-engineer.md" "security-guardian.md" "test-engineer.md" 
                         "qa-lead.md" "devops-engineer.md" "observability-engineer.md" "ai-integration-engineer.md" 
                         "documentation-engineer.md" "release-manager.md" "code-reviewer.md")
        
        local omitted_agents=()
        for agent in "${all_agents[@]}"; do
            local found=false
            for downloaded in "${agents_to_download[@]}"; do
                if [ "$agent" = "$downloaded" ]; then
                    found=true
                    break
                fi
            done
            if [ "$found" = false ]; then
                omitted_agents+=("${agent%.md}")
            fi
        done
        
        if [ ${#omitted_agents[@]} -gt 0 ]; then
            echo ""
            echo -e "${YELLOW}Agentes omitidos (${#omitted_agents[@]}):${NC}"
            for agent in "${omitted_agents[@]}"; do
                echo "  • $agent"
            done
            echo ""
            echo -e "${CYAN}Tip:${NC} Puedes agregar agentes después con: ${GREEN}./add-agent.sh <nombre-agente>${NC}"
        fi
    fi
}

download_template() {
    local template=$1
    
    if [ -n "$template" ]; then
        print_step "Descargando template: $template..."
        
        # Crear directorio templates en ambas ubicaciones
        mkdir -p "$AGENTS_DIR_STANDARD/templates"
        mkdir -p "$AGENTS_DIR_COMPAT/templates"
        
        case $template in
            "pwa-offline")
                $DOWNLOAD_CMD "$REPO_URL/templates/pwa-offline/pwa-specialist.md" > "$AGENTS_DIR_STANDARD/templates/pwa-specialist.md" 2>/dev/null
                cp "$AGENTS_DIR_STANDARD/templates/pwa-specialist.md" "$AGENTS_DIR_COMPAT/templates/pwa-specialist.md" 2>/dev/null || true
                print_success "  templates/pwa-specialist.md"
                ;;
            "saas-platform")
                $DOWNLOAD_CMD "$REPO_URL/templates/saas-platform/saas-architect.md" > "$AGENTS_DIR_STANDARD/templates/saas-architect.md" 2>/dev/null
                cp "$AGENTS_DIR_STANDARD/templates/saas-architect.md" "$AGENTS_DIR_COMPAT/templates/saas-architect.md" 2>/dev/null || true
                print_success "  templates/saas-architect.md"
                ;;
            "ecommerce")
                $DOWNLOAD_CMD "$REPO_URL/templates/ecommerce/payments-specialist.md" > "$AGENTS_DIR_STANDARD/templates/payments-specialist.md" 2>/dev/null
                cp "$AGENTS_DIR_STANDARD/templates/payments-specialist.md" "$AGENTS_DIR_COMPAT/templates/payments-specialist.md" 2>/dev/null || true
                print_success "  templates/payments-specialist.md"
                ;;
        esac
    fi
}

generate_project_context() {
    print_step "Generando project-context.yml..."
    
    # Generar lista de entidades en formato YAML
    local entities_yaml=""
    IFS=',' read -ra ENTITY_ARRAY <<< "$ENTITIES"
    for entity in "${ENTITY_ARRAY[@]}"; do
        entity=$(echo "$entity" | xargs)  # Trim whitespace
        entities_yaml="${entities_yaml}
    - name: \"$entity\"
      description: \"Entidad $entity del sistema\""
    done
    
    # Crear project-context.yml en ubicación estándar
    cat > "$AGENTS_DIR_STANDARD/project-context.yml" << EOF
# =============================================================================
# PROJECT CONTEXT - $PROJECT_NAME
# =============================================================================
# Generado automáticamente por MERN Agents Framework
# Fecha: $(date +"%Y-%m-%d")
# =============================================================================

project:
  name: "$PROJECT_NAME"
  description: "$PROJECT_DESCRIPTION"
  repository: "$PROJECT_REPO"
  type: "$PROJECT_TYPE"
  version: "0.1.0"

stack:
  framework: "next.js"
  framework_version: "14"
  typescript: true
  styling: "tailwind"
  ui_library: "shadcn-ui"
  state_management: "zustand"
  form_handling: "react-hook-form"
  backend: "next-api-routes"
  api_style: "rest"
  database: "mongodb"
  orm: "mongoose"
  deployment: "vercel"

features:
  authentication: $FEAT_AUTH
  auth_provider: "next-auth"
  offline_first: $FEAT_PWA
  pwa: $FEAT_PWA
  payments: $FEAT_PAYMENTS
  payment_provider: "$PAYMENT_PROVIDER"
  ai_integration: $FEAT_AI
  ai_provider: "$AI_PROVIDER"

architecture:
  pattern: "clean-architecture"
  layers:
    domain: "src/core/domain"
    services: "src/core/services"
    repositories: "src/core/repositories"
    api: "src/app/api"
    components: "src/components"
  testing_strategy: "pyramid"
  test_framework: "vitest"
  e2e_framework: "playwright"
  ci_cd: "github-actions"

quality_targets:
  lighthouse_performance: 90
  lighthouse_accessibility: 100
  test_coverage: 80

domain:
  entities:$entities_yaml

  main_flows:
    - name: "user-authentication"
      description: "Flujo de autenticación de usuarios"

conventions:
  component_naming: "PascalCase"
  file_naming: "kebab-case"
  function_naming: "camelCase"
  commit_convention: "conventional"
EOF
    
    # Copiar a ubicación alternativa (compatibilidad)
    cp "$AGENTS_DIR_STANDARD/project-context.yml" "$AGENTS_DIR_COMPAT/project-context.yml"
    
    print_success "project-context.yml generado en ambas ubicaciones"
}

# =============================================================================
# RESUMEN FINAL
# =============================================================================

print_summary() {
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}                    ✓ INSTALACIÓN COMPLETADA${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "Proyecto configurado: ${CYAN}$PROJECT_NAME${NC}"
    echo -e "Tipo: ${CYAN}$PROJECT_TYPE${NC}"
    echo ""
    echo "Archivos creados:"
    echo -e "  ${BLUE}$AGENTS_DIR_STANDARD/${NC} (Ubicación estándar)"
    echo "    ├── _core/             (Contexto compartido)"
    echo "    ├── templates/         (Agentes especializados - si aplica)"
    echo "    ├── project-context.yml (Configuración del proyecto)"
    echo "    └── *.md               (Agentes)"
    echo ""
    echo -e "  ${BLUE}$AGENTS_DIR_COMPAT/${NC} (Ubicación alternativa - compatibilidad)"
    echo "    ├── _core/             (Contexto compartido)"
    echo "    ├── templates/         (Agentes especializados - si aplica)"
    echo "    ├── project-context.yml (Configuración del proyecto)"
    echo "    └── *.md               (Agentes)"
    echo ""
    echo -e "${YELLOW}Próximos pasos:${NC}"
    echo "  1. Revisa y personaliza $AGENTS_DIR_STANDARD/project-context.yml"
    echo "  2. Usa los agentes en GitHub Copilot Chat:"
    echo ""
    echo -e "     ${PURPLE}@orchestrator${NC} ¿Cómo empiezo a desarrollar mi aplicación?"
    echo ""
    echo -e "  3. Consulta la documentación: ${CYAN}https://github.com/Angel-Baez/mern-agents-framework${NC}"
    echo ""
}

# =============================================================================
# MAIN
# =============================================================================

main() {
    local TEMPLATE=""
    
    # Parse arguments
    for arg in "$@"; do
        case $arg in
            --minimal)
                MINIMAL_MODE=true
                ;;
            --no-pipeline)
                NO_PIPELINE=true
                ;;
            --no-auth)
                NO_AUTH=true
                ;;
            --no-ai)
                NO_AI=true
                ;;
            --no-observability)
                NO_OBSERVABILITY=true
                ;;
            --template=*)
                TEMPLATE="${arg#*=}"
                ;;
            --help)
                echo "Uso: $0 [opciones]"
                echo ""
                echo "Opciones:"
                echo "  --minimal              Instalar solo agentes core esenciales (6 agentes)"
                echo "  --no-pipeline          Omitir agentes de CI/CD"
                echo "  --no-auth              Omitir agentes de autenticación"
                echo "  --no-ai                Omitir agentes de integración de IA"
                echo "  --no-observability     Omitir agentes de observabilidad"
                echo "  --template=<template>  Usar template específico (pwa-offline, saas-platform, ecommerce)"
                echo "  --help                 Mostrar esta ayuda"
                echo ""
                echo "Ejemplos:"
                echo "  $0 --minimal                    # Proyecto MVP básico"
                echo "  $0 --no-pipeline                # Proyecto sin CI/CD"
                echo "  $0 --no-auth --no-ai            # Proyecto sin auth ni IA"
                echo ""
                exit 0
                ;;
        esac
    done
    
    print_banner
    check_requirements
    
    # Si no es modo minimal, ejecutar detección y recolectar info
    if [ "$MINIMAL_MODE" = false ]; then
        run_auto_detection
        collect_project_info
    else
        # En modo minimal, usar valores por defecto
        DEFAULT_NAME=$(basename "$(pwd)")
        PROJECT_NAME=$DEFAULT_NAME
        PROJECT_DESCRIPTION="Proyecto MERN Stack con Next.js y TypeScript"
        PROJECT_REPO="usuario/$PROJECT_NAME"
        PROJECT_TYPE="web-app"
        FEAT_AUTH=false
        FEAT_PWA=false
        FEAT_PAYMENTS=false
        FEAT_AI=false
        PAYMENT_PROVIDER=""
        AI_PROVIDER=""
        ENTITIES="User,Product"
    fi
    
    echo ""
    create_directory_structure
    download_core_files
    download_agents
    
    # Descargar template si se especificó o si el tipo lo requiere
    if [ -n "$TEMPLATE" ]; then
        download_template "$TEMPLATE"
    elif [ "$PROJECT_TYPE" = "pwa" ] || [ "$FEAT_PWA" = "true" ]; then
        download_template "pwa-offline"
    elif [ "$PROJECT_TYPE" = "saas" ]; then
        download_template "saas-platform"
    elif [ "$PROJECT_TYPE" = "ecommerce" ] || [ "$FEAT_PAYMENTS" = "true" ]; then
        download_template "ecommerce"
    fi
    
    generate_project_context
    print_summary
}

main "$@"