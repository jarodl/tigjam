//
//  Box2DNode.m
//  tigjam
//
//  Created by Jarod Luebbert on 10/22/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

#import "Box2DNode.h"

@implementation Box2DNode

- (id)initWithWorld:(b2World *)worldIn ptmRatio:(float)ptmRatioIn position:(CGPoint)positionIn
{
    if ((self = [super init]))
    {
        world = worldIn;
        ptmRatio = ptmRatioIn;
    }
    
    return self;
}

- (void)updatePhysics:(ccTime)dt
{
}

- (b2Body *)body
{
    return body;
}

- (void)dealloc
{
//    world->DestroyBody(body);
}

@end
