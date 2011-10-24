//
//  Enemy.h
//  tigjam
//
//  Created by Jarod Luebbert on 10/22/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

#import "Box2DNode.h"

@interface Enemy : Box2DNode

+ (Enemy *)enemyWithWorld:(b2World *)worldIn ptmRatio:(float)ptmRatioIn position:(CGPoint)positionIn;
- (void)applyImpulse;

@end
