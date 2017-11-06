//
//  ScratchCardView.h
//  ScratchCardView
//
//  Created by goldeneye on 2017/11/6.
//  Copyright © 2017年 goldeneye by smart-small. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScratchCardView : UIView
//要刮的图片
@property(nonatomic,strong)UIImage * image;
//涂层图片
@property(nonatomic,strong)UIImage * surfaceImage;

- (void)clear;
- (void)back;

@end
