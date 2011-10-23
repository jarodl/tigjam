//
//  Blob.h
//  tigjam
//
//  Created by Jarod Luebbert on 10/21/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

#import "Box2DNode.h"

@interface Blob : Box2DNode

@property (nonatomic, assign) BOOL reachedWater;

+ (Blob *)blobWithWorld:(b2World *)worldIn ptmRatio:(float)ptmRatioIn position:(CGPoint)positionIn;
- (void)setBodyPosition:(CGPoint)position;

@end
