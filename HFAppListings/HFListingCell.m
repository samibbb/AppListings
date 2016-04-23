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
@end

@implementation HFListingCell

- (void)setListing:(HFListing *)listing {
    _listing = listing;
    [self.appImageView sd_setImageWithURL:listing.thumbnailUrl];
    self.appTitleLabel.text = listing.appTitle;
    self.appCategoryLabel.text = listing.category;
    self.appPriceLabel.text = listing.price;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
