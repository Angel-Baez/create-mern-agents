#!/bin/bash

# =============================================================================
# MERN Agents Framework - Add Agent Script
# =============================================================================
# Script para agregar agentes individuales después de la instalación inicial
# 
# Uso:
#   ./add-agent.sh <nombre-agente> [nombre-agente2 ...]
#
# Ejemplos:
#   ./add-agent.sh security-guardian
#   ./add-agent.sh devops-engineer release-manager
# =============================================================================

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuración
REPO_URL="https://raw.githubusercontent.com/Angel-Baez/mern-agents-framework/main"
AGENTS_DIR_STANDARD=".github/agents"
AGENTS_DIR_COMPAT=".github/copilot/agents"

# Lista de agentes disponibles
AVAILABLE_AGENTS=(
    "ai-integration-engineer"
    "backend-architect"
    "code-reviewer"
    "data-engineer"
    "devops-engineer"
    "documentation-engineer"
    "frontend-architect"
    "observability-engineer"
    "orchestrator"
    "product-manager"
    "qa-lead"
    "release-manager"
    "security-guardian"
    "solution-architect"
    "test-engineer"
)

# =============================================================================
# FUNCIONES DE UTILIDAD
# =============================================================================

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# =============================================================================
# VALIDACIÓN
# =============================================================================

check_requirements() {
    # Verificar que estamos en un directorio de proyecto
    if [ ! -f "package.json" ]; then
        print_error "No se encontró package.json en el directorio actual"
        echo "Ejecuta este script desde la raíz de tu proyecto MERN/Next.js"
        exit 1
    fi
    
    # Verificar que existe el directorio de agentes
    if [ ! -d "$AGENTS_DIR_STANDARD" ]; then
        print_error "No se encontró el directorio de agentes: $AGENTS_DIR_STANDARD"
        echo "¿Ya ejecutaste init-agents.sh?"
        exit 1
    fi
    
    # Verificar curl o wget
    if command -v curl &> /dev/null; then
        DOWNLOAD_CMD="curl -fsSL"
    elif command -v wget &> /dev/null; then
        DOWNLOAD_CMD="wget -qO-"
    else
        print_error "Se requiere curl o wget para descargar los archivos"
        exit 1
    fi
}

validate_agent() {
    local agent=$1
    local found=false
    
    for available in "${AVAILABLE_AGENTS[@]}"; do
        if [ "$available" = "$agent" ]; then
            found=true
            break
        fi
    done
    
    if [ "$found" = false ]; then
        return 1
    fi
    return 0
}

agent_exists() {
    local agent=$1
    if [ -f "$AGENTS_DIR_STANDARD/${agent}.md" ]; then
        return 0
    fi
    return 1
}

# =============================================================================
# DESCARGA DE AGENTES
# =============================================================================

download_agent() {
    local agent=$1
    local agent_file="${agent}.md"
    
    # Validar que el agente existe en el framework
    if ! validate_agent "$agent"; then
        print_error "Agente '$agent' no existe en mern-agents-framework"
        echo ""
        echo "Agentes disponibles:"
        for available in "${AVAILABLE_AGENTS[@]}"; do
            echo "  • $available"
        done
        return 1
    fi
    
    # Verificar si ya existe
    if agent_exists "$agent"; then
        print_warning "Agente '$agent' ya está instalado"
        read -p "¿Deseas reemplazarlo? [y/N]: " replace
        if [[ ! "$replace" =~ ^[Yy]$ ]]; then
            print_info "Omitiendo $agent"
            return 2  # Return 2 to indicate skipped
        fi
    fi
    
    # Descargar el agente
    echo -n "Descargando ${agent}... "
    
    if $DOWNLOAD_CMD "$REPO_URL/agents/$agent_file" > "$AGENTS_DIR_STANDARD/$agent_file" 2>/dev/null; then
        # Copiar a ubicación alternativa (compatibilidad)
        if [ -d "$AGENTS_DIR_COMPAT" ]; then
            cp "$AGENTS_DIR_STANDARD/$agent_file" "$AGENTS_DIR_COMPAT/$agent_file" 2>/dev/null || true
        fi
        print_success "$agent instalado correctamente"
        return 0
    else
        print_error "Error al descargar $agent desde el repositorio"
        return 1
    fi
}

# =============================================================================
# MAIN
# =============================================================================

show_help() {
    echo "MERN Agents Framework - Add Agent"
    echo ""
    echo "Uso: $0 <nombre-agente> [nombre-agente2 ...]"
    echo ""
    echo "Agentes disponibles:"
    for agent in "${AVAILABLE_AGENTS[@]}"; do
        echo "  • $agent"
    done
    echo ""
    echo "Ejemplos:"
    echo "  $0 security-guardian"
    echo "  $0 devops-engineer release-manager"
    echo "  $0 ai-integration-engineer observability-engineer"
    echo ""
}

main() {
    # Si no hay argumentos o se pide ayuda
    if [ $# -eq 0 ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        show_help
        exit 0
    fi
    
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}          MERN Agents Framework - Agregar Agentes${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    check_requirements
    
    # Procesar cada agente
    local success_count=0
    local fail_count=0
    local skip_count=0
    
    for agent in "$@"; do
        set +e  # Temporarily disable exit on error
        download_agent "$agent"
        local result=$?
        set -e  # Re-enable exit on error
        
        if [ $result -eq 0 ]; then
            success_count=$((success_count + 1))
        elif [ $result -eq 2 ]; then
            skip_count=$((skip_count + 1))
        else
            fail_count=$((fail_count + 1))
        fi
    done
    
    # Resumen
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════════════════${NC}"
    if [ $success_count -gt 0 ] || [ $skip_count -gt 0 ]; then
        echo -e "${GREEN}Agentes instalados: $success_count${NC}"
    fi
    if [ $skip_count -gt 0 ]; then
        echo -e "${YELLOW}Agentes omitidos: $skip_count${NC}"
    fi
    if [ $fail_count -gt 0 ]; then
        echo -e "${RED}Errores: $fail_count${NC}"
    fi
    echo ""
    
    if [ $success_count -gt 0 ]; then
        echo -e "${GREEN}✓ Los agentes están listos para usar con GitHub Copilot${NC}"
        echo ""
    fi
    
    # Exit with error only if any downloads failed (not if skipped)
    if [ $fail_count -gt 0 ]; then
        exit 1
    fi
}

main "$@"
