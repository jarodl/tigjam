//
//  ImageLoader.m
//  tigjam
//
//  Created by Jarod Luebbert on 10/21/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

#import "ImageLoader.h"
#import "FileTools.h"
//#import "ErrorLogger.h"

@implementation ImageLoader

SYNTHESIZE_SINGLETON_FOR_CLASS(ImageLoader);

- (CCTexture2D *)imageWithFile:(NSString*)filename
{
	CCTexture2D *texture = nil;
	if([FileTools fileExists:filename])
	{
		texture = [[CCTextureCache sharedTextureCache] addImage:filename];
	}
	else
	{
//		LOG_ERROR(@"%@: Image not found", filename);
	}
	
	if(nil == texture)
	{
//		LOG_ERROR(@"%@: Failed to load image", filename);
	}
	
	return texture;
}

- (CCSpriteFrame *)frameWithFile:(NSString*)filename
{
	CCTexture2D* texture = [self imageWithFile:filename];
	if(nil != texture)
	{
		return [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(0, 0, texture.pixelsWide, texture.pixelsHigh)];
	}
	return nil;
}

- (CCSprite *)spriteWithFile:(NSString *)filename
{
	CCTexture2D* texture = [self imageWithFile:filename];
	if(nil != texture)
	{
        return [CCSprite spriteWithTexture:texture];
    }
    return nil;
}


- (void)loadSpriteSheet:(NSString *)name
{
    NSString* plistPath = [name stringByAppendingPathExtension:@"plist"];
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plistPath];
}

@end
