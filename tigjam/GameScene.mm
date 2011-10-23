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
#import "Enemy.h"
#import "CCGestureRecognizer.h"
#import "CCMoveHorizVert.h"

#define kObjectsSpriteSheetName @"Objects"
#define kBackgroundColor ccc4(177, 235, 255, 255)
#define kWaveOffset 75.0f
#define kGesturePositionChangeLimit 10.0f
#define PTM_RATIO 50.0f
#define kFrontZIndex 5
#define kWorldGravity -7.0f

@interface GameScene ()
@property (nonatomic, strong) FrontWaterLayer *frontWater;
@property (nonatomic, strong) WaterLayer *water;
@property (nonatomic, strong) CloudLayer *clouds;
@property (nonatomic, strong) CCGestureRecognizer *gestureRecognizer;
@property (nonatomic, strong) CCGestureRecognizer *rotationRecognizer;
@property (nonatomic, strong) Blob *currentBlob;

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGestureRecognizer;
- (void)handleRotationGesture:(UIRotationGestureRecognizer *)rotationGesture;
- (void)riseWaterWithAmount:(float)amount;
- (void)addEnemy;
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
        self.contentSize = [Environment sharedInstance].screenSize;
        CCLayerColor *backgroundLayer = [CCLayerColor layerWithColor:kBackgroundColor];
        [self addChild:backgroundLayer];
        
        self.clouds = [CloudLayer node];
        [self addChild:clouds];
        
        self.water = [WaterLayer node];
        water.position = [[Environment sharedInstance] fromBottomLeftX:0.0f y:-(self.contentSize.height - kWaveOffset)];
        [self addChild:water];
        
        self.frontWater = [FrontWaterLayer node];
        self.frontWater.position = [water frontWavePosition];
        [self addChild:frontWater z:kFrontZIndex];
        
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
        
        // Physics
        b2Vec2 gravity;
        gravity.Set(0.0f, kWorldGravity);
        bool doSleep = true;
        world = new b2World(gravity, doSleep);
        world->SetContinuousPhysics(true);
        m_debugDraw = new GLESDebugDraw(PTM_RATIO * CC_CONTENT_SCALE_FACTOR());
        uint32 flags = 0;
        flags += b2DebugDraw::e_shapeBit;
        flags += b2DebugDraw::e_jointBit;
        flags += b2DebugDraw::e_aabbBit;
        flags += b2DebugDraw::e_pairBit;
        flags += b2DebugDraw::e_centerOfMassBit;
        m_debugDraw->SetFlags(flags);
        world->SetDebugDraw(m_debugDraw);
        // ground body
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0, 0);
        groundBody = world->CreateBody(&groundBodyDef);
        // ground box shape
        b2PolygonShape groundBox;
        // left
        groundBox.SetAsEdge(b2Vec2(0, self.contentSize.height / PTM_RATIO), b2Vec2_zero);
        groundBody->CreateFixture(&groundBox, 0);
        // right
        groundBox.SetAsEdge(b2Vec2(self.contentSize.width / PTM_RATIO, self.contentSize.height / PTM_RATIO),
                            b2Vec2(self.contentSize.width / PTM_RATIO, 0));
        groundBody->CreateFixture(&groundBox, 0);
        // bottom
        groundBox.SetAsEdge(b2Vec2_zero, b2Vec2(self.contentSize.width / PTM_RATIO, 0));
        groundBody->CreateFixture(&groundBox, 0);
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
#pragma mark Enemy

- (void)addEnemy
{
    CGPoint startingPosition = [[Environment sharedInstance] fromTopMiddleX:0.0f y:10.0f];
    Enemy *enemy = [Enemy enemyWithWorld:world ptmRatio:PTM_RATIO position:startingPosition];
    [self addChild:enemy];
}

#pragma mark -
#pragma mark Update

- (void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    [water startAnimating];
    [clouds startAnimations];
    [self scheduleUpdate];
    [self schedule:@selector(tick:)];
    [self addEnemy];
}

- (void)update:(ccTime)dt
{
    frontWater.position = [water frontWavePosition];
}

#pragma mark -
#pragma mark Handle touch events

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    CGPoint gestureLocation = [[CCDirector sharedDirector] convertToGL:[pinchGestureRecognizer locationInView:pinchGestureRecognizer.view]];
    b2Vec2 locationInWorld = b2Vec2(gestureLocation.x / PTM_RATIO, gestureLocation.y / PTM_RATIO);
    b2MouseJointDef mouseDef;
    switch (pinchGestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            self.currentBlob = [Blob blobWithWorld:world ptmRatio:PTM_RATIO position:gestureLocation];
            mouseDef.bodyA = groundBody;
            mouseDef.bodyB = self.currentBlob.body;
            mouseDef.target = locationInWorld;
            mouseDef.collideConnected = true;
            mouseDef.maxForce = 1000.0f * self.currentBlob.body->GetMass();
            mouseJoint = (b2MouseJoint *)world->CreateJoint(&mouseDef);
            self.currentBlob.body->SetAwake(true);
            self.currentBlob.scale = pinchGestureRecognizer.scale / 2.0f;
            [self.currentBlob setBodyPosition:gestureLocation];
            [self addChild:currentBlob];
            break;
        case UIGestureRecognizerStateChanged:
            mouseJoint->SetTarget(locationInWorld);
            self.currentBlob.scale = pinchGestureRecognizer.scale / 2.0f;
            [self.currentBlob setBodyPosition:gestureLocation];
            break;
        case UIGestureRecognizerStateEnded:
            if (mouseJoint)
            {
                // TODO:
                // for some reason this causes a crash
                //world->DestroyJoint(mouseJoint);
                mouseJoint = NULL;
            }
            self.currentBlob = nil;
            break;
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
            [self.currentBlob removeFromParentAndCleanup:YES];
            self.currentBlob = nil;
            if (mouseJoint)
            {
                world->DestroyJoint(mouseJoint);
                mouseJoint = NULL;
            }
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

#pragma mark -
#pragma mark Water actions

- (void)riseWaterWithAmount:(float)amount
{
    [water runAction:[CCMoveVerticalBy actionWithDuration:1.25f verticalPosition:amount]];
}

#pragma mark -
#pragma mark Physics

- (void)tick:(ccTime)dt
{
    int32 velocityIterations = 10;
    int32 positionIterations = 10;
    
    world->Step(dt, velocityIterations, positionIterations);
    
    for (b2Body *b = world->GetBodyList(); b; b = b->GetNext())
    {
        if (b->GetUserData() != NULL)
        {
            Box2DNode *body = (__bridge Box2DNode*)b->GetUserData();
            if([body isKindOfClass:[Blob class]])
            {
                b->ApplyForce(b2Vec2(world->GetGravity().x, world->GetGravity().y), b->GetPosition());
                Blob *blob = (Blob *)body;
                if (blob.position.y - (blob.contentSize.height / 2) <= water.position.y + (self.contentSize.height - kWaveOffset) && blob.reachedWater == NO)
                {
                    // for now, should probably calculate some kind of volume
                    float blobSize = blob.contentSize.height / 2;
                    blob.reachedWater = YES;
                    [self riseWaterWithAmount:blobSize];
                }
            }
            [body updatePhysics:dt];
        }
    }
}

#pragma mark -
#pragma mark Debug draw

- (void)draw
{
    [super draw];
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_COLOR_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    world->DrawDebugData();
    glEnable(GL_TEXTURE_2D);
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

- (void)dealloc
{
    delete world;
    world = NULL;
        
    delete m_debugDraw;
}

@end
