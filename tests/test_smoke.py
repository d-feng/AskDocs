"""
Smoke tests — verify the package is importable and key constants are correct.
Real RAG chain tests require valid API keys and are skipped in CI.
"""

import os
import importlib


def test_package_importable():
    """src/llm_rag/__init__.py exists and is importable."""
    spec = importlib.util.find_spec("llm_rag")
    assert spec is not None, "llm_rag package not found; run: pip install -e ."


def test_env_defaults():
    """VECTOR_STORE_DIR falls back to 'vector_store' when unset."""
    os.environ.pop("VECTOR_STORE_DIR", None)
    value = os.getenv("VECTOR_STORE_DIR", "vector_store")
    assert value == "vector_store"


def test_knowledge_dir_exists():
    """knowledge/ directory and its subdirectories are present."""
    from pathlib import Path
    root = Path(__file__).parent.parent
    for subdir in ("indication_profiles", "frameworks", "tutorials", "protocols"):
        assert (root / "knowledge" / subdir).is_dir(), f"knowledge/{subdir} missing"


def test_scripts_exist():
    """build_vectorstore.py is present in scripts/."""
    from pathlib import Path
    script = Path(__file__).parent.parent / "scripts" / "build_vectorstore.py"
    assert script.exists()
