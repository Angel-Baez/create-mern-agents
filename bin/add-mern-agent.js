#!/usr/bin/env node

const { execSync } = require("child_process");
const path = require("path");
const fs = require("fs");

const agents = process.argv.slice(2);

if (agents.length === 0) {
  console.error("❌ Debes especificar al menos un agente");
  console.log("");
  console.log("📖 Uso: npx add-mern-agent <agente1> [agente2] ...");
  console.log("📖 Ejemplo: npx add-mern-agent security-guardian");
  console.log("📖 Ejemplo: npx add-mern-agent devops-engineer release-manager");
  console.log("");
  console.log("🤖 Agentes disponibles:");
  console.log("   - ai-integration-engineer");
  console.log("   - backend-architect");
  console.log("   - code-reviewer");
  console.log("   - data-engineer");
  console.log("   - devops-engineer");
  console.log("   - documentation-engineer");
  console.log("   - frontend-architect");
  console.log("   - observability-engineer");
  console.log("   - orchestrator");
  console.log("   - product-manager");
  console.log("   - qa-lead");
  console.log("   - release-manager");
  console.log("   - security-guardian");
  console.log("   - solution-architect");
  console.log("   - test-engineer");
  console.log("");
  process.exit(1);
}

console.log("");
console.log("🤖 Agregando agentes al proyecto...");
console.log("");

try {
  const scriptPath = path.join(__dirname, "../src/add-agent.sh");
  
  if (!fs.existsSync(scriptPath)) {
    console.error("❌ Script add-agent.sh no encontrado");
    console.error("   Asegúrate de tener la última versión de create-mern-agents");
    process.exit(1);
  }

  // Asegurar permisos de ejecución
  fs.chmodSync(scriptPath, 0o755);

  // Pasar nombres de agentes al script bash
  execSync(`bash "${scriptPath}" ${agents.join(" ")}`, {
    stdio: "inherit",
    env: process.env
  });
} catch (err) {
  console.error("\n❌ Error ejecutando add-agent:");
  console.error(err.message || err);
  process.exit(1);
}
