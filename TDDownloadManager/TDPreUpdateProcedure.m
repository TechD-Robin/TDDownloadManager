//
//  TDPreUpdateProcedure.m
//  TDDownloadManager
//
//  Created by Robin Hsu on 2015/3/25.
//  Copyright (c) 2015年 TechD. All rights reserved.
//
//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


#import "TDPreUpdateProcedure.h"

#import "TDNetworkReachabilityManager.h"
#import "TDDownloadManager.h"

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark class TDPreUpdateProcedure

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark declare private category ()
//  ------------------------------------------------------------------------------------------------
@interface TDPreUpdateProcedure ()
{
    NSString                      * configureUpdateURL;
    
    
    NSString                      * configureFilename;          //  filename with full path.
    
    TDGetPathDirectory              configureDirectory;
    NSString                      * configureSubpath;          //  full path.
    
    NSDictionary                  * configureData;
    
}

//  ------------------------------------------------------------------------------------------------

@end


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark declare private category (Private)
//  ------------------------------------------------------------------------------------------------
@interface TDPreUpdateProcedure (Private)

//  ------------------------------------------------------------------------------------------------
#pragma mark declare for initial this class.
//  ------------------------------------------------------------------------------------------------
/**
 *  @brief initial the attributes of class.
 *  initial the attributes of class.
 */
- ( void ) _InitAttributes;

//  ------------------------------------------------------------------------------------------------
#pragma mark declare for configure data's action
//  ------------------------------------------------------------------------------------------------
/**
 *  @brief load configure data from local file(ios device).
 *  load configure data from local file(ios device).
 *
 *  @return YES|NO                  method success or failure.
 */
- ( BOOL ) _LoadConfigureDataFromFile;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief check device' network is reachable or not, with the device to the URL's 'domain'.
 *  check device' network is reachable or not, with the device to the URL's 'domain'.
 *
 *  @param reachableBlock           a reachable block section to be executed when check finish.
 */
- ( void ) _CheckNetworkReachable:(ReachableStatusBlock)reachableBlock;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief download configure data from the URL and assign the data into the container.
 *  download configure data from the URL and assign the data into the container.
 *
 *  @param completed                a completed block section to be executed when download finish.
 */
- ( void ) _PreDownloadSystemConfigure:(void(^)(BOOL finished) )completed;

//  ------------------------------------------------------------------------------------------------
#pragma mark declare for update from configure data
//  ------------------------------------------------------------------------------------------------
/**
 *  @brief execute update procedure with configure data.
 *  execute update procedure with configure data when find the data of keys.
 *
 *  @param keyList                  a list of keys.
 *
 *  @return YES|NO                  method success or failure.
 */
- ( BOOL ) _UpdateProcedure:(NSArray *)keyList;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief check and download data with the configure data.
 *  check and download data with the configure data.
 *
 *  @param updateInfo               a configure data for key.
 *
 *  @return YES|NO                  method success or failure.
 */
- ( BOOL ) _UpdateDataWith:(NSDictionary *)updateInfo;

//  ------------------------------------------------------------------------------------------------

@end


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark implementation private category (Private)
//  ------------------------------------------------------------------------------------------------
@implementation TDPreUpdateProcedure (Private)

//  ------------------------------------------------------------------------------------------------
#pragma mark method for initial this class.
//  ------------------------------------------------------------------------------------------------

- ( void ) _InitAttributes
{
    configureUpdateURL              = nil;
    configureFilename               = nil;
    
    configureDirectory              = TDTemporaryDirectory;
    configureSubpath                = nil;
    
    configureData                   = nil;
}

//  ------------------------------------------------------------------------------------------------
#pragma mark method for configure data's action
//  ------------------------------------------------------------------------------------------------
- ( BOOL ) _LoadConfigureDataFromFile
{
    NSString                      * json;
    NSError                       * error;
    
    error                           = nil;
    json                            = [NSString stringWithContentsOfFile: configureFilename encoding: NSUTF8StringEncoding error: &error];
    if ( nil != error )
    {
        return NO;
    }
    
    error                           = nil;
    configureData                   = [NSJSONSerialization JSONObjectWithData: [json dataUsingEncoding: NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &error];
    if ( nil != error )
    {
        return NO;
    }
    return YES;
}

//  ------------------------------------------------------------------------------------------------
- ( void ) _CheckNetworkReachable:(ReachableStatusBlock)reachableBlock;
{
    ReachableStatusBlock            networkReachableBlock;
    ReachableStatusBlock            domainReachableBlock;

    
    //  third, return network reachable status.
    domainReachableBlock            = ^(BOOL isReachable)
    {
        if ( nil != reachableBlock )
        {
            reachableBlock( isReachable );
        }
    };
    
    //  second, check reachability from this device to URL.
    networkReachableBlock           = ^(BOOL isReachable)
    {
        if ( NO == isReachable )
        {
            if ( nil != reachableBlock )
            {
                reachableBlock( isReachable );
            }
            return;
        }
        
        NSURL                     * url;
        
        url                         = [NSURL URLWithString: configureUpdateURL];
        if ( nil == url )
        {
            return;
        }
        
        [TDNetworkReachabilityManager checkReachabilityStatusForDomain: [url host] result: domainReachableBlock];
    };
    
    //  first, check network reachability.
    [TDNetworkReachabilityManager  checkNetworkReachabilityStatus: networkReachableBlock];
    
    return;
}

//  ------------------------------------------------------------------------------------------------
- ( void ) _PreDownloadSystemConfigure:(void(^)(BOOL finished) )completed
{
    ReadJSONCompletedCallbackBlock  readJSONCallbackBlock;
    
    //  get JSON data from container.
    readJSONCallbackBlock           = ^(NSDictionary * jsonContent, NSError * error, BOOL finished)
    {
        if ( NO == finished )
        {
            //  load confiure from local file.
            [self                   _LoadConfigureDataFromFile];
            if ( nil != completed )
            {
                completed( finished );
            }
            return;
        }
        
        //  get data from jsonContent.
        configureData               = jsonContent;
        if ( nil != completed )
        {
            completed( finished );
        }
    };
    
    [self                           _CheckNetworkReachable: ^(BOOL isReachable)
    {
        if ( NO == isReachable )
        {
            if ( nil != completed )
            {
                completed( isReachable );
            }
            return;
        }
        
        //  get json data from url.
        [TDDownloadManager          readJSONFile: configureUpdateURL withSaveInto: configureFilename completed: readJSONCallbackBlock];
    }];
}


//  ------------------------------------------------------------------------------------------------
#pragma mark method for update from configure data
//  ------------------------------------------------------------------------------------------------
- ( BOOL ) _UpdateProcedure:(NSArray *)keyList
{
    if ( ( nil == keyList ) || ( [keyList count] == 0 ) )
    {
        return NO;
    }
    
    NSString                      * aKey;
    NSDictionary                  * infoData;
    
    
    for ( int i = 0; i < [keyList count]; ++i )
    {
        aKey                        = [keyList objectAtIndex: i];
        if ( nil == aKey )
        {
            continue;
        }
        
        infoData                    = [configureData objectForKey: aKey];
        if ( nil == infoData )
        {
            continue;
        }
        [self                       _UpdateDataWith: infoData];
        
    }
 
    return YES;
}

//  ------------------------------------------------------------------------------------------------
- ( BOOL ) _UpdateDataWith:(NSDictionary *)updateInfo
{
    if ( ( nil == updateInfo ) || ( [updateInfo count] == 0 ) )
    {
        return NO;
    }
    
    NSString                      * name;
    NSString                      * timestamp;
    NSString                      * dataLink;
    
    name                            = [updateInfo objectForKey: @"Name"];
    timestamp                       = [updateInfo objectForKey: @"Timestamp"];
    dataLink                        = [updateInfo objectForKey: @"DataLink"];
    if ( ( nil == name ) || ( nil == dataLink ) )
    {
        return NO;
    }
    
    [TDDownloadManager              download: name from: dataLink into: configureSubpath of: configureDirectory updateCheckBy: timestamp];
    
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
@implementation TDPreUpdateProcedure


//  ------------------------------------------------------------------------------------------------
#pragma mark synthesize variable.

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark overwrite implementation of NSObject.
//  ------------------------------------------------------------------------------------------------

//  ------------------------------------------------------------------------------------------------

//  ------------------------------------------------------------------------------------------------
#pragma mark method for create the object.
//  ------------------------------------------------------------------------------------------------
- (instancetype ) initWithURL:(NSString *)configureURL
                     withSave:(NSString *)filename into:(NSString *)subpath of:(TDGetPathDirectory)directory
{
    self                            = [super init];
    if ( nil == self )
    {
        return nil;
    }
    
    [self                           _InitAttributes];
    
    configureUpdateURL              = configureURL;
    configureSubpath                = subpath;
    configureDirectory              = directory;
    
    configureFilename               = TDGetPathForDirectories( directory, [filename stringByDeletingPathExtension], [filename pathExtension], subpath, NO );
    return self;
}


//  ------------------------------------------------------------------------------------------------
+ ( instancetype ) preUpdate:(NSString *)configureURL
                    withSave:(NSString *)filename into:(NSString *)subpath of:(TDGetPathDirectory)directory
{
    return [[[self class] alloc] initWithURL: configureURL withSave: filename into: subpath of: directory];
}

//  ------------------------------------------------------------------------------------------------
#pragma mark method for start procedure
//  ------------------------------------------------------------------------------------------------
- ( void ) startProcedure
{
    [self                           _PreDownloadSystemConfigure: ^(BOOL finished)
    {
//        NSLog( @"is finish %d,\n container : %@", finished, configureData );
        NSArray                   * allKeys;
        
        allKeys                     = [configureData allKeys];
        if ( ( nil == allKeys ) || ( [allKeys count] == 0 ) )
        {
            return;
        }
        
        [self                       _UpdateProcedure: allKeys];
        
        
    }];
    return;
}

//  ------------------------------------------------------------------------------------------------
- ( void ) startProcedureWithKey:(NSString *)aKey
{
    if ( ( nil == aKey ) || ( [aKey length] == 0 ) )
    {
        return;
    }
    
    [self                           _PreDownloadSystemConfigure: ^(BOOL finished)
    {
        NSArray                   * keyList;
        
        keyList                     = [NSArray arrayWithObject: aKey];
        if ( ( nil == keyList ) || ( [keyList count] == 0 ) )
        {
            return;
        }
        [self                       _UpdateProcedure: keyList];
    }];
    return;
}

//  ------------------------------------------------------------------------------------------------
- ( void ) startProcedureWithKeys:(NSArray *)keyList
{
    if ( ( nil == keyList ) || ( [keyList count] == 0 ) )
    {
        return;
    }
    
    [self                           _PreDownloadSystemConfigure: ^(BOOL finished)
    {
        [self                       _UpdateProcedure: keyList];
    }];
    return;
}

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------

@end

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------









