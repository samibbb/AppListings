//
//  HFAppListingsUITests.m
//  HFAppListingsUITests
//
//  Created by Sami B on 2016-04-21.
//  Copyright © 2016 Sami B. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface HFAppListingsUITests : XCTestCase

@end

@implementation HFAppListingsUITests

- (void)setUp {
    [super setUp];
    
    self.continueAfterFailure = NO;

    [[[XCUIApplication alloc] init] launch];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSharing {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = app.tables;
    [[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"1"].staticTexts[@"FREE >"] tap];
    [app.buttons[@"shareicon"] tap];
    
    XCUIApplication *app2 = app;
    [[app2.sheets.collectionViews.cells.collectionViews containingType:XCUIElementTypeButton identifier:@"Copy"].buttons[@"More"] tap];
    [tablesQuery.staticTexts[@"Copy"] tap];
    [app.navigationBars[@"Activities"].buttons[@"Done"] tap];
    [app2.sheets.collectionViews.collectionViews.buttons[@"Copy"] tap];
    [app.navigationBars[@"Spotify Music"].buttons[@"Top Apps"] tap];
    
}

- (void) testOpeningAppStore {
    
    if (TARGET_OS_SIMULATOR) return;
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [[app.tables.cells containingType:XCUIElementTypeStaticText identifier:@"4"].staticTexts[@"FREE >"] tap];
    [[[[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"Mobile Strike"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeImage].element tap];
    
}

- (void)testAddingToFavorites {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    // Tap first listing
    XCUIElement * firstListing = [app.tables.cells containingType:XCUIElementTypeStaticText identifier:@"1"].staticTexts[@"FREE >"];
    [firstListing tap];
    
    // Toggle favorite
    [self.favoriteButton tap];
    
    // Navigate back

    XCUIElement * backButton = app.navigationBars[@"Spotify Music"].buttons[@"Top Apps"];
    if (backButton.exists)[backButton tap];
    
    // Check if listing appears in Favorites
    XCUIElement *favoritesNavButton = app.navigationBars[@"Top Apps"].buttons[@"Favorites"];
    [favoritesNavButton tap];
    
    // Back to top apps
    XCUIElement *topAppsButton = app.navigationBars[@"Favorites"].buttons[@"Top Apps"];
    [topAppsButton tap];
    
    // Go back to listing
    [firstListing tap];
    
    [self.favoriteButton tap];
    
    if (backButton.exists)[backButton tap];
    if (favoritesNavButton.exists)[favoritesNavButton tap];
    if (firstListing.exists)[firstListing tap];
    [self.favoriteButton tap];
    if (backButton.exists)[backButton tap];
    
    if (topAppsButton.exists)[topAppsButton tap];
    
}

- (XCUIElement*) favoriteButton {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    return app.buttons[@"favicon"].exists ? app.buttons[@"favicon"] : app.buttons[@"favorited"];
}

@end
