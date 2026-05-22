#!/usr/bin/env python3
"""
scientific-skill-eval: Batch evaluation script
Evaluates multiple skills from a TSV input file.
"""

import sys
import os
import json
import argparse
import subprocess
import tempfile
from pathlib import Path
from datetime import datetime
from typing import List, Dict, Any

# Import from evaluate.py sibling
sys.path.insert(0, str(Path(__file__).parent))
from evaluate import clone_repo, find_skill_dir, run_evaluation


def read_input_tsv(tsv_path: Path) -> List[Dict[str, str]]:
    """Read skills-to-evaluate.tsv and return list of dicts."""
    lines = tsv_path.read_text(encoding='utf-8', errors='ignore').strip().split('\n')
    if not lines:
        return []
    header = lines[0].split('\t')
    rows = []
    for line in lines[1:]:
        if not line.strip():
            continue
        cols = line.split('\t')
        row = {h.strip(): c.strip() for h, c in zip(header, cols)}
        rows.append(row)
    return rows


def write_summary(results: List[Dict[str, Any]], output_dir: Path, fmt: str):
    """Write aggregated summary."""
    if fmt == 'json':
        summary = {
            'evaluated_at': datetime.now().isoformat(),
            'total': len(results),
            'auto_recommend': sum(1 for r in results if r.get('classification') == 'AUTO-RECOMMEND'),
            'candidate': sum(1 for r in results if r.get('classification') == 'CANDIDATE'),
            'exclude': sum(1 for r in results if r.get('classification') == 'EXCLUDE'),
            'results': results
        }
        (output_dir / 'summary.json').write_text(json.dumps(summary, indent=2, ensure_ascii=False), encoding='utf-8')
    elif fmt == 'tsv':
        header = 'Repo\tDomain\tSecurityVerdict\tDepthScore\tClassification\n'
        rows = [header]
        for r in results:
            rows.append(f"{r.get('source', '')}\t{r.get('domain', '')}\t{r.get('security', {}).get('verdict', '')}\t{r.get('depth_score', '')}\t{r.get('classification', '')}\n")
        (output_dir / 'summary.tsv').write_text(''.join(rows), encoding='utf-8')


def write_individual_report(result: Dict[str, Any], output_dir: Path):
    """Write individual markdown report for each skill."""
    name = result.get('source', 'unknown').split('/')[-1].replace('.git', '')
    name = result.get('skill_name', name)

    md = f"""# Skill Evaluation: {name}

**Date:** {result.get('evaluated_at', datetime.now().isoformat())}
**Source:** {result.get('source', 'N/A')}
**Domain:** {result.get('domain', 'N/A')}

## Security Check

| Check | Result |
|-------|--------|
"""
    for check_name, check_data in result.get('security', {}).get('checks', {}).items():
        md += f"| {check_data.get('name', check_name)} | {'PASS' if check_data.get('result') else 'FAIL'} |\n"

    md += f"""
**Verdict:** {result.get('security', {}).get('verdict', 'N/A')}

## Professional Depth Score

**Functions evaluated:** {', '.join(result.get('functions', []))}
**DepthScore:** {result.get('depth_score', 'N/A')}
**Classification:** {result.get('classification', 'N/A')}

## Integration Assessment

| Dimension | Score |
|-----------|-------|
"""
    for dim, score in result.get('integration', {}).items():
        md += f"| {dim} | {score} |\n"

    (output_dir / f'{name}.md').write_text(md, encoding='utf-8')


def main():
    parser = argparse.ArgumentParser(description='Batch evaluate scientific skills')
    parser.add_argument('--input', required=True, help='Input TSV file (Repo,Domain columns)')
    parser.add_argument('--output', required=True, help='Output directory')
    parser.add_argument('--format', choices=['json', 'tsv', 'md'], default='md',
                       help='Output format')
    parser.add_argument('--skills-dir', default='./.agents/skills',
                       help='Directory for installed skills lookup')
    parser.add_argument('--refs-dir', default='./references',
                       help='Directory containing rubric files')

    args = parser.parse_args()

    input_path = Path(args.input)
    output_dir = Path(args.output)
    output_dir.mkdir(parents=True, exist_ok=True)

    if not input_path.exists():
        print(f"Input file not found: {input_path}")
        sys.exit(1)

    rows = read_input_tsv(input_path)
    print(f"Loaded {len(rows)} skills to evaluate")

    refs = Path(args.refs_dir)
    if not refs.exists():
        refs = Path(__file__).parent.parent / 'references'

    results = []
    for i, row in enumerate(rows):
        repo = row.get('Repo', '')
        domain = row.get('Domain', '')
        print(f"[{i+1}/{len(rows)}] Evaluating: {repo}")

        try:
            if repo.startswith('http'):
                with tempfile.TemporaryDirectory() as tmpdir:
                    dest = Path(tmpdir) / 'skill'
                    if clone_repo(repo, dest):
                        skill_dir = find_skill_dir(dest)
                        if skill_dir:
                            result = run_evaluation(skill_dir, 'quick', [], refs)
                            result['source'] = repo
                            result['domain'] = domain
                            results.append(result)
            elif repo.startswith('./'):
                local_path = Path(repo)
                if local_path.exists():
                    result = run_evaluation(local_path, 'quick', [], refs)
                    result['source'] = repo
                    result['domain'] = domain
                    results.append(result)
            else:
                # Named skill
                skills_dir = Path(args.skills_dir)
                skill_path = skills_dir / repo
                if skill_path.exists():
                    result = run_evaluation(skill_path, 'quick', [], refs)
                    result['source'] = repo
                    result['domain'] = domain
                    results.append(result)
        except Exception as e:
            print(f"  Error: {e}")
            results.append({
                'source': repo,
                'domain': domain,
                'error': str(e),
                'classification': 'ERROR'
            })

        write_individual_report(results[-1], output_dir)

    write_summary(results, output_dir, args.format)
    print(f"\nDone. Results in {output_dir}")


if __name__ == '__main__':
    main()