//
//  TDDownloadManager.m
//  TDDownloadManager
//
//  Created by Robin Hsu on 2015/3/4.
//  Copyright (c) 2015年 TechD. All rights reserved.
//

#import "TDDownloadManager.h"

#import "AFNetworking.h"
#import "Foundation+TechD.h"


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
//+ ( BOOL ) _SearchUpdate:(NSString *)destationFile in:(NSString *)path with:(NSString *)timestamp
BOOL _SearchUpdateFile( NSString * destationFile, NSString * path, NSString * timestamp )
{
    if ( ( nil == destationFile ) || ( nil == path ) )
    {
        return NO;
    }
    
    BOOL                            isDir;
    NSFileManager                 * manager;
    NSArray                       * list;
    NSArray                       * fileSeparated;
    NSArray                       * destFileSeparated;
    NSString                      * fileExtension;
    NSDictionary                  * attributes;
    NSError                       * error;
    
    error                           = nil;
    fileSeparated                   = nil;
    destFileSeparated               = nil;
    fileExtension                   = nil;
    manager                         = [NSFileManager defaultManager];
    list                            = [manager contentsOfDirectoryAtPath: path error: &error];
    attributes                      = [manager attributesOfFileSystemForPath: path error: &error];
    
    NSLog( @"list: %@", list  );
    for ( NSString * file in list )
    {
        if ( nil == file )
        {
            continue;
        }
        
        //  if unuse timestamp to compare, when find the file then skip download the file.
        if ( ( nil == timestamp ) || ( [timestamp length] == 0 ) || ( [timestamp isNumeric] == NO ) )
        {
            //if ( [file isEqualToString: destationFile] == NO )
            if ( [[file lowercaseString] isEqualToString: [destationFile lowercaseString]] == NO )
            {
                continue;
            }
            
            isDir                   = NO;
            if ( [manager fileExistsAtPath: [path stringByAppendingPathComponent: file] isDirectory: &isDir] == YES )
            {
                if ( NO == isDir )
                {
                    //  when filename is equal and isn't dir.
                    return NO;              //  skip to download.
                }
                return YES;                 //  when file is not found in list, must download.
            }
            continue;
        }
        
        
        fileSeparated               = [file componentsSeparatedByString: @"."];
        destFileSeparated           = [destationFile componentsSeparatedByString: @"."];
        if ( ( ( nil == fileSeparated ) || ( nil == destFileSeparated ) ) || ( [fileSeparated count] != ( [destFileSeparated count] + 1 ) ) )
        {
            continue;
        }
        
        switch ( [fileSeparated count] )
        {
            case 0:
            {
                continue;                   //  maybe has error...
            }
                
            case 1:
            {
                //  because use timestamp to compare, must download the file in any case.
                continue;
            }
            default:
            {
                if ( [[[file stringByDeletingPathExtension] lowercaseString] isEqualToString: [destationFile lowercaseString]] == NO )
                {
                    continue;
                }
                
                fileExtension       = [file pathExtension];
                if ( ( nil == fileExtension ) || ( [fileExtension length] == 0 ) || ( [fileExtension isNumeric] == NO ) )
                {
                    continue;
                }
                
                //  compare both timestamp, if can find a file's timestamp equal or more then input's timestamp, don't download.
                if ( [fileExtension integerValue] >= [timestamp integerValue] )
                {
                    return NO;              //  not need to download.
                }
                break;
            }
        }
    }   //  End of  for ( NSString * file in list ).
    
    return YES;         //  must download.
}


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
NSURL * _PreSaveProcedure( NSURLResponse * response, NSString * subpath )
{
    if ( nil == response )
    {
        return nil;
    }
    
    NSString                      * downloadFile;
    NSString                      * downloadPath;
    NSURL                         * downloadURL;
    NSFileManager                 * manager;
    NSError                       * error;
    
    error                           = nil;
    downloadURL                     = nil;
    manager                         = [NSFileManager defaultManager];
    downloadFile                    = [response suggestedFilename];
    downloadPath                    = ( ( ( nil == subpath ) || ( [subpath length] == 0 ) ) ? @"downloads" :  [@"downloads" stringByAppendingPathComponent: subpath] );
    if ( nil == downloadFile )
    {
        return nil;
    }
    
    downloadFile                    = TDGetPathForDirectories( TDTemporaryDirectory, [downloadFile stringByDeletingPathExtension], [downloadFile pathExtension], downloadPath, NO );
    if ( nil == downloadFile )
    {
        return nil;
    }

    //  when file exist, delete it.
    if ( [manager fileExistsAtPath: downloadFile] == YES )
    {
        if ( [manager removeItemAtPath: downloadFile error: &error] == NO )
        {
            NSLog( @"remove file error : %@ ", error );
        }
    }
    
    //  pre-create subpath on here, because AFNetwork's  download task save the download's file without create subpath of temporary directory. That's failure for download.
    if ( [manager fileExistsAtPath: [downloadFile stringByDeletingLastPathComponent]] == NO )
    {
        error                       = nil;
        if ( [manager createDirectoryAtPath: [downloadFile stringByDeletingLastPathComponent] withIntermediateDirectories: YES attributes: nil error: &error] == NO )
        {
            NSLog( @"create sub path error : %@", error );
        }
    }

    //  set to NSURL.
    downloadFile                    = [@"file://" stringByAppendingString: downloadFile];
    downloadURL                     = [NSURL URLWithString: downloadFile];
    return downloadURL;
}

//  ------------------------------------------------------------------------------------------------
BOOL _UpdateFileToCurrentDirectory( NSURL * sourceURL, NSString * destationFile, BOOL coverOldFile )
{
    //  when destation data warning,  skip move file.
    if ( ( nil == destationFile ) || ( [destationFile length] == 0 ) )
    {
        return NO;
    }
    
    NSURL                         * destationURL;
    NSFileManager                 * manager;
    NSError                       * error;

    error                           = nil;
    manager                         = [NSFileManager defaultManager];
    //  create subpath on here, when path not exist.
    if ( [manager fileExistsAtPath: [destationFile stringByDeletingLastPathComponent]] == NO )
    {
        if ( [manager createDirectoryAtPath: [destationFile stringByDeletingLastPathComponent] withIntermediateDirectories: YES attributes: nil error: &error] == NO )
        {
            NSLog( @"create destation path error : %@", error );
            return NO;
        }
    }

    //  when must cover older file.
    if ( ( YES == coverOldFile ) && ( [manager fileExistsAtPath: destationFile] == YES ) )
    {
        error                       = nil;
        if ( [manager removeItemAtPath: destationFile error: &error] == NO )
        {
            NSLog( @"delete file error : %@", error );
        }
    }
    
    //  move file.
    error                           = nil;
    //  iOS file system's letter is not to differentiate between lowercase and uppercase, so always set to lowercase.
    destationFile                   = [destationFile lowercaseString];
    destationFile                   = [@"file://" stringByAppendingString: destationFile];
    destationURL                    = [NSURL URLWithString: destationFile];
    if ( nil == destationURL )
    {
        return NO;
    }
    
    if ( [manager moveItemAtURL: sourceURL toURL: destationURL error: &error] == NO )
    {
        NSLog( @"move file error : %@", error );
    }
    return YES;
}

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark class TDNetworkReachabilityManager


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark declare private category (Private)
//  ------------------------------------------------------------------------------------------------
@interface TDDownloadManager (Private)

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) _DownloadProcedure:(NSString *)destationFile from:(NSString *)fileURL into:(NSString *)subpath coverOlder:(BOOL)coverOlder;


//  ------------------------------------------------------------------------------------------------

@end


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark implementation private category (Private)
//  ------------------------------------------------------------------------------------------------
@implementation TDDownloadManager (Private)

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) _DownloadProcedure:(NSString *)destationFile from:(NSString *)fileURL into:(NSString *)subpath coverOlder:(BOOL)coverOlder
{
    if ( ( nil == destationFile ) || ( nil == fileURL ) || ( nil == subpath ) )
    {
        return NO;
    }
    
    
    NSURL                         * url;
    NSURLRequest                  * urlRequest;
    NSURLSessionConfiguration     * configuration;
    NSURLSessionDownloadTask      * downloatTask;
    AFURLSessionManager           * manager;
    
    url                             = [NSURL URLWithString: fileURL];
    configuration                   = [NSURLSessionConfiguration defaultSessionConfiguration];
    downloatTask                    = nil;
    manager                         = nil;
    if ( ( nil == url ) || ( nil == configuration ) )
    {
        return NO;
    }
    
    urlRequest                      = [NSURLRequest requestWithURL: url];
    manager                         = [[AFURLSessionManager alloc] initWithSessionConfiguration: configuration];
    if ( ( nil == urlRequest ) || ( nil == manager ) )
    {
        return NO;
    }
    
    downloatTask                    = [manager downloadTaskWithRequest: urlRequest progress: nil destination: ^NSURL * ( NSURL * targetPath, NSURLResponse * response )
    {
        //  這邊修正成, 在 tmp 目錄下產生一個 downloads 目錄, 然後先去檢查該目錄是否存在, 不存在則產生, 在檢查裡頭是否已經存在預定存放的檔案, 如果已經存在則移除.
        //    這樣就能完整控制下載後的檔案, 一定會是最新的 ... 因為會持續被刪除 ...
        return _PreSaveProcedure( response, subpath );
   }
   completionHandler:  ^( NSURLResponse * response, NSURL * filePath, NSError * error )
   {
        //  然後在這個地方, 再把已經存好的檔案, 移動到預定應該擺放的位置或目錄底下; 擺放的同時 一樣進行目錄產生 然後在移動剛剛下載完成的檔案.
        _UpdateFileToCurrentDirectory( filePath, destationFile, coverOlder );
   }];
    
    [downloatTask                   resume];
    
    return YES;
}

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


@end

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark implementation for public
//  ------------------------------------------------------------------------------------------------
@implementation TDDownloadManager

//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) simpleDownload:(NSString *)downloadURL forDirectory:(NSSearchPathDirectory)directory;
{
    if ( nil == downloadURL )
    {
        return NO;
    }
    
    NSURL                         * url;
    NSURLRequest                  * urlRequest;
    NSURLSessionConfiguration     * configuration;
    AFURLSessionManager           * manager;
    NSURLSessionDownloadTask      * downloatTask;
    
    downloatTask                    = nil;
    manager                         = nil;
    url                             = [NSURL URLWithString: downloadURL];
    configuration                   = [NSURLSessionConfiguration defaultSessionConfiguration];
    if ( ( nil == url ) || ( nil == configuration ) )
    {
        return NO;
    }
    
    urlRequest                      = [NSURLRequest requestWithURL: url];
    manager                         = [[AFURLSessionManager alloc] initWithSessionConfiguration: configuration];
    if ( ( nil == urlRequest ) || ( nil == manager ) )
    {
        return NO;
    }
    
    downloatTask                    = [manager downloadTaskWithRequest: urlRequest progress: nil destination: ^NSURL * ( NSURL * targetPath, NSURLResponse * response )
    {
        NSURL                     * directoryURL;
        
        directoryURL                = [[NSFileManager defaultManager] URLForDirectory: directory inDomain: NSUserDomainMask appropriateForURL: nil create: NO error: nil];
        if ( nil == directoryURL )
        {
            return nil;
        }
        return [directoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    }
    completionHandler:  ^( NSURLResponse * response, NSURL * filePath, NSError * error )
    {
        NSLog( @"filish download : %@", filePath );
    }];
    
    [downloatTask                   resume];
    return YES;
}

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) download:(NSString *)filename from:(NSString *)fileURL into:(NSString *)subpath of:(TDGetPathDirectory)directory updateCheckBy:(NSString *)timestamp
{
    if ( ( nil == filename ) || ( nil == fileURL ) || ( nil == subpath ) )
    {
        return NO;
    }
    
    BOOL                            download;
    NSString                      * destationFilename;
    
    download                        = NO;
    destationFilename               = nil;
    destationFilename               = TDGetPathForDirectoriesWithTimestamp( directory, [filename stringByDeletingPathExtension], timestamp, [filename pathExtension], subpath, NO );
    if ( nil == destationFilename )
    {
        return NO;
    }
    
    download                        = _SearchUpdateFile( filename, [destationFilename stringByDeletingLastPathComponent], timestamp );
    if ( NO == download )
    {
        NSLog( @"already have a latest file in the directory." );
        return YES;
    }
    
    return [TDDownloadManager _DownloadProcedure: destationFilename from: fileURL into: subpath coverOlder: NO];;
}

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) replacementDownload:(NSString *)filename from:(NSString *)fileURL into:(NSString *)subpath of:(TDGetPathDirectory)directory
{
    if ( ( nil == filename ) || ( nil == fileURL ) || ( nil == subpath ) )
    {
        return NO;
    }
    
    NSString                      * destationFilename;
    
    destationFilename               = nil;
    destationFilename               = TDGetPathForDirectories( directory, [filename stringByDeletingPathExtension], [filename pathExtension], subpath, NO );
    if ( nil == destationFilename )
    {
        return NO;
    }
    
    return [TDDownloadManager _DownloadProcedure: destationFilename from: fileURL into: subpath coverOlder: YES];
}
//  ------------------------------------------------------------------------------------------------


@end

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
















