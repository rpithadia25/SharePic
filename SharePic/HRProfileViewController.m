//
//  HRProfileViewController.m
//  SharePic
//
//  Created by Rakshit Pithadia on 12/2/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "HRProfileViewController.h"

@interface HRProfileViewController ()

@end

@implementation HRProfileViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushNewViewController)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _profiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HRProfileCell forIndexPath:indexPath];
    
    HRProfile *profile = _profiles[indexPath.row];
    cell.textLabel.text = [profile profileName];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_profiles removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(IBAction)pushNewViewController {
    
    HRCreateProfileViewController *viewController = [[UIStoryboard storyboardWithName:HRStoryboardName bundle:nil] instantiateViewControllerWithIdentifier:HRCreateProfileStoryBoardIdentifier];
    [viewController callBackDelegate:self];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark HRCreateProfileDelegate Methods

-(void)HRCreateProfileViewWasDismissedWithProfile:(HRProfile *)profile {

    if (!_profiles) {
        _profiles = [[NSMutableArray alloc] init];
    }
    [_profiles insertObject:profile atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (IBAction)settingsButtonPressed:(id)sender {
}

#pragma mark Segue Method

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:HRProfileDetailsSegueIdentifier]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        //NSDate *object = self.objects[indexPath.row];
//        //[[segue destinationViewController] setDetailItem:object];
//    }
//}

@end
