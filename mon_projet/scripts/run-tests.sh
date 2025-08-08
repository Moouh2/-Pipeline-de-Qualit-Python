#!/bin/bash
# scripts/run-tests.sh - Tests automatisés avancés

set -e

# Configuration
TEST_DIR="tests"
SRC_DIR="src"
COVERAGE_THRESHOLD=80

echo "🧪 Exécution de la suite de tests complète"

# Tests unitaires
echo "📋 Tests unitaires..."
python -m pytest $TEST_DIR/unit/ -v --tb=short

# Tests d'intégration
if [ -d "$TEST_DIR/integration" ]; then
    echo "🔗 Tests d'intégration..."
    python -m pytest $TEST_DIR/integration/ -v --tb=short
fi

# Tests avec couverture
echo "📊 Tests avec mesure de couverture..."
python -m pytest $TEST_DIR/ \
    --cov=$SRC_DIR \
    --cov-report=term-missing \
    --cov-report=html \
    --cov-report=xml \
    --cov-fail-under=$COVERAGE_THRESHOLD

# Tests de performance (si présents)
if [ -d "$TEST_DIR/performance" ]; then
    echo "⚡ Tests de performance..."
    python -m pytest $TEST_DIR/performance/ -v --benchmark-only
fi

echo "✅ Tous les tests sont passés avec succès!"