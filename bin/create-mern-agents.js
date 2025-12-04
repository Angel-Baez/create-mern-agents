#!/usr/bin/env node

const { execFileSync } = require("child_process");
const path = require("path");
const fs = require("fs");

console.log("");
console.log("🚀 Iniciando MERN Agents Framework Installer...");
console.log("");

try {
  const scriptPath = path.join(__dirname, "../src/init-agents.sh");
  
  // Obtener argumentos pasados al CLI (después de 'node' y 'script.js')
  const args = process.argv.slice(2);

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
