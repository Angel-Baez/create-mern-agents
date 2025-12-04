#!/usr/bin/env node

const { execSync } = require("child_process");
const path = require("path");
const fs = require("fs");

console.log("");
console.log("🚀 Iniciando MERN Agents Framework Installer...");
console.log("");

try {
  const scriptPath = path.join(__dirname, "../src/init-agents.sh");

  // Asegurar permisos de ejecución
  fs.chmodSync(scriptPath, 0o755);

  // Obtener argumentos de la línea de comandos (excluyendo node y el script)
  const args = process.argv.slice(2);
  
  // Construir el comando con los argumentos
  const command = args.length > 0 
    ? `bash "${scriptPath}" ${args.map(arg => `"${arg}"`).join(' ')}`
    : `bash "${scriptPath}"`;

  execSync(command, {
    stdio: "inherit",
    env: process.env
  });
} catch (err) {
  console.error("\n❌ Error ejecutando el instalador:");
  console.error(err.message || err);
  process.exit(1);
}
