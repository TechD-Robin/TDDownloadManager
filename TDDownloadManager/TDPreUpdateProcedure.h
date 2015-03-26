//
//  TDPreUpdateProcedure.h
//  TDDownloadManager
//
//  Created by Robin Hsu on 2015/3/25.
//  Copyright (c) 2015年 TechD. All rights reserved.
//
//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


#import <Foundation/Foundation.h>
#import "TDFoundation.h"


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
//typedef     void (^FinishedCallbackBlock)(BOOL finished);

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
/**
 *  a pre-upload procedure object is provide simple method for check and update configure data at internet,
 *  this method compare with project's main functional, that can be executed at first timing.
 */
#pragma mark -
#pragma mark class TDPreUpdateProcedure
@interface TDPreUpdateProcedure : NSObject

//  ------------------------------------------------------------------------------------------------

//  ------------------------------------------------------------------------------------------------
#pragma mark property of variable.
//  ------------------------------------------------------------------------------------------------



//  ------------------------------------------------------------------------------------------------
#pragma mark declare for create the object.
//  ------------------------------------------------------------------------------------------------
/**
 *  @brief create a pre-update procedure object, check update condition from URL and save configure data.
 *  create a pre-update procedure object, check update condition from URL and save configure data which these parameters is path condition.
 *
 *  @param fileURL                  the URL of configure data at internet.
 *  @param filename                 save filename of configure data.
 *  @param subpath                  save file's path of configure data.
 *  @param directory                enumeration for directory.
 *
 *  @return object|nil              the pre-update object or nil.
 */
+ ( instancetype ) preUpdate:(NSString *)configureURL
                    withSave:(NSString *)filename into:(NSString *)subpath of:(TDGetPathDirectory)directory ;

//  ------------------------------------------------------------------------------------------------
#pragma mark declare for start procedure
//  ------------------------------------------------------------------------------------------------
/**
 *  @brief start this pre-update procedure to check and update configure data.
 *  start this pre-update procedure to check and update configure data, this method will check all data in configure data.
 */
- ( void ) startProcedure;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief start this pre-update procedure to check and update configure data.
 *  start this pre-update procedure to check and update configure data, this method will check configure data for a key
 *
 *  @param aKey                     a key of data
 */
- ( void ) startProcedureWithKey:(NSString *)aKey;

//  ------------------------------------------------------------------------------------------------
/**
 *  @brief start this pre-update procedure to check and update configure data.
 *  start this pre-update procedure to check and update configure data, this method will check configure data for keys
 *
 *  @param aKey                     keys of data
 */
- ( void ) startProcedureWithKeys:(NSArray *)keyList;

//  ------------------------------------------------------------------------------------------------

@end

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------



