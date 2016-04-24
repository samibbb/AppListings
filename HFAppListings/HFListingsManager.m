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

static NSString * const kBaseUrlString = @"https://itunes.apple.com/";
static NSString * const kTopListingsEndpoint = @"us/rss/topgrossingapplications/limit=50/json";
static NSString * const kPersistedFavoritesKey = @"kFavoritesDataKey";

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
        
        NSURL * baseUrl = [NSURL URLWithString:kBaseUrlString];
        _sessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:baseUrl];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer new];
        
    }
    
    return self;
}

- (NSArray<HFListing *> * _Nonnull) favorites {
    
    NSData * persistedFavoritesData = [[NSUserDefaults standardUserDefaults] dataForKey:kPersistedFavoritesKey];
    if (persistedFavoritesData){
        return [NSKeyedUnarchiver unarchiveObjectWithData:persistedFavoritesData];
    }
    
    return @[];
    
}

- (BOOL) removeFromFavorites:(HFListing*)listing {
    
    NSArray<HFListing*> * currentFavorites = self.favorites;
    
    if (![currentFavorites containsObject:listing]){
        return NO;
    }
    
    // Remove
    NSPredicate * removedFavPredicate = [NSPredicate predicateWithBlock:^BOOL(HFListing *  _Nonnull favorite, NSDictionary<NSString *,id> * _Nullable bindings) {
        return ![listing isEqual:favorite];
    }];
    NSArray<HFListing*> * newFavs = [currentFavorites filteredArrayUsingPredicate:removedFavPredicate];
    NSData * newFavsData = [NSKeyedArchiver archivedDataWithRootObject:newFavs];
    
    // Write to disk
    if (newFavsData){
        [[NSUserDefaults standardUserDefaults] setObject:newFavsData forKey:kPersistedFavoritesKey];
        BOOL removalSuccess = [[NSUserDefaults standardUserDefaults] synchronize];
        return removalSuccess;
    }
    
    return NO;
}

- (BOOL) addToFavorites:(HFListing*)newFavorite {
    
    NSArray<HFListing*> * currentFavorites = self.favorites;
    
    if ([currentFavorites containsObject:newFavorite]){
        return NO;
    }
    
    NSData * newFavsData = [NSKeyedArchiver archivedDataWithRootObject:[currentFavorites arrayByAddingObject:newFavorite]];
    
    if (newFavsData){
        [[NSUserDefaults standardUserDefaults] setObject:newFavsData forKey:kPersistedFavoritesKey];
        BOOL writeSuccess = [[NSUserDefaults standardUserDefaults] synchronize];
        return writeSuccess;
    }
    
    return NO;
}

- (void) fetchTopListingsWithCompletion:(HFListingRequestCompletion)completion {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self.sessionManager GET:kTopListingsEndpoint parameters:nil progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                         
        if ([responseObject isKindOfClass:NSDictionary.class]){
            NSArray * listingsInfo = responseObject[@"feed"][@"entry"];
            
            NSError * jsonError;
            NSArray<HFListing*> *listings = [HFListing arrayOfModelsFromDictionaries:listingsInfo error:&jsonError];
            
            if (completion && !jsonError){
                completion(listings);
            } else {
                [HFListingsManager handleFailure:jsonError];
            }
        } else {
            
            NSString * invalidJsonErrMessage = [NSString stringWithFormat:@"Invalid JSON. Expected a dictionary, received a %@", NSStringFromClass([responseObject class])];
            [HFListingsManager handleFailure:[NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey:invalidJsonErrMessage}]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [HFListingsManager handleFailure:error];
    
    }];
    
}

+ (void) handleFailure:(NSError*)error {
    NSLog(@"Error : %@", error.userInfo);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

@end
