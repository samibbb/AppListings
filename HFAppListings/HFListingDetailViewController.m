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
#import "HFListingsManager.h"

static NSString * kFavoritedIconName = @"favorited";
static NSString * kNotFavoritedIconName = @"favicon";

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
    
    self.title = theListing.appTitle;
    
    [self.appImageView sd_setImageWithURL:theListing.largeImageUrl];
    
    self.appTitleLabel.text = theListing.appTitle;
    self.appPublisherLabel.text = theListing.publisherName;
    self.appReleaseDateLabel.text = theListing.releaseDate;
    self.appPriceLabel.text = theListing.displayPrice;
    self.descriptionTextView.text = theListing.summary;
    
    [self.appPriceLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openInAppStore)]];
    [self.appImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openInAppStore)]];
    
    if (theListing.isFavorited){
        [self.favoriteButton setImage:[UIImage imageNamed:kFavoritedIconName] forState:UIControlStateNormal];
    }
}

- (void) openInAppStore {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.listing.appUrl]];
}

- (IBAction)shareButtonPressed:(id)sender {
    UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:@[self.listing.activityDescription] applicationActivities:nil];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (IBAction)favoriteButtonPressed:(id)sender {
    
    HFListing * theListing = self.listing;
    
    BOOL success = NO;
    
    if (!theListing) return;
    
    if (!theListing.isFavorited){
        success = [[HFListingsManager sharedManager] addToFavorites:theListing];
        if (success)[self.favoriteButton setImage:[UIImage imageNamed:kFavoritedIconName] forState:UIControlStateNormal];
    } else {
        success = [[HFListingsManager sharedManager] removeFromFavorites:theListing];
        if (success)[self.favoriteButton setImage:[UIImage imageNamed:kNotFavoritedIconName] forState:UIControlStateNormal];
    }
    
    if (!success){
        NSError * writeError = [NSError errorWithDomain:NSCocoaErrorDomain
                                                   code:0
                                               userInfo:@{ NSLocalizedDescriptionKey : @"Error writing to disk"}];
        [HFListingsManager handleFailure:writeError];
    }
    
}

@end
