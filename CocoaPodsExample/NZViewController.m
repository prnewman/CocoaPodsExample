//
//  NZViewController.m
//  CocoaPodsExample
//
//  Created by Paul Newman on 12/8/12.
//  Copyright (c) 2012 Newman Zone. All rights reserved.
//

#import "NZViewController.h"
#import "NZTraktAPIClient.h"
#import <AFNetworking.h>

@interface NZViewController ()
{
    __weak IBOutlet UIScrollView *showScrollView;
    __weak IBOutlet UIPageControl *showPageControl;

    NSArray *jsonResponse;
    BOOL pageControlUsed;
    int previousPage;
    NSMutableSet *loadedPages;
}

@end

@implementation NZViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // 1 - Create trakt API client
    NZTraktAPIClient *client = [NZTraktAPIClient sharedClient];
    // 2 - Create date instance with today's date
    NSDate *today = [NSDate date];
    // 3 - Create date formatter
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    NSString *todayString = [formatter stringFromDate:today];
    // 4 - Create API query request
    NSString *path = [NSString stringWithFormat:@"user/calendar/shows.json/%@/%@/%@/%d", kTraktAPIKey, @"marcelofabri", todayString, 3];
    NSLog(@"path: %@", path);
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:nil];
    // 5 - Create JSON request operation
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // 6 - Request succeeded block
        NSLog(@"%@", JSON);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        // 7 - Request failed block
    }];
    // 8 - Start request
    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pageChanged:(id)sender {
}

-(void)loadShow:(int)index {
    // empty for now...
}

@end
