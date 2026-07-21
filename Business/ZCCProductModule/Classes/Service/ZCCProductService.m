//
//  ZCCProductService.m
//  ZCCProductModule
//

#import "ZCCProductService.h"
#import "ZCCProductListVC.h"
#import "ZCCProductDetailVC.h"
#import "ZCCProductDetailCard.h"
#import "ZCCProductTraceCard.h"

@implementation ZCCProductService

- (NSString *)getProductName:(NSString *)productId {
    return [NSString stringWithFormat:@"海南黄花梨-%@", productId];
}

- (ZCCProductDetailData *)getProductDetail:(NSString *)productId {
    ZCCProductDetailData *data = [[ZCCProductDetailData alloc] init];
    data.productId = productId;
    data.title = [NSString stringWithFormat:@"海南黄花梨(%@)", productId];
    data.subtitle = @"降香黄檀 · 树龄15年 · 胸径28cm";
    data.marketPrice = 188888.00;
    data.priceUnit = @"元";

    // Banner 图片
    data.bannerImages = @[
        @"https://example.com/wood_banner_1.jpg",
        @"https://example.com/wood_banner_2.jpg",
        @"https://example.com/wood_banner_3.jpg",
    ];

    // 卖家信息
    ZCCSellerInfo *seller = [[ZCCSellerInfo alloc] init];
    seller.sellerId = @"S001";
    seller.name = @"林先生";
    seller.avatarUrl = @"https://example.com/avatar_seller.jpg";
    seller.company = @"海南东方亿林苗木有限公司";
    data.sellerInfo = seller;

    // 详情 HTML
    data.detailHTML = @"<h3>商品详情</h3><p>本品为海南黄花梨（降香黄檀），产自海南东方，树龄15年，胸径28cm，树高8.5m。</p><p>海南黄花梨是国家二级保护植物，木材质地坚硬、纹理美观，是制作高档家具和工艺品的上等材料。</p>";

    // 详情参数
    data.detailParams = @{
        @"品种": @"降香黄檀",
        @"树龄": @"15年",
        @"胸径": @"28cm",
        @"树高": @"8.5m",
        @"产地": @"海南东方",
        @"坐标": @"19°06'N, 108°38'E",
        @"数量": @"单株",
        @"土地期限": @"2050-12-31",
        @"管护到期": @"2028-06-30",
    };

    data.latitude = 19.1;
    data.longitude = 108.63;
    data.location = @"海南省东方市亿林庄园";

    return data;
}

- (UIViewController *)productDetailViewController:(NSString *)productId {
    ZCCProductDetailVC *vc = [[ZCCProductDetailVC alloc] init];
    vc.productId = productId;
    return vc;
}

- (UIViewController *)productListViewController {
    return [[ZCCProductListVC alloc] init];
}

- (NSArray<ZCCTreeTraceNode *> *)getTreeTraceNodes:(NSString *)productId {
    return @[
        [self makeNode:@"N001" title:@"种植" desc:@"苗木定植于亿林庄园A区3号地块" date:@"2021-03-15" img:@"https://example.com/trace_plant.jpg"],
        [self makeNode:@"N002" title:@"首次浇水" desc:@"完成定根水浇灌，水量20L" date:@"2021-03-15" img:nil],
        [self makeNode:@"N003" title:@"施肥" desc:@"施用有机肥5kg，复合肥0.5kg" date:@"2021-06-20" img:nil],
        [self makeNode:@"N004" title:@"测量" desc:@"树高1.2m，胸径3.5cm" date:@"2022-03-15" img:@"https://example.com/trace_measure.jpg"],
        [self makeNode:@"N005" title:@"修剪" desc:@"修剪侧枝，保留主干" date:@"2022-09-10" img:nil],
        [self makeNode:@"N006" title:@"测量" desc:@"树高3.8m，胸径12cm" date:@"2023-03-15" img:@"https://example.com/trace_measure2.jpg"],
        [self makeNode:@"N007" title:@"施肥" desc:@"施用有机肥8kg" date:@"2023-06-20" img:nil],
        [self makeNode:@"N008" title:@"测量" desc:@"树高5.6m，胸径20cm" date:@"2024-03-15" img:@"https://example.com/trace_measure3.jpg"],
        [self makeNode:@"N009" title:@"病虫害防治" desc:@"喷洒生物制剂防虫" date:@"2024-08-05" img:nil],
        [self makeNode:@"N010" title:@"测量" desc:@"树高8.5m，胸径28cm" date:@"2025-03-15" img:@"https://example.com/trace_measure4.jpg"],
    ];
}

- (ZCCTreeTraceNode *)makeNode:(NSString *)nid title:(NSString *)title desc:(NSString *)desc date:(NSString *)date img:(NSString *)img {
    ZCCTreeTraceNode *node = [[ZCCTreeTraceNode alloc] init];
    node.nodeId = nid;
    node.title = title;
    node.nodeDescription = desc;
    node.dateString = date;
    node.imageUrl = img;
    return node;
}

- (UIView *)productDetailCardForProduct:(NSString *)productId frame:(CGRect)frame {
    ZCCProductDetailCard *card = [[ZCCProductDetailCard alloc] initWithFrame:frame];
    ZCCProductDetailData *data = [self getProductDetail:productId];
    card.params = data.detailParams;
    return card;
}

- (UIView *)productTraceCardForProduct:(NSString *)productId frame:(CGRect)frame {
    ZCCProductTraceCard *card = [[ZCCProductTraceCard alloc] initWithFrame:frame];
    card.traceNodes = [self getTreeTraceNodes:productId];
    return card;
}

- (CGFloat)productDetailCardHeight:(NSString *)productId {
    ZCCProductDetailData *data = [self getProductDetail:productId];
    return [ZCCProductDetailCard heightForParams:data.detailParams];
}

- (CGFloat)productTraceCardHeight:(NSString *)productId {
    return [ZCCProductTraceCard heightForNodes:[self getTreeTraceNodes:productId]];
}

@end
