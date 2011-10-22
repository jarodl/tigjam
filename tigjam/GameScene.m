//
//  GameScene.m
//  tigjam
//
//  Created by Jarod Luebbert on 10/19/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

#import "GameScene.h"
#import "ImageLoader.h"
#import "CloudLayer.h"
#import "WaterLayer.h"
#import "Environment.h"
#import "Blob.h"
#import "CCGestureRecognizer.h"

#define kObjectsSpriteSheetName @"Objects"
#define kBackgroundColor ccc4(177, 235, 255, 255)
#define kWaveOffset 75.0f
#define kGesturePositionChangeLimit 10.0f

@interface GameScene ()
@property (nonatomic, strong) FrontWaterLayer *frontWater;
@property (nonatomic, strong) WaterLayer *water;
@property (nonatomic, strong) CloudLayer *clouds;
@property (nonatomic, strong) CCGestureRecognizer *gestureRecognizer;
@property (nonatomic, strong) CCGestureRecognizer *rotationRecognizer;
@property (nonatomic, strong) Blob *currentBlob;

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGestureRecognizer;
- (void)handleRotationGesture:(UIRotationGestureRecognizer *)rotationGesture;
@end

@implementation GameScene

@synthesize water;
@synthesize frontWater;
@synthesize clouds;
@synthesize gestureRecognizer;
@synthesize rotationRecognizer;
@synthesize currentBlob;

#pragma mark -
#pragma mark Set up

- (id)init
{
    if ((self = [super init]))
    {
        [[ImageLoader sharedInstance] loadSpriteSheet:kObjectsSpriteSheetName];
        CCLayerColor *backgroundLayer = [CCLayerColor layerWithColor:kBackgroundColor];
        [self addChild:backgroundLayer];
        
        self.clouds = [CloudLayer node];
        [self addChild:clouds];
        
        self.water = [WaterLayer node];
        water.position = [[Environment sharedInstance] fromBottomLeftX:0.0f y:-(self.contentSize.height - kWaveOffset)];
        [self addChild:water];
        
        self.frontWater = [FrontWaterLayer node];
        self.frontWater.position = ccpSub([water frontWavePosition], ccp(0, self.contentSize.height - kWaveOffset));
        [self addChild:frontWater];
        
        UIPinchGestureRecognizer *pinchGestureRecognizer = [UIPinchGestureRecognizer new];
        self.gestureRecognizer = [CCGestureRecognizer recognizerWithRecognizer:pinchGestureRecognizer
                                                                        target:self
                                                                        action:@selector(handlePinchGesture:)];
        UIRotationGestureRecognizer *rotationGestureRecognizer = [UIRotationGestureRecognizer new];
        self.rotationRecognizer = [CCGestureRecognizer recognizerWithRecognizer:rotationGestureRecognizer
                                                                         target:self
                                                                         action:@selector(handleRotationGesture:)];
        [self addGestureRecognizer:gestureRecognizer];
        [self addGestureRecognizer:rotationRecognizer];
    }
    
    return self;
}

#pragma mark -
#pragma mark Clean up

- (void)onExit
{
    [super onExit];
    [self removeGestureRecognizer:gestureRecognizer];
    [self removeGestureRecognizer:rotationRecognizer];
}


#pragma mark -
#pragma mark Update

- (void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    [water startAnimating];
    [clouds startAnimations];
    [self scheduleUpdate];
}

- (void)update:(ccTime)dt
{
    self.frontWater.position = ccpSub([water frontWavePosition], ccp(0, self.contentSize.height - kWaveOffset));
}

#pragma mark -
#pragma mark Handle touch events

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    CGPoint gestureLocation = [[CCDirector sharedDirector] convertToGL:[pinchGestureRecognizer locationInView:pinchGestureRecognizer.view]];
    switch (pinchGestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            self.currentBlob = [Blob new];
            self.currentBlob.position = gestureLocation;
            self.currentBlob.scale = pinchGestureRecognizer.scale / 5.0f;
            [self addChild:currentBlob];
            break;
        case UIGestureRecognizerStateChanged:
            self.currentBlob.scale = pinchGestureRecognizer.scale / 5.0f;
            if (ccpDistance(gestureLocation, currentBlob.position) < kGesturePositionChangeLimit)
                self.currentBlob.position = gestureLocation;
            break;
        case UIGestureRecognizerStateEnded:
            self.currentBlob = nil;
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
            [self.currentBlob removeFromParentAndCleanup:YES];
            break;
        default:
            break;
    }
}

- (void)handleRotationGesture:(UIRotationGestureRecognizer *)rotationGesture
{
    switch (rotationGesture.state)
    {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            self.currentBlob.rotation = CC_RADIANS_TO_DEGREES(rotationGesture.rotation);
            break;
        default:
            break;
    }
}

@end
