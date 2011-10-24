//
//  Enemy.m
//  tigjam
//
//  Created by Jarod Luebbert on 10/22/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

#import "Enemy.h"
#import "RNG.h"
#import "CCNode+setContentSizeFromChildren.h"

#define kEnemySpriteFrameName @"enemy.png"
#define kLinearVelocity 3.0f
#define kAngularVelocity 0.5f

@interface Enemy ()
@end

@implementation Enemy

+ (Enemy *)enemyWithWorld:(b2World *)worldIn ptmRatio:(float)ptmRatioIn position:(CGPoint)positionIn
{
    return [[self alloc] initWithWorld:worldIn ptmRatio:ptmRatioIn position:positionIn];
}

- (id)initWithWorld:(b2World *)worldIn ptmRatio:(float)ptmRatioIn position:(CGPoint)positionIn
{
    if ((self = [super initWithWorld:worldIn ptmRatio:ptmRatioIn position:positionIn]))
    {
        CCSprite *enemySprite = [CCSprite spriteWithSpriteFrameName:kEnemySpriteFrameName];
        [self addChild:enemySprite];
        [self setContentSizeFromChildren];
        self.position = positionIn;
        self.scale = 0.5f;
        
        b2BodyDef bodyDef;
        bodyDef.type = b2_dynamicBody;
        bodyDef.position.Set(self.position.x / ptmRatio, self.position.y / ptmRatio);
        bodyDef.userData = (__bridge void*)self;
        body = world->CreateBody(&bodyDef);
        b2CircleShape circleShape;
        circleShape.m_radius = (self.contentSize.height * self.scale * 0.5) / ptmRatio;
        b2FixtureDef circleShapeDef;
        circleShapeDef.shape = &circleShape;
        circleShapeDef.density = 1.0f;
        circleShapeDef.friction = 0.0f;
        circleShapeDef.restitution = 1.0f;
        body->CreateFixture(&circleShapeDef);
    }
    
    return self;
}

- (void)applyImpulse
{
    b2Vec2 force = b2Vec2([[RNG sharedInstance] randomFloatFrom:-kLinearVelocity to:kLinearVelocity],
                          [[RNG sharedInstance] randomFloatFrom:-kLinearVelocity to:kLinearVelocity]);
    body->ApplyLinearImpulse(force, body->GetPosition());
    body->ApplyAngularImpulse(kAngularVelocity);
}

- (void)updatePhysics:(ccTime)dt
{
    self.rotation = CC_RADIANS_TO_DEGREES(body->GetAngle());
    self.position = CGPointMake(body->GetPosition().x * ptmRatio, body->GetPosition().y * ptmRatio);
}

@end
