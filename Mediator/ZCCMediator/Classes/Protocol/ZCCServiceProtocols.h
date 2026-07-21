//
//  ZCCServiceProtocols.h
//  ZCCMediator
//
//  业务服务协议汇总 — 由 Mediator 层定义，各业务模块实现。
//  所有跨模块通信仅依赖这些协议，不依赖具体实现。
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// ──────────────────────────────────────────
// 订单状态
// ──────────────────────────────────────────
typedef NS_ENUM(NSInteger, ZCCOrderState) {
    ZCCOrderStateCreating      = 11,  // 创建中
    ZCCOrderStateWaitPay       = 21,  // 待付款
    ZCCOrderStateWaitFinalPay  = 22,  // 待付尾款
    ZCCOrderStateFinalPaid     = 23,  // 已付尾款（待确认）
    ZCCOrderStatePaid          = 31,  // 已付款
    ZCCOrderStateCompleted     = 41,  // 已完成 ← 可签合同
    ZCCOrderStateCanceled      = 51,  // 已取消
    ZCCOrderStateRefunding     = 61,  // 退款中
    ZCCOrderStateRefundingFirst= 62,  // 退款中（首款）
    ZCCOrderStateRefunded      = 71,  // 已退款
    ZCCOrderStateRefundedFirst = 72,  // 已退首款
};

// ──────────────────────────────────────────
// 合同状态
// ──────────────────────────────────────────
typedef NS_ENUM(NSInteger, ZCCContractState) {
    ZCCContractStateBackup        = 0,   // 备用
    ZCCContractStateWaitGen       = 1,   // 待生成
    ZCCContractStateGenerated     = 10,  // 已生成
    ZCCContractStateWaitSign      = 15,  // 待签署
    ZCCContractStateSigning       = 20,  // 签订中
    ZCCContractStateSigned        = 30,  // 已签订 ← 可办证
    ZCCContractStateEffective     = 40,  // 生效中 ← 可办证
    // 失效状态
    ZCCContractStateWaitGenInvalid   = -1,   // 待生成→已失效
    ZCCContractStateGeneratedInvalid = -10,  // 已生成→已失效
    ZCCContractStateSigningInvalid   = -20,  // 签订中→已失效
    ZCCContractStateSignedInvalid    = -30,  // 已签订→已失效
    ZCCContractStateEffectiveInvalid = -40,  // 生效中→已失效
};

// ──────────────────────────────────────────
// 办证状态
// ──────────────────────────────────────────
typedef NS_ENUM(NSInteger, ZCCCertState) {
    ZCCCertStateDraft          = 11,  // 草稿
    ZCCCertStateResubmit       = 12,  // 待重复提交
    ZCCCertStateWaitPay        = 21,  // 待支付
    ZCCCertStateWaitAudit      = 31,  // 待审核
    ZCCCertStateAuthing        = 41,  // 认证中
    ZCCCertStateAuthDone       = 51,  // 认证完成
    ZCCCertStateAuthFailed     = 52,  // 认证失败
    ZCCCertStateAuthExpired    = 61,  // 认证过期
};

// ──────────────────────────────────────────
// 按钮 UI 状态（资产模块内部使用）
// ──────────────────────────────────────────
typedef NS_ENUM(NSInteger, ZCCButtonUIState) {
    ZCCButtonUIStateNormal   = 0,   // 可点击
    ZCCButtonUIStateDisabled = -1,  // 不可点击（前置条件不满足）
    ZCCButtonUIStateDone     = 1,   // 已完成
    ZCCButtonUIStatePending  = 2,   // 处理中
};

// ──────────────────────────────────────────
// 通用数据模型
// ──────────────────────────────────────────

@interface ZCCSellerInfo : NSObject
@property (nonatomic, copy) NSString *sellerId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *company;
@end

@interface ZCCProductDetailData : NSObject
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) double marketPrice;
@property (nonatomic, copy) NSString *priceUnit;
@property (nonatomic, copy) NSArray<NSString *> *bannerImages;
@property (nonatomic, strong) ZCCSellerInfo *sellerInfo;
@property (nonatomic, copy) NSString *detailHTML;
@property (nonatomic, copy) NSDictionary *detailParams;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@end

@interface ZCCTreeTraceNode : NSObject
@property (nonatomic, copy) NSString *nodeId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *nodeDescription;
@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, copy) NSString *imageUrl;
@end

/// 按钮最终展示信息（由资产模块统一计算后使用）
@interface ZCCButtonStateInfo : NSObject
@property (nonatomic, assign) ZCCButtonUIState state;
@property (nonatomic, copy) NSString *stateText;
@property (nonatomic, copy) NSString *colorHex;
@property (nonatomic, assign) BOOL clickable;
@end

// ──────────────────────────────────────────
// 商品模块服务协议
// ──────────────────────────────────────────
@protocol ZCCProductServiceProtocol <NSObject>
- (NSString *)getProductName:(NSString *)productId;
- (ZCCProductDetailData *)getProductDetail:(NSString *)productId;
- (UIViewController *)productDetailViewController:(NSString *)productId;
- (UIViewController *)productListViewController;
- (NSArray<ZCCTreeTraceNode *> *)getTreeTraceNodes:(NSString *)productId;
/// 获取林木参数卡片视图 ← 嵌入资产详情页
- (UIView *)productDetailCardForProduct:(NSString *)productId frame:(CGRect)frame;
/// 获取林木溯源时间线卡片视图 ← 嵌入资产详情页
- (UIView *)productTraceCardForProduct:(NSString *)productId frame:(CGRect)frame;
/// 参数卡片高度
- (CGFloat)productDetailCardHeight:(NSString *)productId;
/// 溯源卡片高度
- (CGFloat)productTraceCardHeight:(NSString *)productId;
@end

// ──────────────────────────────────────────
// 权益模块服务协议
// ──────────────────────────────────────────
@protocol ZCCBenefitServiceProtocol <NSObject>
- (NSArray<NSDictionary *> *)getCurrentBenefits;
- (NSArray<NSDictionary *> *)getBenefitsForProduct:(NSString *)productId;
- (UIViewController *)benefitDetailViewController:(NSString *)benefitId;
- (UIViewController *)benefitListViewController;
- (UIView *)benefitViewForProduct:(NSString *)productId frame:(CGRect)frame;
@end

// ──────────────────────────────────────────
// 资产模块服务协议
// ──────────────────────────────────────────
@protocol ZCCAssetServiceProtocol <NSObject>
- (double)getTotalAssets;
- (UIViewController *)assetDetailViewController:(NSString *)assetId;
- (UIViewController *)assetListViewController;
@end

// ──────────────────────────────────────────
// 订单模块服务协议 — 返回原始状态码
// ──────────────────────────────────────────
@protocol ZCCOrderServiceProtocol <NSObject>

/// 获取订单原始状态码
- (ZCCOrderState)getOrderState:(NSString *)productId;
/// 获取订单状态的可读文字
- (NSString *)orderStateName:(ZCCOrderState)state;
/// 跳转订单详情
- (void)showOrderDetailForProduct:(NSString *)productId
             navigationController:(UINavigationController *)nav;

@end

// ──────────────────────────────────────────
// 合同模块服务协议 — 返回原始状态码
// ──────────────────────────────────────────
@protocol ZCCContractServiceProtocol <NSObject>

/// 获取合同原始状态码
- (ZCCContractState)getContractState:(NSString *)productId;
/// 获取合同状态的可读文字
- (NSString *)contractStateName:(ZCCContractState)state;
/// 跳转合同页面
- (void)showContractForProduct:(NSString *)productId
          navigationController:(UINavigationController *)nav;

@end

// ──────────────────────────────────────────
// 办证模块服务协议 — 返回原始状态码
// ──────────────────────────────────────────
@protocol ZCCCertificateServiceProtocol <NSObject>

/// 获取办证原始状态码
- (ZCCCertState)getCertificateState:(NSString *)productId;
/// 获取办证状态的可读文字
- (NSString *)certificateStateName:(ZCCCertState)state;
/// 跳转办证页面
- (void)showCertificateForProduct:(NSString *)productId
             navigationController:(UINavigationController *)nav;

@end

NS_ASSUME_NONNULL_END
