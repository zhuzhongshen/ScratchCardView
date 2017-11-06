
//
//  ScratchCardView.m
//  ScratchCardView
//
//  Created by goldeneye on 2017/11/6.
//  Copyright © 2017年 goldeneye by smart-small. All rights reserved.
//

#import "ScratchCardView.h"


@interface ScratchCardView()

@property(nonatomic,strong)UIImageView * surfaceIamgeView;
@property(nonatomic,strong)CALayer * imageLabyer;
@property(nonatomic,strong)CAShapeLayer * shapeLayer;
//手指路径
@property (nonatomic,assign)CGMutablePathRef path;
//储存所有的point
@property(nonatomic,strong)NSMutableArray * allPaths;
//储存每次手指触摸结束的point
@property(nonatomic,strong)NSMutableArray * appendPaths;

@end

@implementation ScratchCardView

- (NSMutableArray *)allPaths
{
    if (!_allPaths) {
        _allPaths = [NSMutableArray array];
    }
    return _allPaths;
}
- (NSMutableArray *)appendPaths{
    if (!_appendPaths) {
        _appendPaths = [NSMutableArray array];
    }
    return _appendPaths;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    //添加imageview（surfaceImageView）到self上
    self.surfaceIamgeView = [[UIImageView alloc]initWithFrame:self.bounds];
    [self addSubview:self.surfaceIamgeView];
    //添加layer（imageLayer）到self上
    self.imageLabyer = [CALayer layer];
    self.imageLabyer.frame = self.bounds;
    [self.layer addSublayer:self.imageLabyer];
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = self.bounds;
    self.shapeLayer.lineCap = kCALineCapRound;
    self.shapeLayer.lineJoin = kCALineJoinRound;
    self.shapeLayer.lineWidth = 10.0f;
    self.shapeLayer.strokeColor = [[UIColor blueColor] CGColor];
    self.shapeLayer.fillColor = nil;
    [self.layer addSublayer:self.shapeLayer];
    
    self.imageLabyer.mask = self.shapeLayer;
    
    self.path = CGPathCreateMutable();
    
}
- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageLabyer.contents = (id)image.CGImage;
}
- (void)setSurfaceImage:(UIImage *)surfaceImage
{
    _surfaceImage = surfaceImage;
    self.surfaceIamgeView.image = surfaceImage;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //开始一条可变路径，
    CGPathMoveToPoint(self.path, NULL, point.x, point.y);
    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
    self.shapeLayer.path = path;
    CGPathRelease(path);
    
    self.appendPaths = [NSMutableArray array];
    
    [self.appendPaths addObject:[NSValue valueWithCGPoint:point]];

    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //路径追加
    CGPathAddLineToPoint(self.path, NULL, point.x, point.y);
    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
    self.shapeLayer.path = path;
    CGPathRelease(path);
    [self.appendPaths addObject:[NSValue valueWithCGPoint:point]];

}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self.allPaths addObject:self.appendPaths];

}
//清除
- (void)clear{
    
    [self.allPaths removeAllObjects];
    self.path = CGPathCreateMutable();
    CGPathMoveToPoint(self.path, NULL, 0, 0);
    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
    self.shapeLayer.path = path;
    CGPathRelease(path);
}
//撤回
- (void)back{

    [self.allPaths removeLastObject];
    self.path = CGPathCreateMutable();
    //如果撤回步骤大于0次执行撤回 否则执行清除操作
    if (self.allPaths.count>0) {
        for (int i=0; i<self.allPaths.count; i++) {
            NSArray * array = self.allPaths[i];
            for (int j =0 ; j<array.count; j++) {
                CGPoint point = [array[j] CGPointValue];
                if (j==0) {
                    CGPathMoveToPoint(self.path, NULL, point.x, point.y);
                    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
                    self.shapeLayer.path = path;
                    CGPathRelease(path);
                    
                }else{

                    CGPathAddLineToPoint(self.path, NULL, point.x, point.y);
                    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
                    self.shapeLayer.path = path;
                    CGPathRelease(path);
                }
            }
        }
        
    }else{
        [self clear];
    }
}
- (void)dealloc
{
    if (self.path) {
        CGPathRelease(self.path);
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
