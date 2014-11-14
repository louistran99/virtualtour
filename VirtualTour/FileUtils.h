//
//  FileUtils.h
//  DbBridge
//
//  Created by John Huang on 3/19/14.
//  Copyright (c) 2014 Zillow Inc. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface FileUtils : NSObject {
    
}

+ (bool)fileExists:(NSString *)path;
+ (void)deleteFile:(NSString *)path;
+ (bool)copyFile:(NSString *)toPath from:(NSString *)fromPath;
+ (bool)moveFile:(NSString *)toPath from:(NSString *)fromPath;
+ (uint64_t)fileLength:(NSString *)path;
@end
