//
//  CloudLayer.m
//  tigjam
//
//  Created by Jarod Luebbert on 10/21/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

#import "CloudLayer.h"
#import "RNG.h"
#import "Environment.h"

#define kCloudFrameNameFormat @"cloud_%d.png"
#define kNumberOfClouds 5

@interface CloudLayer ()
@property (nonatomic, strong) NSMutableArray *clouds;

- (CCFiniteTimeAction *)movingCloudAction;
@end

@implementation CloudLayer

@synthesize clouds;

- (id)init
{
    if ((self = [super init]))
    {
        self.contentSize = [Environment sharedInstance].screenSize;
        
        NSArray *cloudPositions = [NSArray arrayWithObjects:
                                   [NSValue valueWithCGPoint:[[Environment sharedInstance] fromTopLeftX:75.0f y:25.0f]],
                                   [NSValue valueWithCGPoint:[[Environment sharedInstance] fromTopRightX:35.0f y:100.0f]],
                                   [NSValue valueWithCGPoint:[[Environment sharedInstance] fromTopLeftX:25.0f y:50.0f]],
                                   [NSValue valueWithCGPoint:[[Environment sharedInstance] fromTopRightX:50.0f y:75.0f]],
                                   [NSValue valueWithCGPoint:[[Environment sharedInstance] fromTopMiddleX:10.0f y:125.0f]],
                                   nil];
        self.clouds = [NSMutableArray arrayWithCapacity:kNumberOfClouds];
        for (int i = 0; i < kNumberOfClouds; i++)
        {
            NSString *frameName = [NSString stringWithFormat:kCloudFrameNameFormat, i];
            CCSprite *cloud = [CCSprite spriteWithSpriteFrameName:frameName];
            NSValue *position = [cloudPositions objectAtIndex:i];
            cloud.position = [position CGPointValue];
            cloud.opacity = 0;
            [self.clouds addObject:cloud];
            [self addChild:cloud];
        }
    }
    
    return self;
}


#pragma mark -
#pragma mark Animations

- (void)startAnimations
{
    for (CCSprite *cloud in clouds)
    {
        [cloud runAction:[CCFadeIn actionWithDuration:5.0f]];
        [cloud runAction:[self movingCloudAction]];
    }
}

- (CCFiniteTimeAction *)movingCloudAction
{
    float duration = [[RNG sharedInstance] randomFloatFrom:20.0f to:35.0f];
    float direction = ([[RNG sharedInstance] randomBool]) ? 1.0f : -1.0f;
    return [CCRepeatForever actionWithAction:[CCSequence actions:
                                              [CCMoveBy actionWithDuration:duration
                                                                  position:ccp(direction * self.contentSize.width, 0)],
                                              [CCDelayTime actionWithDuration:[[RNG sharedInstance] randomFloatFrom:1.0f to:3.0f]],
                                              [CCMoveBy actionWithDuration:duration
                                                                  position:ccp(-1 * direction * self.contentSize.width, 0)],
                                              [CCDelayTime actionWithDuration:[[RNG sharedInstance] randomFloatFrom:1.0f to:3.0f]],
                                              nil]];
}

@end
