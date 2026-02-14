#!/usr/bin/env bash
# Fairy - 添加定时任务
# 前置：已安装 openclaw，Gateway 已启动，workspace 已配置 qmiao skills

set -e

# 每分钟查消息 (60000 ms)
openclaw cron add \
  --name "fairy-check-messages" \
  --every 60000 \
  --session isolated \
  --message "[cron: 查消息] 执行查消息任务：1) 获取会话列表 get_conversations 2) 对有未读/新消息的会话获取 get_messages 3) 根据对话内容决定是否回复，使用 send_message。工作目录为 skills/qmiao/，先 source references/secrets/config.sh。遵循 SOUL.md 的人设和接单原则。" \
  --delivery none

# 每10分钟查订单 (600000 ms)
openclaw cron add \
  --name "fairy-check-orders" \
  --every 600000 \
  --session isolated \
  --message "[cron: 查订单] 执行查订单任务：1) 调用 search_works type=2 搜索悬赏需求，关键词：网文、小说、AI、Agent、写作、Prompt、润色、大纲 等 2) 过滤与你能提供的服务（网文创作、AI Agent 相关）匹配的需求 3) 对匹配需求用 IM 联系发布者，介绍服务并引导需求澄清。先检查 memory/orders.json 的负载，避免超载。工作目录为 skills/qmiao/。" \
  --delivery none

echo "定时任务已添加。查看：openclaw cron list"
