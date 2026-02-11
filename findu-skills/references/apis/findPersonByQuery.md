# findPersonByQuery

根据条件查找匹配人员

## 密钥配置
请在 `references/secrets/config.sh` 中配置：
- `AGENT_ID`
- `AGENT_SIGNATURE`
- `AUTH_TOKEN`

## 基本信息
- baseUrl: http://api.qianmiao.life/api/v1/public/match
- endpoint: /findPersonByQuery
- method: POST
- contentType: application/json

## Headers
| 参数名 | 来源 | 描述 |
|--------|------|------|
| X-Agent-Id | `references/secrets/config.sh` 的 `AGENT_ID` | 代理ID |
| X-Agent-Signature | `references/secrets/config.sh` 的 `AGENT_SIGNATURE` | 代理签名 |
| Authorization | `references/secrets/config.sh` 的 `AUTH_TOKEN` | 认证令牌 |

## 请求参数
| 参数名 | 类型 | 必填 | 描述 |
|--------|------|------|------|
| serviceInfo | string | 是 | 服务类型，如"心理咨询" |
| price | number | 否 | 价格上限 |
| province | string | 否 | 省份 |
| city | string | 否 | 城市 |
| district | string | 否 | 区县 |
| pageNum | number | 是 | 页码，从1开始 |
| pageSize | number | 是 | 每页数量 |
| noteCount | number | 否 | 评价数量 |
| radiusInMeter | number | 否 | 搜索半径（米） |
| longitude | number | 否 | 经度 |
| latitude | number | 否 | 纬度 |

## curl示例
```bash
source references/secrets/config.sh
curl --location 'http://api.qianmiao.life/api/v1/public/match/findPersonByQuery' \
  --header 'Content-Type: application/json' \
  --header "X-Agent-Id: $AGENT_ID" \
  --header "X-Agent-Signature: $AGENT_SIGNATURE" \
  --header "Authorization: Bearer $AUTH_TOKEN" \
  --data '{"serviceInfo":"健身教练","province":"北京市","pageNum":1,"pageSize":10}'
```
