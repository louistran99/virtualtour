//
//  FileUtils.m
//  DbBridge
//
//  Created by John Huang on 3/19/14.
//  Copyright (c) 2014 Zillow Inc. All rights reserved.
//

#import "FileUtils.h"
#import <sys/xattr.h>

@implementation FileUtils

+ (bool)fileExists:(NSString *)path
{
	BOOL isDir = NO;
	return [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
	
}

+ (void)deleteFile:(NSString *)path
{
    if ([self fileExists:path])
    {
        NSError * error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }
}


+ (bool)copyFile:(NSString *)toPath from:(NSString *)fromPath
{
    if ([self fileExists:fromPath] && ![self fileExists:toPath])
    {
        return [[NSFileManager defaultManager] copyItemAtPath:fromPath toPath:toPath error:nil];
    }
    return false;
}

+ (bool)moveFile:(NSString *)toPath from:(NSString *)fromPath
{
    if ([self fileExists:fromPath] && ![self fileExists:toPath])
    {
        return [[NSFileManager defaultManager] copyItemAtPath:fromPath toPath:toPath error:nil];
    }
    return false;
    
}

+ (uint64_t)fileLength:(NSString *)path
{
    NSDictionary * fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSNumber * fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
    return fileSizeNumber.unsignedLongLongValue;
}
@end
