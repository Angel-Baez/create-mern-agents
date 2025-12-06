#!/usr/bin/env node

const { execFileSync, execSync } = require("child_process");
const path = require("path");
const fs = require("fs");
const https = require("https");

// =============================================================================
// AGENT METADATA
// =============================================================================
const AGENTS_METADATA = {
  // 🎯 Core
  "orchestrator": {
    category: "Core",
    description: "Coordinador principal",
    icon: "🎯",
    role: "Coordina y distribuye tareas entre agentes"
  },
  "solution-architect": {
    category: "Core",
    description: "Diseño de arquitectura",
    icon: "🎯",
    role: "Define la arquitectura general del sistema"
  },
  "product-manager": {
    category: "Core",
    description: "Gestión de producto",
    icon: "🎯",
    role: "Define features y prioriza backlog"
  },
  "code-reviewer": {
    category: "Core",
    description: "Revisión de código",
    icon: "🎯",
    role: "Revisa código siguiendo best practices"
  },
  "documentation-engineer": {
    category: "Core",
    description: "Documentación",
    icon: "🎯",
    role: "Genera y mantiene documentación técnica"
  },

  // 🏗️ Arquitectura
  "backend-architect": {
    category: "Arquitectura",
    description: "APIs y servicios",
    icon: "🏗️",
    role: "Diseña APIs RESTful o GraphQL"
  },
  "frontend-architect": {
    category: "Arquitectura",
    description: "Componentes UI",
    icon: "🏗️",
    role: "Diseña arquitectura de componentes"
  },

  // 🧪 Calidad
  "test-engineer": {
    category: "Calidad",
    description: "Testing y QA",
    icon: "🧪",
    role: "Crea tests unitarios e integración"
  },
  "qa-lead": {
    category: "Calidad",
    description: "Control de calidad",
    icon: "🧪",
    role: "Define estrategia de testing y QA"
  },

  // 🔒 Seguridad y Datos
  "security-guardian": {
    category: "Seguridad y Datos",
    description: "Autenticación y seguridad",
    icon: "🔒",
    role: "Implementa autenticación y seguridad"
  },
  "data-engineer": {
    category: "Seguridad y Datos",
    description: "Esquemas de BD",
    icon: "🔒",
    role: "Diseña esquemas de BD y optimiza queries"
  },

  // 🚀 Operaciones
  "devops-engineer": {
    category: "Operaciones",
    description: "CI/CD y deployment",
    icon: "🚀",
    role: "Configura CI/CD y automatización"
  },
  "release-manager": {
    category: "Operaciones",
    description: "Gestión de versiones",
    icon: "🚀",
    role: "Gestiona versiones y releases"
  },
  "observability-engineer": {
    category: "Operaciones",
    description: "Logging y métricas",
    icon: "🚀",
    role: "Implementa logging, métricas y alertas"
  },

  // 🤖 Especialistas
  "ai-integration-engineer": {
    category: "Especialistas",
    description: "Integración de IA",
    icon: "🤖",
    role: "Integra APIs de IA (OpenAI, Anthropic)"
  }
};

// Repository configuration
// Note: This URL points to the official mern-agents-framework repository
// where agent definitions are maintained. It's hardcoded to ensure stability
// and prevent accidental downloads from forked/modified repositories.
const REPO_URL = "https://raw.githubusercontent.com/Angel-Baez/mern-agents-framework/main";
const AGENTS_DIR_STANDARD = ".github/agents";
const AGENTS_DIR_COMPAT = ".github/copilot/agents";

// =============================================================================
// UTILITY FUNCTIONS
// =============================================================================

function downloadFile(url) {
  return new Promise((resolve, reject) => {
    https.get(url, (res) => {
      if (res.statusCode !== 200) {
        reject(new Error(`Failed to download: ${res.statusCode}`));
        return;
      }
      let data = "";
      res.on("data", (chunk) => data += chunk);
      res.on("end", () => resolve(data));
    }).on("error", reject);
  });
}

function isAgentInstalled(agentName) {
  const standardPath = path.join(process.cwd(), AGENTS_DIR_STANDARD, `${agentName}.md`);
  const compatPath = path.join(process.cwd(), AGENTS_DIR_COMPAT, `${agentName}.md`);
  // Check both locations - agent is installed if it exists in either location
  return fs.existsSync(standardPath) || fs.existsSync(compatPath);
}

function ensureAgentDirectories() {
  const standardDir = path.join(process.cwd(), AGENTS_DIR_STANDARD);
  const compatDir = path.join(process.cwd(), AGENTS_DIR_COMPAT);
  
  if (!fs.existsSync(standardDir)) {
    fs.mkdirSync(standardDir, { recursive: true });
  }
  if (!fs.existsSync(compatDir)) {
    fs.mkdirSync(compatDir, { recursive: true });
  }
}

// =============================================================================
// SUBCOMMAND: LIST
// =============================================================================

function listAgents() {
  console.log("");
  console.log("📋 Agentes disponibles:");
  console.log("");

  // Group agents by category
  const categories = {};
  Object.entries(AGENTS_METADATA).forEach(([name, meta]) => {
    if (!categories[meta.category]) {
      categories[meta.category] = [];
    }
    categories[meta.category].push({ name, ...meta });
  });

  // Display agents by category
  Object.entries(categories).forEach(([category, agents]) => {
    const icon = agents[0].icon;
    console.log(`${icon} ${category}`);
    agents.forEach(agent => {
      const installed = isAgentInstalled(agent.name);
      const checkmark = installed ? "✓" : " ";
      const nameFormatted = agent.name.padEnd(25);
      console.log(`  ${checkmark} ${nameFormatted} - ${agent.description}`);
    });
    console.log("");
  });

  console.log("✓ = instalado en este proyecto");
  console.log("");
}

// =============================================================================
// SUBCOMMAND: INFO
// =============================================================================

async function showAgentInfo(agentName) {
  if (!AGENTS_METADATA[agentName]) {
    console.error(`❌ Agente '${agentName}' no encontrado`);
    console.log("");
    console.log("Usa 'npx create-mern-agents list' para ver agentes disponibles");
    process.exit(1);
  }

  const meta = AGENTS_METADATA[agentName];
  const installed = isAgentInstalled(agentName);

  console.log("");
  console.log(`${meta.icon} ${agentName}`);
  console.log("━".repeat(60));
  console.log(`Categoría:    ${meta.category}`);
  console.log(`Descripción:  ${meta.description}`);
  console.log(`Rol:          ${meta.role}`);
  console.log(`Estado:       ${installed ? "✓ Instalado" : "✗ No instalado"}`);
  console.log("");

  // Try to fetch additional info from remote if not installed
  if (!installed) {
    try {
      const url = `${REPO_URL}/agents/${agentName}.md`;
      const content = await downloadFile(url);
      
      // Extract first few lines of description
      const lines = content.split("\n").filter(l => l.trim() && !l.startsWith("#")).slice(0, 3);
      if (lines.length > 0) {
        console.log("Capacidades:");
        lines.forEach(line => console.log(`  • ${line.trim()}`));
        console.log("");
      }
    } catch (err) {
      // Ignore errors fetching remote info
    }
  }
}

// =============================================================================
// SUBCOMMAND: ADD
// =============================================================================

async function addAgents(agentNames) {
  console.log("");
  console.log("🤖 Agregando agentes al proyecto...");
  console.log("");

  // Check if we're in a project directory
  if (!fs.existsSync("package.json")) {
    console.error("❌ No se encontró package.json en el directorio actual");
    console.log("Ejecuta este comando desde la raíz de tu proyecto");
    process.exit(1);
  }

  ensureAgentDirectories();

  let successCount = 0;
  let skipCount = 0;
  let failCount = 0;

  for (const agentName of agentNames) {
    // Validate agent exists
    if (!AGENTS_METADATA[agentName]) {
      console.error(`❌ Agente '${agentName}' no existe`);
      console.log("   Usa 'npx create-mern-agents list' para ver agentes disponibles");
      failCount++;
      continue;
    }

    // Check if already installed
    if (isAgentInstalled(agentName)) {
      console.log(`⚠ Agente '${agentName}' ya está instalado`);
      
      // Ask for confirmation in interactive mode
      if (process.stdin.isTTY) {
        const readline = require("readline").createInterface({
          input: process.stdin,
          output: process.stdout
        });
        
        try {
          const answer = await new Promise(resolve => {
            readline.question("¿Deseas reemplazarlo? [y/N]: ", resolve);
          });

          if (answer.toLowerCase() !== "y" && answer.toLowerCase() !== "yes") {
            console.log(`ℹ Omitiendo ${agentName}`);
            skipCount++;
            continue;
          }
        } finally {
          readline.close();
        }
      } else {
        // Non-interactive mode, skip
        skipCount++;
        continue;
      }
    }

    // Download agent
    try {
      console.log(`✓ Descargando ${agentName}...`);
      const url = `${REPO_URL}/agents/${agentName}.md`;
      const content = await downloadFile(url);

      // Save to both locations
      const standardPath = path.join(process.cwd(), AGENTS_DIR_STANDARD, `${agentName}.md`);
      const compatPath = path.join(process.cwd(), AGENTS_DIR_COMPAT, `${agentName}.md`);

      try {
        fs.writeFileSync(standardPath, content, "utf8");
        fs.writeFileSync(compatPath, content, "utf8");
        console.log(`✅ Guardado en ${AGENTS_DIR_STANDARD}/${agentName}.md`);
        successCount++;
      } catch (writeErr) {
        // If write fails, try to clean up partial writes
        try {
          if (fs.existsSync(standardPath)) fs.unlinkSync(standardPath);
          if (fs.existsSync(compatPath)) fs.unlinkSync(compatPath);
        } catch (cleanupErr) {
          // Ignore cleanup errors
        }
        throw writeErr;
      }
    } catch (err) {
      console.error(`❌ Error al descargar ${agentName}: ${err.message}`);
      failCount++;
    }
  }

  // Summary
  console.log("");
  console.log("━".repeat(60));
  if (successCount > 0) {
    console.log(`✅ Agentes instalados: ${successCount}`);
  }
  if (skipCount > 0) {
    console.log(`⚠ Agentes omitidos: ${skipCount}`);
  }
  if (failCount > 0) {
    console.error(`❌ Errores: ${failCount}`);
  }
  console.log("");

  if (failCount > 0) {
    process.exit(1);
  }
}

// =============================================================================
// SUBCOMMAND: INIT (default - backward compatibility)
// =============================================================================

function initAgents(args) {
  console.log("");
  console.log("🚀 Iniciando MERN Agents Framework Installer...");
  console.log("");

  try {
    const scriptPath = path.join(__dirname, "../src/init-agents.sh");
    
    // Asegurar permisos de ejecución
    fs.chmodSync(scriptPath, 0o755);

    // Pasar argumentos al script bash de forma segura
    execFileSync("bash", [scriptPath, ...args], {
      stdio: "inherit",
      env: process.env
    });
  } catch (err) {
    console.error("\n❌ Error ejecutando el instalador:");
    console.error(err.message || err);
    process.exit(1);
  }
}

// =============================================================================
// HELP
// =============================================================================

function showHelp() {
  console.log("");
  console.log("🤖 MERN Agents Framework CLI");
  console.log("");
  console.log("Uso:");
  console.log("  npx create-mern-agents [comando] [opciones]");
  console.log("");
  console.log("Comandos:");
  console.log("  add <agente...>    Agregar uno o más agentes al proyecto");
  console.log("  list               Listar todos los agentes disponibles");
  console.log("  info <agente>      Ver información detallada de un agente");
  console.log("  (sin comando)      Inicializar framework (comportamiento por defecto)");
  console.log("");
  console.log("Ejemplos:");
  console.log("  npx create-mern-agents add security-guardian");
  console.log("  npx create-mern-agents add devops-engineer release-manager");
  console.log("  npx create-mern-agents list");
  console.log("  npx create-mern-agents info orchestrator");
  console.log("  npx create-mern-agents --minimal");
  console.log("");
  console.log("Opciones de inicialización:");
  console.log("  --minimal              Instalar solo agentes core esenciales");
  console.log("  --no-pipeline          Omitir agentes de CI/CD");
  console.log("  --no-auth              Omitir agentes de autenticación");
  console.log("  --no-ai                Omitir agentes de integración de IA");
  console.log("  --no-observability     Omitir agentes de observabilidad");
  console.log("  --help                 Mostrar esta ayuda");
  console.log("");
}

// =============================================================================
// MAIN
// =============================================================================

async function main() {
  const args = process.argv.slice(2);
  
  // No arguments or help flag
  if (args.length === 0 || args[0] === "--help" || args[0] === "-h") {
    if (args.length === 0) {
      // Default behavior: run init
      initAgents(args);
    } else {
      showHelp();
    }
    return;
  }

  const command = args[0];

  // Check if it's a subcommand or init flag
  if (command === "list") {
    listAgents();
  } else if (command === "add") {
    const agentNames = args.slice(1);
    if (agentNames.length === 0) {
      console.error("❌ Debes especificar al menos un agente");
      console.log("");
      console.log("Uso: npx create-mern-agents add <agente1> [agente2] ...");
      console.log("");
      console.log("Ejemplo: npx create-mern-agents add security-guardian");
      console.log("");
      process.exit(1);
    }
    await addAgents(agentNames);
  } else if (command === "info") {
    const agentName = args[1];
    if (!agentName) {
      console.error("❌ Debes especificar un agente");
      console.log("");
      console.log("Uso: npx create-mern-agents info <agente>");
      console.log("");
      console.log("Ejemplo: npx create-mern-agents info orchestrator");
      console.log("");
      process.exit(1);
    }
    await showAgentInfo(agentName);
  } else if (command.startsWith("--")) {
    // It's an init flag, run init
    initAgents(args);
  } else {
    console.error(`❌ Comando desconocido: ${command}`);
    console.log("");
    showHelp();
    process.exit(1);
  }
}

main().catch(err => {
  console.error("\n❌ Error:");
  console.error(err.message || err);
  process.exit(1);
});
