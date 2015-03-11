//
//  TDNetworkReachabilityManager.h
//  TDDownloadManager
//
//  Created by Robin Hsu on 2015/3/10.
//  Copyright (c) 2015年 TechD. All rights reserved.
//
//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


#import <Foundation/Foundation.h>
#import "AFNetworking.h"



//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
@interface TDNetworkReachabilityManager : NSObject

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) checkReachabilityStatus:(void (^)(AFNetworkReachabilityStatus status))statusBlock;

//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) checkNetworkReachabilityStatus:(void (^)(BOOL isReachable))reachableBlock;

//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) checkReachabilityStatusForDomain:(NSString *)domain status:(void (^)(AFNetworkReachabilityStatus status))statusBlock;

//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) checkReachabilityStatusForDomain:(NSString *)domain result:(void (^)(BOOL isReachable))reachableBlock;

//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) checkReachabilityStatusForAddress:(NSString *)address with:(NSUInteger)port status:(void (^)(AFNetworkReachabilityStatus status))statusBlock;

//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) checkReachabilityStatusForAddress:(NSString *)address with:(NSUInteger)port result:(void (^)(BOOL isReachable))reachableBlock;


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------

@end

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------

