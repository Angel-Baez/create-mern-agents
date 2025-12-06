#!/bin/bash

# =============================================================================
# MERN Agents Framework - Add Agent Script
# =============================================================================
# Script para agregar agentes individuales a un proyecto existente
# 
# Uso:
#   ./add-agent.sh <agent-name>
#   ./add-agent.sh security-guardian
#   ./add-agent.sh --list
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

# Funciones de utilidad
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Lista de agentes disponibles generada dinámicamente desde los archivos de agentes.
# NOTA: Para descripciones y categorías completas, consulta el archivo fuente de verdad:
#   bin/create-mern-agents.js (AGENTS_METADATA)
# Si agregas, renombras o eliminas agentes, asegúrate de mantener ambos en sincronía.
list_agents() {
    echo ""
    echo -e "${CYAN}Agentes disponibles (detectados en el directorio de agentes):${NC}"
    echo ""
    AGENTS_FOUND=0
    # Buscar en ambos directorios posibles
    for AGENTS_DIR in "$AGENTS_DIR_STANDARD" "$AGENTS_DIR_COMPAT"; do
        if [ -d "$AGENTS_DIR" ]; then
            for agent_file in "$AGENTS_DIR"/*; do
                if [ -f "$agent_file" ]; then
                    agent_name=$(basename "$agent_file")
                    # Quitar extensión si existe (por ejemplo .js, .sh, etc.)
                    agent_name="${agent_name%%.*}"
                    echo "  • $agent_name"
                    AGENTS_FOUND=1
                fi
            done
        fi
    done
    if [ "$AGENTS_FOUND" -eq 0 ]; then
        echo -e "${YELLOW}No se encontraron agentes en los directorios esperados.${NC}"
    fi
    echo ""
    echo -e "${YELLOW}Nota:${NC} Para descripciones y categorías, consulta la documentación o el archivo bin/create-mern-agents.js"
}

# Verificar requisitos
check_requirements() {
    # Verificar que estamos en un proyecto con agentes
    if [ ! -d "$AGENTS_DIR_STANDARD" ] && [ ! -d "$AGENTS_DIR_COMPAT" ]; then
        print_error "No se encontró la estructura de agentes"
        print_warning "Ejecuta primero: npx create-mern-agents"
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

# Descargar agente
download_agent() {
    local agent_name=$1
    
    # Agregar extensión .md si no la tiene
    if [[ ! "$agent_name" == *.md ]]; then
        agent_name="${agent_name}.md"
    fi
    
    # Verificar si el agente ya existe
    if [ -f "$AGENTS_DIR_STANDARD/$agent_name" ]; then
        print_warning "El agente $agent_name ya existe"
        read -p "¿Deseas sobrescribirlo? [y/N]: " overwrite
        if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
            print_info "Operación cancelada"
            exit 0
        fi
    fi
    
    print_info "Descargando $agent_name..."
    
    # Crear directorios si no existen
    mkdir -p "$AGENTS_DIR_STANDARD"
    mkdir -p "$AGENTS_DIR_COMPAT"
    
    # Descargar a ubicación estándar
    if $DOWNLOAD_CMD "$REPO_URL/agents/$agent_name" > "$AGENTS_DIR_STANDARD/$agent_name" 2>/dev/null; then
        # Copiar a ubicación alternativa (compatibilidad)
        cp "$AGENTS_DIR_STANDARD/$agent_name" "$AGENTS_DIR_COMPAT/$agent_name" 2>/dev/null || true
        print_success "Agente $agent_name instalado correctamente"
        if ! cp "$AGENTS_DIR_STANDARD/$agent_name" "$AGENTS_DIR_COMPAT/$agent_name" 2>/dev/null; then
            print_warning "No se pudo copiar a ubicación de compatibilidad: $AGENTS_DIR_COMPAT/$agent_name"
        fi
        print_info "Ahora puedes usar el agente en GitHub Copilot Chat:"
        echo -e "  ${CYAN}@${agent_name%.md}${NC} <tu pregunta>"
    else
        print_error "No se pudo descargar $agent_name"
        print_warning "Verifica que el nombre del agente sea correcto"
        echo ""
        echo "Usa: ./add-agent.sh --list para ver agentes disponibles"
        exit 1
    fi
}

# Main
main() {
    if [ $# -eq 0 ]; then
        print_error "Debes especificar un agente o usar --list"
        echo ""
        echo "Uso:"
        echo "  ./add-agent.sh <agent-name>"
        echo "  ./add-agent.sh --list"
        exit 1
    fi
    
    if [ "$1" = "--list" ] || [ "$1" = "-l" ]; then
        list_agents
        exit 0
    fi
    
    check_requirements
    download_agent "$1"
}

main "$@"
