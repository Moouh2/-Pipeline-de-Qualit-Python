#!/bin/bash
# scripts/dev-workflow.sh - Workflow de développement automatisé

# Configuration
BRANCH_PREFIX="feature/"
MAIN_BRANCH="main"

# Fonctions utilitaires
run_tests() {
    echo "🧪 Exécution des tests..."
    python -m pytest tests/ -v --cov=src --cov-report=term-missing
}

run_quality_checks() {
    echo "🔍 Vérifications de qualité..."
    pre-commit run --all-files
}

create_feature_branch() {
    local feature_name=$1
    if [ -z "$feature_name" ]; then
        echo "❌ Nom de feature requis"
        echo "Usage: $0 new-feature <nom-de-la-feature>"
        exit 1
    fi
    
    echo "🌿 Création de la branche feature/$feature_name"
    git checkout $MAIN_BRANCH
    git pull origin $MAIN_BRANCH
    git checkout -b "$BRANCH_PREFIX$feature_name"
}

commit_changes() {
    local message=$1
    if [ -z "$message" ]; then
        echo "❌ Message de commit requis"
        echo "Usage: $0 commit <message>"
        exit 1
    fi
    
    echo "📝 Ajout des fichiers modifiés..."
    git add .
    
    echo "🔍 Vérifications pre-commit..."
    if ! pre-commit run --all-files; then
        echo "❌ Vérifications pre-commit échouées"
        exit 1
    fi
    
    echo "📝 Commit avec message: $message"
    git commit -m "$message"
}

push_and_pr() {
    local current_branch=$(git branch --show-current)
    
    echo "⬆️ Push de la branche $current_branch"
    git push origin $current_branch
    
    echo "🔗 Création automatique de la PR..."
    if command -v gh &> /dev/null; then
        gh pr create --title "$(git log -1 --pretty=%B)" --body "Automatiquement créée par dev-workflow.sh"
    else
        echo "💡 Installez GitHub CLI (gh) pour la création automatique de PR"
        echo "🌐 Créez manuellement la PR sur GitHub"
    fi
}

# Workflow principal
case "$1" in
    "setup")
        echo "⚙️ Configuration de l'environnement de développement"
        source venv/bin/activate 2>/dev/null || {
            echo "🐍 Création de l'environnement virtuel"
            python3 -m venv venv
            source venv/bin/activate
        }
        pip install -r requirements-dev.txt
        pre-commit install
        echo "✅ Configuration terminée"
        ;;
    "test")
        run_tests
        ;;
    "check")
        run_quality_checks
        ;;
    "new-feature")
        create_feature_branch $2
        ;;
    "commit")
        shift
        commit_changes "$*"
        ;;
    "push")
        push_and_pr
        ;;
    "full-check")
        echo "🔄 Vérification complète..."
        run_quality_checks && run_tests
        echo "✅ Toutes les vérifications sont passées"
        ;;
    "release")
        echo "🚀 Préparation de la release..."
        git checkout $MAIN_BRANCH
        git pull origin $MAIN_BRANCH
        run_quality_checks && run_tests
        echo "✅ Prêt pour la release"
        ;;
    *)
        echo "🛠️ Workflow de Développement Automatisé"
        echo ""
        echo "Usage: $0 <commande> [arguments]"
        echo ""
        echo "Commandes disponibles:"
        echo "  setup                 - Configuration initiale"
        echo "  test                  - Exécution des tests"
        echo "  check                 - Vérifications de qualité"
        echo "  new-feature <nom>     - Création d'une nouvelle branche feature"
        echo "  commit <message>      - Commit automatisé avec vérifications"
        echo "  push                  - Push et création de PR automatique"
        echo "  full-check            - Vérification complète (qualité + tests)"
        echo "  release               - Préparation de release"
        echo ""
        exit 1
        ;;
esac