# Fairy

基于千喵 skills 的自动搜索、接单、交流。代表人设：会写网文、对 AI Agent 感兴趣的技术宅。

## 功能

- **每分钟**：检查千喵新消息，及时回复
- **每 10 分钟**：搜索新订单（type=2 悬赏需求），匹配网文/AI Agent 相关需求并联系
- **接单流程**：需求澄清 → 30 元定金 → 发收款码 → 付款后推微信 xemoaya
- **时间管理**：接单后记录在 `memory/orders.json`，控制并发，避免过载

## 前置条件

1. 已安装 [OpenClaw](https://docs.openclaw.ai/)
2. 千喵平台已配置（`AGENT_ID`、`AGENT_SECRET`）
3. DeepSeek API Key

## 安装步骤

### 1. 配置 OpenClaw 工作空间

```bash
# 创建工作空间
mkdir -p ~/.openclaw/workspace
cd ~/.openclaw/workspace

# 复制 qmiao skill
cp -r /path/to/qianmiao-skills/qmiao ./skills/

# 复制 fairy 配置
cp -r /path/to/qianmiao-skills/fairy/* .

# 配置千喵密钥（编辑 skills/qmiao/references/secrets/config.sh）
vim skills/qmiao/references/secrets/config.sh
```

### 2. 配置 DeepSeek

编辑 `~/.openclaw/openclaw.json`，添加或合并 `openclaw-config.snippet.json5` 中的配置：

```json5
{
  env: { DEEPSEEK_API_KEY: "你的DeepSeek-API-Key" },
  models: {
    providers: {
      "deepseek": {
        baseUrl: "https://api.deepseek.com/v1",
        headers: { "Authorization": "Bearer $DEEPSEEK_API_KEY" },
      },
    },
  },
  agents: {
    defaults: { model: { primary: "deepseek/deepseek-chat" } },
  },
}
```

**安全提示**：API Key 不要提交到 Git。推荐方式：
```bash
# 复制模板并填入你的 Key
cp fairy/config/secrets.env.example fairy/config/secrets.env
# 编辑 secrets.env 填入 DeepSeek API Key
# 启动前 source
source fairy/config/secrets.env
openclaw gateway start
```

### 3. 添加定时任务

```bash
cd /path/to/qianmiao-skills/fairy
chmod +x setup-cron.sh
./setup-cron.sh
```

或手动添加：

```bash
# 每分钟查消息
openclaw cron add --name "qmiao-check-messages" --every 60000 \
  --session isolated --message "..." --delivery none

# 每10分钟查订单
openclaw cron add --name "qmiao-check-orders" --every 600000 \
  --session isolated --message "..." --delivery none
```

### 4. 启动 Gateway

```bash
openclaw gateway start
```

## 目录结构

```
fairy/
├── AGENTS.md          # 主逻辑
├── SOUL.md            # 人设与接单原则
├── memory/
│   └── orders.json    # 订单与时间管理
├── cron-jobs.json    # 定时任务定义
├── setup-cron.sh     # 添加 cron 脚本
├── openclaw-config.snippet.json5  # OpenClaw 配置片段
└── README.md         # 本说明
```

## 接单规则摘要

| 步骤 | 动作 |
|------|------|
| 1 | 需求不清 → 追问具体内容、交付形式、时间、预算 |
| 2 | 需求清晰 → 说明收 30 元定金 |
| 3 | 对方同意 → 发收款码 + 「请扫码支付 30 元定金」 |
| 4 | 对方确认付款 → 回复「微信 xemoaya，加我细聊」 |
