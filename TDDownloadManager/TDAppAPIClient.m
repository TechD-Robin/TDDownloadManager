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
+ ( id ) _CreateSessionManager:(NSString *)URLString acceptable:(NSSet *)responseContentTypes;

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
+ ( id ) _CreateSessionManager:(NSString *)URLString acceptable:(NSSet *)responseContentTypes
{
    AFHTTPSessionManager          * sessionManager;
    AFJSONRequestSerializer       * requestSerializer;
    AFJSONResponseSerializer      * responseSerializer;
    
    sessionManager                  = [[AFHTTPSessionManager alloc] initWithBaseURL: [NSURL URLWithString: URLString]];
    requestSerializer               = [AFJSONRequestSerializer serializer];
    responseSerializer              = [AFJSONResponseSerializer serializer];
    NSParameterAssert( nil != sessionManager );
    NSParameterAssert( nil != requestSerializer );
    NSParameterAssert( nil != responseSerializer );
    
    [sessionManager                 setSecurityPolicy: [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
    [responseSerializer             setAcceptableContentTypes: responseContentTypes];
    [sessionManager                 setRequestSerializer: requestSerializer];
    [sessionManager                 setResponseSerializer: responseSerializer];
    
    return sessionManager;
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

//  ------------------------------------------------------------------------------------------------
+ (NSURLSessionDataTask *) getData: (NSString *)URLString
                        parameters: (nullable id)parameters
                        acceptable: (NSSet *)responseContentTypes
                          progress: (nullable appAPIprogressBlock)progress
                           success: (appAPIResponseSuccessBlock)success
                           failure: (appAPIResponseFailureBlock)failure
{
    AFHTTPSessionManager          * sessionManager;
    
    if ( nil == responseContentTypes )
    {
        NSLog( @"Warning, the resopnse acceptable content type container is nil!" );
    }
    sessionManager                  = [[self class] _CreateSessionManager: URLString acceptable: responseContentTypes];
    NSParameterAssert( nil != sessionManager );
    
    return [sessionManager GET: URLString parameters: parameters progress: progress success: success failure: failure];
}

//  ------------------------------------------------------------------------------------------------
+ (NSURLSessionDataTask *) postData: (NSString *)URLString
                         parameters: (nullable id)parameters
                         acceptable: (NSSet *)responseContentTypes
                           progress: (nullable appAPIprogressBlock)progress
                            success: (appAPIResponseSuccessBlock)success
                            failure: (appAPIResponseFailureBlock)failure
{
    AFHTTPSessionManager          * sessionManager;
    
    if ( nil == responseContentTypes )
    {
        NSLog( @"Warning, the resopnse acceptable content type container is nil!" );
    }
    sessionManager                  = [[self class] _CreateSessionManager: URLString acceptable: responseContentTypes];
    NSParameterAssert( nil != sessionManager );
    
    return [sessionManager POST: URLString parameters: parameters progress: progress success: success failure: failure];
}

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
+ (NSURLSessionDataTask *) putData: (NSString *)URLString
                        parameters: (nullable id)parameters
                        acceptable: (NSSet *)responseContentTypes
                           success: (appAPIResponseSuccessBlock)success
                           failure: (appAPIResponseFailureBlock)failure
{
    AFHTTPSessionManager          * sessionManager;
    
    if ( nil == responseContentTypes )
    {
        NSLog( @"Warning, the resopnse acceptable content type container is nil!" );
    }
    sessionManager                  = [[self class] _CreateSessionManager: URLString acceptable: responseContentTypes];
    NSParameterAssert( nil != sessionManager );
    
    return [sessionManager PUT: URLString parameters: parameters success: success failure: failure];
}

//  ------------------------------------------------------------------------------------------------

//  ------------------------------------------------------------------------------------------------


@end

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------








