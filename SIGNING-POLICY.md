# Code signing policy

**Windows、macOS 与 Linux 产物未做代码签名**；Android 使用 CI 注入的自有密钥库签名，仓库中不含任何密钥材料。

## 当前签名状态

| 平台 | 状态 | 说明 |
|---|---|---|
| Android | 条件签名 | 提供 `KEYSTORE`、`KEY_ALIAS`、`STORE_PASSWORD`、`KEY_PASSWORD` 时使用发布密钥库；未提供时回退 debug 签名，包名附加 `.dev` 后缀 |
| Windows | **未签名** | CI 直接产出未签名二进制与安装器 |
| macOS | **未签名** | CI 产出未签名 `.app` 与 `.dmg` |
| Linux | **未签名** | deb / rpm / AppImage 均未签名 |

Windows 未签名的后果：首次运行 `setup.exe` 或主程序时，SmartScreen 可能提示「Windows 已保护你的电脑」，需点「更多信息 → 仍要运行」；若系统开启了**智能应用控制**，未签名程序可能被直接拦截，需在「Windows 安全中心 → 应用和浏览器控制 → 智能应用控制」中关闭后才能运行。关闭智能应用控制后无法在不重装系统的前提下重新开启，请自行权衡。

## Team roles

| Role | Members |
|---|---|
| Committers and reviewers | ipevel |

变更通过拉取请求提交，合并前运行 `.github/workflows/pr.yaml` 的 `analyze-test` 检查。当前 `main` 分支尚未启用强制分支保护，是否合并由维护者依据检查结果确认。仓库管理员账号已启用多因素认证。

## Privacy policy

本程序不会向其他网络系统传输任何信息，除非用户或安装、运行本程序的人明确要求。具体而言：

- **代理流量**只发往用户配置的节点，并遵循用户自己的规则。
- **订阅与备份请求**只发往用户填写的地址。
- **延迟测试与 IP 质量检测**仅在用户主动触发时访问公共第三方接口（`api.ip.sb`、`ipinfo.io`、`www.cloudflare.com/cdn-cgi/trace` 等）。
- **更新检查**请求 `https://github.com/ipevel/ErClash/releases/latest`，是一次不携带设备或用户信息的普通 HTTPS GET；自动检查可在设置中关闭。
- 发布版本中**没有启用遥测、分析或崩溃上报**。
- 不收集、不上传账号、设备标识或使用数据。

## 产物

| 产物 | 说明 |
|---|---|
| `ErClash.exe` | 界面（用户态） |
| `ErClashCore.exe` | 代理内核（Mihomo） |
| `ErClashHelperService.exe` | SYSTEM 提权服务 |
| `EnableLoopback.exe` | UWP 回环豁免工具 |
| `ErClash-<version>-windows-<arch>-setup.exe` | Inno Setup 安装器 |

以上产物**均未做代码签名**，由 CI 直接构建产出。

**完整性校验（非签名）**：提权服务在启动内核前校验 `ErClashCore.exe` 的 SHA256，该值与构建时写入的白名单一致才允许启动，因此服务只会拉起随包发布的内核；这不是数字签名，不能替代操作系统层面的签名信任。

## Android

- 发布构建从 CI secrets 注入自有密钥库（`android/app/keystore.jks` 与 `android/local.properties`），仓库内不含密钥。
- 未注入密钥库时，构建回退到 debug 签名，并给包名附加 `.dev` 后缀，避免与发布包混淆。
- CI 未配置 secrets 时不产出可发布的签名包。

### Required secrets

| Secret | 用途 |
|---|---|
| `KEYSTORE` | 密钥库文件的 base64 内容 |
| `KEY_ALIAS` | 密钥别名 |
| `STORE_PASSWORD` | 密钥库口令 |
| `KEY_PASSWORD` | 密钥口令 |
