//
//  TDDownloadManager.h
//  TDDownloadManager
//
//  Created by Robin Hsu on 2015/3/4.
//  Copyright (c) 2015年 TechD. All rights reserved.
//
//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "TDFoundation.h"

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
//- ( NSString * ) TDGetCurrentFile:(NSString *)filename in:(NSString *)subpath of:(TDGetPathDirectory)directory;
NSString * TDGetCurrentFilePathWithUpdate( NSString * filename, NSString * subpath, TDGetPathDirectory directory, NSString * updateFilename, NSString * updateSubpath, TDGetPathDirectory updateDirectory, NSString * updateTimestamp );

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
@interface TDDownloadManager : NSObject

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) simpleDownload:(NSString *)downloadURL forDirectory:(NSSearchPathDirectory)directory;

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
//  have the same filename in the destation, will not to cover(download).b
+ ( BOOL ) download:(NSString *)filename from:(NSString *)fileURL into:(NSString *)subpath of:(TDGetPathDirectory)directory updateCheckBy:(NSString *)timestamp;

//  ------------------------------------------------------------------------------------------------
//  ... a simple new method, download & always cover the file.
+ ( BOOL ) replacementDownload:(NSString *)filename from:(NSString *)fileURL into:(NSString *)subpath of:(TDGetPathDirectory)directory;

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) readJSONFile:(NSString *)jsonURL compeleted:( void(^)( NSDictionary * jsonContent, NSError * error ) )compeleted;

//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) readJSONFile:(NSString *)jsonURL
               withSave:(NSString *)filename into:(NSString *)subpath of:(TDGetPathDirectory)directory extension:(NSString *)timestamp
             compeleted:( void(^)( NSDictionary * jsonContent, NSError * error, BOOL finished ) )compeleted;

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


@end

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
