//
//  Blob.m
//  tigjam
//
//  Created by Jarod Luebbert on 10/21/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

#import "Blob.h"
#import "RNG.h"
#import "CCNode+setContentSizeFromChildren.h"

#define kBlobSpriteFrameNameFormat @"blob_%d.png"
#define kBlobCount 5

@implementation Blob

@synthesize reachedWater;

+ (Blob *)blobWithWorld:(b2World *)worldIn ptmRatio:(float)ptmRatioIn position:(CGPoint)positionIn
{
    return [[self alloc] initWithWorld:worldIn ptmRatio:ptmRatioIn position:positionIn];
}

- (id)initWithWorld:(b2World *)worldIn ptmRatio:(float)ptmRatioIn position:(CGPoint)positionIn
{
    if ((self = [super init]))
    {
        int i = [[RNG sharedInstance] randomNumberFrom:0 to:kBlobCount - 1];
        CCSprite *blobSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:kBlobSpriteFrameNameFormat, i]];
        [self addChild:blobSprite];
        [self setContentSizeFromChildren];

        world = worldIn;
        ptmRatio = ptmRatioIn;
        self.position = positionIn;
        self.reachedWater = NO;
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        bodyDef.position.Set(positionIn.x / ptmRatioIn, positionIn.y / ptmRatioIn);
        bodyDef.userData = (__bridge void *)self;
        body = world->CreateBody(&bodyDef);
        b2PolygonShape boxShape;
        boxShape.SetAsBox((self.contentSize.width * 0.5) / ptmRatioIn, (self.contentSize.height * 0.5) / ptmRatioIn);
        b2FixtureDef boxShapeDef;
        boxShapeDef.shape = &boxShape;
        boxShapeDef.density = 1.0f;
        boxShapeDef.friction = 0.1f;
        boxShapeDef.restitution = 0.1f;
        body->CreateFixture(&boxShapeDef);
    }
    
    return self;
}

#pragma mark -
#pragma mark Physics

- (b2Body *)body
{
    return body;
}

- (void)setRotation:(float)rotationIn
{
    [super setRotation:rotationIn];
    body->SetTransform(body->GetPosition(), CC_DEGREES_TO_RADIANS(-rotationIn));
}

- (void)setScale:(float)scaleIn
{
    [super setScale:scaleIn];
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(body->GetPosition().x, body->GetPosition().y);
    bodyDef.userData = body->GetUserData();
    bodyDef.angle = body->GetAngle();
    world->DestroyBody(body);
    body = world->CreateBody(&bodyDef);
    b2PolygonShape boxShape;
    boxShape.SetAsBox((self.contentSize.width * 0.5 * scaleIn) / ptmRatio,
                      (self.contentSize.height * 0.5 * scaleIn) / ptmRatio);
    b2FixtureDef boxShapeDef;
    boxShapeDef.shape = &boxShape;
    boxShapeDef.density = 1.0f;
    boxShapeDef.friction = 0.1f;
    boxShapeDef.restitution = 0.1f;
    body->CreateFixture(&boxShapeDef);
}

- (void)updatePhysics:(ccTime)dt
{
    self.position = CGPointMake(body->GetPosition().x * ptmRatio, body->GetPosition().y * ptmRatio);
}

@end
