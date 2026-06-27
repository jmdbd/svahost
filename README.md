# svahost

> 基于 RustDesk 1.4.8 的企业级远程桌面解决方案

svahost 是基于开源项目 [RustDesk](https://github.com/rustdesk/rustdesk) 1.4.8 的企业定制版本，由 vlanl 团队维护。开箱即用，无需配置，数据自主可控。

---

## 与 RustDesk 的差异

### 企业定制功能

| 功能 | 说明 | 实现位置 |
|------|------|----------|
| Repository Secrets 注入 | 通过 GitHub Actions secrets 编译期注入服务器地址、公钥、默认密码等 | `libs/hbb_common/build.rs` + `config.rs` |
| 隐藏 CM 管理窗口 | 支持 `allow-hide-cm` 选项隐藏远程连接确认窗口 | `src/ui/cm.tis` |
| 隐藏托盘图标 | 支持 `hide-tray` 选项完全隐藏系统托盘图标 | `src/tray.rs` |
| PIN 设置锁 | 主窗口支持 PIN 码锁定，防止未授权操作 | `src/ui/index.tis` + `src/ipc.rs` |
| 解锁画质 & FPS | 画质范围 10–4095，FPS 范围 5–120（原限制 10–100 / 5–30） | `src/client.rs` |
| APP_NAME 动态化 | 全平台使用动态 APP_NAME，避免硬编码 "RustDesk" | `src/platform/windows.rs` + `src/plugin/mod.rs` |
| 默认配置优化 | 自动更新、直连、静音 默认勾选 | `config.rs` |

### 品牌定制

| 项目 | 修改范围 |
|------|----------|
| 应用名称 | svahost（全平台） |
| 服务器地址 | `rs-ny.vlanl.com` |
| Windows 安装路径 | `Program Files\svahost\svahost.exe` |
| 语言文件 | 51 个语言文件全部 rebrand（RustDesk → svahost） |
| Android 包名 | `com.carriez.flutter_hbb` → `com.vlanl.svahost` |
| 深度链接 | `rustdesk://` 协议保留不改（保证现有链接兼容） |

### Flutter UI 增强

| 功能 | 说明 |
|------|------|
| 左侧连接面板 | ID 卡片（浅蓝背景）+ 密码卡片 + 远程 ID 输入框 + 2×2 按钮网格（传输文件/摄像头/终端/连接） |
| 绿色主题 | 按钮渐变 `#43A047→#2E7D32`，悬停边框绿色，远程 ID 聚焦绿色 |
| svahost 右侧面板 | 专属 Banner（绿色渐变 + 自然装饰动画）+ 设备列表 + 端到端加密安全提示 |
| 状态栏 | 左下角固定就绪状态指示（绿点 + 服务连接状态 + 每秒轮询） |
| 布局优化 | helpCards/pluginEntry/状态栏固定底部，不受滚动裁剪 |
| 暗黑模式 | 全界面（左栏/右栏/面板/分割线/输入框/按钮边框）适配暗黑主题 |

### 版本检查 & 自动更新

| 功能 | 说明 |
|------|------|
| 版本检查端点 | `https://XXXX.XXXX.com/up/XXXX/version/latest.php` |
| 动态文件名 | 下载文件前缀动态匹配 APP_NAME，支持 Android `.apk` |
| 更新提示 | Flutter 端移除 `isCustomClient()` 守卫，自定义客户端正常显示更新 |

### CI/CD

| 特性 | 说明 |
|------|------|
| 全平台构建 | Windows (x64/i686) + Linux (x64/aarch64/armv7) + macOS (x64/aarch64) + Android + iOS |
| Secrets 注入 | 6 个 env 变量通过 `option_env!` 编译期注入 |
| 产物命名 | 全部 `svahost-*` 格式 |
| 手动触发 | 支持 `workflow_dispatch` 手动触发构建 |

---

## 编译

### 环境要求

```bash
# Ubuntu/Debian
sudo apt-get install -y pkg-config libssl-dev libxdo-dev libx11-dev libxext-dev \
  libxcb-shape0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-image0-dev \
  libxcb-keysyms1 libxcb-util-dev libsodium-dev nasm libayatana-appindicator3-dev

# Windows: Visual Studio Build Tools 2022 + Rust (stable-msvc)
# macOS: brew install nasm libsodium
```

### 本地编译

```bash
# 1. 克隆
git clone --recurse-submodules https://github.com/vlanl/svahost.git
cd svahost

# 2. 编译 Rust 端
cargo build --release

# 3. 编译 Flutter 端（Windows 示例）
cd flutter && flutter build windows --release
```

> **注意**：本地编译时 `option_env!` 无法读取 CI secrets，会回退到 `config.rs` 中的 fallback 值（`rs-ny.vlanl.com` / `svahost`）。

### 子模块

```
vlanl/svahost (master)
├── libs/hbb_common → vlanl/hbb_common (main)
│   └── 包含 build.rs secrets 注入 + config.rs 默认配置 + config.rs 中文注释
├── flutter/         → Flutter 前端（含 svahost 专属 UI）
├── src/             → Rust 后端（含企业定制功能）
└── .github/         → CI 工作流
```

---

## 配置文件

### DEFAULT_SETTINGS 默认值

```toml
allow-auto-update = "Y"          # 允许自动更新
direct-server = "Y"              # 允许 IP 直接访问
disable_audio = "Y"              # 默认静音
approve-mode = "password"        # 密码批准模式
verification-method = "use-permanent-password"
allow-hide-cm = "Y"              # 允许隐藏 CM 窗口
hide-tray = "Y"                  # 隐藏托盘图标
unlock-pin = ""                  # PIN 锁（编译期可注入）
custom-rendezvous-server = "rs-ny.vlanl.com"
relay-server = "rs-ny.vlanl.com"
api-server = "https://xxxx.xxxx.com"
key = ""                         # 公钥（编译期可注入）
```

### 配置优先级

```
OVERWRITE_SETTINGS > CONFIG2.options > DEFAULT_SETTINGS
```

---

## GitHub Actions Secrets

| Secret | 说明 | 示例 |
|--------|------|------|
| `APP_NAME` | 应用名称 | `svahost` |
| `RENDEZVOUS_SERVER` | ID/中继服务器 | `rs-ny.vlanl.com` |
| `RELAY_SERVER` | 中继服务器 | `rs-ny.vlanl.com` |
| `API_SERVER` | API 服务器 | `https://xxxx.xxxx.com` |
| `RS_PUB_KEY` | 公钥 | base64 编码 |
| `DEFAULT_PASSWORD` | 默认连接密码 | 手动设置 |

---

## 暗黑模式适配

Flutter 界面完整支持暗黑模式，通过 `Theme.of(context).brightness == Brightness.dark` 检测：

| 元素 | 暗黑 | 亮色 |
|------|------|------|
| 页面背景 | `0xFF1E1E1E` | `Colors.white` |
| 卡片/面板 | `0xFF2A2A2A` | `Colors.white` |
| 分割线 | `0xFF3A3A3A` | `0xFFE0E0E0` |

---

## 常见问题

### 编译报错 `librustdesk.dll` not found

本地编译前需先运行 `flutter_rust_bridge_codegen` 生成 bridge 代码：

```bash
flutter_rust_bridge_codegen \
  --rust-input src/flutter_ffi.rs \
  --dart-output flutter/lib/generated_bridge.dart \
  --class-name svahost
```

### Windows 浅克隆无法推送

```bash
git fetch --unshallow
```

### 子模块同时存在同名分支和标签

推送时指定完整 ref：
```bash
git push origin refs/heads/main:refs/heads/main
```

---

## 开发规范

- **暗黑模式**：每个 Widget 方法内独立定义 `isDark`，不在类级别缓存
- **颜色**：硬编码 `Colors.white` 需改为 `isDark ? Color(0xFF...) : Colors.white`
- **CI**：修改 `src/` 或 `libs/` 下的非忽略文件自动触发构建
- **子模块**：修改子模块后需在主仓库 `git add libs/hbb_common` 更新指针
- **Rebrand**：GitHub 组织名 `rustdesk-org` 绝对不能替换（第三方 fork 依赖）

---

## 许可

svahost 基于 [RustDesk](https://github.com/rustdesk/rustdesk) 开发，遵循 AGPL-3.0 许可证。
