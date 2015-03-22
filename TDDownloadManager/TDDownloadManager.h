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
#pragma mark declare for get path.
//  ------------------------------------------------------------------------------------------------
/**
 *  @brief get a file's full path when the file can update data from URL.
 *  get a file's full path when the file can update data from URL.
 *  if can find the update's file in the update's directory then assign it to the current path, otherwise assign from original.
 *
 *  @param filename                 a original filename.
 *  @param subpath                  the original file's subpath of directory.
 *  @param directory                the original file's enumeration for directory.
 *  @param updateFilename           a update's filename.
 *  @param updateSubpath            the update's file's subpath of directory.
 *  @param updateDirectory          the update's file's enumeration of directory.
 *  @param updateTimestamp          the file update condition that was check for integer type.
 *
 *  @return filename|nil            a current filename with full path or nil.
 */
NSString * TDGetCurrentFilePathWithUpdate( NSString * filename, NSString * subpath, TDGetPathDirectory directory, NSString * updateFilename, NSString * updateSubpath, TDGetPathDirectory updateDirectory, NSString * updateTimestamp );

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------



//  ------------------------------------------------------------------------------------------------
//  the Download Manager provide method simply download data from URL;
//  build this object base on AFNetworking.
//  ------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark class TDDownloadManager
@interface TDDownloadManager : NSObject

//  ------------------------------------------------------------------------------------------------
#pragma mark declare for download file.
//  ------------------------------------------------------------------------------------------------
/**
 *  @brief download a file from URL and save the file to directory.
 *  download a file from URL and save the file to directory that is enumeration for directory.
 *
 *  @param downloadURL              the URL of file at internet.
 *  @param directory                enumeration for directory.
 *
 *  @return YES|NO                  method success or failure.
 */
+ ( BOOL ) simpleDownload:(NSString *)downloadURL forDirectory:(NSSearchPathDirectory)directory;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief download a file from URL and save the file to directory.
 *  download a file from URL and save the file to directory which these parameters is path condition for append;
 *  if find the same filename in the directory, don't download.
 *
 *  @param filename                 save filename.
 *  @param fileURL                  the URL of file at internet.
 *  @param subpath                  the subpath of directory.
 *  @param directory                enumeration for directory.
 *  @param timestamp                the file update condition that was check for integer type.
 *
 *  @return YES|NO                  method success or failure.
 */
+ ( BOOL ) download:(NSString *)filename from:(NSString *)fileURL into:(NSString *)subpath of:(TDGetPathDirectory)directory updateCheckBy:(NSString *)timestamp;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief download a file from URL and save the file to directory.
 *  download a file from URL and save the file to directory which these parameters is path condition for append.
 * if find the same filename in the directory, download and replace it.
 *
 *  @param filename                 save filename.
 *  @param fileURL                  the URL of file at internet.
 *  @param subpath                  the subpath of directory
 *  @param directory                enumeration for directory.
 *
 *  @return YES|NO                  method success or failure.
 */
+ ( BOOL ) replacementDownload:(NSString *)filename from:(NSString *)fileURL into:(NSString *)subpath of:(TDGetPathDirectory)directory;

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
//  --------------------------------
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













