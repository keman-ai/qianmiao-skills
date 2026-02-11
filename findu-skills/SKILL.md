---
name: findu-skills
description: 帮助用户发布需求、找人解决问题，例如咨询、培训、私教
---

# 需求发布与匹配服务

## 何时使用
当用户需要发布需求、找人解决问题时使用此skill。

## 功能

### 1. 发布需求
收集用户需求信息，包括：
- 服务类型
- 预算价格
- 地理位置（省/市/区）
- 详细描述
- 其他要求

### 2. 找人匹配
根据需求找人：
- 在 `references/apis/` 目录查看API描述
- 在 `references/secrets/config.sh` 配置API密钥
- 根据文档手动编写curl命令
- 使用 `scripts/exec.sh` 执行curl请求

### 3. 密钥配置
敏感信息（如API密钥）存储在 `references/secrets/config.sh`，AI在生成curl时会自动读取注入Headers。

### 4. 执行命令
使用 `scripts/exec.sh` 执行任意shell命令（如curl请求）

## 在 openclaw 中使用

### 使用示例
用户输入：`给我推荐几个健身教练，北京的`

AI处理流程：
1. 识别需求：找健身教练，地点北京
2. 读取 `references/apis/findPersonByQuery.md` 获取接口描述
3. 读取 `references/secrets/config.sh` 获取认证信息（AGENT_ID, AGENT_SIGNATURE, AUTH_TOKEN）
4. 生成curl命令并执行
5. 解析返回结果，向用户展示匹配的教练信息

### 效果展示

![openclaw使用效果](assets/openclaw.png)

### 生成curl示例
```bash
# 读取密钥配置
source references/secrets/config.sh

# 生成并执行请求
./scripts/exec.sh "curl --location 'http://api.qianmiao.life/api/v1/public/match/findPersonByQuery' --header 'Content-Type: application/json' --header \"X-Agent-Id: \$AGENT_ID\" --header \"X-Agent-Signature: \$AGENT_SIGNATURE\" --header \"Authorization: Bearer \$AUTH_TOKEN\" --data '{\"serviceInfo\":\"健身教练\",\"province\":\"北京市\",\"pageNum\":1,\"pageSize\":10}'"
```

## 查看可用接口
阅读 `references/apis/` 目录下的md文件了解每个API的详细描述和参数。
