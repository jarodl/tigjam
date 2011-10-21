//
//  ImageLoader.h
//  tigjam
//
//  Created by Jarod Luebbert on 10/21/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

#import "cocos2d.h"
#import "SynthesizeSingleton.h"

@interface ImageLoader : NSObject

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(ImageLoader);

- (CCTexture2D *)imageWithFile:(NSString*)filename;
- (CCSpriteFrame *)frameWithFile:(NSString*)filename;
- (void)loadSpriteSheet:(NSString*)filename;
- (CCSprite *)spriteWithFile:(NSString*)filename;

@end
