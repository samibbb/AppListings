//
//  HFListingDetailViewController.m
//  HFAppListings
//
//  Created by Sami B on 2016-04-23.
//  Copyright © 2016 Sami B. All rights reserved.
//
#import "HFListing.h"
#import "HFListingDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSString+Currency.h"

@interface HFListingDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *appImageView;
@property (weak, nonatomic) IBOutlet UILabel *appTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *appPublisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *appReleaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *appPriceLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@end

@implementation HFListingDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    HFListing * theListing = self.listing;
    
    [self.appImageView sd_setImageWithURL:theListing.largeImageUrl];
    
    self.appTitleLabel.text = theListing.appTitle;
    self.appPublisherLabel.text = theListing.publisherName;
    self.appReleaseDateLabel.text = theListing.releaseDate;
    self.appPriceLabel.text = theListing.displayPrice;
    self.descriptionTextView.text = theListing.summary;
}
@end
