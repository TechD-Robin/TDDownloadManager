//
//  TableViewController.m
//  DemoDownloadManager
//
//  Created by Robin Hsu on 2015/3/5.
//  Copyright (c) 2015年 TechD. All rights reserved.
//


#import <netinet/in.h>

#import "TableViewController.h"

#import "ARCMacros.h"
#import "TDNetworkReachabilityManager.h"

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
@interface TableViewController ()
{
    NSMutableArray                * demoList;
    
    
    UIViewController              * demoViewController;

}

@end

//  ------------------------------------------------------------------------------------------------
@interface TableViewController (Private)

//  ------------------------------------------------------------------------------------------------
- ( CGFloat ) _GetStatusBarHeight;
- ( void ) _InitAttributes;
- ( void ) _ReleaseDemoViewController;
- ( BOOL ) _CreateDemoViewController;

//  ------------------------------------------------------------------------------------------------
- ( void ) _CheckReachabilityStatus;
- ( void ) _CheckReachabilityStatusWithResult;
- ( void ) _CheckReachabilityStatusForDomain;
- ( void ) _CheckReachabilityStatusForDomainWithResult;


//  ------------------------------------------------------------------------------------------------
+ ( void ) _OutputResult:(NSInteger)result;

//  ------------------------------------------------------------------------------------------------

@end


@implementation TableViewController (Private)

//  ------------------------------------------------------------------------------------------------
- ( CGFloat ) _GetStatusBarHeight
{
    UIApplication                 * application;
//    BOOL                            isPortrait;
    
    application                     = [UIApplication sharedApplication];
    if ( ( nil == application ) || ( [application isStatusBarHidden] == YES ) )
    {
        return 0.0f;
    }
    
//    isPortrait                      = ( [self interfaceOrientation] == UIInterfaceOrientationPortrait );
//    return ( ( YES == isPortrait ) ? [application statusBarFrame].size.height : [application statusBarFrame].size.width );
    return [application statusBarFrame].size.height;
}

//  ------------------------------------------------------------------------------------------------
- ( void ) _InitAttributes
{
    
    demoList                        = [NSMutableArray arrayWithCapacity: 4];
    [demoList                       addObject: @" Check Reachability Status" ];
    [demoList                       addObject: @" Check Network Reachability Status" ];
    [demoList                       addObject: @" Check Reachability For Domain (result)" ];
    [demoList                       addObject: @" Check Reachability For Domain (status)" ];
    
    demoViewController              = nil;
    
}

//  ------------------------------------------------------------------------------------------------
- ( void ) _ReleaseDemoViewController
{
    SAFE_ARC_RELEASE( demoViewController );
    SAFE_ARC_ASSIGN_POINTER_NIL( demoViewController );
}


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
- ( BOOL ) _CreateDemoViewController
{
    UIViewController              * viewController;
    
    viewController                  = [UIViewController new];
    if ( nil == viewController )
    {
        return NO;
    }
    demoViewController              = viewController;
    
    //  init Top bar & back button.
    CGFloat                         screenWidth;
    CGFloat                         statusBarHeight;
    UINavigationBar               * bar;
    
    screenWidth                     = [[UIScreen mainScreen] bounds].size.width;
    statusBarHeight                 = [self _GetStatusBarHeight];
    bar                             = [[UINavigationBar alloc] initWithFrame: CGRectMake( 0, ( statusBarHeight + 1.0f ), screenWidth, 36)];
    if ( nil == bar )
    {
        return YES;
    }
    [[viewController                view] setBackgroundColor: [UIColor darkGrayColor]];
    [[viewController                view] addSubview: bar];
    
    UIBarButtonItem               * backItem;
    UINavigationItem              * titleItem;
    
    backItem                        = SAFE_ARC_AUTORELEASE( [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target: self action: @selector( _BackAction: )] );
    
    titleItem                       = SAFE_ARC_AUTORELEASE( [[UINavigationItem alloc] initWithTitle: @"test"] );
    if ( nil == titleItem )
    {
        return YES;
    }
    
    NSLog( @"title %@", titleItem );
    [bar                            pushNavigationItem: titleItem animated: YES];
    if ( nil != backItem )
    {
        [titleItem                  setLeftBarButtonItem: backItem];
    }
    
    return YES;
}

//  ------------------------------------------------------------------------------------------------
- ( void ) _BackAction:(id) sender
{
    [demoViewController             dismissViewControllerAnimated: YES completion: ^()
     {
         [self                       _ReleaseDemoViewController];
     }];
    
}

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
- ( void ) _CheckReachabilityStatus
{
    [TDNetworkReachabilityManager checkReachabilityStatus: ^(AFNetworkReachabilityStatus status)
    {
        [TableViewController        _OutputResult:(NSInteger)status];
    }];
}

//  ------------------------------------------------------------------------------------------------
- ( void ) _CheckReachabilityStatusWithResult
{
    
}

//  ------------------------------------------------------------------------------------------------
- ( void ) _CheckReachabilityStatusForDomain
{
    [TDNetworkReachabilityManager checkReachabilityStatusForDomain: @"www.google.com.tw" result: ^(AFNetworkReachabilityStatus status)
    {
        NSLog( @"\n\rcheck domain" );
       [TableViewController        _OutputResult:(NSInteger)status];
    }];    
    [TDNetworkReachabilityManager checkReachabilityStatusForDomain: @"techd.idv.tw" result: ^(AFNetworkReachabilityStatus status)
     {
         [TableViewController        _OutputResult:(NSInteger)status];
     }];
    [TDNetworkReachabilityManager checkReachabilityStatusForDomain: @"www.google.com.tw" result: ^(AFNetworkReachabilityStatus status)
     {
         [TableViewController        _OutputResult:(NSInteger)status];
     }];
}

//  ------------------------------------------------------------------------------------------------
- ( void ) _CheckReachabilityStatusForDomainWithResult
{
    struct sockaddr_in ipAddress;
    ipAddress.sin_len = sizeof(ipAddress);
    ipAddress.sin_family = AF_INET;
    ipAddress.sin_port = htons(80);
    inet_pton(AF_INET, "192.168.1.1", &ipAddress.sin_addr);
    
    static void * a;
    
    a = [TDNetworkReachabilityManager checkReachabilityStatusForAddress: &ipAddress result: ^(AFNetworkReachabilityStatus status)
     {
         NSLog( @"\n\rcheck address" );
         [TableViewController        _OutputResult:(NSInteger)status];
     }];
}



//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
+ ( void ) _OutputResult:(NSInteger)result
{
    switch ( result )
    {
        case 0:
        {
            NSLog( @"device's network is not reachable" );
            break;
        }
        case 1:
        {
            NSLog( @"WWAN is reachable" );
            break;
        }
        case 2:
        {
            NSLog( @"WIFI is reachable" );
            break;
        }
        default:
        {
            NSLog( @"device's network has error" );
            break;
        }
    }
}

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------

@end

//  ------------------------------------------------------------------------------------------------





@implementation TableViewController

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark overwrite implementation of UIViewController
//  ------------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    //  must register cell class for reuse identifier.
    [(UITableView *)[self           view] registerClass: [UITableViewCell class] forCellReuseIdentifier: @"Cell"];
    
    
    
    [self                           _InitAttributes];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------
#pragma mark protocol required for UITableViewDataSource.
//  ------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if ( ( nil == demoList ) || ( [demoList count] == 0 ) )
    {
        return 0;
    }
    return [demoList count];
}

//  ------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell               * cell;
    
    cell                            = [tableView dequeueReusableCellWithIdentifier: @"Cell" forIndexPath: indexPath];
    if ( nil == cell )
    {
        cell                        = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: @"Cell"];
    }
    
    
    NSString                      * demoName;
    
    demoName                        = [demoList objectAtIndex: indexPath.row];
    if ( nil != demoName )
    {
        NSLog( @"row : %ld %@", (long)indexPath.row, demoName );
        [[cell                      textLabel] setText: demoName];
    }
    
    // Configure the cell...
    [[cell                          contentView] setBackgroundColor: [UIColor grayColor]];
    
    return cell;
}

//  ------------------------------------------------------------------------------------------------
#pragma mark protocol optional for UITableViewDelegate.
//  ------------------------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog( @"%@", indexPath );
//    
//    if ( [self _CreateDemoViewController] == NO )
//    {
//        return;
//    }
    
    switch ( indexPath.row )
    {
        case 0: [self               _CheckReachabilityStatus];                      break;
        case 1: [self               _CheckReachabilityStatusWithResult];            break;
        case 2: [self               _CheckReachabilityStatusForDomain];             break;
        case 3: [self               _CheckReachabilityStatusForDomainWithResult];   break;
            
        default:
            break;
    }
    
    
    
//    [self                           presentViewController: demoViewController animated: YES completion: nil];
    
}


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------



@end


//  ------------------------------------------------------------------------------------------------
//  ------------------------------------------------------------------------------------------------

