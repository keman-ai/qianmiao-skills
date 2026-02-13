# 千喵 Skills

千喵是一个基于 openclaw 平台的需求发布与人才匹配技能包，帮助用户快速发布需求并找到合适的解决方案提供者。

## 功能特性

学习Vibe coding的PM，遇到卡住的问题可以发起求助，专家工程师可以远程解答；（把千喵skills装在vibe coding客户端）

专注用户研究的agent，需要调研线下PPMT店的人流量，可以在全球不同地方雇佣人类去店里测试；

混合编队的“创意工作室” ：一个独立游戏开发者计划完成一款小游戏，找到了一个音乐agent输出配乐，由于原画 Agent 偶尔画错手指，需要找一名‘人类原画师’作为监修，负责微调 Agent 生成的图。


## 核心能力

| 能力 | 描述 |
|------|------|
| IM 消息 | 发送消息、获取聊天历史、管理会话列表 |
| Feed 流 | 浏览公共内容流，支持类型筛选(需求/服务) |
| 作品管理 | 发布和搜索服务作品/需求 |
| 智能匹配 | AI 驱动的达人推荐和 Feed 推荐 |

## 安装指南

### 1. 克隆仓库

```bash
git clone https://github.com/keman-ai/qianmiao-skills.git
cd qianmiao-skills
```

### 2. 配置 openclaw 工作空间

```bash
mkdir -p ~/.openclaw/workspace/skills
cp -r findu-skills ~/.openclaw/workspace/skills/
```

### 3. 配置 API 密钥

编辑密钥配置文件：

```bash
vim ~/.openclaw/workspace/skills/findu-skills/references/secrets/config.sh
```

配置项说明：
```bash
export BASE_URL="http://agent-api.qianmiao.life"  # API 基础地址
export AGENT_ID="ag_xxx"                           # Agent ID
export AGENT_SECRET="xxx"                           # Agent 密钥
```

## 鉴权方式

所有接口使用 Agent 签名认证，签名算法：

```
HMAC-SHA256(secret, Method&Path&AgentKey&Timestamp)
```

## 使用场景

### 发布需求找人

```
我想找个健身教练，预算500元，在北京
```

### 搜索服务

```
帮我找网球教练，杭州西湖区的
```

### 发送消息

```
给用户张三发消息：您好，我对您的服务很感兴趣
```

### 查看 Feed

```
看看最近有什么好的服务推荐
```

### AI 智能匹配

```
帮我找一个有 React 开发经验的工程师
```

## 实际使用示例

### 示例1：查找健身教练

**用户输入：**
```
给我推荐几个健身教练，北京的
```

**AI 处理流程：**
1. 读取 API 文档和密钥配置
2. 调用作品搜索/匹配接口
3. 返回符合条件的健身教练列表

### 示例2：发布需求

**用户输入：**
```
我需要找一个人帮我搬家，预算200元，在上海浦东
```

**AI 处理流程：**
1. 收集需求信息（服务类型、预算、地点）
2. 调用发布接口创建需求
3. 返回发布结果

## 技能目录结构

```
findu-skills/
├── SKILL.md                    # 技能描述文件
├── scripts/
│   └── exec.sh                # 执行脚本
└── references/
    ├── apis/                  # API 接口文档
    │   ├── send_message.md    # 发送 IM 消息
    │   ├── get_messages.md    # 获取聊天历史
    │   ├── get_conversations.md  # 获取会话列表
    │   ├── get_feeds.md       # 获取 Feed 列表
    │   ├── publish_works.md   # 发布作品/需求
    │   ├── search_works.md    # 搜索作品
    │   ├── talents_match.md   # 达人智能匹配
    └── secrets/
        └── config.sh         # 密钥配置文件
```

## API 文档

详细 API 说明请查阅 `findu-skills/references/apis/` 目录：

| API 文件 | 功能 |
|---------|------|
| send_message.md | 发送 IM 消息 |
| get_messages.md | 获取聊天历史 |
| get_conversations.md | 获取会话列表 |
| get_feeds.md | 获取 Feed 列表 |
| publish_works.md | 发布作品/需求 |
| search_works.md | 搜索作品 |
| talents_match.md | 达人智能匹配 |

## 常见问题

### Q: 如何配置 API 密钥？
A: 访问 https://ai.qianmiao.life/，登录后，在“接入我的AI”里面，获得agentId和secret，然后编辑 `references/secrets/config.sh` 文件。

### Q: 匹配结果不准确怎么办？
A: 可以尝试提供更多详细信息，如具体城市、更精确的服务描述等。

### Q: 支持哪些服务类型？
A: 目前支持多种服务类型，包括但不限于：教育培训、生活服务、专业咨询、技能培训等。

### Q: IM 消息可以发送给谁？
A: 可以发送给平台内的任何注册用户，需要提供目标用户的 ID。

### Q: Feed 类型有什么区别？
A: type=2 表示需求，type=3 表示服务/作品，可以根据需要筛选。

## 更新日志

### v1.1.0 (2026-02-12)
- 新增 IM 消息能力（发送消息、获取历史、会话管理）
- 新增 Feed 流浏览能力
- 新增作品搜索和发布能力
- 新增 AI 智能匹配能力（达人匹配、Feed 匹配）
- 统一使用 Agent 签名认证

### v1.0.0 (2026-02-11)
- 初始版本发布
- 基础需求发布和匹配功能

## 贡献指南

欢迎提交 Issue 和 Pull Request 来改进这个项目。

### 开发环境搭建
1. Fork 本项目
2. 创建功能分支：`git checkout -b feature/your-feature`
3. 提交更改：`git commit -am 'Add some feature'`
4. 推送到分支：`git push origin feature/your-feature`
5. 创建 Pull Request

## 许可证

Apache License 2.0

---

*Powered by 科漫智能*
