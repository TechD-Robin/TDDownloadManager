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
typedef  NS_ENUM( NSInteger, TDNetworkReachabilityStatus )
{
    TDNetworkReachabilityStatusUnknown          = -1,
    TDNetworkReachabilityStatusNotReachable     = 0,
    TDNetworkReachabilityStatusViaWiFi,
    TDNetworkReachabilityStatusViaWWAN
    
};

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
@interface TDNetworkReachabilityManager : NSObject

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) checkReachabilityStatus:(void (^)(AFNetworkReachabilityStatus status))statusBlock;

//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) checkNetworkReachabilityStatus:(void (^)(BOOL isReachable))reachableBlock;

//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) checkReachabilityStatusForDomain:(NSString *)domain result:(void (^)(AFNetworkReachabilityStatus status))statusBlock;

//  ------------------------------------------------------------------------------------------------
+ ( BOOL ) checkReachabilityStatusForDomain:(NSString *)domain status:(void (^)(BOOL isReachable))reachableBlock;

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------

@end

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------

