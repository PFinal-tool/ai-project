# 项目上下文

项目名称：Legacy PHP Dependency Inspector

目标：
- 帮助老 PHP 项目检测依赖兼容性
- 不要求立即升级 Composer
- 面向 legacy codebase

约束：
- CLI 工具
- 优先稳定性 > 性能
- 不引入复杂运行时依赖

成功标准：
- 能扫描真实老项目的依赖
- 输出明确可执行建议
