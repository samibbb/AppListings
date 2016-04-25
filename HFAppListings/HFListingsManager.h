//
//  HFListingsManager.h
//  HFAppListings
//
//  Created by Sami B on 2016-04-21.
//  Copyright © 2016 Sami B. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HFListing;

typedef void (^HFListingRequestCompletion)(NSArray<HFListing*> * _Nullable retrievedListings);

@interface HFListingsManager : NSObject

/*!
 * @brief Persited app listings favorited by the user
 * @return An array of @p HFListing objects
 */
@property (readonly) NSArray<HFListing*> * _Nonnull  favorites;

+ (instancetype __nonnull)sharedManager;

+ (void) handleFailure:(NSError* _Nullable)error;

- (BOOL) addToFavorites:(HFListing* _Nonnull)newFavorite;
- (BOOL) removeFromFavorites:(HFListing* _Nonnull)listing;
- (void) fetchTopListingsWithCompletion:(HFListingRequestCompletion _Nullable)completion;
@end
