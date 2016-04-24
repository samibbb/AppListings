//
//  HFListing.m
//  HFAppListings
//
//  Created by Sami B on 2016-04-22.
//  Copyright © 2016 Sami B. All rights reserved.
//

#import "HFListing.h"
#import "NSString+Currency.h"
#import "HFListingsManager.h"

typedef enum {
    HPAppIconIndex_Thumbnail = 1,
    HPAppIconIndex_Large
} HFAppIconIndex;

@implementation HFListing

- (NSString *)displayPrice {
    
    NSString * sanitizedPrice = self.price.doubleValue > 0.0 ? self.price.dollarAmount : NSLocalizedString(@"FREE >", @"Free label");
    return sanitizedPrice;
    
}

- (NSString *)activityDescription {
    return [NSString stringWithFormat:@"%@ by %@ \n %@", self.appTitle, self.publisherName, self.appUrl];
}

- (BOOL) isFavorited {
    return [[HFListingsManager sharedManager].favorites containsObject:self];
}

- (NSString *)shortSummary {
    
    // Return text up to to first line break, or first sentence - whichever is shorter
    NSString *upToFirstLineBreak = [[self.summary componentsSeparatedByString:@"\n"].firstObject stringByAppendingString:@"."];
    NSString *firstSentence = @"";
    NSScanner *scanner = [NSScanner scannerWithString:self.summary];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@".!"];
    [scanner scanUpToCharactersFromSet:set intoString:&firstSentence];
    
    return upToFirstLineBreak.length > firstSentence.length ? [firstSentence stringByAppendingString:@"."] : upToFirstLineBreak;
}

- (NSURL *)thumbnailUrl {
    return [NSURL URLWithString:[self.appIconSet[HPAppIconIndex_Thumbnail] imageUrl]];
}

- (NSURL *)largeImageUrl {
    return [NSURL URLWithString:[self.appIconSet[HPAppIconIndex_Large] imageUrl]];
}

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id.attributes.im:id":@"appIdentifier",
                                                       @"im:name.label": @"appTitle",
                                                       @"im:image":@"appIconSet",
                                                       @"category.attributes.label":@"category",
                                                       @"summary.label": @"summary",
                                                       @"im:price.attributes.amount": @"price",
                                                       @"link.attributes.href": @"appUrl",
                                                       @"im:artist.label":@"publisherName",
                                                       @"im:artist.attributes.href":@"publisherUrl",
                                                       @"im:releaseDate.attributes.label":@"releaseDate"}];
}


- (BOOL)isEqual:(HFListing*)listing {    
    return [self.appIdentifier isEqualToString:listing.appIdentifier];
}

@end

@implementation HFListingImage

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"label":@"imageUrl",
                                                       @"attributes.height":@"size"}];
}

@end