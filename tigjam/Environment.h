//
//  Environment.h
//  tigjam
//
//  Created by Jarod Luebbert on 10/21/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

#import "SynthesizeSingleton.h"

@interface Environment : NSObject

@property (nonatomic, assign) CGSize screenSize;

+ (Environment *)sharedInstance;
- (CGPoint)fromCenterX:(float)x y:(float)y;
- (CGPoint)fromBottomLeftX:(float)x y:(float)y;
- (CGPoint)fromBottomRightX:(float) x y:(float)y;
- (CGPoint)fromTopLeftX:(float)x y:(float)y;
- (CGPoint)fromTopRightX:(float)x y:(float)y;
- (CGPoint)fromTopMiddleX:(float)x y:(float)y;
- (CGPoint)fromBottomMiddleX:(float)x y:(float)y;
- (CGPoint)fromLeftMiddleX:(float)x y:(float)y;
- (CGPoint)fromRightMiddleX:(float)x y:(float)y;

@end
