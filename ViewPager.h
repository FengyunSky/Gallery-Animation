//
//  ViewPager.h
//  Planning Design Survey System
//
//  Created by flame_thupdi on 13-4-17.
//  Copyright (c) 2013年 flame_thupdi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPageControl.h"

@class ViewPager;
@protocol ViewPagerDelegate<NSObject>
-(void)ViewPager:(ViewPager *)viewPager didSelectIndex:(NSInteger)index;
@end

@interface ViewPager : UIView<UIScrollViewDelegate>
{
    UIScrollView* _scrollView;
    MyPageControl* _pageControl;
    NSArray* _views;
}
@property(nonatomic,assign)id<ViewPagerDelegate> delegate;
- (id)initWithFrame:(CGRect)frame andViews:(NSArray *)views;
@end
