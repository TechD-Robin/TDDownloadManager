//
//  TDDownloadManager.m
//  TDDownloadManager
//
//  Created by Robin Hsu on 2015/3/4.
//  Copyright (c) 2015年 TechD. All rights reserved.
//

#import "TDDownloadManager.h"

#import "AFNetworking.h"
#import "TDFoundation.h"

@implementation TDDownloadManager


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) download:(NSString *)urlString
{
    if ( nil == urlString )
    {
        return NO;
    }
    
    NSURL                         * url;
    NSURLRequest                  * urlRequest;
    NSURLSessionConfiguration     * configuration;
    NSURLSessionDownloadTask      * downloatTask;
    AFURLSessionManager           * manager;
    
    url                             = [NSURL URLWithString: urlString];
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
        NSString                  * downloadFilename;
        NSString                  * file;
        NSString                  * extension;
        NSURL                     * destationURL;
        
        destationURL                = nil;
        downloadFilename            = [response suggestedFilename];
        if ( nil == downloadFilename )
        {
            //  do something ...
            return nil;
        }
        
        file                        = [downloadFilename stringByDeletingPathExtension];
        extension                   = [downloadFilename pathExtension];
        downloadFilename            = TDGetPathForDirectories( TDTemporaryDirectory, file, extension, file );
        if ( nil == downloadFilename )
        {
            //  do something ...
            return nil;
        }
        
        destationURL                = [NSURL URLWithString: downloadFilename];
        return destationURL;
    }
    completionHandler:  ^( NSURLResponse * response, NSURL * filePath, NSError * error )
    {
        ;
    }];
    
    
    
    
    
    return YES;
}
//  --------------------------------

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


@end

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------



