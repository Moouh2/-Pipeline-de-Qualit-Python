#!/bin/bash
# scripts/deploy.sh - Déploiement automatisé

set -e

ENVIRONMENT=${1:-staging}
VERSION=${2:-latest}

echo "🚀 Déploiement automatique vers $ENVIRONMENT (version: $VERSION)"

# Vérifications pré-déploiement
echo "🔍 Vérifications pré-déploiement..."
make full-check

# Build du package
echo "📦 Construction du package..."
python -m build

# Tests du package construit
echo "🧪 Test du package construit..."
python -m pip install dist/*.whl --force-reinstall
python -c "import $(basename $(pwd) | tr '-' '_'); print('Package installé avec succès')"

# Déploiement selon l'environnement
case $ENVIRONMENT in
    "staging")
        echo "🌱 Déploiement vers staging..."
        # Commandes spécifiques au staging
        ;;
    "production")
        echo "🏭 Déploiement vers production..."
        # Commandes spécifiques à la production
        # Avec vérifications supplémentaires
        ;;
    *)
        echo "❌ Environnement non reconnu: $ENVIRONMENT"
        exit 1
        ;;
esac

echo "✅ Déploiement terminé avec succès!"