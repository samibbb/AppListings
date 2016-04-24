//
//  HFTopListingsViewController.m
//  HFAppListings
//
//  Created by Sami B on 2016-04-21.
//  Copyright © 2016 Sami B. All rights reserved.
//
#import "HFListingsManager.h"
#import "HFTopListingsViewController.h"
#import "HFListingCell.h"
#import "HFListing.h"
#import "HFListingDetailViewController.h"

static NSString * HFListingSegueId = @"HFListingSegue";
static NSString * HFListingCellId = @"HFListingCellId";
static NSString * kFavoritesTitle = @"Favorites";
static NSString * kTopAppsTitle = @"Top Apps";


@interface HFTopListingsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy,nonatomic) NSArray<HFListing*> *topListings;
@end

@implementation HFTopListingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 104.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib * listingCellNib = [UINib nibWithNibName:NSStringFromClass(HFListingCell.class) bundle:nil];
    [self.tableView registerNib:listingCellNib forCellReuseIdentifier:HFListingCellId];
    
    [self populateTopListings];
    
}

- (void) populateTopListings {
    __weak typeof(self) weakSelf = self;
    [[HFListingsManager sharedManager] fetchTopListingsWithCompletion:^(NSArray<HFListing *> * _Nullable retrievedListings) {
        weakSelf.topListings = retrievedListings;
        [weakSelf.tableView reloadData];
        
        weakSelf.title = kTopAppsTitle;
        weakSelf.navigationItem.rightBarButtonItem.title = kFavoritesTitle;
        weakSelf.navigationItem.leftBarButtonItem.title = @"";
        
        [UIView animateWithDuration:0.5f animations:^{
            self.tableView.alpha = 1.0f;
        }];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFListingCell * listingCell = [tableView dequeueReusableCellWithIdentifier:HFListingCellId forIndexPath:indexPath];
    listingCell.listing = self.topListings[indexPath.row];
    return listingCell;
}
- (IBAction)favoritesPressed:(id)sender {
    self.topListings = [HFListingsManager sharedManager].favorites;
    [self.tableView reloadData];
    
    self.title = kFavoritesTitle;
    self.navigationItem.rightBarButtonItem.title = @"";
    self.navigationItem.leftBarButtonItem.title = kTopAppsTitle;
}

- (IBAction)topAppsPressed:(id)sender {
    [self populateTopListings];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.title isEqualToString:kFavoritesTitle]){
        self.topListings = [HFListingsManager sharedManager].favorites;
    }
    
    [self.tableView reloadData];
    
    if (!self.topListings){
        self.tableView.alpha = 0.0f;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HFListingCell * appCell = (HFListingCell*)cell;
    appCell.rankingLabel.text = @(indexPath.row + 1).stringValue;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self performSegueWithIdentifier:HFListingSegueId sender:[self.tableView cellForRowAtIndexPath:indexPath]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:HFListingSegueId]){
        HFListingDetailViewController * listingDetailView = (HFListingDetailViewController*)segue.destinationViewController;
        HFListingCell * selectedCell = (HFListingCell*)sender;
        listingDetailView.listing = selectedCell.listing;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topListings.count;
}

@end
