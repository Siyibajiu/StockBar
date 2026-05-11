# StockBar

一款 macOS 菜单栏股票监控工具，伪装成系统监控界面，保护隐私。

## 功能

- **实时行情** — 接入新浪财经 API，交易时间每 3 秒自动刷新
- **三种可视化** — 音量条、热力图、柱状图，每只股票可独立设置
- **持仓管理** — 设置成本价和股数，悬浮显示当日涨跌额和持仓盈亏
- **自定义命名** — 给股票起别名，隐藏真实名称
- **隐私模式** — 一键关闭红绿涨跌色，全部显示为黑色
- **灵活布局** — 支持拖拽排序、合并行、拆分行，柱状图最多一行三个
- **自定义图标** — 支持 DMG 安装包导出

## 截图

> 菜单栏常驻显示，点击展开完整面板

## 构建

```bash
# 克隆项目
git clone https://github.com/Siyibajiu/StockBar.git
cd StockBar

# 用 Xcode 打开
open StockBar.xcodeproj

# 或命令行编译 Release
xcodebuild -scheme StockBar -configuration Release build
```

## 导出 DMG

```bash
xcodebuild -scheme StockBar -configuration Release clean build CONFIGURATION_BUILD_DIR=/tmp/StockBar-build
hdiutil create -volname "StockBar" -srcfolder /tmp/StockBar-build/StockBar.app -ov -format UDZO ~/Desktop/StockBar.dmg
```

## 数据存储

配置数据保存在 `~/Library/Preferences/com.stockbar.app.plist`，删除即恢复默认。

## 系统要求

- macOS 14.0+
- Xcode 16.0+
- Swift 5.9+

## License

MIT
