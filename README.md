# ⚡ ErClash

**ErClash 是一款多平台代理客户端（Android + Windows + macOS + Linux），以 Flutter 构建界面，以 Mihomo（Clash.Meta）作为内核。**

> 许可证：GPL-3.0

## 定位

ErClash 把界面、内核与提权操作分开：界面只做用户交互，内核负责代理与分流，需要特权的动作交给独立服务。四端共用同一套 Flutter 界面与配置模型，行为保持一致。

- **四端统一**：Android、Windows、macOS、Linux 共用一套界面与数据模型
- **内核**：Mihomo（Clash.Meta），支持 TUN、系统代理、DNS、规则分流与脚本扩展
- **提权隔离**：Windows 以 SYSTEM 服务、Linux 以 root helper 承担特权操作，界面进程保持用户态
- **可审计**：完整源码随发行版提供，发布版本不含遥测、分析或崩溃上报

## 核心特性

* **开箱即用**：内置订阅导入、配置切换与规则集资源，首次启动即可接管流量。
* **规则分流**：可视化编辑代理组、规则与 DNS，支持 YAML 直接编辑与脚本扩展。
* **可观测**：连接明细、DNS 查询记录、实时速率与 IP 质量检测集中在一个界面。
* **桌面集成**：系统托盘、全局快捷键、开机自启与系统代理接管。
* **移动端优化**：前台服务与磁贴控制、按应用分流、低功耗后台运行。
* **多语言**：简体中文、英文、日文、韩文、俄文、法文、西班牙文。

## 架构

| 层 | 技术 |
|---|---|
| UI | Flutter（Dart） |
| 内核 | Mihomo / Clash.Meta（Go，源码位于 `core/Clash.Meta`） |
| 提权服务 | Rust（`services/helper`：Windows SCM 服务、Linux systemd 单元） |
| Android 宿主 | Kotlin + JNI（Go 内核以 C 共享库加载） |

桌面端由界面进程拉起独立的内核进程，双方通过内核的 `external-controller` 通信；Android 端内核运行在应用进程内，经 JNI 调用。Windows 提权服务以 SYSTEM 身份常驻并监听 `127.0.0.1:47890`，只接受本机请求；拉起内核前会校验内核二进制的 SHA-256，与构建时写入的值一致才放行。

## Code signing policy

Android 使用 CI 注入的自有密钥库签名；Windows、macOS 与 Linux 产物未做代码签名，首次运行可能被 SmartScreen 或智能应用控制拦截。签名范围、完整性校验、团队角色与隐私说明见 [SIGNING-POLICY.md](SIGNING-POLICY.md)。

## 致谢

- **[Mihomo / Clash.Meta](https://github.com/MetaCubeX/mihomo)** — 内核
- **[FlClash](https://github.com/chen08209/FlClash)** — 本项目的界面与桌面实现来自 FlClash 的代码，原始版权归其作者所有

本项目遵循 GPL-3.0 发布，源代码与二进制一并提供。

## 开发

```bash
# 依赖
flutter pub get

# 静态分析 / 测试
flutter analyze
flutter test

# 构建
dart setup.dart android --arch arm64
dart setup.dart windows
```

Go 内核与 Rust 提权服务由构建钩子在 `flutter build` / `flutter test` 时自动编译，需要本机具备 Go 与 Rust 工具链。CI 见 `.github/workflows/build.yaml`。
