#!/usr/bin/env python3
"""
Script d'automatisation pour générer la documentation.
"""
import subprocess
import sys
from pathlib import Path

def build_sphinx_docs():
    """Build la documentation Sphinx automatiquement."""
    docs_dir = Path("docs")
    if not docs_dir.exists():
        print("📁 Création du répertoire docs...")
        docs_dir.mkdir()
        
        # Auto-génération de la structure Sphinx
        subprocess.run([
            "sphinx-quickstart", 
            "--quiet",
            "--project=Mon Projet",
            "--author=Équipe Dev",
            "--release=1.0.0",
            "--language=fr",
            "--extensions=sphinx.ext.autodoc,sphinx.ext.viewcode,sphinx.ext.napoleon",
            "docs/"
        ])
    
    try:
        subprocess.run([
            "sphinx-build", 
            "-b", "html", 
            "docs/", 
            "docs/_build/html/"
        ], check=True)
        print("✅ Documentation générée avec succès")
        return True
    except subprocess.CalledProcessError:
        print("❌ Erreur lors de la génération de la documentation")
        return False

if __name__ == "__main__":
    print("📚 Génération automatique de la documentation...")
    if build_sphinx_docs():
        sys.exit(0)
    else:
        sys.exit(1)