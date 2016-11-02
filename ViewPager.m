//
//  ViewPager.m
//

#import "ViewPager.h"
#import "UIColor+String.h"
#import "AppDelegate.h"
#import "math.h"

#define ScrollViewAlpha 0.7
#define ScrollViewTransform 0.8

extern const CGFloat TopNavigationHeight;
extern const CGFloat TabBarHeight;
CGFloat const PageDotViewRadius = 5.0;
CGFloat const PageDotViewSpace = 8.0;
CGFloat const ViewPagerScrollViewWidth = 650;

@interface ViewPager()
{
    CGFloat scalePrevious;//用于记录判断左右滑动
}
@end

@implementation ViewPager
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame andViews:(NSArray *)views
{
    self = [super initWithFrame:frame];
    if (self) {
        _views = views;
        self.backgroundColor = [UIColor colorWithHexString:@"e9ecf0"];//bbbbbb
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
//    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
//    NSLog(@"!!!screenSize.width  is %f",screenSize.width);
//    NSLog(@"!!!screenSize.height is %f",screenSize.height);
    
    NSInteger defaultIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"SetDefaultIconIndex"];
    scalePrevious = defaultIndex;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake((rect.size.width-ViewPagerScrollViewWidth)/2, 86, ViewPagerScrollViewWidth, rect.size.height-TabBarHeight-TopNavigationHeight)];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.clipsToBounds = NO;
    
    [_scrollView setContentSize:CGSizeMake(ViewPagerScrollViewWidth*_views.count, 0)];
    _scrollView.delegate = self;
    
    CGRect frame;
    frame.origin.y = 0;
    frame.size.height = _scrollView.frame.size.height;
    frame.size.width = _scrollView.frame.size.width;
    for (int index = 0; index < _views.count; index++) {
        UIView* view = [_views objectAtIndex:index];
        if (index == 0) {
            frame.origin.x = 0;
        }
        else
        {
            frame.origin.x = _scrollView.frame.size.width*index;
        }
        
        view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        view.opaque = YES;
        view.alpha = 1.0;
        [view setFrame:frame];
        
        if (index != defaultIndex)
        {
            view.transform = CGAffineTransformMakeScale(ScrollViewTransform, ScrollViewTransform);
            view.alpha = ScrollViewAlpha;
        }
        
        [_scrollView addSubview:view];
    }
    
    CGFloat pageControlWidth = _views.count*PageDotViewRadius*2 + (_views.count - 1)*PageDotViewSpace;
    
    _pageControl = [[MyPageControl alloc]initWithFrame:CGRectMake((rect.size.width-pageControlWidth)/2, 36, PageDotViewRadius*2, PageDotViewRadius*2)];
    _pageControl.PageNum = _views.count;
    
    //默认显示的桌面
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*defaultIndex, 0) animated:YES];
    
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
    
    //解决透明度第一次设置无效问题
    for (int index = 0; index < _views.count; index++) {
        UIView* view = [_views objectAtIndex:index];
        if (index != defaultIndex)
        {
            view.alpha = ScrollViewAlpha;
        }
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scale = scrollView.contentOffset.x/scrollView.frame.size.width;
    NSUInteger index = fabs(scale);
//    NSLog(@"scale=%f, index=%ld", scale, index);
    
    if (scale < scalePrevious) {
//        NSLog(@"右滑");
        if (scale <= _views.count-1 && scale >= 0) {
            for (int subIndex = 0; subIndex < _views.count; subIndex++) {
                _scrollView.subviews[subIndex].alpha = 1.0;
                if (subIndex == index+1) {
                    _scrollView.subviews[subIndex].transform = CGAffineTransformMakeScale(ScrollViewTransform+0.2*(scale-index), ScrollViewTransform+(1-ScrollViewTransform)*(scale-index));
                }
                else if (subIndex == index)
                {
                    _scrollView.subviews[index].transform = CGAffineTransformMakeScale(1+(index-scale)*(1-ScrollViewTransform), 1+(index-scale)*(1-ScrollViewTransform));
                }
            }
        }
    }
    else
    {
//        NSLog(@"左滑");
        if (scale <= _views.count-1 && scale >= 0) {
            for (int subIndex = 0; subIndex < _views.count; subIndex++) {
                _scrollView.subviews[subIndex].alpha = 1.0;
                if (subIndex == index+1) {
                    _scrollView.subviews[subIndex].transform = CGAffineTransformMakeScale(ScrollViewTransform+(1-ScrollViewTransform)*(scale-index), ScrollViewTransform+(1-ScrollViewTransform)*(scale-index));
                }
                else
                {
                    _scrollView.subviews[index].transform = CGAffineTransformMakeScale(1+(index-scale)*(1-ScrollViewTransform), 1+(index-scale)*(1-ScrollViewTransform));
                }
            }
        }
    }
    
    scalePrevious = scale;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    [_pageControl setSelectIndex:index];
    
    //设定透明度
    for (int subIndex = 0; subIndex < _views.count; subIndex++) {
        _scrollView.subviews[subIndex].alpha = 1.0;
        if (subIndex != index) {
            _scrollView.subviews[subIndex].alpha = ScrollViewAlpha;
        }
    }

    if ([self.delegate respondsToSelector:@selector(ViewPager:didSelectIndex:)]) {
        [self.delegate ViewPager:self didSelectIndex:index];
    }
    
}

#pragma mark---重写hitTest方法
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isEqual:self]){
        for (UIView *subview in _scrollView.subviews){
            CGPoint offset = CGPointMake(point.x - _scrollView.frame.origin.x + _scrollView.contentOffset.x - subview.frame.origin.x, point.y - _scrollView.frame.origin.y + _scrollView.contentOffset.y - subview.frame.origin.y);
            
            if ((view = [subview hitTest:offset withEvent:event])){
                return view;
            }
        }
        return _scrollView;
    }
    return view;
}

@end
