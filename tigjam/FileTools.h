//
//  FileTools.h
//  tigjam
//
//  Created by Jarod Luebbert on 10/21/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileTools : NSObject

+ (NSString *)fullPath:(NSString *)path;
+ (NSURL *)urlOfPath:(NSString *)path;
+ (bool)fileExists:(NSString *)path;

@end
