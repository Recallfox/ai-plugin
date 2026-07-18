"""recallfox integration for Hermes Agent.

The skill lives at the repository root so Claude Code, Codex, and Hermes all
use the same instructions. The installer symlinks this directory into Hermes;
resolving the symlink lets us find the shared skill beside it.
"""

from __future__ import annotations

import logging
from pathlib import Path

logger = logging.getLogger(__name__)

_PLUGIN_DIR = Path(__file__).resolve().parent
_SKILLS_DIR = _PLUGIN_DIR.parent / "skills"


def _discover_skills() -> list[tuple[str, Path]]:
    """Return every shared skill that has a SKILL.md file."""
    if not _SKILLS_DIR.is_dir():
        logger.warning("skills/ directory missing at %s", _SKILLS_DIR)
        return []

    return [
        (child.name, child / "SKILL.md")
        for child in sorted(_SKILLS_DIR.iterdir())
        if child.is_dir() and (child / "SKILL.md").is_file()
    ]


def register(ctx) -> None:
    """Register the repository's shared skills with Hermes."""
    skills = _discover_skills()
    for skill_name, skill_md in skills:
        ctx.register_skill(skill_name, skill_md)
    logger.info("recallfox: registered %d skill(s)", len(skills))

