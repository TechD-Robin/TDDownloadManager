//
//  TDNetworkReachabilityManager.m
//  TDDownloadManager
//
//  Created by Robin Hsu on 2015/3/10.
//  Copyright (c) 2015年 TechD. All rights reserved.
//
//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------

#import "TDNetworkReachabilityManager.h"

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
typedef     void (^AFNetworkReachabilityStatusBlock)(AFNetworkReachabilityStatus status);


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark class TDNetworkReachabilityManager

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark declare private category ()
//  ------------------------------------------------------------------------------------------------
@interface TDNetworkReachabilityManager ()
{
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
@interface TDNetworkReachabilityManager (Private)

//  ------------------------------------------------------------------------------------------------
#pragma mark declare for initial this class.
//  ------------------------------------------------------------------------------------------------
/**
 *  @brief initial the attributes of class.
 *  initial the attributes of class.
 */
- ( void ) _InitAttributes;


//  ------------------------------------------------------------------------------------------------

@end


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark implementation private category (Private)
//  ------------------------------------------------------------------------------------------------
@implementation TDNetworkReachabilityManager (Private)

//  ------------------------------------------------------------------------------------------------
#pragma mark method for initial this class.
//  ------------------------------------------------------------------------------------------------
- ( void ) _InitAttributes
{
    
}


//  ------------------------------------------------------------------------------------------------

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
@implementation TDNetworkReachabilityManager

//  ------------------------------------------------------------------------------------------------
#pragma mark synthesize variable.

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark overwrite implementation of NSObject.
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
#pragma mark method for create the object.
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) checkReachabilityStatus:(void (^)(AFNetworkReachabilityStatus status))statusBlock
{
    __weak AFNetworkReachabilityStatusBlock blockStatusBlock;
    
    blockStatusBlock                = statusBlock;
    [[AFNetworkReachabilityManager  sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager  sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         if ( nil != blockStatusBlock )
         {
             blockStatusBlock( status );
         }
         [[AFNetworkReachabilityManager      sharedManager] stopMonitoring];
     }];
    
    return YES;
}

//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) checkNetworkReachabilityStatus:(void (^)(BOOL isReachable))reachableBlock;
{
    if ( nil == reachableBlock )
    {
        return NO;
    }
    
    [[AFNetworkReachabilityManager  sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager  sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         if ( AFNetworkReachabilityStatusReachableViaWWAN <= status )
         {
             reachableBlock( YES );
         }
         else
         {
             reachableBlock( NO );
         }
         [[AFNetworkReachabilityManager      sharedManager] stopMonitoring];
     }];
    
    return YES;
}

//  ------------------------------------------------------------------------------------------------
//  --------------------------------
+ ( BOOL ) checkReachabilityStatusForDomain:(NSString *)domain result:(void (^)(AFNetworkReachabilityStatus status))statusBlock
{
    if ( nil == domain )
    {
        return NO;
    }
    
    AFNetworkReachabilityManager  * manager;
    
    manager                         = [AFNetworkReachabilityManager managerForDomain: domain];
    if ( nil == manager )
    {
        return NO;
    }
    [manager                        startMonitoring];
    
    
    __weak id                               blockManager;
    __weak AFNetworkReachabilityStatusBlock blockStatusBlock;
    
    blockManager                    = manager;
    blockStatusBlock                = statusBlock;
    [manager                        setReachabilityStatusChangeBlock: ^(AFNetworkReachabilityStatus status)
     {
         if ( nil != blockStatusBlock )
         {
             blockStatusBlock( status );
         }
         [blockManager               stopMonitoring];
     }];
    
    return YES;
}

//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) checkReachabilityStatusForDomain:(NSString *)domain status:(void (^)(BOOL isReachable))reachableBlock;
{
    if ( ( nil == domain ) || ( nil == reachableBlock ) )
    {
        return NO;
    }
    
    AFNetworkReachabilityManager  * manager;
    __weak id                       blockManager;
    
    manager                         = [AFNetworkReachabilityManager managerForDomain: domain];
    if ( nil == manager )
    {
        return NO;
    }
    [manager                        startMonitoring];
    
    
    blockManager                    = manager;
    [manager                        setReachabilityStatusChangeBlock: ^(AFNetworkReachabilityStatus status)
     {
         if ( AFNetworkReachabilityStatusReachableViaWWAN <= status )
         {
             reachableBlock( YES );
         }
         else
         {
             reachableBlock( NO );
         }
         [blockManager               stopMonitoring];
     }];
    
    return YES;
}

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


@end

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------









