//
//  HFListingCell.m
//  HFAppListings
//
//  Created by Sami B on 2016-04-23.
//  Copyright © 2016 Sami B. All rights reserved.
//

#import "HFListingCell.h"
#import "HFListing.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HFListingCell ()
@property (weak, nonatomic) IBOutlet UIImageView *appImageView;
@property (weak, nonatomic) IBOutlet UILabel *appTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *appCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *appPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *appPublisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortSummaryLabel;
@end

@implementation HFListingCell

- (void)setListing:(HFListing *)listing {
    _listing = listing;
    
    [self.appImageView sd_setImageWithURL:listing.thumbnailUrl];
    
    self.appTitleLabel.text = listing.appTitle;
    
    self.shortSummaryLabel.text = listing.shortSummary;
    
    self.appCategoryLabel.text = listing.category;
    
    self.appPublisherLabel.text = listing.publisherName;
    
    self.appPriceLabel.text = listing.displayPrice;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
@end
