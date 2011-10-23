//
//  Enemy.m
//  tigjam
//
//  Created by Jarod Luebbert on 10/22/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

#import "Enemy.h"
#import "CCNode+setContentSizeFromChildren.h"

#define kEnemySpriteFrameName @"enemy.png"

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
        circleShapeDef.friction = 0.1f;
        circleShapeDef.restitution = 0.1f;
        body->CreateFixture(&circleShapeDef);
    }
    
    return self;
}

- (void)updatePhysics:(ccTime)dt
{
    self.position = CGPointMake(body->GetPosition().x * ptmRatio, body->GetPosition().y * ptmRatio);
}

@end
