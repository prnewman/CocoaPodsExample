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
#import <ConciseKit.h>
#import <SSCategories.h>

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
    
    // 4.1 - Initialize variables
    loadedPages = [NSMutableSet set];
    previousPage = -1;
    
    
    NSURLRequest *request = [client requestWithMethod:@"GET" path:path parameters:nil];
    // 5 - Create JSON request operation
    AFJSONRequestOperation* operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        // 6 - Request succeeded block
        //NSLog(@"%@", JSON);
        [self parseJSON:JSON];
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

- (void)parseJSON:(NSArray *)JSON
{
    // 6.1 - Load JSON into internal variable
    jsonResponse = JSON;
    // 6.2 - Get the number of shows
    int shows = 0;
    for (NSDictionary *day in jsonResponse) {
        shows += [[day $for: @"episodes"] count];
        // $for: above is the same as objectForKey: - we're using ConciseKit here.
        NSLog(@"ConciseKit: %i", [[day $for: @"episodes"] count]); // 2, 1
        NSLog(@"Bracket notation: %i", [day[@"episodes"] count]);
    }
    // 6.3 - Set up page control
    showPageControl.numberOfPages = shows;
    showPageControl.currentPage = 0;
    // 6.4 - Set up scroll view
    showScrollView.contentSize = CGSizeMake(self.view.bounds.size.width * shows, showScrollView.frame.size.height);
    // 6.5 - Load first show
    [self loadShow:0];
}

- (IBAction)pageChanged:(id)sender {
}

-(void)loadShow:(int)index {
    // 1 - Does the pages array contain the specified page?
    if (![loadedPages containsObject:$int(index)]) {
        // $int(x) is the same as [NSNumber numberWithInt:x]
        // 2 - Find the show for the given index
        int shows = 0;
        NSDictionary *show = nil;
        for (NSDictionary *day in jsonResponse) {
            int count = [[day $for: @"episodes"] count];
            // 3 - Did we find the right show?
            if (index < shows + count) {
                show = [[day $for:@"episodes"] $at: index-shows];
                break;
            }
            // 4 - Increment the shows counter
            shows += count;
        }
        // 5 - Load the show information
        //NSDictionary *episodeDict = [show $for:@"episode"];
        NSDictionary *showDict = [show $for:@"show"];
        // 6 - Display the show information
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(index * showScrollView.bounds.size.width, 40, showScrollView.bounds.size.width, 40)];
        label.text = [showDict $for: @"title"];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:18];
        label.textAlignment = NSTextAlignmentCenter;
        [showScrollView addSubview:label];
        // 7 - Add the new page to the loadedPages array
        [loadedPages addObject:$int(index)];
    }
}
@end
