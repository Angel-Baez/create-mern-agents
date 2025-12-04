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

  // Pasar argumentos de línea de comandos al script
  const args = process.argv.slice(2).join(" ");
  const command = `bash "${scriptPath}" ${args}`;

  execSync(command, {
    stdio: "inherit",
    env: process.env
  });
} catch (err) {
  console.error("\n❌ Error ejecutando el instalador:");
  console.error(err.message || err);
  process.exit(1);
}
