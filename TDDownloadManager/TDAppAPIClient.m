//
//  TDAppAPIClient.m
//  TDDownloadManager
//
//  Created by Robin Hsu on 2016/6/2.
//  Copyright © 2016年 TechD. All rights reserved.
//

#import "TDAppAPIClient.h"


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark class TDAppAPIClient

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark declare private category ()
//  ------------------------------------------------------------------------------------------------
@interface TDAppAPIClient ()
{
}

@end


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark declare private category (Private)
//  ------------------------------------------------------------------------------------------------
@interface TDAppAPIClient (Private)

//  ------------------------------------------------------------------------------------------------
#pragma mark declare for initial this class.
//  ------------------------------------------------------------------------------------------------
/**
 *  @brief initial the attributes of class.
 *  initial the attributes of class.
 */
- ( void ) _InitAttributes;

//  ------------------------------------------------------------------------------------------------

//  ------------------------------------------------------------------------------------------------

@end


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark implementation private category (Private)
//  ------------------------------------------------------------------------------------------------
@implementation TDAppAPIClient (Private)

//  ------------------------------------------------------------------------------------------------
#pragma mark method for initial this class.
//  ------------------------------------------------------------------------------------------------
- ( void ) _InitAttributes
{
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
@implementation TDAppAPIClient

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
    
    //  initial.
    [self                           _InitAttributes];
    return self;
}

//  ------------------------------------------------------------------------------------------------
#pragma mark method for create the object.
//  ------------------------------------------------------------------------------------------------
+ ( instancetype ) defaultManager
{
    static TDAppAPIClient         * defaultManager   = nil;
    static dispatch_once_t          oneToken;
    
    _dispatch_once( &oneToken, ^
    {
        defaultManager              = [[[self class] alloc] initWithBaseURL: [NSURL URLWithString: @"http://localhost:8000/"]];
        NSParameterAssert( nil != defaultManager );
        [defaultManager             setSecurityPolicy: [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
    });
    
    return defaultManager;
}

//  ------------------------------------------------------------------------------------------------
////  ------------------------------------------------------------------------------------------------
+ (NSURLSessionDataTask *) postData: (NSString *)URLString
                         parameters: (nullable id)parameters
                            success: (appAPIResponseSuccessBlock)success
                            failure: (appAPIResponseFailureBlock)failure
{
    NSSet                           * contentTypes;
    TDAppAPIClient                  * defaultManager;
    AFJSONRequestSerializer       * requestSerializer;
    AFJSONResponseSerializer      * responseSerializer;
    
    
    requestSerializer               = [AFJSONRequestSerializer serializer];
    responseSerializer              = [AFJSONResponseSerializer serializer];
    defaultManager                  = [[self class] defaultManager];
    NSParameterAssert( nil != requestSerializer );
    NSParameterAssert( nil != responseSerializer );
    NSParameterAssert( nil != defaultManager );
    
    
    contentTypes                    = [NSSet setWithObjects: @"application/json", nil];
    [responseSerializer             setAcceptableContentTypes: contentTypes];
    
    [defaultManager                 setRequestSerializer: requestSerializer];
    [defaultManager                 setResponseSerializer: responseSerializer];
    
    return [defaultManager POST: URLString parameters: parameters progress: nil success: success failure: failure];
}

////  ------------------------------------------------------------------------------------------------
+ (NSURLSessionDataTask *) putData: (NSString *)URLString
                        parameters: (nullable id)parameters
                           success: (appAPIResponseSuccessBlock)success
                           failure: (appAPIResponseFailureBlock)failure
{
    NSSet                           * contentTypes;
    TDAppAPIClient                  * defaultManager;
    AFJSONRequestSerializer       * requestSerializer;
    AFJSONResponseSerializer      * responseSerializer;
    
    
    requestSerializer               = [AFJSONRequestSerializer serializer];
    responseSerializer              = [AFJSONResponseSerializer serializer];
    defaultManager                  = [[self class] defaultManager];
    NSParameterAssert( nil != requestSerializer );
    NSParameterAssert( nil != responseSerializer );
    NSParameterAssert( nil != defaultManager );
    
    
    contentTypes                    = [NSSet setWithObjects: @"application/json", nil];
    [responseSerializer             setAcceptableContentTypes: contentTypes];
    
    [defaultManager                 setRequestSerializer: requestSerializer];
    [defaultManager                 setResponseSerializer: responseSerializer];
    
    return [defaultManager PUT: URLString parameters: parameters success: success failure: failure];
}

//  ------------------------------------------------------------------------------------------------


@end

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------








