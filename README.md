AssetUtil - 关键资产安全存储工具
AssetUtil 是一个基于 HarmonyOS AssetStoreKit 的安全存储工具类，用于安全地存储、检索和管理敏感数据（如密钥、凭证等）。它提供了简单易用的 API 来操作加密资产，并支持同步/异步两种操作模式。

功能特性
✅ 安全存储：使用系统级加密保护敏感数据

⚡ 同步/异步操作：支持同步和异步两种调用方式

🔍 设备兼容性检查：自动检测设备是否支持安全存储功能

🛡️ 冲突处理：内置覆盖式冲突解决机制

📦 持久化支持：可选择是否持久化存储（当前版本默认开启）


快速开始

存储关键资产（异步）
typescript
// 存储访问令牌（异步）
const success = await AssetUtil.add('api_access_token', 'your_token_here');
if (success) {
  console.log('令牌存储成功');
}
检索关键资产（同步）
typescript
// 获取API密钥（同步）
const apiKey = AssetUtil.getSync('third_party_api_key');
if (apiKey) {
  console.log('获取到的API密钥:', apiKey);
}
删除资产（异步）
typescript
// 删除过期凭证（异步）
const removed = await AssetUtil.remove('expired_credential');
if (removed) {
  console.log('凭证已删除');
}
API 参考
canIUse(): boolean
检查当前设备是否支持安全资产模块

typescript
const supported = AssetUtil.canIUse();
console.log(`设备支持状态: ${supported}`);
添加资产
add(key: string, value: string, persistent?: boolean): Promise<boolean>
异步添加资产

参数：

key: 资产别名（唯一标识）

value: 资产明文值

persistent: 是否持久化（应用卸载后保留，默认 true）

返回：操作是否成功（Promise）

addSync(key: string, value: string, persistent?: boolean): boolean
同步添加资产

获取资产
get(key: string): Promise<string>
异步获取资产

参数：

key: 资产别名

返回：资产明文值（Promise）

getSync(key: string): string
同步获取资产

删除资产
remove(key: string): Promise<boolean>
异步删除资产

参数：

key: 资产别名

返回：操作是否成功（Promise）

removeSync(key: string): boolean
同步删除资产

错误处理
所有操作都会自动捕获异常并返回安全值：

添加/删除失败时返回 false

获取失败时返回空字符串 ''

错误详情会通过 LogUtil 输出到日志系统：

text
[ERROR] AssetStore-get-异常 ~ code: 401 -·- message: Alias not found
最佳实践
敏感数据处理：仅用于存储真正敏感的少量数据

别名设计：使用有意义的别名并建立命名规范

错误处理：总是检查操作返回值

数据清理：不再需要的资产及时删除

兼容性检查：关键操作前使用 canIUse() 检查支持性

typescript
// 安全存储示例
async function storeUserCredentials(userId: string, token: string) {
  if (!AssetUtil.canIUse()) {
    console.error('设备不支持安全存储');
    return;
  }
  
  const alias = `user_${userId}_token`;
  const stored = await AssetUtil.add(alias, token);
  
  if (stored) {
    console.log('凭证安全存储完成');
  } else {
    console.error('凭证存储失败');
  }
}
注意事项
当前版本默认启用持久化存储（应用卸载后保留）

资产大小限制：建议存储不超过 1KB 的数据

性能影响：同步操作会阻塞主线程，敏感操作建议使用异步方式

设备兼容性：依赖系统安全能力，部分旧设备可能不支持

实现说明
数据编码：使用 TextEncoder/TextDecoder 进行 UTF-8 编码转换

冲突解决：采用 OVERWRITE 策略（存在同名资产时覆盖）

同步策略：设置为 THIS_DEVICE（仅限本设备访问）

依赖项
@kit.AssetStoreKit: 安全资产存储核心模块

@kit.BasicServicesKit: 基础服务（错误处理）

@kit.ArkTS: 运行时工具（文本编码）

zcommon/LogUtil: 日志工具（可替换为其他日志实现）

注意：实际使用前请确保所有依赖包已正确安装和配置
