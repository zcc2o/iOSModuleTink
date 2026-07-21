//
//  ZCCProductTraceCard.h
//  ZCCProductModule
//
//  林木溯源时间线卡片 — 展示种植→浇水→施肥→测量等生长历程
//

#import <UIKit/UIKit.h>
#import <ZCCMediator/ZCCServiceProtocols.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCCProductTraceCard : UIView

/// 传入溯源节点数组，自动渲染时间线
@property (nonatomic, copy) NSArray<ZCCTreeTraceNode *> *traceNodes;

/// 当前高度（根据节点数量动态计算）
+ (CGFloat)heightForNodes:(NSArray<ZCCTreeTraceNode *> *)nodes;

@end

NS_ASSUME_NONNULL_END
