//
//  Blob.h
//  tigjam
//
//  Created by Jarod Luebbert on 10/21/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

@interface Blob : CCNode
{
    b2World *world;
    float ptmRatio;
    b2Body *body;
    b2Vec2 currentForce;
}

@property (nonatomic, assign) BOOL reachedWater;

- (b2Body *)body;
+ (Blob *)blobWithWorld:(b2World *)worldIn ptmRatio:(float)ptmRatioIn position:(CGPoint)positionIn;
- (id)initWithWorld:(b2World *)worldIn ptmRatio:(float)ptmRatioIn position:(CGPoint)positionIn;
- (void)updatePhysics:(ccTime)dt;

@end
