//
//  WaterLayer.h
//  tigjam
//
//  Created by Jarod Luebbert on 10/21/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

@interface WaterLayer : CCLayer

@property (nonatomic, assign) float opacity;

- (void)startAnimating;
- (CGPoint)frontWavePosition;

@end

@interface FrontWaterLayer : CCLayer
@end
