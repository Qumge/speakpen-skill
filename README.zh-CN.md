# SpeakPen Skill

[English](README.md) | [简体中文](README.zh-CN.md)

**让说出口的想法，成为下一步行动。**

这个开源 Agent Skill 教 AI 查找你的 SpeakPen 笔记，先读原文再整理结论，并给出笔记来源。SpeakPen 帮你留下想法，Agent 再基于这些想法帮你梳理计划、待办或草稿。

## 从这里开始

**[先用 SpeakPen 留下你的想法 →](https://speakpen.app/zh-Hans?utm_source=github-speakpen-skill&utm_medium=readme&utm_campaign=voice_to_action)**

[下载 iOS](https://apps.apple.com/app/id6743360755) · [下载 Android](https://play.google.com/store/apps/details?id=com.qumge.speakpen) · [使用网页版](https://speakpen.app/app?utm_source=github-speakpen-skill&utm_medium=readme&utm_campaign=voice_to_action)

1. 在 SpeakPen 录一段想法，等待笔记处理完成。
2. [安装 Skill](#安装)，再通过 MCP 或 API token 授权访问笔记。
3. 让 Agent 找出这个想法，帮你梳理下一步行动。

已经有 SpeakPen 笔记？可以[直接安装](#安装)，或查看[连接指南](https://speakpen.app/zh-Hans/connect?utm_source=github-speakpen-skill&utm_medium=readme&utm_campaign=voice_to_action)。安装和复用技能文件免费，读取云端笔记仍需账号授权。

例如，你可以问：

- “这周我对发布计划说过什么？”
- “找到我关于定价的笔记，整理最后的结论。”
- “把昨天记录的内容整理成待办事项。”

## 需要 SpeakPen 账号吗？

不注册也能阅读、复制和安装技能文件。**使用其中的 SpeakPen 笔记工具，需要账号和授权**：可以通过 MCP 的 OAuth 登录，也可以使用自己的 API token。API token 仍属于 SpeakPen 账号，不是免账号模式。

| 你想做什么 | 当前条件 |
|---|---|
| 阅读、修改或安装 MIT 许可的技能文件 | 不需要 SpeakPen 账号 |
| 搜索、读取自己的 SpeakPen 笔记 | 账号 + OAuth 或 API token |
| 从自己的笔记中得到有用结果 | 至少一条处理完成的 SpeakPen 笔记 |
| 用这个技能转写本地音频或读取任意本地 Markdown | 本仓库尚未实现 |

仅连接这个只读集成不要求付费订阅。录音等服务功能仍受套餐额度限制；你使用的 AI 客户端也可能有自己的权限和费用要求。

本仓库目前**没有游客模式、可运行的示例数据模式或本地转写引擎**。技能提供使用流程，不能替代 SpeakPen App 或线上服务。

[从免费账号开始](https://speakpen.app/zh-Hans?utm_source=github-speakpen-skill&utm_medium=readme&utm_campaign=voice_to_action) → 录一段想法 → 等待处理完成 → 连接 Agent → 尝试上面的问题。

## 如何访问笔记

1. **优先使用 MCP**：在客户端连接 `https://speakpen.app/mcp`，技能会使用 `search`、`fetch`、`list_recent_notes`。详见 [speakpen-mcp](https://github.com/Qumge/speakpen-mcp)。
2. **HTTP 备用方式**：在 https://speakpen.app/app 的“设置 → 连接 → 开发者”创建 API token，通过环境变量 `SPEAKPEN_TOKEN` 提供给 Agent。接口说明见 [API reference](skills/speakpen/references/api-reference.md)。

访问是只读的：Agent 不能创建、修改或删除笔记，也不会收到原始音频。只有处理完成的笔记可以通过 MCP 读取。

## 安装

**Claude Code**：安装技能及其 `speakpen` MCP 配置；使用工具时仍需通过 OAuth 登录 SpeakPen。

```text
/plugin marketplace add Qumge/speakpen-skill
/plugin install speakpen@speakpen
```

也可以在终端执行 `claude plugin marketplace add Qumge/speakpen-skill`，然后执行 `claude plugin install speakpen@speakpen`。

**其他 Agent / 手动安装**：复制 `skills/speakpen` 到客户端的技能目录，再连接 MCP 或使用上述 HTTP 备用方式。以 Claude Code 为例：

```bash
git clone https://github.com/Qumge/speakpen-skill
mkdir -p ~/.claude/skills
cp -R speakpen-skill/skills/speakpen ~/.claude/skills/speakpen
```

## Skill 帮助 Agent 做什么

- 按主题或时间查找笔记，引用之前先读取来源。
- 区分你的原话、Agent 的理解与建议行动。
- 提供标题、日期和笔记链接，方便你核对。
- 如实说明没有匹配笔记或工具调用失败，不编造答案。

Skill 服务于已有的 SpeakPen 笔记，不提供本地音频转写、游客演示或独立本地笔记服务器。安装文件不等于获得私有笔记权限，仍需 OAuth 或 API token 授权。

## 从哪里开始

- [连接指南](https://speakpen.app/zh-Hans/connect?utm_source=github-speakpen-skill&utm_medium=readme&utm_campaign=voice_to_action)：各客户端的连接和授权步骤。
- 本仓库提供 Agent 使用流程；[speakpen-mcp](https://github.com/Qumge/speakpen-mcp) 说明托管连接方式，不需要把两个仓库都克隆下来。

## 相关项目

- [speakpen-mcp](https://github.com/Qumge/speakpen-mcp)：托管 MCP 服务的文档与注册信息。
- [SpeakPen Sync for Obsidian](https://github.com/Qumge/speakpen-obsidian)：把笔记同步为知识库里的 Markdown 文件。

## 许可证

MIT 适用于本仓库中的技能、文档等文件，不代表开放了 SpeakPen 托管后端，也不授予访问他人笔记的权利。线上服务遵循 [SpeakPen 服务条款](https://speakpen.app/terms)。
