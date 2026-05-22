#!/usr/bin/env python3
"""
scientific-skill-eval: Main evaluation script
Evaluates a single scientific skill using two-stage assessment.
"""

import sys
import os
import json
import argparse
import subprocess
import tempfile
import shutil
from pathlib import Path
from typing import Optional, Dict, Any, List
from datetime import datetime


def clone_repo(url: str, dest: Path) -> bool:
    """Clone a GitHub repo to a temp directory."""
    try:
        subprocess.run(['git', 'clone', '--depth', '1', url, str(dest)],
                      capture_output=True, timeout=60, check=True)
        return True
    except Exception as e:
        print(f"Clone failed: {e}", file=sys.stderr)
        return False


def find_skill_dir(base: Path) -> Optional[Path]:
    """Find the skill directory (look for SKILL.md)."""
    if (base / 'SKILL.md').exists():
        return base
    for sub in base.iterdir():
        if sub.is_dir() and (sub / 'SKILL.md').exists():
            return sub
    return None


def infer_functions(skill_path: Path) -> List[str]:
    """Infer the skill's primary functions from SKILL.md."""
    skill_md = skill_path / 'SKILL.md'
    if not skill_md.exists():
        return []

    content = skill_md.read_text(encoding='utf-8', errors='ignore')
    functions = []

    # Keyword-based function detection
    function_map = {
        'literature-search': ['literature search', 'pubmed', 'arxiv', 'semantic scholar', 'database search'],
        'literature-review': ['literature review', 'systematic review', 'prisma', 'screening'],
        'academic-writing': ['academic writing', 'paper writing', 'manuscript', 'latex'],
        'figure-generation': ['figure', 'chart', 'visualization', 'plot'],
        'statistical-analysis': ['statistical', 'regression', 'hypothesis', 'p-value', 'anova'],
        'citation-management': ['citation', 'bibtex', 'reference', 'doi'],
        'medical-domain': ['medical', 'clinical', 'epidemiology', 'prisma', 'strobe', 'consort'],
        'research-tool': ['agent', 'orchestrat', 'framework', 'pipeline', 'multi-'],
        'workflow-orchestration': ['workflow', 'pipeline', 'stage', 'checkpoint'],
        'journal-specific': ['nature', 'science', 'cell', 'submission', 'journal'],
    }

    content_lower = content.lower()
    for func_id, keywords in function_map.items():
        if any(kw in content_lower for kw in keywords):
            if func_id not in functions:
                functions.append(func_id)

    return functions[:2]  # Return top 2 inferred functions


def load_rubric(function_type: str, refs_dir: Path) -> Optional[str]:
    """Load the rubric for a given function type."""
    rubric_file = refs_dir / f'rubric-{function_type}.md'
    if rubric_file.exists():
        return rubric_file.read_text(encoding='utf-8', errors='ignore')
    return None


def score_function(function_type: str, skill_path: Path, rubric: str) -> float:
    """
    Score a function based on the rubric.
    This is a simplified scoring - in practice, the LLM would do this.
    Returns a score from 1-5.
    """
    # For script-based evaluation, we do a simplified evidence-based scoring
    # Real scoring is done by the LLM using the rubric
    return 3.0  # Placeholder - actual scoring happens in SKILL.md workflow


def run_evaluation(skill_path: Path, mode: str, functions: List[str], refs_dir: Path) -> Dict[str, Any]:
    """Run the full two-stage evaluation."""

    # Stage 0: Security check
    sys.path.insert(0, str(refs_dir.parent / 'scripts'))
    try:
        from security_check import run_security_check
        sec_result = run_security_check(skill_path)
    except Exception as e:
        sec_result = {'verdict': 'ERROR', 'auto_exclude': False, 'error': str(e)}

    if sec_result.get('auto_exclude'):
        return {
            'stage': 'security',
            'excluded': True,
            'reason': sec_result.get('failure_reasons', ['Security veto']),
            'security': sec_result
        }

    # Stage 1: Function identification
    if mode == 'full' and functions:
        selected_functions = functions
    else:
        selected_functions = infer_functions(skill_path)
        if not selected_functions:
            selected_functions = ['research-tool']  # Default fallback

    # Stage 2: Tier 1 - Professional depth scoring
    # For each function, load rubric and score (done by LLM in practice)
    scores = {}
    for func in selected_functions:
        rubric = load_rubric(func, refs_dir)
        scores[func] = {
            'rubric_available': rubric is not None,
            'score': None  # LLM assigns this
        }

    # Stage 3: Tier 2 - Integration assessment (placeholder)
    integration = {
        'integration_difficulty': 3,
        'mcp_compatibility': 3,
        'conflict_risk': 3,
        'maintenance_cost': 3,
        'context_dependency': 3,
    }

    # Stage 4: Classification
    depth_score = 3.5  # Placeholder - LLM calculates actual score

    if depth_score < 3.0:
        classification = 'EXCLUDE'
    elif depth_score <= 4.0:
        classification = 'CANDIDATE'
    else:
        classification = 'AUTO-RECOMMEND'

    return {
        'stage': 'complete',
        'excluded': False,
        'security': sec_result,
        'functions': selected_functions,
        'scores': scores,
        'depth_score': depth_score,
        'integration': integration,
        'classification': classification,
        'skill_path': str(skill_path),
        'evaluated_at': datetime.now().isoformat()
    }


def main():
    parser = argparse.ArgumentParser(description='Evaluate a scientific skill')
    parser.add_argument('--url', help='GitHub URL of the skill repo')
    parser.add_argument('--local', help='Local path to skill directory')
    parser.add_argument('--name', help='Name of installed skill to evaluate')
    parser.add_argument('--mode', choices=['quick', 'full'], default='quick',
                       help='Evaluation mode')
    parser.add_argument('--functions', nargs='+',
                       help='Function types to evaluate (for full mode)')
    parser.add_argument('--output', help='Output file path')
    parser.add_argument('--format', choices=['json', 'md', 'tsv'], default='md',
                       help='Output format')
    parser.add_argument('--skills-dir', default='./.agents/skills',
                       help='Directory containing installed skills')
    parser.add_argument('--refs-dir', default='./references',
                       help='Directory containing rubric files')

    args = parser.parse_args()

    # Determine skill source
    if args.url:
        with tempfile.TemporaryDirectory() as tmpdir:
            dest = Path(tmpdir) / 'skill'
            if not clone_repo(args.url, dest):
                print(json.dumps({'error': 'Failed to clone repo'}))
                sys.exit(1)
            skill_dir = find_skill_dir(dest)
            if not skill_dir:
                print(json.dumps({'error': 'No SKILL.md found in repo'}))
                sys.exit(1)
            refs = Path(args.refs_dir)
            if not refs.exists():
                refs = Path(__file__).parent.parent / 'references'
            result = run_evaluation(skill_dir, args.mode, args.functions or [], refs)
    elif args.local:
        skill_path = Path(args.local)
        if not skill_path.exists():
            print(json.dumps({'error': f'Path not found: {skill_path}'}))
            sys.exit(1)
        refs = Path(args.refs_dir)
        if not refs.exists():
            refs = Path(__file__).parent.parent / 'references'
        result = run_evaluation(skill_path, args.mode, args.functions or [], refs)
    elif args.name:
        skills_dir = Path(args.skills_dir)
        skill_path = skills_dir / args.name
        if not skill_path.exists():
            print(json.dumps({'error': f'Skill not found: {args.name}'}))
            sys.exit(1)
        refs = Path(args.refs_dir)
        if not refs.exists():
            refs = Path(__file__).parent.parent / 'references'
        result = run_evaluation(skill_path, args.mode, args.functions or [], refs)
    else:
        print(json.dumps({'error': 'Must specify --url, --local, or --name'}))
        sys.exit(1)

    # Output
    output = json.dumps(result, indent=2, ensure_ascii=False)

    if args.output:
        Path(args.output).write_text(output, encoding='utf-8')
    else:
        print(output)

    sys.exit(0 if not result.get('excluded') else 1)


if __name__ == '__main__':
    main()