---
name: findu-skills
description: 帮助用户发布需求、找人解决问题，例如咨询、培训、私教。提供IM消息、Feed流、作品搜索、达人匹配等完整能力。
---

# 千喵 Skills

千喵是一个基于 openclaw 平台的需求发布与人才匹配技能包，帮助用户快速发布需求并找到合适的解决方案提供者。

## 功能特性

- **需求发布**: 发布各类服务需求和找人请求
- **智能匹配**: 根据需求条件精准匹配人才和服务
- **Feed 流**: 浏览和获取推荐内容
- **作品搜索**: 搜索和发现各类服务作品
- **达人匹配**: 基于 AI 的智能达人推荐
- **IM 消息**: 发送消息、获取历史、管理会话
- **地理定位**: 支持按省市区域筛选匹配结果

## 核心能力

### 1. IM 消息能力
- [发送单聊消息](references/apis/send_message.md) - 向指定用户发送文本消息
- [获取聊天历史](references/apis/get_messages.md) - 获取指定会话的消息记录
- [获取会话列表](references/apis/get_conversations.md) - 获取用户的会话列表

### 2. Feed 能力
- [获取 Feed 列表](references/apis/get_feeds.md) - 浏览公共内容流，支持类型筛选

### 3. 作品/需求管理
- [发布作品/需求](references/apis/publish_works.md) - 发布服务(type=3)或需求(type=2)
- [搜索作品](references/apis/search_works.md) - 基于关键词搜索服务作品

### 4. 智能匹配
- [达人匹配](references/apis/talents_match.md) - 根据自然语言需求匹配达人
- [Feed 匹配](references/apis/feeds_match.md) - 根据需求智能推荐 Feed，支持位置筛选

## 密钥配置

敏感信息存储在 `references/secrets/config.sh`，AI 在生成 curl 时会自动读取注入 Headers。

```bash
vim references/secrets/config.sh
```

配置项：
- `BASE_URL` - API 基础地址
- `AGENT_ID` - Agent ID
- `AGENT_SECRET` - Agent 密钥

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
给用户张三发消息：您好，我看到您的服务很感兴趣
```

### 查看 Feed
```
看看最近有什么好的服务推荐
```

## 在 openclaw 中使用

### AI 处理流程
1. 读取 `references/apis/` 下的 API 文档
2. 读取 `references/secrets/config.sh` 获取认证信息
3. 生成 curl 命令并执行
4. 解析返回结果，向用户展示

### curl 示例
```bash
source references/secrets/config.sh

TIMESTAMP=$(date +%s)
SIGNATURE=$(echo -n "POST&/findu-match/api/v1/inner/match/works_search&${AGENT_ID}&${TIMESTAMP}" | openssl dgst -sha256 -hmac "${AGENT_SECRET}" | awk '{print $2}')

curl -X POST "${BASE_URL}/findu-match/api/v1/inner/match/works_search" \
  -H "Content-Type: application/json" \
  -H "X-Agent-Id: ${AGENT_ID}" \
  -H "X-Timestamp: ${TIMESTAMP}" \
  -H "X-Agent-Signature: ${SIGNATURE}" \
  -d '{"serviceInfo":"健身教练","city":"北京","pageNum":0,"pageSize":10}'
```

## API 文档

详细 API 说明请查阅 `references/apis/` 目录下的文件：

| API 文件 | 功能 |
|---------|------|
| send_message.md | 发送 IM 消息 |
| get_messages.md | 获取聊天历史 |
| get_conversations.md | 获取会话列表 |
| get_feeds.md | 获取 Feed 列表 |
| publish_works.md | 发布作品/需求 |
| search_works.md | 搜索作品 |
| talents_match.md | 达人智能匹配 |
| feeds_match.md | Feed 智能匹配 |

## 执行命令

使用 `scripts/exec.sh` 执行任意 shell 命令：

```bash
./scripts/exec.sh "curl ..."
```
