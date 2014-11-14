//
//  DirectoryUtils.m
//  DbBridge
//
//  Created by John Huang on 3/19/14.
//  Copyright (c) 2014 Zillow Inc. All rights reserved.
//


#import "DirectoryUtils.h"
#import "FileUtils.h"

@implementation DirectoryUtils

+ (NSString *) getUserFolder
{
	return NSHomeDirectory();
}

+ (NSString *) getUserSubfolder:(NSString *)path
{
    return [[self getUserFolder] stringByAppendingPathComponent:path];
}

+ (NSString *) getDocumentFolder
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString *) getDocumentSubfolder:(NSString *)path
{
    return [[self getDocumentFolder] stringByAppendingPathComponent:path];
}

+ (NSString *) getLibraryFolder
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString * libraryDirectory = [paths objectAtIndex:0];
    return libraryDirectory;
}

+ (NSString *) getLibrarySubfolder:(NSString *)path
{
    return [[self getLibraryFolder] stringByAppendingPathComponent:path];
}


+ (NSString *) getDownloadFolder
{
    NSString * folder = [self getCacheSubfolder:@"Downloads"];
    [self ensureFolderExist:folder];
    return folder;
}

+ (NSString *) getDownloadSubfolder:(NSString *)path
{
    NSString * folder =  [[self getDownloadFolder] stringByAppendingPathComponent:path];
    [self ensureFolderExist:folder];
    return folder;
}

+ (NSString *) getTempFolder
{
    NSString * folder = NSTemporaryDirectory();
    if (folder)
    {
        return folder;
    }
    else
    {
        return [DirectoryUtils getDocumentFolder];
    }
}

+ (NSString *) getTempSubfolder:(NSString *)path
{
    return [[self getTempFolder] stringByAppendingPathComponent:path];
}

+ (NSString *) getCacheFolder
{
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return cachePath;
}

+ (NSString *) getCacheSubfolder:(NSString *)path
{
    NSString * folder = [[self getCacheFolder] stringByAppendingPathComponent:path];
    [self ensureFolderExist:folder];
    return folder;
}

+ (NSString *) getBundleFolder
{
	NSBundle * bundle = [NSBundle mainBundle];
	return [bundle bundlePath];
}

+ (NSString *) getBundleSubfolder:(NSString *)path
{
    return [[self getBundleFolder] stringByAppendingPathComponent:path];
}

+ (NSString *) getPicturesFolder
{
	return [DirectoryUtils getUserSubfolder:@"Pictures"];
}

+ (NSString *) getCameraRollFolder
{
	return @"/var/mobile/Media/DCIM";
    //	return [DirectoryUtils getUserSubfolder:@"Pictures"];
    //	return [NSString stringWithFormat:@"/var/mobile/Media/DCIM"];
}

+ (NSArray *)foldersIn:(NSString *)path
{
    NSArray * array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    if (array)
    {
        NSMutableArray * folders = [NSMutableArray array];
        
        for (NSString * child in array)
        {
            NSString * fullPath = [path stringByAppendingPathComponent:child];
            if ([DirectoryUtils isFolder:fullPath])
            {
                [folders addObject:fullPath];
            }
        }
        return folders;
    }
    else
    {
        return nil;
    }
}

+ (NSArray *)filesIn:(NSString *)path extension:(NSString *)extension
{
    NSArray * array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    if (array)
    {
        NSMutableArray * files = [NSMutableArray array];
        NSString * extensionUpper = nil;
        if (extension)
        {
            extensionUpper = [extension uppercaseString];
        }
        
        for (NSString * child in array)
        {
            NSString * fullPath = [path stringByAppendingPathComponent:child];
            if (![DirectoryUtils isFolder:fullPath])
            {
                if (extensionUpper)
                {
                    if ([[[child pathExtension] uppercaseString] isEqualToString:extensionUpper])
                    {
                        [files addObject:fullPath];
                    }
                }
                else
                {
                    [files addObject:fullPath];
                }
            }
        }
        return files;
    }
    else
    {
        return nil;
    }
    
}

+ (bool) isFolder:(NSString *)path
{
	BOOL isDir = NO;
	[[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
	return isDir;
}

+ (bool)folderExist:(NSString *)path
{
	BOOL isDir = NO;
	bool exist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
	return (exist && isDir);
}

+ (NSString *)parentFolder:(NSString *)path
{
	return [path stringByDeletingLastPathComponent];
}

+ (bool)ensureFolderExist:(NSString *)path
{
	if (path == nil || [path isEqualToString:@"/"])
	{
		return true;
	}
	else
	{
		BOOL isDir = NO;
		bool exist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
		if (exist)
		{
			return true;
		}
		else
		{
			NSString * parent = [self parentFolder:path];
			if ([self ensureFolderExist:parent])
			{
				return [[NSFileManager defaultManager] createDirectoryAtPath:path
												 withIntermediateDirectories:true attributes:nil error:nil];
			}
			return false;
		}
	}
}

+ (void)deleteFolder:(NSString *)folder
{
    NSError * error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:folder error:&error];
}

@end
