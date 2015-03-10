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
    NSMutableArray                * afManagerContainer;
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
- ( BOOL ) _InsertManager:(AFNetworkReachabilityManager *)afManager;
- ( BOOL ) _RemoveManager:(AFNetworkReachabilityManager *)afManager;

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
    afManagerContainer              = [[NSMutableArray alloc] init];
}

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
- ( BOOL ) _InsertManager:(AFNetworkReachabilityManager *)afManager
{
    if ( nil == afManager )
    {
        return NO;
    }
    
    static  dispatch_once_t         onceToken;

    dispatch_once( &onceToken, ^{
        [afManagerContainer         addObject: afManager];
    });
    return YES;
}

//  ------------------------------------------------------------------------------------------------
- ( BOOL ) _RemoveManager:(AFNetworkReachabilityManager *)afManager
{
    if ( nil == afManager )
    {
        return NO;
    }
    
    static  dispatch_once_t         onceToken;
    
    dispatch_once( &onceToken, ^{
        [afManagerContainer         removeObject: afManager];
    });
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
@implementation TDNetworkReachabilityManager

//  ------------------------------------------------------------------------------------------------
#pragma mark synthesize variable.

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark overwrite implementation of NSObject.
//  ------------------------------------------------------------------------------------------------
//  --------------------------------
- ( instancetype ) init
{
    self                            = [super init];
    if ( nil == self )
    {
        return nil;
    }
    
    [self                           _InitAttributes];
    
    return self;
}

//  ------------------------------------------------------------------------------------------------
- ( void ) dealloc
{
    if ( nil != afManagerContainer )
    {
        [afManagerContainer         removeAllObjects];
//.        [afManagerContainer         release];
        afManagerContainer          = nil;
        
    }
}

//  ------------------------------------------------------------------------------------------------
#pragma mark method for create the object.
//  ------------------------------------------------------------------------------------------------
+ ( instancetype ) shareManager
{
    static  TDNetworkReachabilityManager  * manager = nil;
    static  dispatch_once_t                 onceToken;
    
    dispatch_once( &onceToken, ^{
        
        manager                     = [[self alloc] init];
    });
    return manager;
}

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) keepingManager:(AFNetworkReachabilityManager *)afManager
{
    if ( nil == afManager )
    {
        return NO;
    }
    
    TDNetworkReachabilityManager  * managerSelf;
    
    managerSelf                     = [TDNetworkReachabilityManager shareManager];
    if ( nil == managerSelf )
    {
        return NO;
    }
    [managerSelf                    _InsertManager: afManager];
    return YES;
}

//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) releaseManager:(AFNetworkReachabilityManager *)afManager
{
    if ( nil == afManager )
    {
        return NO;
    }
    
    TDNetworkReachabilityManager  * managerSelf;
    
    managerSelf                     = [TDNetworkReachabilityManager shareManager];
    if ( nil == managerSelf )
    {
        return NO;
    }
    [managerSelf                    _RemoveManager: afManager];
    return YES;
}

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
    
    [TDNetworkReachabilityManager   keepingManager: manager];               //  when ARC & nothing to keep the allocated memory.
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
         [blockManager                  stopMonitoring];
         [TDNetworkReachabilityManager  releaseManager: blockManager];      // release the keeping.
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
    [TDNetworkReachabilityManager   keepingManager: manager];               //  when ARC & nothing to keep the allocated memory.
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
         [TDNetworkReachabilityManager  releaseManager: blockManager];      // release the keeping.
     }];
    
    return YES;
}

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


@end

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------









