//
//  Box2DNode.h
//  tigjam
//
//  Created by Jarod Luebbert on 10/22/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

#import "CCNode.h"

@interface Box2DNode : CCNode
{
    b2World *world;
    b2Body *body;
    float ptmRatio;
}

- (id)initWithWorld:(b2World *)worldIn ptmRatio:(float)ptmRatioIn position:(CGPoint)positionIn;
- (void)updatePhysics:(ccTime)dt;
- (b2Body *)body;

@end
