//
//  ZCCBannerView.m
//  ZCCUIComponent
//

#import "ZCCBannerView.h"

@interface ZCCBannerView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign, readwrite) NSInteger currentPage;

@end

@implementation ZCCBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _placeholderColor = [UIColor colorWithRed:0.2 green:0.4 blue:0.3 alpha:1.0];
        _autoScroll = YES;
        _scrollInterval = 4.0;
        _pageIndicatorColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        _currentPageIndicatorColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_scrollView];

    _pageControl = [[UIPageControl alloc] init];
    _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _pageControl.pageIndicatorTintColor = _pageIndicatorColor;
    _pageControl.currentPageIndicatorTintColor = _currentPageIndicatorColor;
    [self addSubview:_pageControl];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    _scrollView.frame = self.bounds;
    _pageControl.frame = CGRectMake(0, h - 26, w, 20);

    // 重新布局图片
    for (NSInteger i = 0; i < _scrollView.subviews.count; i++) {
        UIView *v = _scrollView.subviews[i];
        if ([v isKindOfClass:[UIImageView class]]) {
            v.frame = CGRectMake(i * w, 0, w, h);
        }
    }
    _scrollView.contentSize = CGSizeMake(w * self.imageUrls.count, h);
}

- (void)setImageUrls:(NSArray<NSString *> *)urls {
    _imageUrls = [urls copy];
    [self reloadBanner];
}

- (void)reloadBanner {
    // 清除旧视图
    for (UIView *v in _scrollView.subviews) { [v removeFromSuperview]; }
    [self stopTimer];

    if (self.imageUrls.count == 0) return;

    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;

    for (NSInteger i = 0; i < self.imageUrls.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * w, 0, w, h)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        imgView.backgroundColor = self.placeholderColor;
        imgView.tag = i;
        imgView.userInteractionEnabled = YES;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        [imgView addGestureRecognizer:tap];

        // 实际项目使用 SDWebImage: [imgView sd_setImageWithURL:url placeholderImage:nil]
        [self addLabelToImage:imgView index:i];

        [_scrollView addSubview:imgView];
    }

    _scrollView.contentSize = CGSizeMake(w * self.imageUrls.count, h);
    _pageControl.numberOfPages = self.imageUrls.count;
    _pageControl.currentPage = 0;
    _currentPage = 0;

    if (self.autoScroll && self.imageUrls.count > 1) {
        [self startTimer];
    }
}

- (void)addLabelToImage:(UIImageView *)imgView index:(NSInteger)index {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, imgView.bounds.size.height - 50, imgView.bounds.size.width - 32, 30)];
    label.text = [NSString stringWithFormat:@"海南黄花梨 · 第%ld张", (long)(index + 1)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [imgView addSubview:label];
}

- (void)imageTapped:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(bannerView:didTapImageAtIndex:)]) {
        [self.delegate bannerView:self didTapImageAtIndex:tap.view.tag];
    }
}

#pragma mark - Auto Scroll

- (void)startTimer {
    [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollInterval
                                                  target:self
                                                selector:@selector(scrollToNext)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollToNext {
    NSInteger next = (self.currentPage + 1) % self.imageUrls.count;
    [self.scrollView setContentOffset:CGPointMake(next * self.bounds.size.width, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = (NSInteger)(scrollView.contentOffset.x / self.bounds.size.width + 0.5);
    self.currentPage = page;
    self.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.autoScroll && self.imageUrls.count > 1) {
        [self startTimer];
    }
}

- (void)dealloc {
    [self stopTimer];
}

@end
