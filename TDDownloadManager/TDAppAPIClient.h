//
//  TDAppAPIClient.h
//  TDDownloadManager
//
//  Created by Robin Hsu on 2016/6/2.
//  Copyright © 2016年 TechD. All rights reserved.
//
//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark type define.

NS_ASSUME_NONNULL_BEGIN

//  ------------------------------------------------------------------------------------------------
//typedef     void (^loginResultCallbackBlock)(BOOL successLogin);
typedef     void (^appAPIResponseSuccessBlock)(NSURLSessionDataTask * dataTask, id _Nullable response);
typedef     void (^appAPIResponseFailureBlock)(NSURLSessionDataTask * _Nullable dataTask, NSError * error);

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------

#pragma mark -
#pragma mark class TDAppAPIClient
@interface TDAppAPIClient : AFHTTPSessionManager


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
//  Gets the singleton instance.
+ ( instancetype) defaultManager;

////  ------------------------------------------------------------------------------------------------
+ (NSURLSessionDataTask *) postData: (NSString *)URLString
                         parameters: (nullable id)parameters
                            success: (appAPIResponseSuccessBlock)success
                            failure: (appAPIResponseFailureBlock)failure;

////  ------------------------------------------------------------------------------------------------
+ (NSURLSessionDataTask *) putData: (NSString *)URLString
                         parameters: (nullable id)parameters
                            success: (appAPIResponseSuccessBlock)success
                            failure: (appAPIResponseFailureBlock)failure;

//  ------------------------------------------------------------------------------------------------

@end

NS_ASSUME_NONNULL_END
//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------













