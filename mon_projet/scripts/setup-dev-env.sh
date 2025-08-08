#!/bin/bash
# setup-dev-env.sh - Configuration automatique de l'environnement de développement

set -e  # Arrêt en cas d'erreur

echo "🚀 Configuration automatique de l'environnement de développement Python"

# Vérification des prérequis
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 n'est pas installé"
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo "❌ Git n'est pas installé"
    exit 1
fi

# Configuration du projet
PROJECT_NAME=${1:-"mon-projet-python"}
echo "📁 Configuration du projet: $PROJECT_NAME"

# Création de l'environnement virtuel
echo "🐍 Création de l'environnement virtuel..."
python3 -m venv venv
source venv/bin/activate

# Mise à jour de pip
echo "📦 Mise à jour de pip..."
pip install --upgrade pip setuptools wheel

# Installation des dépendances de développement
echo "🛠️ Installation des outils de développement..."
pip install -r requirements-dev.txt

# Configuration de pre-commit
echo "🔧 Configuration des pre-commit hooks..."
pre-commit install
pre-commit install --hook-type commit-msg

# Configuration de Git hooks personnalisés
echo "⚙️ Configuration des Git hooks personnalisés..."
cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
echo "🧪 Exécution des tests avant push..."
python -m pytest tests/ --quiet
if [ $? -ne 0 ]; then
    echo "❌ Les tests ont échoué. Push annulé."
    exit 1
fi
echo "✅ Tests réussis. Push autorisé."
EOF
chmod +x .git/hooks/pre-push

# Configuration de l'IDE (VS Code)
if command -v code &> /dev/null; then
    echo "💻 Configuration de VS Code..."
    mkdir -p .vscode
    cat > .vscode/settings.json << 'EOF'
{
    "python.defaultInterpreterPath": "./venv/bin/python",
    "python.linting.enabled": true,
    "python.linting.flake8Enabled": true,
    "python.formatting.provider": "black",
    "python.sortImports.args": ["--profile", "black"],
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.organizeImports": true
    },
    "python.testing.pytestEnabled": true,
    "python.testing.unittestEnabled": false,
    "python.testing.pytestArgs": ["tests/"]
}
EOF

    cat > .vscode/extensions.json << 'EOF'
{
    "recommendations": [
        "ms-python.python",
        "ms-python.flake8",
        "ms-python.black-formatter",
        "ms-python.isort",
        "ms-python.mypy-type-checker"
    ]
}
EOF
fi

# Test de la configuration
echo "🔍 Test de la configuration..."
pre-commit run --all-files || true

echo "✅ Configuration terminée avec succès!"
echo "💡 Pour activer l'environnement: source venv/bin/activate"
echo "🔧 Pour lancer les tests: pytest"
echo "🚀 Pour commiter: git add . && git commit -m 'votre message'"