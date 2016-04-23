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

@interface HFTopListingsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray<HFListing*> *topListings;
@end

@implementation HFTopListingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    
    self.tableView.estimatedRowHeight = 104.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib * listingCellNib = [UINib nibWithNibName:NSStringFromClass(HFListingCell.class) bundle:nil];
    [self.tableView registerNib:listingCellNib forCellReuseIdentifier:HFListingCellId];
    
    [[HFListingsManager sharedManager] fetchTopListingsWithCompletion:^(NSArray<HFListing *> * _Nullable retrievedListings) {
        weakSelf.topListings = retrievedListings;
        [weakSelf.tableView reloadData];
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HFListingCell * listingCell = [tableView dequeueReusableCellWithIdentifier:HFListingCellId forIndexPath:indexPath];
    listingCell.listing = self.topListings[indexPath.row];
    
    return listingCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
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
