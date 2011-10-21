//
//  FileTools.m
//  MouseMadness
//
//  Created by Karl Stenerud on 10-02-12.
//

#import "FileTools.h"


@implementation FileTools

+ (NSString *)fullPath:(NSString *)path
{
	if ([path characterAtIndex:0] != '/')
	{
		return [[NSBundle mainBundle] pathForResource:[[path pathComponents] lastObject] ofType:nil];
	}
    
	return path;
}

+ (NSURL*)urlOfPath:(NSString *)path
{
	return [NSURL fileURLWithPath:[self fullPath:path]];
}

+ (bool)fileExists:(NSString *)path
{
	if ([path length] == 0)
	{
		return NO;
	}
	return [[NSFileManager defaultManager] fileExistsAtPath:[self fullPath:path]];
}

@end
