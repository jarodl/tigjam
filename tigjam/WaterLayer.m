//
//  WaterLayer.m
//  tigjam
//
//  Created by Jarod Luebbert on 10/21/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

#import "WaterLayer.h"
#import "CCActionCyclic.h"
#import "CCMoveHorizVert.h"
#import "Environment.h"

#define kWaveFrameName @"wave_%d.png"
#define kWaveLineFrameName @"wave_line.png"
#define kWaveCount 3
#define kWavePeriod 4
#define kVertMovement 5
#define kHorizMovement 10
#define kFrontWaterColor ccc4(107, 190, 219, 255)
#define kFrontWaveOpacity 150

@interface WaterLayer ()
@property (nonatomic, strong) NSMutableArray *waves;
@property (nonatomic, strong) CCLayerColor *water;

- (CCActionInterval *)makeBaseWaveActionWithPhaseShift:(CGFloat)phaseShift;
@end

@implementation WaterLayer

@synthesize waves;
@synthesize opacity;
@synthesize water;

- (id)init
{
    if ((self = [super init]))
    {
        self.contentSize = [Environment sharedInstance].screenSize;
        self.anchorPoint = ccp(0.5, 1.0f);
        self.waves = [NSMutableArray arrayWithCapacity:kWaveCount];
        
        for (int i = kWaveCount - 1; i >= 0; i--)
        {
            CCSprite *wave = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:kWaveFrameName, i]];
            wave.position = [[Environment sharedInstance] fromTopMiddleX:0.0f y:wave.contentSize.height / 2];
            [waves addObject:wave];
            [self addChild:wave];
        }
        
        CCSprite *frontWave = [waves lastObject];
        self.water = [CCLayerColor layerWithColor:kFrontWaterColor];
        self.water.position = ccpSub(frontWave.position, ccp(self.contentSize.width / 2, (frontWave.contentSize.height / 2) + self.contentSize.height));
        [self addChild:water];
    }
    
    return self;
}

- (void)setOpacity:(float)opacityIn
{
    opacity = opacityIn;
    for (CCSprite *wave in waves)
        wave.opacity = opacity;
    self.water.opacity = opacity;
}

- (CGPoint)frontWavePosition
{
    return [[waves lastObject] position];
}

- (void)startAnimating
{
    float phaseShift = 0.0f;
    for (CCSprite *wave in waves)
    {
        [wave runAction:[self makeBaseWaveActionWithPhaseShift:phaseShift]];
        phaseShift += 0.05;
    }
}

- (CCActionInterval *)makeBaseWaveActionWithPhaseShift:(CGFloat)phaseShift
{
    return [CCRepeatForever actionWithAction:
            [CCActionCyclic actionWithPhaseShift:phaseShift * kWavePeriod
                                          action:
             [CCSpawn actions:
              [CCSequence actions:
               [CCEaseSineInOut actionWithAction:
                [CCMoveVerticalBy actionWithDuration:kWavePeriod / 4 verticalPosition:-kVertMovement]],
               [CCEaseSineInOut actionWithAction:
                [CCMoveVerticalBy actionWithDuration:kWavePeriod / 4 verticalPosition:kVertMovement]],
               nil],
              [CCEaseSineInOut actionWithAction:
               [CCMoveHorizontalBy actionWithDuration:kWavePeriod / 2 horizontalPosition:-kHorizMovement]],
              nil]]];
}


@end

@implementation FrontWaterLayer

- (id)init
{
    if ((self = [super init]))
    {
        self.contentSize = [Environment sharedInstance].screenSize;
        self.anchorPoint = ccp(0.5, 1.0f);
        CCSprite *frontWave = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:kWaveFrameName, 0]];
        frontWave.opacity = kFrontWaveOpacity;
        [self addChild:frontWave];
        CCSprite *waveLine = [CCSprite spriteWithSpriteFrameName:kWaveLineFrameName];
        [self addChild:waveLine];
        CCLayerColor *water = [CCLayerColor layerWithColor:ccc4(kFrontWaterColor.r,
                                                                kFrontWaterColor.g,
                                                                kFrontWaterColor.b,
                                                                kFrontWaveOpacity)];
        water.position = ccpSub(frontWave.position, ccp(self.contentSize.width / 2,
                                                        (frontWave.contentSize.height / 2) + self.contentSize.height));
        [self addChild:water];
    }
    
    return self;
}

@end
