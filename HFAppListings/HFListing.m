//
//  HFListing.m
//  HFAppListings
//
//  Created by Sami B on 2016-04-22.
//  Copyright © 2016 Sami B. All rights reserved.
//

#import "HFListing.h"

typedef enum {
    HPAppIconIndex_Thumbnail = 1,
    HPAppIconIndex_Large
} HFAppIconIndex;

@implementation HFListing

+(JSONKeyMapper*)keyMapper{
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"im:name.label": @"appTitle",
                                                       @"im:image":@"appIconSet",
                                                       @"category.attributes.label":@"category",
                                                       @"summary.label": @"summary",
                                                       @"im:price.attributes.amount": @"price",
                                                       @"link.attributes.href": @"appUrl",
                                                       @"im:artist.label":@"publisherName",
                                                       @"im:artist.attributes.href":@"publisherUrl",
                                                       @"im:releaseDate.attributes.label":@"releaseDate"}];
}


- (NSURL *)thumbnailUrl {
    return [NSURL URLWithString:[self.appIconSet[HPAppIconIndex_Thumbnail] imageUrl]];
}

- (NSURL *)largeImageUrl {
    return [NSURL URLWithString:[self.appIconSet[HPAppIconIndex_Large] imageUrl]];
}

@end


@implementation HFListingImage

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"label":@"imageUrl",
                                                       @"attributes.height":@"size"}];
}

@end