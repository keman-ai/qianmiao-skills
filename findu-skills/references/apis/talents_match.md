# talentsMatch

根据查询文本智能匹配达人/服务提供者

## 密钥配置

请在 `references/secrets/config.sh` 中配置：
- `BASE_URL`
- `AGENT_ID`
- `AGENT_SECRET`

## 基本信息

- baseUrl: `{BASE_URL}/findu-match`
- endpoint: `/talents_match/`
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
| q | string | 是 | - | 查询文本，自然语言描述需求 |
| limit | number | 否 | 10 | 返回数量限制，最大建议100 |

## curl 示例

```bash
source references/secrets/config.sh

TIMESTAMP=$(date +%s)
SIGNATURE=$(echo -n "GET&/findu-match/talents_match/&${AGENT_ID}&${TIMESTAMP}" | openssl dgst -sha256 -hmac "${AGENT_SECRET}" | awk '{print $2}')

# 基本查询
curl -X GET "${BASE_URL}/findu-match/talents_match/?q=我需要一个React前端开发工程师&limit=10" \
  -H "X-Agent-Id: ${AGENT_ID}" \
  -H "X-Timestamp: ${TIMESTAMP}" \
  -H "X-Agent-Signature: ${SIGNATURE}"
```

## 响应示例

成功:
```json
{
  "code": "200",
  "message": "success",
  "data": [
    {
      "userId": "68d63538cddf59418aab1093",
      "similarity": 0.85,
      "matchLevel": "高度匹配",
      "nickname": "张三",
      "avatarUrl": "https://example.com/avatar.jpg",
      "backgroundUrl": "https://example.com/background.jpg",
      "tags": [
        {
          "name": "React",
          "type": "skill"
        },
        {
          "name": "前端开发",
          "type": "skill"
        }
      ],
      "bio": "资深前端开发工程师，5年React开发经验"
    }
  ]
}
```

## 响应字段说明

| 字段名 | 类型 | 描述 |
|--------|------|------|
| userId | string | 用户ID |
| similarity | double | 相似度（0-1之间），数值越大越相似 |
| matchLevel | string | 匹配度等级：高度匹配/较好匹配/一般匹配/弱匹配 |
| nickname | string | 用户昵称 |
| avatarUrl | string | 头像URL |
| backgroundUrl | string | 背景图URL |
| tags | array | 用户标签列表 |
| tags[].name | string | 标签名称 |
| tags[].type | string | 标签类型 |
| bio | string | 个人简介 |

## 匹配度等级说明

| 相似度范围 | 匹配度等级 |
|-----------|-----------|
| >= 0.8 | 高度匹配 |
| 0.6 - 0.8 | 较好匹配 |
| 0.4 - 0.6 | 一般匹配 |
| 0.1 - 0.4 | 弱匹配 |
| < 0.1 | 不匹配（不返回） |

## 使用场景示例

1. **技能需求查询**:
   ```
   q=需要React前端开发工程师
   ```

2. **复杂需求查询**:
   ```
   q=寻找UI设计师，有移动端设计经验，熟悉Figma和Sketch
   ```

3. **项目需求查询**:
   ```
   q=需要数据分析师，熟悉Python和机器学习算法，有电商数据分析经验
   ```

## 注意事项

- 查询文本越详细、越具体，匹配结果越准确
- 系统只返回相似度 >= 0.1 的结果
- 建议 limit 参数不超过 100
- 查询文本长度建议不超过 500 字符
