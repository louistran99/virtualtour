//
//  DirectoryUtils.h
//  DbBridge
//
//  Created by John Huang on 3/19/14.
//  Copyright (c) 2014 Zillow Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DirectoryUtils : NSObject
{
}

+ (NSString *) getUserFolder;
+ (NSString *) getUserSubfolder:(NSString *)path;

+ (NSString *) getDocumentFolder;
+ (NSString *) getDocumentSubfolder:(NSString *)path;

+ (NSString *) getLibraryFolder;
+ (NSString *) getLibrarySubfolder:(NSString *)path;

+ (NSString *) getDownloadFolder;
+ (NSString *) getDownloadSubfolder:(NSString *)path;

+ (NSString *) getCacheFolder;
+ (NSString *) getCacheSubfolder:(NSString *)path;

+ (NSString *) getTempFolder;
+ (NSString *) getTempSubfolder:(NSString *)path;

+ (NSString *) getBundleFolder;
+ (NSString *) getBundleSubfolder:(NSString *)path;

+ (NSString *) getPicturesFolder;

+ (NSString *) getCameraRollFolder;

+ (NSArray *)foldersIn:(NSString *)path;
+ (NSArray *)filesIn:(NSString *)path extension:(NSString *)extension;

+ (bool)isFolder:(NSString *)path;

+ (bool)folderExist:(NSString *)path;
+ (NSString *)parentFolder:(NSString *)path;
+ (bool)ensureFolderExist:(NSString *)path;

+ (void)deleteFolder:(NSString *)folder;


@end
