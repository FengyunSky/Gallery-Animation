//
//  ViewPageControl.m
//
//  Created by FengyunSky on 16-11-02.
//  Copyright (c) 2016年 ZTE. All rights reserved.
//

#import "ViewPageControl.h"
#import "UIColor+String.h"

@implementation MyPageControl
@synthesize PageNum;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat spacing = PageDotViewRadius*2 + PageDotViewSpace;
    UIView *dotViewIn, *dotViewOut;
    
    for (int index = 0; index < PageNum; index++) {
        dotViewOut = [[UIView alloc]initWithFrame:CGRectMake(spacing*index, 0, PageDotViewRadius*2, PageDotViewRadius*2)];
        dotViewOut.backgroundColor = [UIColor colorWithHexString:@"bdcad0"];
        dotViewOut.layer.cornerRadius = PageDotViewRadius;
        
        dotViewIn = [[UIView alloc]initWithFrame:CGRectMake(dotViewOut.frame.origin.x+1, 1, dotViewOut.frame.size.width-2, dotViewOut.frame.size.height-2)];
        dotViewIn.backgroundColor = [UIColor colorWithHexString:@"e9ecf0"];
        dotViewIn.layer.cornerRadius = (dotViewOut.frame.size.height-2)/2;
        
        [self addSubview:dotViewOut];
        [self addSubview:dotViewIn];
    }

    //圆圈半径
    NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:@"SetDefaultIconIndex"];
    CGRect frame = dotViewOut.frame;
    frame.origin.x = index*(PageDotViewRadius*2 + PageDotViewSpace);
    _selectView = [[UIView alloc]initWithFrame:frame];
    _selectView.layer.cornerRadius = frame.size.height/2;
    [_selectView setBackgroundColor:[UIColor colorWithHexString:@"0092cd"]];
    [self addSubview:_selectView];

}

-(void)setSelectIndex:(NSInteger)index
{
    float width = PageDotViewRadius*2 + PageDotViewSpace;
    CGRect rect = _selectView.frame;
    rect.origin.x = index*width;
    _selectView.frame = rect;
}


@end
