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
+ ( instancetype ) _ShareManager;

//  ------------------------------------------------------------------------------------------------
- ( BOOL ) _InsertManager:(AFNetworkReachabilityManager *)afManager;
- ( BOOL ) _RemoveManager:(AFNetworkReachabilityManager *)afManager;

+ ( BOOL ) _KeepingManager:(AFNetworkReachabilityManager *)afManager;
+ ( BOOL ) _ReleaseManager:(AFNetworkReachabilityManager *)afManager;


//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) _CheckReachabilityStatus:(AFNetworkReachabilityManager *)afManager withStatusBlock:(void (^)(AFNetworkReachabilityStatus status))statusBlock;
+ ( BOOL ) _CheckReachabilityStatus:(AFNetworkReachabilityManager *)afManager withResultBlock:(void (^)(BOOL isReachable))reachableBlock;


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
#pragma mark method for create the object.
//  ------------------------------------------------------------------------------------------------
+ ( instancetype ) _ShareManager
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
- ( BOOL ) _InsertManager:(AFNetworkReachabilityManager *)afManager
{
    if ( nil == afManager )
    {
        return NO;
    }
    
    [afManagerContainer             addObject: afManager];
    return YES;
}

//  ------------------------------------------------------------------------------------------------
- ( BOOL ) _RemoveManager:(AFNetworkReachabilityManager *)afManager
{
    if ( nil == afManager )
    {
        return NO;
    }
    
    [afManagerContainer             removeObject: afManager];
    return YES;
}


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) _KeepingManager:(AFNetworkReachabilityManager *)afManager
{
    if ( nil == afManager )
    {
        return NO;
    }
    
    TDNetworkReachabilityManager  * managerSelf;
    
    managerSelf                     = [TDNetworkReachabilityManager _ShareManager];
    if ( nil == managerSelf )
    {
        return NO;
    }
    [managerSelf                    _InsertManager: afManager];
    return YES;
}

//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) _ReleaseManager:(AFNetworkReachabilityManager *)afManager
{
    if ( nil == afManager )
    {
        return NO;
    }
    
    TDNetworkReachabilityManager  * managerSelf;
    
    managerSelf                     = [TDNetworkReachabilityManager _ShareManager];
    if ( nil == managerSelf )
    {
        return NO;
    }
    [managerSelf                    _RemoveManager: afManager];
    return YES;
}


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) _CheckReachabilityStatus:(AFNetworkReachabilityManager *)afManager withStatusBlock:(void (^)(AFNetworkReachabilityStatus status))statusBlock
{
    if ( ( nil == afManager ) || ( nil == statusBlock ) )
    {
        return NO;
    }
    
    __weak __typeof(afManager)      blockManager;
    __weak __typeof(statusBlock)    blockStatusBlock;
    
    blockManager                    = afManager;
    blockStatusBlock                = statusBlock;
    [TDNetworkReachabilityManager   _KeepingManager: afManager];            //  when ARC & nothing to keep the allocated memory.
    [afManager                      startMonitoring];
    [afManager                      setReachabilityStatusChangeBlock: ^(AFNetworkReachabilityStatus status)
     {
         if ( nil != blockStatusBlock )
         {
             blockStatusBlock( status );
         }
         [blockManager                  stopMonitoring];
         [TDNetworkReachabilityManager  _ReleaseManager: blockManager];     // release the keeping.
     }];
    
    return YES;
}

//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) _CheckReachabilityStatus:(AFNetworkReachabilityManager *)afManager withResultBlock:(void (^)(BOOL isReachable))reachableBlock
{
    if ( ( nil == afManager ) || ( nil == reachableBlock ) )
    {
        return NO;
    }
    
    __weak __typeof(afManager)      blockManager;
    __weak __typeof(reachableBlock) blockReachableBlock;
    
    blockManager                    = afManager;
    blockReachableBlock             = reachableBlock;
    [TDNetworkReachabilityManager   _KeepingManager: afManager];            //  when ARC & nothing to keep the allocated memory.
    [afManager                      startMonitoring];
    [afManager                      setReachabilityStatusChangeBlock: ^(AFNetworkReachabilityStatus status)
     {
         BOOL                       reachable;
         
         reachable                  = ( ( AFNetworkReachabilityStatusReachableViaWWAN <= status ) ? YES : NO );
         if ( nil != blockReachableBlock )
         {
             blockReachableBlock( reachable );
         }
         [blockManager                  stopMonitoring];
         [TDNetworkReachabilityManager  _ReleaseManager: blockManager];     // release the keeping.
     }];
    
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
    return [TDNetworkReachabilityManager _ShareManager];
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
+ ( BOOL ) checkReachabilityStatusForDomain:(NSString *)domain status:(void (^)(AFNetworkReachabilityStatus status))statusBlock
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
    
    return [TDNetworkReachabilityManager _CheckReachabilityStatus: manager withStatusBlock: statusBlock];
}

//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) checkReachabilityStatusForDomain:(NSString *)domain result:(void (^)(BOOL isReachable))reachableBlock;
{
    if ( ( nil == domain ) || ( nil == reachableBlock ) )
    {
        return NO;
    }
    
    AFNetworkReachabilityManager  * manager;
    
    manager                         = [AFNetworkReachabilityManager managerForDomain: domain];
    if ( nil == manager )
    {
        return NO;
    }
    return [TDNetworkReachabilityManager _CheckReachabilityStatus: manager withResultBlock: reachableBlock];
}

//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) checkReachabilityStatusForAddress:(const void *)address status:(void (^)(AFNetworkReachabilityStatus status))statusBlock
{
    if ( NULL == address )
    {
        return NO;
    }
    
    AFNetworkReachabilityManager  * manager;
    
    manager                         = [AFNetworkReachabilityManager managerForAddress: address];
    if ( nil == manager )
    {
        return NO;
    }
    
    return [TDNetworkReachabilityManager _CheckReachabilityStatus: manager withStatusBlock: statusBlock];
}

//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) checkReachabilityStatusForAddress:(const void *)address result:(void (^)(BOOL isReachable))reachableBlock
{
    if ( NULL == address )
    {
        return NO;
    }
    
    AFNetworkReachabilityManager  * manager;
    
    manager                         = [AFNetworkReachabilityManager managerForAddress: address];
    if ( nil == manager )
    {
        return NO;
    }
    return [TDNetworkReachabilityManager _CheckReachabilityStatus: manager withResultBlock: reachableBlock];
}

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


@end

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------









