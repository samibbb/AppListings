//
//  HFListingsManager.m
//  HFAppListings
//
//  Created by Sami B on 2016-04-21.
//  Copyright © 2016 Sami B. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>
#import "HFListingsManager.h"
#import "HFListing.h"

static NSString * const kBaseUrl = @"https://itunes.apple.com/";
static NSString * const kTopListingsEndpoint = @"us/rss/topgrossingapplications/limit=50/json";

@interface HFListingsManager ()
@property (strong,nonatomic) AFHTTPSessionManager * sessionManager;
@end

@implementation HFListingsManager

+ (instancetype)sharedManager {
    static HFListingsManager *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init {
    
    if (self = [super init]){
        _sessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer new];
        
    }
    
    return self;
}

- (void) fetchTopListingsWithCompletion:(HFListingRequestCompletion)completion {
    
    [self.sessionManager GET:kTopListingsEndpoint parameters:nil progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:NSDictionary.class]){
            NSArray * listingsInfo = responseObject[@"feed"][@"entry"];
            
            NSError * jsonError;
            NSArray<HFListing*> *listings = [HFListing arrayOfModelsFromDictionaries:listingsInfo error:&jsonError];
            
            if (completion){
                completion(listings);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

@end
