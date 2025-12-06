# 🚀 Quick Start: Audit System

This is a quick reference guide for using the hybrid audit system.

## For Repository Maintainers

### Initial Setup (One-Time)

1. **Create labels in the target repository:**
   ```bash
   ./scripts/create-audit-labels.sh Angel-Baez mern-agents-framework
   ```

2. **Create Epic Issue #7** in `mern-agents-framework` repository:
   - Title: `[EPIC] Auditoría de 100 Usos - Framework de 15 Agentes`
   - Body: See the example in the workflow file
   - Add label: `audit`

3. **Verify the GitHub Action** is enabled in the repository

### Creating Audit Cases

1. Go to **Issues** → **New Issue**
2. Select **"Caso de Auditoría Individual"** template
3. Fill in all fields
4. Submit the issue

The Epic #7 will update automatically! ✨

## For Auditors

### Quick Commands

```bash
# View all audit cases
gh issue list --repo Angel-Baez/mern-agents-framework --label audit

# View success cases only
gh issue list --repo Angel-Baez/mern-agents-framework --label case-success

# View violations by specific agent
gh issue list --repo Angel-Baez/mern-agents-framework --label "agent:orchestrator,case-violation-major"

# View cases needing review
gh issue list --repo Angel-Baez/mern-agents-framework --label needs-review
```

### Label Quick Reference

#### Result Labels
- `case-success` - Agent performed correctly
- `case-violation-minor` - Protocol omitted but implementation correct
- `case-violation-major` - Violated scope or fundamental limits

#### Agent Labels
- `agent:orchestrator`
- `agent:backend-architect`
- `agent:frontend-architect`
- (and more - see AUDIT_SYSTEM.md)

#### Environment Labels
- `env:vscode` - Executed in VSCode Chat
- `env:github-copilot` - Executed in GitHub Copilot Chat

#### Violation Type Labels
- `violation:scope` - Modified code outside its area
- `violation:protocol` - Didn't follow verification procedures
- `violation:tools` - Used prohibited tools
- `violation:handoff` - Didn't handoff when required

#### Status Labels
- `needs-review` - Case needs review
- `validated` - Case validated and confirmed
- `disputed` - Case disputed or needs clarification

## Files in This Repository

```
.github/
├── ISSUE_TEMPLATE/
│   └── audit-case.yml              # Template for audit cases
└── workflows/
    └── update-audit-epic.yml       # Auto-updates Epic #7

scripts/
├── create-audit-labels.sh          # Creates audit labels
└── create-initial-audit-issues.sh  # Reference: creates 4 initial sub-issues

AUDIT_SYSTEM.md                     # Complete documentation
```

## Need Help?

- **Full Documentation**: See [AUDIT_SYSTEM.md](./AUDIT_SYSTEM.md)
- **Issue Template**: `.github/ISSUE_TEMPLATE/audit-case.yml`
- **Workflow Details**: `.github/workflows/update-audit-epic.yml`

## Common Issues

### Epic not updating?
- Check that the issue has the `audit` label
- Check that the workflow is enabled in Actions tab
- Verify the Epic number is 7 in the workflow file

### Can't create labels?
- Ensure you have `gh` CLI installed: https://cli.github.com/
- Ensure you're authenticated: `gh auth login`
- Ensure you have admin access to the repository

### Template not showing?
- Issue templates can take a few minutes to appear after push
- Try refreshing the page
- Check that the YAML is valid

---

**Made with ❤️ for MERN Agents Framework**
