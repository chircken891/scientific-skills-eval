#!/usr/bin/env python3
"""
scientific-skill-eval: Security check script
Runs four hard security checks on a skill directory or cloned repo.
Any FAIL = immediate EXCLUDE.
"""

import sys
import os
import re
import json
import argparse
import subprocess
from pathlib import Path
from typing import Optional


def check_data_security(skill_path: Path) -> tuple[bool, str]:
    """Check for hardcoded credentials, API keys, secrets in code/config files."""
    issues = []

    patterns = [
        (r'api[_-]?key["\']?\s*[:=]\s*["\'][A-Za-z0-9]{16,}', "hardcoded API key"),
        (r'secret["\']?\s*[:=]\s*["\'][A-Za-z0-9]{16,}', "hardcoded secret"),
        (r'password["\']?\s*[:=]\s*["\'][^"\']{8,}', "hardcoded password"),
        (r'bearer\s+[A-Za-z0-9_\-]{20,}', "bearer token"),
        (r'ghp_[A-Za-z0-9]{36,}', "GitHub personal access token"),
        (r'sk-[A-Za-z0-9]{48,}', "OpenAI API key"),
    ]

    for ext in ['*.py', '*.js', '*.ts', '*.yaml', '*.yml', '*.json', '*.sh', '*.md']:
        for f in skill_path.rglob(ext):
            if 'node_modules' in str(f) or '.git' in str(f):
                continue
            try:
                content = f.read_text(encoding='utf-8', errors='ignore')
                for pattern, label in patterns:
                    if re.search(pattern, content, re.IGNORECASE):
                        issues.append(f"{f.relative_to(skill_path)}: {label}")
            except Exception:
                pass

    if issues:
        return False, "; ".join(issues)
    return True, "No hardcoded credentials found"


def check_permission_scope(skill_path: Path) -> tuple[bool, str]:
    """Check for unnecessary filesystem or network permissions."""
    issues = []

    # Check SKILL.md for allowed-tools
    skill_md = skill_path / 'SKILL.md'
    if skill_md.exists():
        content = skill_md.read_text(encoding='utf-8', errors='ignore')
        # Warn if overly broad permissions requested
        if 'Write' in content and 'all directories' in content.lower():
            issues.append("SKILL.md: Write permission to all directories requested")
        if 'Bash' in content and ('rm -rf' in content or 'delete' in content.lower()):
            issues.append("SKILL.md: Bash permission with destructive commands")

    # Check for suspicious file operations
    for ext in ['*.py', '*.js', '*.sh']:
        for f in skill_path.rglob(ext):
            if 'node_modules' in str(f) or '.git' in str(f):
                continue
            try:
                content = f.read_text(encoding='utf-8', errors='ignore')
                if re.search(r'chmod\s+777|chmod\s+000', content):
                    issues.append(f"{f.relative_to(skill_path)}: overly permissive chmod")
            except Exception:
                pass

    if issues:
        return False, "; ".join(issues)
    return True, "Permissions appropriate"


def check_network_requests(skill_path: Path) -> tuple[bool, str]:
    """Check for undeclared or suspicious outbound network connections."""
    issues = []
    declared_hosts = set()

    # Extract declared network targets from SKILL.md or config
    skill_md = skill_path / 'SKILL.md'
    if skill_md.exists():
        content = skill_md.read_text(encoding='utf-8', errors='ignore')
        hosts = re.findall(r'https?://([A-Za-z0-9_\-\.]+)', content)
        declared_hosts.update(hosts)

    # Check scripts for hardcoded URLs
    for ext in ['*.py', '*.js', '*.ts', '*.sh']:
        for f in skill_path.rglob(ext):
            if 'node_modules' in str(f) or '.git' in str(f):
                continue
            try:
                content = f.read_text(encoding='utf-8', errors='ignore')
                urls = re.findall(r'https?://([A-Za-z0-9_\-\.]+)', content)
                for url in urls:
                    if url not in declared_hosts and not any(safe in url for safe in ['github.com', 'raw.githubusercontent.com', 'pypi.org', 'npmjs.com']):
                        issues.append(f"{f.relative_to(skill_path)}: undeclared host: {url}")
            except Exception:
                pass

    if issues:
        return False, "; ".join(issues)
    return True, "All network requests declared or standard"


def check_dependency_source(skill_path: Path) -> tuple[bool, str]:
    """Check package dependencies for transparency and known vulnerabilities."""
    issues = []

    # Check package files
    for pkg_file in ['requirements.txt', 'package.json', 'pipfile', 'pyproject.toml', 'setup.py']:
        pf = skill_path / pkg_file
        if pf.exists():
            content = pf.read_text(encoding='utf-8', errors='ignore')
            # Check for git-based deps without commit hashes
            if 'git+' in content and '@' not in content.split('git+')[1].split('\n')[0]:
                issues.append(f"{pkg_file}: git dependency without commit hash")

    # Check for lock file presence when package file exists
    if (skill_path / 'package.json').exists() and not (skill_path / 'package-lock.json').exists() and not (skill_path / 'yarn.lock').exists():
        issues.append("package.json without lock file (non-deterministic)")

    # Try running pip audit or npm audit if available
    req_txt = skill_path / 'requirements.txt'
    if req_txt.exists():
        try:
            result = subprocess.run(['pip', 'audit', '--json'], capture_output=True, text=True, timeout=30)
            if result.returncode == 0:
                pass  # No vulnerabilities
            elif result.returncode == 1:
                # Vulnerabilities found - parse and report
                try:
                    audit_data = json.loads(result.stdout)
                    vulns = audit_data.get('vulnerabilities', {})
                    if vulns:
                        issues.append(f"pip audit: {sum(len(v) for v in vulns.values())} vulnerabilities found")
                except json.JSONDecodeError:
                    issues.append("pip audit found vulnerabilities (parse failed)")
        except (subprocess.TimeoutExpired, FileNotFoundError):
            pass  # pip-audit not available, skip

    if issues:
        return False, "; ".join(issues)
    return True, "Dependencies transparent and secure"


def run_security_check(skill_path: Path) -> dict:
    """
    Run all four security checks.
    Returns dict with check results and overall verdict.
    """
    checks = {
        'data_security': {'name': '数据安全', 'result': None, 'detail': ''},
        'permission_scope': {'name': '权限范围', 'result': None, 'detail': ''},
        'network_requests': {'name': '网络请求', 'result': None, 'detail': ''},
        'dependency_source': {'name': '依赖来源', 'result': None, 'detail': ''},
    }

    checks['data_security']['result'], checks['data_security']['detail'] = check_data_security(skill_path)
    checks['permission_scope']['result'], checks['permission_scope']['detail'] = check_permission_scope(skill_path)
    checks['network_requests']['result'], checks['network_requests']['detail'] = check_network_requests(skill_path)
    checks['dependency_source']['result'], checks['dependency_source']['detail'] = check_dependency_source(skill_path)

    all_pass = all(c['result'] for c in checks.values())
    any_fail = any(not c['result'] for c in checks.values())

    return {
        'checks': checks,
        'verdict': 'PASS' if all_pass else 'FAIL',
        'auto_exclude': any_fail,
        'failure_reasons': [f"{c['name']}: {c['detail']}" for c in checks.values() if not c['result']]
    }


def main():
    parser = argparse.ArgumentParser(description='Security check for scientific skills')
    parser.add_argument('path', help='Path to skill directory')
    args = parser.parse_args()

    skill_path = Path(args.path)
    if not skill_path.exists():
        print(json.dumps({'error': f'Path not found: {skill_path}'}))
        sys.exit(1)

    result = run_security_check(skill_path)
    print(json.dumps(result, indent=2, ensure_ascii=False))

    sys.exit(0 if result['verdict'] == 'PASS' else 1)


if __name__ == '__main__':
    main()