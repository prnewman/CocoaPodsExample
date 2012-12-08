//
//  NZTraktAPIClient.h
//  CocoaPodsExample
//
//  Created by Paul Newman on 12/8/12.
//  Copyright (c) 2012 Newman Zone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPClient.h>

extern NSString * const kTraktAPIKey;
extern NSString * const kTraktBaseURLString;

@interface NZTraktAPIClient : AFHTTPClient

+(NZTraktAPIClient *)sharedClient;

@end