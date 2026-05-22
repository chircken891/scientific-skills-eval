// Skill Router for Scientific-Do
// Per D-16, D-17: Skill routing capability

import { Intent } from './intent-parser';

export interface RouteResult {
  primarySkill: string;
  secondarySkills: string[];
  executionOrder: string[];
  confidence: number;
}

// Fallback guide for non-scientific requests (D-21: everything-claude-code integration)
const FALLBACK_GUIDE = {
  everything_claude_code: 'everything-claude-code: 200+ 通用开发 skills (FastAPI/Django/React/Docker/安全审计等)',
  general_note: '当前请求不在 scientific-do 的科研能力范围内。请直接用 Claude Code 处理，或使用 everything-claude-code 的通用开发 skills。'
};

// Skill mapping table
const SKILL_MAP: Record<string, string[]> = {
  '文献检索': ['deepxiv_sdk'],
  '论文分析': ['academic-paper-analysis', 'deepxiv_sdk'],
  '数据分析': ['scientific-agent-skills'],
  '论文写作': ['academic-writing-skills'],
  '图表生成': ['paper-plot-skills'],
  '投稿润色': ['Paper-Polish-Workflow-skill'],
  '医学专项': ['medsci-skills'],
  'skill评测': ['scientific-skill-eval'],
  'skill评估': ['scientific-skill-eval'],
  'skill打分': ['scientific-skill-eval'],
  'skill质量': ['scientific-skill-eval'],
  '科研工具评测': ['scientific-skill-eval'],
  '批量评测': ['scientific-skill-eval']
};

export function routeSkill(intent: Intent): RouteResult {
  // 0. Domain gate (D-21: route non-scientific requests to everything-claude-code)
  if (intent.domain === 'general' || intent.domain === 'engineering') {
    return {
      primarySkill: 'FALLBACK',
      secondarySkills: ['everything-claude-code'],
      executionOrder: ['everything-claude-code'],
      confidence: intent.confidence * 0.5
    };
  }

  // 1. Exact match
  const exactMatch = findExactMatch(intent);
  if (exactMatch) return exactMatch;

  // 2. Fuzzy fallback
  const fuzzyMatch = findFuzzyMatch(intent);
  if (fuzzyMatch) return fuzzyMatch;

  // 3. Smart tuning
  return smartTuning(intent);
}

function findExactMatch(intent: Intent): RouteResult | null {
  const stage = intent.stage;
  const skills = SKILL_MAP[stage] || [];
  if (skills.length > 0) {
    return {
      primarySkill: skills[0],
      secondarySkills: skills.slice(1),
      executionOrder: buildDependencyChain(skills),
      confidence: intent.confidence
    };
  }
  return null;
}

function findFuzzyMatch(intent: Intent): RouteResult | null {
  const taskTypes = intent.taskType;
  if (taskTypes.length > 0) {
    const allSkills = taskTypes.flatMap(t => SKILL_MAP[t] || []);
    const unique = [...new Set(allSkills)];
    if (unique.length > 0) {
      return {
        primarySkill: unique[0],
        secondarySkills: unique.slice(1),
        executionOrder: buildDependencyChain(unique),
        confidence: intent.confidence * 0.8
      };
    }
  }
  return null;
}

function smartTuning(intent: Intent): RouteResult {
  return {
    primarySkill: 'deepxiv_sdk',
    secondarySkills: [],
    executionOrder: ['deepxiv_sdk'],
    confidence: intent.confidence * 0.5
  };
}

export function buildDependencyChain(skills: string[]): string[] {
  const order: string[] = ['deepxiv_sdk'];
  if (skills.includes('scientific-agent-skills')) order.push('scientific-agent-skills');
  if (skills.includes('academic-writing-skills')) order.push('academic-writing-skills');
  if (skills.includes('paper-plot-skills')) order.push('paper-plot-skills');
  if (skills.includes('Paper-Polish-Workflow-skill')) order.push('Paper-Polish-Workflow-skill');
  return order.filter(s => skills.includes(s));
}
