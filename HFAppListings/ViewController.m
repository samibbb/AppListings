//
//  ViewController.m
//  HFAppListings
//
//  Created by Sami B on 2016-04-21.
//  Copyright © 2016 Sami B. All rights reserved.
//
#import "HFListingsManager.h"
#import "ViewController.h"
#import "HFListingCell.h"
#import "HFListing.h"

static NSString * HFListingCellId = @"HFListingCellId";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray<HFListing*> *topListings;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 89.0f;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(HFListingCell.class)
                                               bundle:nil] forCellReuseIdentifier:HFListingCellId];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topListings.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
