//
//  ViewController.m
//  CAEmitterLayer
//
//  Created by rimi on 15/7/8.
//  Copyright (c) 2015年 LeeSefung. All rights reserved.
//  https://github.com/LeeSefung/FireFlower.git
//

#import "ViewController.h"
#import <QuartzCore/CoreAnimation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
#pragma mark - 创建fireworksEmitter（烟花发射点）
    
    // 创建出Layer
    CAEmitterLayer *fireworksEmitter = [CAEmitterLayer layer];
    CGRect viewBounds = self.view.layer.bounds;
    // 发射点：屏幕下方中点(发射源形状的中心)
    fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
    //可以设置它的frame
    fireworksEmitter.frame = self.view.bounds;
    //超过边框部分影藏(此处没有作用)
    fireworksEmitter.masksToBounds = YES;
    //发射模式
    fireworksEmitter.emitterMode	= kCAEmitterLayerOutline;
    //发射形状
    fireworksEmitter.emitterShape	= kCAEmitterLayerLine;
    //渲染模式
    fireworksEmitter.renderMode		= kCAEmitterLayerAdditive;
    //用于初始化随机数产生的种子
    fireworksEmitter.seed = (arc4random()%100)+1;

#pragma mark - 烟花发射粒子轨迹
    
    //CAEmitterCell类代从从CAEmitterLayer射出的粒子；emitter cell定义了粒子发射的方向和其它属性。
    //创建cell
    CAEmitterCell* rocket = [CAEmitterCell emitterCell];
    //每秒钟产生的粒子数量
    rocket.birthRate		= 1.0;
    //周围发射角度变化范围
    rocket.emissionRange	= 0.15 * M_PI;  // some variation in angle
    //每个粒子的速度
    rocket.velocity			= 580;
    //每个粒子的速度变化范围
    rocket.velocityRange	= 120;
    //粒子y方向的加速度分量
    rocket.yAcceleration	= 75;
    //每一个粒子的生存周期多少秒
    rocket.lifetime			= 1.02;	// we cannot set the birthrate < 1.0 for the burst
    //是个CGImageRef的对象,既粒子要展现的图片
    rocket.contents			= (id) [[UIImage imageNamed:@"DazRing"] CGImage];
    //整体缩放比例（0.0~1.0）
    rocket.scale			= 0.2;
    //每个粒子的颜色
    rocket.color			= [[UIColor redColor] CGColor];
    //一个粒子的颜色red/green/blue 能改变的范围；
    rocket.greenRange		= 1.0;		// different colors
    rocket.redRange			= 1.0;
    rocket.blueRange		= 1.0;
    rocket.spinRange		= M_PI;		// slow spin
    
#pragma mark - 烟花爆炸瞬间
    
    CAEmitterCell* burst = [CAEmitterCell emitterCell];
    
    burst.birthRate			= 1.0;		// at the end of travel
    burst.velocity			= 0;
    burst.scale				= 2.5;
    burst.redSpeed			=-1.5;		// shifting
    burst.blueSpeed			=+1.5;		// shifting
    burst.greenSpeed		=+1.0;		// shifting
    burst.lifetime			= 0.35;
    
#pragma mark - 烟花动画
    
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    
    spark.birthRate			= 400;
    spark.velocity			= 125;
    spark.emissionRange		= 2* M_PI;	// 360 deg
    spark.yAcceleration		= 75;		// gravity
    spark.lifetime			= 3;
    
    spark.contents			= (id) [[UIImage imageNamed:@"DazStarOutline"] CGImage];
    spark.scaleSpeed		=-0.2;
    spark.greenSpeed		=-0.1;
    spark.redSpeed			= 0.4;
    spark.blueSpeed			=-0.1;
    spark.alphaSpeed		=-0.25;
    spark.spin				= 2* M_PI;
    spark.spinRange			= 2* M_PI;
    
#pragma mark - 连接烟花动画
    
    // 让CAEmitterCell与CAEmitterLayer产生关联
    fireworksEmitter.emitterCells	= [NSArray arrayWithObject:rocket];
    rocket.emitterCells				= [NSArray arrayWithObject:burst];
    burst.emitterCells				= [NSArray arrayWithObject:spark];
    [self.view.layer addSublayer:fireworksEmitter];
}

@end
