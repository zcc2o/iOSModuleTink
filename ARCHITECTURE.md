# 海南黄花梨 iOS 组件化架构演进

## 目录

1. [项目背景](#1-项目背景)
2. [第一阶段：三层架构搭建](#2-第一阶段三层架构搭建)
3. [第二阶段：资产详情页拆分](#3-第二阶段资产详情页拆分)
4. [第三阶段：跨组件通信与解耦](#4-第三阶段跨组件通信与解耦)
5. [第四阶段：状态管理下沉](#5-第四阶段状态管理下沉)
6. [第五阶段：编译加速与双模式切换](#6-第五阶段编译加速与双模式切换)
7. [第六阶段：Base/Standard 业务分层](#7-第六阶段basestandard-业务分层)
8. [扩展方案：EnterpriseAssetModule](#8-扩展方案enterpriseassetmodule)
9. [架构全景图](#9-架构全景图)

---

## 1. 项目背景

**业务**：海南黄花梨林木交易平台
**技术栈**：iOS Objective-C + CocoaPods 组件化
**参考项目**：`ogw-iOS_ModulePreciousWoodShop`

---

## 2. 第一阶段：三层架构搭建

从零搭建基础三层结构：Foundation → Mediator → Business。

```
┌─────────────────────────────────────────────────────┐
│                    MainApp (主工程)                   │
├─────────────────────────────────────────────────────┤
│  业务层 Business                                     │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐   │
│  │ ProductModule│ │BenefitModule│ │ AssetModule │   │
│  │ 商品模块      │ │ 权益模块     │ │ 资产模块     │   │
│  └─────────────┘ └─────────────┘ └─────────────┘   │
├─────────────────────────────────────────────────────┤
│  解耦层 Mediator                                     │
│  ┌─────────────────────────────────────────────┐   │
│  │            ZCCMediator (Bifrost 模式)        │   │
│  │  · 协议 → 实现 注册/查找                      │   │
│  │  · URL 路由 注册/分发                         │   │
│  │  · 模块生命周期管理                           │   │
│  └─────────────────────────────────────────────┘   │
├─────────────────────────────────────────────────────┤
│  基础层 Foundation                                   │
│  ┌──────────┐ ┌──────────┐ ┌──────────────┐       │
│  │UIComponent│ │WebComponent│ │ LogComponent │       │
│  │ UI 基类   │ │ Web 容器   │ │ 日志系统      │       │
│  └──────────┘ └──────────┘ └──────────────┘       │
└─────────────────────────────────────────────────────┘
```

**依赖方向**：MainApp → Business → Mediator → Foundation（单向，无循环）

每层职责：
- **Foundation**：纯工具，无业务语义
- **Mediator**：协议定义 + 服务注册/查找，不包含业务逻辑
- **Business**：具体业务实现，通过 Mediator 互相通信

---

## 3. 第二阶段：资产详情页拆分

资产详情页（ZCCAssetDetailVC）包含 9 张卡片。**核心原则：谁的数据谁负责 UI。**

### 3.1 拆分前 vs 拆分后

**拆分前**（所有代码在 VC 中）：
```
ZCCAssetDetailVC.m (~800 行)
├── Banner 轮播（内联实现）
├── 市场指导价（内联 UILabel）
├── 操作按钮 8 个（内联 UIView + 手势）
├── 转卖卡片（内联布局）
├── 林木参数（内联循环 UILabel）
├── Web 详情（内联 WKWebView）
├── 权益列表（内联 UIView）
└── 林木溯源时间线（内联循环）
```

**拆分后**（VC 只做调度，各组件负责 UI + 数据）：

```
ZCCAssetDetailVC.m (~100 行)
│
├── Card1 Banner ──────────→ ZCCUIComponent/ZCCBannerView
├── Card2 市场指导价 ───────→ VC 内联（简单 UI，数据来自 ProductService）
├── Card3 操作按钮 ─────────→ ZCCAssetModule/ZCCAssetActionCard（自有实现）
├── Card4 转卖 ────────────→ ZCCAssetModule/ZCCResaleCardView（自有实现）
├── Card5 林木参数 ─────────→ ZCCProductModule/ZCCProductDetailCard ✓
├── Card6 地图 ────────────→ （占位，后续接第三方地图 SDK）
├── Card7 Web 详情 ─────────→ ZCCWebComponent/ZCCWebViewController ✓
├── Card8 权益 ────────────→ ZCCBenefitModule/benefitViewForProduct ✓
└── Card9 林木溯源 ─────────→ ZCCProductModule/ZCCProductTraceCard ✓
```

### 3.2 为什么 Card5/Card9 要移到 ProductModule？

```
┌───────────────────────────────────────────────────┐
│  错误做法：AssetDetailVC 里拼 Product 的 UI        │
│                                                     │
│  AssetDetailVC                                     │
│  ┌─────────────────────────────────────┐           │
│  │ Card5: for (key in product.params) { │           │
│  │   ...创建 UILabel...                 │  ← 耦合！  │
│  │ }                                    │           │
│  └─────────────────────────────────────┘           │
│                                                     │
│  问题：                                             │
│  · Asset 模块需要知道 Product 的数据结构             │
│  · Product 改字段 → Asset 也要改                     │
│  · 无法复用（其他页面也需要参数卡片时）              │
└───────────────────────────────────────────────────┘

┌───────────────────────────────────────────────────┐
│  正确做法：ProductModule 提供完整 UI                │
│                                                     │
│  ProductService                                    │
│  ┌─────────────────────────────────────┐           │
│  │ - (UIView *)productDetailCard:      │           │
│  │     frame:(CGRect)frame;            │           │
│  │                                      │           │
│  │ 内部：ZCCProductDetailCard           │           │
│  │ ┌───────────────────────────────┐   │           │
│  │ │ 林木参数                       │   │           │
│  │ │ 品种: 降香黄檀                  │   │           │
│  │ │ 树龄: 15年                     │   │           │
│  │ └───────────────────────────────┘   │           │
│  └─────────────────────────────────────┘           │
│                                                     │
│  AssetDetailVC 只需要：                              │
│  UIView *card = [productService                    │
│      productDetailCardForProduct:id                 │
│      frame:frame];                                  │
│  [wrapper addSubview:card];  ← 一行搞定             │
└───────────────────────────────────────────────────┘
```

---

## 4. 第三阶段：跨组件通信与解耦

### 4.1 Mediator 核心机制

```
┌─────────────────────────────────────────────────────────┐
│                     ZCCMediator                          │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │  服务注册表                                       │   │
│  │                                                  │   │
│  │  @protocol(ZCCProductServiceProtocol) → ProductService │
│  │  @protocol(ZCCBenefitServiceProtocol) → BenefitService │
│  │  @protocol(ZCCOrderServiceProtocol)    → OrderService  │
│  │  @protocol(ZCCContractServiceProtocol) → ContractService│
│  │  @protocol(ZCCCertificateServiceProtocol)→CertService  │
│  │                                                  │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │  URL 路由表                                      │   │
│  │                                                  │   │
│  │  "asset"    → AssetDetailVC                       │   │
│  │  "product"  → ProductDetailVC / ProductListVC     │   │
│  │  "benefit"  → BenefitDetailVC                     │   │
│  │                                                  │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

### 4.2 跨组件调用流程

以"资产详情页点击"使用权益兑换"按钮 → 跳转到权益列表"为例：

```
┌──────────────┐  ① 用户点击   ┌──────────────────────┐
│   UIButton    │──────────────→│ ZCCAssetActionCard    │
│ "使用权益兑换" │               │ (AssetModule 的 View) │
└──────────────┘               └──────────┬───────────┘
                                          │ ② delegate 回调
                                          ▼
                               ┌──────────────────────┐
                               │  ZCCAssetDetailVC     │
                               │  (AssetModule 的 VC)  │
                               └──────────┬───────────┘
                                          │ ③ 通过 Mediator 获取
                                          │ [[ZCCMediator sharedInstance]
                                          │     benefitService]
                                          ▼
                               ┌──────────────────────┐
                               │    ZCCMediator        │
                               │  查找协议对应的实现    │
                               └──────────┬───────────┘
                                          │ ④ 返回服务实例
                                          ▼
┌──────────────────────────────────────────────────────┐
│  id<ZCCBenefitServiceProtocol> svc =                 │
│      [mediator benefitService];                       │
│                                                       │
│  UIViewController *vc =                               │
│      [svc benefitListViewController];  ← Benefit 模块 │
│                                                       │
│  [self.navigationController pushViewController:vc     │
│      animated:YES];                                   │
└──────────────────────────────────────────────────────┘
```

**Asset 模块不 import Benefit 模块的任何头文件**。全程通过协议通信。

### 4.3 协议定义位置

```
ZCCServiceProtocols.h (在 ZCCMediator 中)
│
├── @protocol ZCCProductServiceProtocol    ← ProductModule 实现
│   ├── getProductDetail: → ZCCProductDetailData
│   ├── productDetailCardForProduct:frame: → UIView (Card5)
│   └── productTraceCardForProduct:frame: → UIView (Card9)
│
├── @protocol ZCCBenefitServiceProtocol    ← BenefitModule 实现
│   ├── getBenefitsForProduct: → NSArray
│   └── benefitViewForProduct:frame: → UIView (Card8)
│
├── @protocol ZCCOrderServiceProtocol      ← OrderModule 实现
│   ├── getOrderState: → ZCCOrderState
│   ├── orderStateName: → NSString
│   └── showOrderDetailForProduct:nav:
│
├── @protocol ZCCContractServiceProtocol   ← ContractModule 实现
│   └── getContractState: → ZCCContractState
│
└── @protocol ZCCCertificateServiceProtocol ← CertModule 实现
    └── getCertificateState: → ZCCCertState
```

---

## 5. 第四阶段：状态管理下沉

### 5.1 问题

操作按钮（订单/合同/办证）有级联依赖：订单完成 → 合同可签 → 合同签署 → 办证可办。这个逻辑最初写在 VC 中：

```objc
// ❌ VC 中的 ~100 行业务逻辑
- (void)computeButtonStates {
    if (orderState == 41) {
        if (contractState >= 30) {
            // ...
        }
    }
}
```

### 5.2 提取到 Model

```
┌─────────────────────────────────────────────────────┐
│  ZCCAssetStateModel (纯数据模型，无 UI 依赖)         │
│                                                     │
│  ┌─────────────────────────────────────────────┐   │
│  │ 输入：三个原始状态码                           │   │
│  │  · orderState    = ZCCOrderStateCompleted    │   │
│  │  · contractState = ZCCContractStateSigned    │   │
│  │  · certState     = ZCCCertStateAuthing       │   │
│  └─────────────────────────────────────────────┘   │
│                      │                              │
│                      ▼                              │
│  ┌─────────────────────────────────────────────┐   │
│  │  级联规则计算                                 │   │
│  │                                              │   │
│  │  computeOrder()                              │   │
│  │    → 始终可点击，显示状态文字                  │   │
│  │                                              │   │
│  │  computeContract()                           │   │
│  │    → if orderState == 41                     │   │
│  │        → 显示合同状态，可点击                  │   │
│  │      else                                    │   │
│  │        → "请先完成订单" 禁用                   │   │
│  │                                              │   │
│  │  computeCert()                               │   │
│  │    → if orderState == 41                     │   │
│  │        if contractState >= 30                 │   │
│  │          → 显示办证状态，可点击                │   │
│  │        else                                  │   │
│  │          → "请先签署合同" 禁用                  │   │
│  └─────────────────────────────────────────────┘   │
│                      │                              │
│                      ▼                              │
│  ┌─────────────────────────────────────────────┐   │
│  │  输出：三个按钮展示信息                        │   │
│  │  · orderButtonInfo    (text, color, clickable)│   │
│  │  · contractButtonInfo                        │   │
│  │  · certButtonInfo                            │   │
│  └─────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────┘
```

VC 中从 100 行变为：

```objc
self.stateModel = [[ZCCAssetStateModel alloc] init];
[self.stateModel updateWithOrderState:... contractState:... certState:...];
// 直接用 stateModel.orderButtonInfo 渲染
```

---

## 6. 第五阶段：编译加速与双模式切换

### 6.1 问题

Foundation 层变更频率极低，但每次 `pod install` 后都会重新编译所有 .m 文件。

### 6.2 方案：独立工程 + Podfile swap

每个 Foundation Pod 变成独立 Xcode 工程：

```
Foundation/ZCCLogComponent/
├── ZCCLogComponent.xcodeproj    ← 独立工程
├── project.yml                  ← xcodegen 描述
├── Classes/                     ← 源码（.m 不进主工程编译）
├── Binary/
│   └── ZCCLogComponent.framework  ← 编译产物
├── ZCCLogComponent_source.podspec
├── ZCCLogComponent_binary.podspec
└── ZCCLogComponent.podspec      ← Podfile 自动 copy 切换
```

```
Podfile 中的切换机制：

pod install               → cp _source.podspec → .podspec
                             (s.source_files = 'Classes/**/*.{h,m}')

USE_BINARY=1 pod install  → cp _binary.podspec → .podspec
                             (s.vendored_frameworks = 'Binary/XXX.framework')
```

```
编译流程：

 ./build_binary.sh
     │
     ├── xcodebuild ZCCLogComponent.xcodeproj  → Binary/ZCCLogComponent.framework
     ├── xcodebuild ZCCUIComponent.xcodeproj   → Binary/ZCCUIComponent.framework
     ├── xcodebuild ZCCWebComponent.xcodeproj  → Binary/ZCCWebComponent.framework
     └── xcodebuild ZCCBaseAssetModule.xcodeproj → Binary/ZCCBaseAssetModule.framework

 USE_BINARY=1 pod install  → 主工程直接链接 4 个 .framework，跳过源码编译
```

---

## 7. 第六阶段：Base/Standard 业务分层

### 7.1 问题

ZCCAssetModule 包含 VC + View + Model + Service + 大量 Helper 代码，编译越来越慢。但其中：
- Model/View/Service 变更极少（业务逻辑稳定后几乎不改）
- VC + Helper 频繁变更（页面调整、新增功能）

### 7.2 拆分方案

```
拆分前：
ZCCAssetModule (整体编译 ~30s)
├── VC/        ZCCAssetDetailVC, ZCCAssetListVC
├── View/      ZCCAssetActionCard, ZCCResaleCardView
├── Model/     ZCCAssetStateModel
├── Service/   ZCCAssetService
├── Module/    ZCCAssetModule
└── Helper/    ZCCAssetViewHelper_1~5 (模拟大型项目)

拆分后：
┌──────────────────────────────────────────────────────┐
│  ZCCAssetModule (Standard · 始终源码 · ~10s 编译)     │
│  ────────────────────────────────────────────────── │
│  · VC/       ZCCAssetDetailVC, ZCCAssetListVC        │
│  · Module/   ZCCAssetModule (注入 VC 工厂)           │
│  · Helper/   5 个 ViewHelper                          │
│                                                       │
│  ── 依赖 ──→                                         │
│              ┌──────────────────────────────────────┐ │
│              │ ZCCBaseAssetModule (Base)             │ │
│              │ · 支持 source/framework 切换          │ │
│              │ ─────────────────────────────────────│ │
│              │ · Model/   ZCCAssetStateModel         │ │
│              │ · View/    ZCCAssetActionCard         │ │
│              │ · View/    ZCCResaleCardView          │ │
│              │ · Service/ ZCCAssetService             │ │
│              └──────────────────────────────────────┘ │
└──────────────────────────────────────────────────────┘
```

### 7.3 VC 工厂注入（解决 Base → Standard 不能反向依赖）

```
在 ZCCAssetModule 注册时（didRegister），
Standard 层将 VC 创建逻辑注入到 Base 层的 Service：

┌─────────────────────────────────────────────────────┐
│  ZCCAssetModule.m (Standard)                        │
│                                                     │
│  - (void)moduleDidRegister {                        │
│      // 1. 注册服务                                  │
│      [mediator registerService:...                  │
│                    implClass:[ZCCAssetService class]]│
│                                                     │
│      // 2. 注入 VC 工厂 ← 关键一步                   │
│      ZCCAssetService *svc = [mediator assetService];│
│      svc.detailVCFactory = ^(NSString *aid) {       │
│          return [[ZCCAssetDetailVC alloc] init];     │
│      };    ↑                                        │
│  }          └── Standard 层 VC，Base 层不 import     │
└─────────────────────────────────────────────────────┘
```

---

## 8. 扩展方案：EnterpriseAssetModule

### 8.1 场景

企业版需要不同的资产详情页：企业信息、企业权益、批量资产管理等。但基础 UI 组件（ActionCard、ResaleCard）和状态模型可复用。

### 8.2 扩展架构

```
┌───────────────────────────────────────────────────────┐
│                  ZCCBaseAssetModule                    │
│  ┌─────────────────────────────────────────────────┐  │
│  │  可复用组件（不改动）                             │  │
│  │  · ZCCAssetActionCard (8 按钮卡片)               │  │
│  │  · ZCCResaleCardView  (转卖卡片)                 │  │
│  │  · ZCCAssetStateModel (状态转换模型)              │  │
│  │  · ZCCAssetService    (服务基类)                 │  │
│  └─────────────────────────────────────────────────┘  │
│           │                          │                │
│           ▼                          ▼                │
│  ┌──────────────────┐   ┌──────────────────────────┐  │
│  │ ZCCAssetModule   │   │ ZCCEnterpriseAssetModule  │  │
│  │ (个人版 Standard) │   │ (企业版 Standard · 新增)  │  │
│  │                  │   │                          │  │
│  │ · AssetDetailVC  │   │ · EnterpriseAssetListVC  │  │
│  │ · AssetListVC    │   │ · EnterpriseAssetDetailVC│  │
│  │ · ViewHelpers    │   │ · EnterpriseHelper       │  │
│  │                  │   │                          │  │
│  │ 注入:             │   │ 注入:                     │  │
│  │  detailVCFactory │   │  detailVCFactory         │  │
│  │  → AssetDetailVC │   │  → EnterpriseDetailVC    │  │
│  └──────────────────┘   └──────────────────────────┘  │
└───────────────────────────────────────────────────────┘

Podfile:

  pod 'ZCCBaseAssetModule', ...        ← Base（个人+企业共享）
  pod 'ZCCAssetModule', ...            ← 个人版 Standard
  pod 'ZCCEnterpriseAssetModule', ...  ← 企业版 Standard（新增）
```

### 8.3 新增 EnterpriseAssetModule 只需做什么

```
ZCCEnterpriseAssetModule/
├── Classes/
│   ├── VC/
│   │   ├── ZCCEnterpriseAssetDetailVC.h/m  ← 企业版资产详情页（不同卡片排列）
│   │   └── ZCCEnterpriseAssetListVC.h/m    ← 企业版资产列表
│   ├── Module/
│   │   └── ZCCEnterpriseAssetModule.h/m    ← 注册时注入不同 VC 工厂
│   └── Helper/
│       └── ...                              ← 企业版特有 Helper
│
│   无需重写：
│   ✗ ZCCAssetActionCard      (复用 Base)
│   ✗ ZCCResaleCardView       (复用 Base)
│   ✗ ZCCAssetStateModel      (复用 Base)
│   ✗ ZCCAssetService         (复用 Base，注入新工厂)
```

### 8.4 企业版注册时替换 VC 工厂

```objc
@implementation ZCCEnterpriseAssetModule

- (void)moduleDidRegister {
    // 同一套 Base Service，注入企业版 VC
    ZCCAssetService *svc = [[ZCCMediator sharedInstance] assetService];
    svc.detailVCFactory = ^(NSString *aid) {
        return [[ZCCEnterpriseAssetDetailVC alloc] init];  // 企业版 VC
    };
    svc.listVCFactory = ^(NSString *aid) {
        return [[ZCCEnterpriseAssetListVC alloc] init];
    };
}

@end
```

---

## 9. 架构全景图

```
┌─────────────────────────────────────────────────────────────────┐
│                         MainApp.xcworkspace                      │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │  MainApp                                                   │ │
│  │  · AppDelegate (注册所有模块到 Mediator)                   │ │
│  │  · MainViewController (首页入口)                           │ │
│  └───────────────────────────────────────────────────────────┘ │
│                              │                                  │
│  ┌───────────────────────────┼───────────────────────────────┐ │
│  │                    Business 业务层                         │ │
│  │                                                           │ │
│  │  ┌──────────────────────────────────────────────┐        │ │
│  │  │  Standard 层 (始终源码 · 高频变更)             │        │ │
│  │  │                                              │        │ │
│  │  │  ┌──────────────┐  ┌──────────────┐         │        │ │
│  │  │  │ AssetModule  │  │  Product/     │         │        │ │
│  │  │  │ (个人版)     │  │  Benefit/     │         │        │ │
│  │  │  │              │  │  Order/       │         │        │ │
│  │  │  │ · DetailVC   │  │  Contract/    │         │        │ │
│  │  │  │ · ListVC     │  │  Certificate  │         │        │ │
│  │  │  │ · 工厂注入   │  │  Module       │         │        │ │
│  │  │  └──────┬───────┘  └──────────────┘         │        │ │
│  │  └─────────┼───────────────────────────────────┘        │ │
│  │            │ 依赖                                        │ │
│  │  ┌─────────▼───────────────────────────────────┐        │ │
│  │  │  Base 层 (framework/源码 可切换)             │        │ │
│  │  │                                              │        │ │
│  │  │  ┌─────────────────────────────────┐        │ │ │
│  │  │  │  ZCCBaseAssetModule             │        │ │ │
│  │  │  │  · ZCCAssetActionCard           │        │ │ │
│  │  │  │  · ZCCResaleCardView            │        │ │ │
│  │  │  │  · ZCCAssetStateModel           │        │ │ │
│  │  │  │  · ZCCAssetService (VC 工厂)    │        │ │ │
│  │  │  └─────────────────────────────────┘        │ │ │
│  │  └────────────────────────────────────────────┘        │ │
│  └───────────────────────────────────────────────────────┘ │
│                              │                                  │
│  ┌───────────────────────────┼───────────────────────────────┐ │
│  │                    Mediator 解耦层                         │ │
│  │                                                           │ │
│  │  ┌─────────────────────────────────────────────────┐     │ │
│  │  │  ZCCMediator                                     │     │ │
│  │  │  · Protocol/  ZCCServiceProtocols.h (所有协议)    │     │ │
│  │  │  · Core/      ZCCMediator.h/m (注册/查找/路由)    │     │ │
│  │  │  · Core/      ZCCMediator+Business.h (分类)      │     │ │
│  │  │  · Define/    ZCCModuleDefines.h (常量)          │     │ │
│  │  └─────────────────────────────────────────────────┘     │ │
│  └───────────────────────────────────────────────────────┘ │ │
│                              │                                  │
│  ┌───────────────────────────┼───────────────────────────────┐ │
│  │                    Foundation 基础层                       │ │
│  │                                                           │ │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────────┐             │ │
│  │  │UIComponent│ │WebComponent│ │ LogComponent │             │ │
│  │  │          │ │          │ │              │             │ │
│  │  │ BannerView│ │WebViewCtrl│ │ Logger       │             │ │
│  │  │ BaseVC   │ │ JSBridge │ │ LogFormatter │             │ │
│  │  │ BaseNav  │ │          │ │              │             │ │
│  │  │ UIView+  │ │          │ │              │             │ │
│  │  └──────────┘ └──────────┘ └──────────────┘             │ │
│  │                                                           │ │
│  │  每个都有独立 .xcodeproj + source/framework 切换          │ │
│  └───────────────────────────────────────────────────────┘ │ │
└─────────────────────────────────────────────────────────────────┘
```

### 文件目录总览

```
ComponentizedApp/
├── Podfile                     ← USE_BINARY=1 切换
├── build_binary.sh             ← 一键编译 4 个 framework
│
├── MainApp/                    ← 主工程
│
├── Foundation/                 ← 基础层 (独立工程 + source/framework)
│   ├── ZCCUIComponent/
│   │   ├── ZCCUIComponent.xcodeproj
│   │   ├── Classes/{Base,View,Category}/
│   │   └── Binary/ZCCUIComponent.framework
│   ├── ZCCWebComponent/        ← 同上
│   └── ZCCLogComponent/        ← 同上
│
├── Mediator/ZCCMediator/       ← 协议 + 路由 (source 编译)
│   └── Classes/{Core,Protocol,Model,Define}/
│
└── Business/                   ← 业务层
    ├── ZCCBaseAssetModule/     ← Base (独立工程 + source/framework)
    │   ├── ZCCBaseAssetModule.xcodeproj
    │   ├── Classes/{Model,View,Service}/
    │   └── Binary/ZCCBaseAssetModule.framework
    │
    ├── ZCCAssetModule/         ← Standard 个人版 (始终源码)
    │   └── Classes/{VC,Module,Helper}/
    │
    ├── ZCCProductModule/       ← Standard
    │   └── Classes/{Module,Service,VC,View}/
    │
    ├── ZCCBenefitModule/       ← Standard
    ├── ZCCOrderModule/         ← 状态 + 跳转
    ├── ZCCContractModule/      ← 状态 + 跳转
    └── ZCCCertificateModule/   ← 状态 + 跳转
```

---

## 附录：关键设计决策

| 决策 | 理由 |
|------|------|
| 协议定义在 Mediator 而非各模块 | 避免模块间直接依赖，协议是"合同"，Mediator 是"公证处" |
| Base 层 Service 用 block 工厂而非 import VC | 依赖方向 Base ← Standard 不可行，block 注入解除循环依赖 |
| URL 路由 + 服务查找双通道 | URL 用于页面跳转（解耦 nav），服务查找用于数据/UI 获取 |
| Foundation 独立工程 + swap podspec | 避免 CocoaPods subspec 的重复链接问题，`:path` 最稳定 |
| Standard 层不设 framework 模式 | 高频变更层做 framework 需要频繁重编，得不偿失 |
