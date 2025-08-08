#!/usr/bin/env python3
"""
Script d'automatisation pour vérifier et mettre à jour les requirements.
"""
import subprocess
import sys
from pathlib import Path

def check_outdated_packages():
    """Vérifie les packages obsolètes."""
    try:
        result = subprocess.run(
            ["pip", "list", "--outdated", "--format=json"],
            capture_output=True,
            text=True,
            check=True
        )
        if result.stdout.strip() != "[]":
            print("⚠️ Packages obsolètes détectés:")
            print(result.stdout)
            return False
        return True
    except subprocess.CalledProcessError:
        print("❌ Erreur lors de la vérification des packages")
        return False

def verify_requirements_sync():
    """Vérifie la synchronisation des fichiers requirements."""
    requirements_files = [
        "requirements.txt",
        "requirements-dev.txt"
    ]
    
    for req_file in requirements_files:
        if Path(req_file).exists():
            try:
                subprocess.run(
                    ["pip-check-reqs", req_file],
                    check=True,
                    capture_output=True
                )
                print(f"✅ {req_file} est synchronisé")
            except subprocess.CalledProcessError as e:
                print(f"❌ {req_file} n'est pas synchronisé:")
                print(e.stdout.decode())
                return False
    return True

if __name__ == "__main__":
    print("🔍 Vérification des requirements...")
    
    checks = [
        check_outdated_packages(),
        verify_requirements_sync()
    ]
    
    if all(checks):
        print("✅ Toutes les vérifications sont passées")
        sys.exit(0)
    else:
        print("❌ Certaines vérifications ont échoué")
        sys.exit(1)