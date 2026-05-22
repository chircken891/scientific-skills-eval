# Rubric: Figure / Chart Generation

For skills that create publication-ready figures, charts, and visualizations from data.

## Score Criteria

| Score | Criteria |
|-------|----------|
| 5/5 | Generates publication-ready figures with journal-specific typography, color schemes, resolution >= 300 dpi, and proper axis labeling. Supports multiple output formats (PNG, SVG, PDF, EPS). Style transfer from existing papers (match a reference paper's figure style). Data-to-figure pipeline with automated encoding selection. Multi-panel figure composition. Colorblind-safe palette options. |
| 4/5 | Publication-ready figures with customizable styles. Supports 2-3 output formats. Good axis labeling and typography. Manual multi-panel composition. |
| 3/5 | Generates clean charts (bar, line, scatter, boxplot) with matplotlib/ggplot-style defaults. Basic customization. Standard resolution. Single-panel only. |
| 2/5 | Basic charts with minimal styling. Limited output formats. Default color schemes only. Axis labels may need manual correction. |
| 1/5 | Cannot generate visualizations. May produce data tables or ASCII representations only. |

## Score Translation

- **5** → 出版级+多格式+风格迁移+色盲安全+多面板自动排版
- **4** → 出版级但多面板需手动
- **3** → 基础图表（ matplotlib 默认风格），单面板
- **2** → 样式有限，可能需手动修正标签
- **1** → 无可视化能力

## Function Type ID

`figure-generation`