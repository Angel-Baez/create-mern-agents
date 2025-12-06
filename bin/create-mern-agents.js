#!/usr/bin/env node

const { execSync } = require("child_process");
const path = require("path");
const fs = require("fs");
const https = require("https");
const readline = require("readline");

// Configuración
const REPO_URL = "https://raw.githubusercontent.com/Angel-Baez/mern-agents-framework/main";
const AGENTS_DIR_STANDARD = ".github/agents";
const AGENTS_DIR_COMPAT = ".github/copilot/agents";

// Lista de agentes disponibles con sus metadatos
const AGENTS_METADATA = {
  // Core agents
  "orchestrator": {
    category: "Core",
    description: "Coordina todos los agentes del equipo",
    icon: "🎯"
  },
  "product-manager": {
    category: "Core",
    description: "Define requerimientos y prioridades",
    icon: "📋"
  },
  "solution-architect": {
    category: "Core",
    description: "Diseño de arquitectura general",
    icon: "🏗️"
  },
  "backend-architect": {
    category: "Arquitectura",
    description: "Arquitectura backend y APIs",
    icon: "⚙️"
  },
  "frontend-architect": {
    category: "Arquitectura",
    description: "Arquitectura frontend y UI",
    icon: "🎨"
  },
  "test-engineer": {
    category: "Calidad",
    description: "Estrategia de testing y tests",
    icon: "🧪"
  },
  "qa-lead": {
    category: "Calidad",
    description: "QA y testing de integración",
    icon: "✅"
  },
  "code-reviewer": {
    category: "Calidad",
    description: "Revisión de código y best practices",
    icon: "👀"
  },
  "security-guardian": {
    category: "Seguridad y Datos",
    description: "Seguridad y autenticación",
    icon: "🔒"
  },
  "data-engineer": {
    category: "Seguridad y Datos",
    description: "Modelado de datos y optimización DB",
    icon: "🗄️"
  },
  "devops-engineer": {
    category: "Operaciones",
    description: "CI/CD y automatización",
    icon: "🚀"
  },
  "observability-engineer": {
    category: "Operaciones",
    description: "Monitoring y logging",
    icon: "📊"
  },
  "release-manager": {
    category: "Operaciones",
    description: "Gestión de releases y deploys",
    icon: "📦"
  },
  "ai-integration-engineer": {
    category: "Especialistas",
    description: "Integración con APIs de IA",
    icon: "🤖"
  },
  "documentation-engineer": {
    category: "Especialistas",
    description: "Documentación técnica",
    icon: "📚"
  }
};

// Utilidades
function printSuccess(msg) {
  console.log(`\x1b[32m✓\x1b[0m ${msg}`);
}

function printError(msg) {
  console.log(`\x1b[31m✗\x1b[0m ${msg}`);
}

function printInfo(msg) {
  console.log(`\x1b[34mℹ\x1b[0m ${msg}`);
}

function printWarning(msg) {
  console.log(`\x1b[33m⚠\x1b[0m ${msg}`);
}

// Verificar si un agente está instalado
function isAgentInstalled(agentName) {
  const fileName = agentName.endsWith(".md") ? agentName : `${agentName}.md`;
  const standardPath = path.join(process.cwd(), AGENTS_DIR_STANDARD, fileName);
  return fs.existsSync(standardPath);
}

// Obtener agentes instalados
function getInstalledAgents() {
  const agentsDir = path.join(process.cwd(), AGENTS_DIR_STANDARD);
  if (!fs.existsSync(agentsDir)) {
    return [];
  }
  return fs.readdirSync(agentsDir)
    .filter(f => f.endsWith(".md"))
    .map(f => f.replace(".md", ""));
}

// Descargar archivo desde URL
function downloadFile(url) {
  return new Promise((resolve, reject) => {
    const request = https.get(url, (res) => {
      if (res.statusCode === 200) {
        let data = "";
        res.on("data", chunk => data += chunk);
        res.on("end", () => resolve(data));
      } else {
        reject(new Error(`HTTP ${res.statusCode}`));
      }
    }).on("error", reject);
    
    // Add timeout to prevent hanging
    request.setTimeout(30000, () => {
      request.destroy();
      reject(new Error("Request timeout"));
    });
  });
}

// Preguntar al usuario (para confirmaciones)
function askQuestion(question) {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });
  
  return new Promise((resolve) => {
    rl.question(question, (answer) => {
      rl.close();
      resolve(answer);
    });
  });
}

// Comando: add
async function commandAdd(agentNames) {
  if (!agentNames || agentNames.length === 0) {
    printError("Debes especificar al menos un agente");
    console.log("\nUso:");
    console.log("  npx create-mern-agents add <agente1> [agente2] [agente3]");
    console.log("\nEjemplo:");
    console.log("  npx create-mern-agents add security-guardian");
    console.log("  npx create-mern-agents add devops-engineer release-manager");
    process.exit(1);
  }

  // Crear directorios si no existen
  const standardDir = path.join(process.cwd(), AGENTS_DIR_STANDARD);
  const compatDir = path.join(process.cwd(), AGENTS_DIR_COMPAT);
  
  if (!fs.existsSync(standardDir)) {
    fs.mkdirSync(standardDir, { recursive: true });
  }
  if (!fs.existsSync(compatDir)) {
    fs.mkdirSync(compatDir, { recursive: true });
  }

  console.log("");
  
  for (const agentName of agentNames) {
    const fileName = agentName.endsWith(".md") ? agentName : `${agentName}.md`;
    const cleanName = agentName.replace(".md", "");
    
    // Validar que el agente existe en metadata
    if (!AGENTS_METADATA[cleanName]) {
      printWarning(`Agente '${cleanName}' no encontrado en la lista de agentes disponibles`);
      printInfo("Usa 'npx create-mern-agents list' para ver agentes disponibles");
      continue;
    }

    // Verificar si ya existe
    if (isAgentInstalled(cleanName)) {
      printWarning(`El agente '${cleanName}' ya existe`);
      const answer = await askQuestion("¿Deseas sobrescribirlo? (y/N): ");
      if (!answer.match(/^[Yy](es)?$/i)) {
        printInfo("Operación cancelada para " + cleanName);
        continue;
      }
    }

    // Descargar agente
    printInfo(`Descargando ${cleanName}...`);
    try {
      const url = `${REPO_URL}/agents/${fileName}`;
      const content = await downloadFile(url);
      
      // Guardar en ubicación estándar
      const standardPath = path.join(standardDir, fileName);
      fs.writeFileSync(standardPath, content, "utf8");
      
      // Copiar a ubicación de compatibilidad
      const compatPath = path.join(compatDir, fileName);
      fs.writeFileSync(compatPath, content, "utf8");
      
      printSuccess(`Agente '${cleanName}' instalado correctamente`);
      console.log(`  Ahora puedes usar: \x1b[36m@${cleanName}\x1b[0m <tu pregunta>`);
    } catch (err) {
      printError(`No se pudo descargar '${cleanName}': ${err.message}`);
    }
  }
  
  console.log("");
}

// Comando: list
function commandList() {
  console.log("");
  console.log("📋 \x1b[1mAgentes disponibles:\x1b[0m");
  console.log("");

  const installed = getInstalledAgents();
  const categories = {};
  
  // Agrupar por categoría
  Object.entries(AGENTS_METADATA).forEach(([name, meta]) => {
    if (!categories[meta.category]) {
      categories[meta.category] = [];
    }
    categories[meta.category].push({ name, ...meta });
  });

  // Ordenar categorías
  const categoryOrder = ["Core", "Arquitectura", "Calidad", "Seguridad y Datos", "Operaciones", "Especialistas"];
  
  categoryOrder.forEach(category => {
    if (!categories[category]) return;
    
    console.log(`\x1b[1m${category}\x1b[0m`);
    categories[category].forEach(agent => {
      const isInstalled = installed.includes(agent.name);
      const mark = isInstalled ? "\x1b[32m✓\x1b[0m" : " ";
      const name = agent.name.padEnd(25);
      console.log(`  ${mark} ${name} - ${agent.description}`);
    });
    console.log("");
  });

  console.log("\x1b[32m✓\x1b[0m = instalado en este proyecto");
  console.log("");
}

// Comando: info
async function commandInfo(agentName) {
  if (!agentName) {
    printError("Debes especificar un agente");
    console.log("\nUso:");
    console.log("  npx create-mern-agents info <agente>");
    console.log("\nEjemplo:");
    console.log("  npx create-mern-agents info orchestrator");
    process.exit(1);
  }

  const cleanName = agentName.replace(".md", "");
  
  if (!AGENTS_METADATA[cleanName]) {
    printError(`Agente '${cleanName}' no encontrado`);
    printInfo("Usa 'npx create-mern-agents list' para ver agentes disponibles");
    process.exit(1);
  }

  const meta = AGENTS_METADATA[cleanName];
  const isInstalled = isAgentInstalled(cleanName);
  
  console.log("");
  console.log(`${meta.icon} \x1b[1m${cleanName}\x1b[0m`);
  console.log("");
  console.log(`\x1b[1mCategoría:\x1b[0m ${meta.category}`);
  console.log(`\x1b[1mDescripción:\x1b[0m ${meta.description}`);
  console.log(`\x1b[1mEstado:\x1b[0m ${isInstalled ? "\x1b[32mInstalado ✓\x1b[0m" : "\x1b[33mNo instalado\x1b[0m"}`);
  
  // Intentar obtener más información del archivo local o remoto
  console.log("");
  
  if (isInstalled) {
    try {
      const agentPath = path.join(process.cwd(), AGENTS_DIR_STANDARD, `${cleanName}.md`);
      const content = fs.readFileSync(agentPath, "utf8");
      
      // Extraer primera sección del markdown (descripción/rol)
      const lines = content.split("\n");
      let infoSection = [];
      let foundStart = false;
      
      for (let line of lines) {
        if (line.startsWith("#") && !foundStart) {
          foundStart = true;
          continue;
        }
        if (foundStart && line.trim() && !line.startsWith("#")) {
          infoSection.push(line);
          if (infoSection.length >= 5) break;
        }
        if (foundStart && line.startsWith("#") && infoSection.length > 0) {
          break;
        }
      }
      
      if (infoSection.length > 0) {
        console.log("\x1b[1mDetalles:\x1b[0m");
        infoSection.forEach(line => console.log(`  ${line.trim()}`));
      }
    } catch (err) {
      // If we can't read the file, just skip the details section
      printWarning("No se pudo leer el archivo del agente");
    }
  } else {
    printInfo("Para ver más detalles, instala el agente:");
    console.log(`  npx create-mern-agents add ${cleanName}`);
  }
  
  console.log("");
}

// Mostrar ayuda
function showHelp() {
  console.log("");
  console.log("\x1b[1m🤖 create-mern-agents\x1b[0m");
  console.log("");
  console.log("CLI para gestionar agentes del MERN Agents Framework");
  console.log("");
  console.log("\x1b[1mUso:\x1b[0m");
  console.log("  npx create-mern-agents [comando] [opciones]");
  console.log("");
  console.log("\x1b[1mComandos:\x1b[0m");
  console.log("  (sin comando)           Inicializar proyecto con agentes");
  console.log("  add <agente> [...]      Agregar uno o más agentes");
  console.log("  list                    Listar agentes disponibles");
  console.log("  info <agente>           Ver información de un agente");
  console.log("  --help, -h              Mostrar esta ayuda");
  console.log("");
  console.log("\x1b[1mEjemplos:\x1b[0m");
  console.log("  npx create-mern-agents");
  console.log("  npx create-mern-agents --minimal");
  console.log("  npx create-mern-agents add security-guardian");
  console.log("  npx create-mern-agents add devops-engineer release-manager");
  console.log("  npx create-mern-agents list");
  console.log("  npx create-mern-agents info orchestrator");
  console.log("");
}

// Main
async function main() {
  const args = process.argv.slice(2);
  
  if (args.length === 0) {
    // Sin argumentos: comportamiento original (init)
    console.log("");
    console.log("🚀 Iniciando MERN Agents Framework Installer...");
    console.log("");

    try {
      const scriptPath = path.join(__dirname, "../src/init-agents.sh");
      fs.chmodSync(scriptPath, 0o755);
      execSync(`bash "${scriptPath}"`, {
        stdio: "inherit",
        env: process.env
      });
    } catch (err) {
      console.error("\n❌ Error ejecutando el instalador:");
      console.error(err.message || err);
      process.exit(1);
    }
    return;
  }

  const command = args[0];

  // Manejar flags de ayuda
  if (command === "--help" || command === "-h") {
    showHelp();
    return;
  }

  // Comandos especiales
  if (command === "add") {
    await commandAdd(args.slice(1));
    return;
  }

  if (command === "list") {
    commandList();
    return;
  }

  if (command === "info") {
    await commandInfo(args[1]);
    return;
  }

  // Si empieza con --, es un flag para init-agents.sh
  if (command.startsWith("--")) {
    console.log("");
    console.log("🚀 Iniciando MERN Agents Framework Installer...");
    console.log("");

    try {
      const scriptPath = path.join(__dirname, "../src/init-agents.sh");
      fs.chmodSync(scriptPath, 0o755);
      const argsStr = args.join(" ");
      execSync(`bash "${scriptPath}" ${argsStr}`, {
        stdio: "inherit",
        env: process.env
      });
    } catch (err) {
      console.error("\n❌ Error ejecutando el instalador:");
      console.error(err.message || err);
      process.exit(1);
    }
    return;
  }

  // Comando no reconocido
  printError(`Comando no reconocido: ${command}`);
  console.log("");
  console.log("Usa 'npx create-mern-agents --help' para ver comandos disponibles");
  console.log("");
  process.exit(1);
}

main().catch(err => {
  console.error("\n❌ Error:");
  console.error(err.message || err);
  process.exit(1);
});
