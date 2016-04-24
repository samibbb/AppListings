//
//  HFListing.h
//  HFAppListings
//
//  Created by Sami B on 2016-04-22.
//  Copyright © 2016 Sami B. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol HFListingImage
@end

@interface HFListingImage : JSONModel
@property (nonatomic,copy) NSString * imageUrl;
@property (nonatomic,assign) NSString * size;
@end

@interface HFListing : JSONModel
@property (nonatomic,copy) NSString * appTitle;
@property (nonatomic,copy) NSString * appUrl;
@property (nonatomic,copy) NSString * category;
@property (nonatomic,copy) NSString * price;
@property (nonatomic,copy) NSString * publisherName;
@property (nonatomic,copy) NSString * publisherUrl;
@property (nonatomic,copy) NSString * releaseDate;
@property (nonatomic,copy) NSString * summary;
@property (nonatomic,strong) NSArray<HFListingImage> * appIconSet;

@property (nonatomic,readonly) NSURL * thumbnailUrl;
@property (nonatomic,readonly) NSURL * largeImageUrl;
@property (nonatomic,readonly) NSString * shortSummary;

@end
