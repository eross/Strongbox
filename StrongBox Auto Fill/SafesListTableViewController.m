//
//  SafesListTableViewController.m
//  Strongbox Auto Fill
//
//  Created by Mark on 11/10/2018.
//  Copyright © 2018 Mark McGuill. All rights reserved.
//

#import "SafesListTableViewController.h"
#import "SafeMetaData.h"
#import "SafesList.h"
#import "InitialTabViewController.h"
#import "SafeStorageProviderFactory.h"
#import "Settings.h"

@interface SafesListTableViewController ()

@property NSArray<SafeMetaData*> *safes;

@end

@implementation SafesListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.safes = SafesList.sharedInstance.snapshot;

    if([self getPrimarySafe]) {
        [self.barButtonShowQuickView setEnabled:YES];
        [self.barButtonShowQuickView setTintColor:nil];
    }
    else {
        [self.barButtonShowQuickView setEnabled:NO];
        [self.barButtonShowQuickView setTintColor: [UIColor clearColor]];
    }
}

- (SafeMetaData*)getPrimarySafe {
    SafeMetaData* primary = [self.safes firstObject];
    
    return primary;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.safes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    SafeMetaData *safe = [self.safes objectAtIndex:indexPath.row];
    
    cell.textLabel.text = safe.nickName;
    cell.detailTextLabel.text = safe.fileName;
    
    id<SafeStorageProvider> provider = [SafeStorageProviderFactory getStorageProviderFromProviderId:safe.storageProvider];
    NSString *icon = provider.icon;
    cell.imageView.image = [UIImage imageNamed:icon];
    
    return cell;
}

- (InitialTabViewController *)getInitialViewController {
    InitialTabViewController *ivc = (InitialTabViewController*)self.navigationController.parentViewController;
    return ivc;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onShowQuickLaunchView:(id)sender {
    NSLog(@"TODO: Show Quick View");
    Settings.sharedInstance.useQuickLaunchAsRootView = YES;
    
    [[self getInitialViewController] showQuickLaunchView];
}

@end
