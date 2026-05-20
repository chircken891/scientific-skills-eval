// Intent Parser for Scientific-Do
// Per D-16: Intent parsing capability

export interface Intent {
  stage: 'literature' | 'analysis' | 'writing' | 'polishing' | 'submission';
  taskType: string[];
  domainKeywords: string[];
  domain?: 'scientific' | 'engineering' | 'general' | 'mixed';
  confidence: number;
}

export function parseIntent(input: string): Intent {
  // 1. Recognize research stages
  const stages = {
    literature: ['文献', '检索', '搜索', 'paper', 'article', 'search', 'find'],
    analysis: ['分析', '统计', '建模', 'analyze', 'analysis', 'model'],
    writing: ['写作', '写', '撰写', 'write', 'writing', 'draft'],
    polishing: ['润色', '修改', 'polish', 'edit', 'revise'],
    submission: ['投稿', 'submit', 'submission', 'journal']
  };

  // 2. Recognize task types
  const taskTypes = {
    '文献检索': ['检索', '搜索', 'find', 'search', 'query'],
    '数据分析': ['分析', '统计', 'model', 'analyze', 'analyse'],
    '图表生成': ['图', '表', 'plot', 'chart', 'figure', 'visualize'],
    '论文写作': ['写', '写作', 'write', 'draft', 'compose'],
    '论文润色': ['润色', 'polish', 'edit', 'revise', 'improve']
  };

  // 3. Recognize domain keywords
  const domains = ['医学', 'biomedical', 'clinical', '统计', 'statistical', 'machine learning', 'ML', 'AI'];

  // 4. Detect request domain (D-21: everything-claude-code integration)
  const domain = detectDomain(input);

  return {
    stage: detectStage(input, stages),
    taskType: detectTaskTypes(input, taskTypes),
    domainKeywords: detectDomains(input, domains),
    domain,
    confidence: calculateConfidence(input)
  };
}

function detectStage(input: string, stages: Record<string, string[]>): string {
  const lower = input.toLowerCase();
  for (const [stage, keywords] of Object.entries(stages)) {
    if (keywords.some(k => lower.includes(k.toLowerCase()))) {
      return stage;
    }
  }
  return 'literature'; // default
}

function detectTaskTypes(input: string, taskTypes: Record<string, string[]>): string[] {
  const lower = input.toLowerCase();
  const matched: string[] = [];
  for (const [type, keywords] of Object.entries(taskTypes)) {
    if (keywords.some(k => lower.includes(k.toLowerCase()))) {
      matched.push(type);
    }
  }
  return matched;
}

function detectDomains(input: string, domains: string[]): string[] {
  const lower = input.toLowerCase();
  return domains.filter(d => lower.includes(d.toLowerCase()));
}

function detectDomain(input: string): 'scientific' | 'engineering' | 'general' | 'mixed' {
  const lower = input.toLowerCase();
  const scientific = [
    '文献', '论文', '研究', '分析', '统计', '医学', '临床', '生物', '基因', '蛋白',
    '药物', '分子', '细胞', '流行病学', 'prisma', 'strobe', 'consort', 'meta分析',
    '系统综述', 'rct', '队列', '病例对照', '诊断', '预后', '综述', '润色', '图表',
    '绘图', '投稿', '发表', 'article', 'paper', 'research', 'manuscript', 'journal',
    'literature', 'pubmed', 'medrxiv', 'cochrane', 'meta-analysis', 'biomedical'
  ];
  const engineering = [
    'api', 'fastapi', 'django', 'react', 'vue', 'docker', 'k8s', 'kubernetes',
    'deploy', 'security audit', '测试', 'tdd', 'database', 'sql', 'nosql', 'ci/cd',
    '前端', '后端', '接口', '部署', '代码', '编程', 'web开发', 'app开发'
  ];

  const hasScientific = scientific.some(k => lower.includes(k.toLowerCase()));
  const hasEngineering = engineering.some(k => lower.includes(k.toLowerCase()));

  if (hasScientific && hasEngineering) return 'mixed';
  if (hasScientific) return 'scientific';
  if (hasEngineering) return 'engineering';
  return 'general';
}

function calculateConfidence(input: string): number {
  const wordCount = input.split(/\s+/).length;
  const hasKeywords = ['分析', '论文', '研究', 'paper', 'research', 'study'].some(k =>
    input.toLowerCase().includes(k.toLowerCase())
  );
  if (wordCount > 10 && hasKeywords) return 0.9;
  if (wordCount > 3 && hasKeywords) return 0.7;
  if (hasKeywords) return 0.5;
  return 0.3;
}
