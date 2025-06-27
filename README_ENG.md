AssetUtil is a security storage utility based on HarmonyOS AssetStoreKit, designed for securely storing, retrieving, and managing sensitive data (such as keys, credentials, etc.). It provides simple APIs for operating encrypted assets with support for both synchronous and asynchronous modes.
Features
✅ Secure Storage: Protects sensitive data using system-level encryption

⚡ Sync/Async Operations: Supports both synchronous and asynchronous methods

🔍 Device Compatibility Check: Automatically detects device support

🛡️ Conflict Handling: Built-in overwrite conflict resolution

📦 Persistence Support: Optional persistent storage (enabled by default)

Quick Start
Import Utility Class
typescript
import { AssetUtil } from ‘./AssetUtil’;
Store Critical Asset (Async)
typescript
// Store access token (async)
const success = await AssetUtil.add(‘api_access_token’, ‘your_token_here’);
if (success) {
console.log(‘Token stored successfully’);
}
Retrieve Critical Asset (Sync)
typescript
// Get API key (sync)
const apiKey = AssetUtil.getSync(‘third_party_api_key’);
if (apiKey) {
console.log(‘Retrieved API key:’, apiKey);
}
Delete Asset (Async)
typescript
// Delete expired credential (async)
const removed = await AssetUtil.remove(‘expired_credential’);
if (removed) {
console.log(‘Credential deleted’);
}
API Reference
canIUse(): boolean
Check device support for secure asset module

typescript
const supported = AssetUtil.canIUse();
console.log(`Device support status: ${supported}`);
Add Assets
add(key: string, value: string, persistent?: boolean): Promise<boolean>
Add asset asynchronously

Parameters:

key: Asset alias (unique identifier)

value: Plaintext value

persistent: Whether to persist after app uninstall (default true)

Returns: Operation success status (Promise)

addSync(key: string, value: string, persistent?: boolean): boolean
Add asset synchronously

Retrieve Assets
get(key: string): Promise<string>
Retrieve asset asynchronously

Parameters:

key: Asset alias

Returns: Asset plaintext value (Promise)

getSync(key: string): string
Retrieve asset synchronously

Delete Assets
remove(key: string): Promise<boolean>
Delete asset asynchronously

Parameters:

key: Asset alias

Returns: Operation success status (Promise)

removeSync(key: string): boolean
Delete asset synchronously

Error Handling
All operations automatically catch exceptions and return safe values:

Add/remove failures return false

Get failures return empty string ‘’

Error details are logged via LogUtil:

text
[ERROR] AssetStore-get-Exception ~ code: 401 -·- message: Alias not found
Best Practices
Sensitive Data Handling: Only for truly sensitive small data

Alias Design: Use meaningful aliases with naming conventions

Error Handling: Always check operation return values

Data Cleanup: Delete unnecessary assets promptly

Compatibility Check: Use canIUse() before critical operations

typescript
// Secure storage example
async function storeUserCredentials(userId: string, token: string) {
if (!AssetUtil.canIUse()) {
console.error(‘Device does not support secure storage’);
return;
}

const alias = `user_${userId}_token`;
const stored = await AssetUtil.add(alias, token);

if (stored) {
console.log(‘Credentials securely stored’);
} else {
console.error(‘Credential storage failed’);
}
}
Important Notes
Persistence enabled by default (retains after app uninstall)

Size limit: Recommended max 1KB per asset

Performance: Sync operations block main thread — prefer async

Device Compatibility: Depends on system security capabilities

Implementation Details
Data Encoding: Uses TextEncoder/TextDecoder for UTF-8 conversion

Conflict Resolution: Uses OVERWRITE strategy (overwrites existing assets)

Sync Policy: Set to THIS_DEVICE (local device access only)

Dependencies
@kit.AssetStoreKit: Core secure asset storage

@kit.BasicServicesKit: Basic services (error handling)

@kit.ArkTS: Runtime utilities (text encoding)

zcommon/LogUtil: Logging utility (replaceable)

Note: Ensure all dependencies are properly installed and configured before use
