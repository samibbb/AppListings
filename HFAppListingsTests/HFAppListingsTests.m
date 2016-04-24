
//
//  HFAppListingsTests.m
//  HFAppListingsTests
//
//  Created by Sami B on 2016-04-21.
//  Copyright © 2016 Sami B. All rights reserved.
//
#import "HFListingsManager.h"
#import <XCTest/XCTest.h>
#import "HFListing.h"

@interface HFAppListingsTests : XCTestCase
@property (nonatomic,strong) XCTestExpectation * fetchListingExpectation;
@end

@implementation HFAppListingsTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testRemovingFromFavorites {
    
    XCTestExpectation * removalPromise = [self expectationWithDescription:@"FavRemovalPromise"];
    
    [[HFListingsManager sharedManager] fetchTopListingsWithCompletion:^(NSArray<HFListing *> * _Nullable retrievedListings) {
        
        __block BOOL removalSuccess = YES; // True by default, in case favorites are empty
        [retrievedListings enumerateObjectsUsingBlock:^(HFListing * _Nonnull appListing, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (appListing.isFavorited){
                removalSuccess = [[HFListingsManager sharedManager] removeFromFavorites:appListing];
                *stop = YES;
                XCTAssertTrue(removalSuccess);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    XCTAssertFalse(appListing.isFavorited);
                });
                
            }
            
        }];
        
        [removalPromise fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0f handler:^(NSError * _Nullable error) {
        NSLog(@"Error removing from favorites : %@", error.localizedDescription);
    }];
}

- (void)testAddingToFavorites {
    XCTestExpectation * favoritesPromise = [self expectationWithDescription:@"AddFavoritePromise"];
    
    [[HFListingsManager sharedManager] fetchTopListingsWithCompletion:^(NSArray<HFListing *> * _Nullable retrievedListings) {
        
        [retrievedListings enumerateObjectsUsingBlock:^(HFListing * _Nonnull appListing, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (!appListing.isFavorited){
                BOOL addSuccess = [[HFListingsManager sharedManager] addToFavorites:appListing];
                *stop = YES;
                XCTAssertTrue(addSuccess);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    XCTAssertTrue(appListing.isFavorited);
                });
                
            }
            
        }];
        
        [favoritesPromise fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0f handler:^(NSError * _Nullable error) {
        NSLog(@"Error adding to favorites : %@", error.localizedDescription);
    }];
}

- (void)testListingRequest {
    XCTestExpectation * topListingsPromise = [self expectationWithDescription:@"TopListingsExpectation"];
    
    NSUInteger expectedCount = 50;
    
    [[HFListingsManager sharedManager] fetchTopListingsWithCompletion:^(NSArray<HFListing *> * _Nullable retrievedListings) {
       
        XCTAssertTrue(retrievedListings.count == expectedCount, @"Should receive 50 top apps");
        [retrievedListings enumerateObjectsUsingBlock:^(HFListing * _Nonnull listing, NSUInteger idx, BOOL * _Nonnull stop) {
            XCTAssertTrue([listing isKindOfClass:HFListing.class], @"Should serialize each app listing to HFListing model");
            XCTAssertNotNil(listing.largeImageUrl, @"Should have a non-nil large image url");
            XCTAssertNotNil(listing.thumbnailUrl, @"Should have a non-nil thumbnail url");
            XCTAssertNotNil(listing.summary, @"Should have a non-nil summary");
            XCTAssertNotNil(listing.publisherUrl, @"Should have a non-nil publisher URL");
            XCTAssertNotNil(listing.publisherName, @"Should have a non-nil publisher name");
            XCTAssertNotNil(listing.appTitle, @"Should have a non-nil title");
            XCTAssertNotNil(listing.appIdentifier, @"Should have a non-nil app id");
            XCTAssertNotNil(listing.appUrl, @"Should have a non-nil app store URL");
            XCTAssertNotNil(listing.price, @"Should have a non-nil price");
            XCTAssertNotNil(listing.category, @"Should have a non-nil category");
        }];
        
        [topListingsPromise fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0f handler:^(NSError * _Nullable error) {
       
        NSLog(@"Error retrieving top listings : %@", error.localizedDescription);
        
    }];
}

@end
