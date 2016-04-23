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
+ (instancetype __nonnull)sharedManager;
- (void) fetchTopListingsWithCompletion:(HFListingRequestCompletion _Nullable)completion;
@end
