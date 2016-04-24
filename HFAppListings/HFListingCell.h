//
//  HFListingCell.h
//  HFAppListings
//
//  Created by Sami B on 2016-04-23.
//  Copyright © 2016 Sami B. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HFListing;

@interface HFListingCell : UITableViewCell
@property (nonatomic,strong) HFListing * listing;
@property (weak, nonatomic) IBOutlet UILabel *rankingLabel;
@end
