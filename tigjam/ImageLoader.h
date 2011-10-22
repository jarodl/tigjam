//
//  ImageLoader.h
//  tigjam
//
//  Created by Jarod Luebbert on 10/21/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

#import "cocos2d.h"

@interface ImageLoader : NSObject

+ (id)sharedInstance;
- (CCTexture2D *)imageWithFile:(NSString*)filename;
- (CCSpriteFrame *)frameWithFile:(NSString*)filename;
- (void)loadSpriteSheet:(NSString*)filename;
- (CCSprite *)spriteWithFile:(NSString*)filename;

@end
