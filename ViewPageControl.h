//
//  MyPageControl.h
//  Planning Design Survey System
//
//  Created by flame_thupdi on 13-4-17.
//  Copyright (c) 2013年 flame_thupdi. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const PageDotViewRadius;
extern CGFloat const PageDotViewSpace;

@interface MyPageControl : UIView
{
    UIView* _selectView;
}
-(void)setSelectIndex:(NSInteger)index;
@property(nonatomic,assign) NSUInteger PageNum;
@end
