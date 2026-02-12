# feedsMatch

根据需求描述智能匹配 Feed（支持位置筛选）

## 密钥配置

请在 `references/secrets/config.sh` 中配置：
- `BASE_URL`
- `AGENT_ID`
- `AGENT_SECRET`

## 基本信息

- baseUrl: `{BASE_URL}/findu-match/api/v1/inner/match`
- endpoint: `/feeds_match`
- method: GET
- contentType: application/json

## 鉴权 Headers

签名算法: `HMAC-SHA256(secret, Method&Path&AgentKey&Timestamp)`

| 参数名 | 来源 | 描述 |
|--------|------|------|
| X-Agent-Id | `config.sh` 的 `AGENT_ID` | 代理ID |
| X-Timestamp | 当前时间戳 (秒) | 请求时间戳 |
| X-Agent-Signature | HMAC-SHA256签名 | 签名 |

## 请求参数 (Query)

| 参数名 | 类型 | 必填 | 默认值 | 描述 |
|--------|------|------|--------|------|
| q | string | 是 | - | 查询文本，可以是普通文本或 JSON 格式 |
| limit | number | 否 | 10 | 返回数量限制 |

### q 参数格式

q 可以是：
1. **普通文本**: `找网球教练`
2. **JSON 格式** (推荐，包含更丰富的筛选条件):

```json
{
  "service": {
    "name": "需求描述",
    "value": "找网球教练带入门"
  },
  "industry": {
    "TennisLevel": {
      "name": "我的网球等级",
      "value": "纯小白（1.0水平）"
    }
  },
  "expectedPrice": {
    "name": "期望价格",
    "value": "面议"
  },
  "serviceMethod": {
    "name": "服务位置",
    "value": "线下"
  },
  "serviceLocation": {
    "name": "服务地区",
    "value": "杭州西湖区"
  }
}
```

## curl 示例

```bash
source references/secrets/config.sh

TIMESTAMP=$(date +%s)
SIGNATURE=$(echo -n "GET&/findu-match/api/v1/inner/match/feeds_match&${AGENT_ID}&${TIMESTAMP}" | openssl dgst -sha256 -hmac "${AGENT_SECRET}" | awk '{print $2}')

# 普通文本查询
curl -X GET "${BASE_URL}/findu-match/api/v1/inner/match/feeds_match?q=找网球教练&limit=10" \
  -H "X-Agent-Id: ${AGENT_ID}" \
  -H "X-Timestamp: ${TIMESTAMP}" \
  -H "X-Agent-Signature: ${SIGNATURE}"

# JSON 格式查询（支持位置筛选）
curl -X GET "${BASE_URL}/findu-match/api/v1/inner/match/feeds_match?q=%7B%22service%22%3A%7B%22name%22%3A%22%E9%9C%80%E6%B1%82%E6%8F%8F%E8%BF%B0%22%2C%22value%22%3A%22%E6%89%BE%E7%BD%91%E7%90%83%E6%95%99%E7%BB%83%E5%B8%A6%E5%85%A5%E9%97%A8%22%7D%2C%22serviceMethod%22%3A%7B%22name%22%3A%22%E6%9C%8D%E5%8A%A1%E4%BD%8D%E7%BD%AE%22%2C%22value%22%3A%22%E7%BA%BF%E4%B8%8B%22%7D%2C%22serviceLocation%22%3A%7B%22name%22%3A%22%E6%9C%8D%E5%8A%A1%E5%9C%B0%E5%8C%BA%22%2C%22value%22%3A%22%E6%9D%AD%E5%B7%9E%E8%A5%BF%E6%B9%96%E5%8C%BA%22%7D%7D&limit=10" \
  -H "X-Agent-Id: ${AGENT_ID}" \
  -H "X-Timestamp: ${TIMESTAMP}" \
  -H "X-Agent-Signature: ${SIGNATURE}"
```

## 响应示例

成功:
```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "id": 123,
      "title": "专业网球教练服务",
      "subtitle": "提供专业的网球教学服务",
      "similarity": 0.85,
      "extendInfo": {
        "serviceMethod": "线下",
        "serviceLocation": "杭州西湖区",
        "expectedPrice": "面议"
      },
      "authorId": "user_001",
      "authorName": "张教练"
    }
  ]
}
```

## 响应字段说明

| 字段名 | 类型 | 描述 |
|--------|------|------|
| id | number | Feed ID |
| title | string | Feed 标题 |
| subtitle | string | Feed 副标题/内容摘要 |
| similarity | double | 相似度（0-1之间） |
| extendInfo | object | 扩展信息 |
| extendInfo.serviceMethod | string | 服务方式 |
| extendInfo.serviceLocation | string | 服务地点 |
| extendInfo.expectedPrice | string | 期望价格 |
| authorId | string | 作者ID |
| authorName | string | 作者名称 |

## 行为说明

### 线下服务 (serviceMethod="线下" 或 "offline")
1. 解析 JSON 为 DemandDTO
2. 检测到 serviceMethod="线下" 或 "offline"
3. 提取 Location 信息（省/市/区县）
4. 使用位置筛选进行向量搜索
5. LLM 语义过滤

### 普通文本/在线服务
1. 解析 queryText（如果是 JSON 则提取 service.value）
2. 不触发位置提取和筛选
3. 使用普通向量搜索
4. LLM 语义过滤
