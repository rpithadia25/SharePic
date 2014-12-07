//
//  HRProfileViewController.m
//  SharePic
//
//  Created by Rakshit Pithadia on 12/2/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "HRSelectProfileViewController.h"
#import "HRFlickr.h"

#define kHRSettingImageResizeFactor 3.5

@interface HRSelectProfileViewController ()
@property NSMutableDictionary *supportedAccounts;
@end

@implementation HRSelectProfileViewController
@synthesize supportedAccounts = _supportedAccounts;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _supportedAccounts = [[NSMutableDictionary alloc] init];
    NSArray *supportedAccounts = [HRAbstractAccount supportedAccounts];
    for (HRAbstractAccount *account in supportedAccounts) {
        [_supportedAccounts setObject:account forKey:[account description]];
    }
    
    [self loadProfiles];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:HRBackButtonLabel
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushNewViewController)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIImage* settingsImage = [UIImage imageNamed:@"Settings.png"];
    CGRect frame = CGRectMake(0, 0, settingsImage.size.width / kHRSettingImageResizeFactor, settingsImage.size.height / kHRSettingImageResizeFactor);
    UIButton *settingsButton = [[UIButton alloc] initWithFrame:frame];
    [settingsButton setBackgroundImage:settingsImage forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(settingsButtonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    [settingsButton setShowsTouchWhenHighlighted:YES];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
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
    if ([profile profileName]) {
        cell.textLabel.text = [profile profileName];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_profiles removeObjectAtIndex:indexPath.row];
        [self saveUserDefaults];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(IBAction)pushNewViewController {    
    HRCreateProfileViewController *viewController = [[UIStoryboard storyboardWithName:HRStoryboardMain bundle:nil] instantiateViewControllerWithIdentifier:HRCreateProfileStoryBoardIdentifier];
    [viewController callBackDelegate:self];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark HRCreateProfileDelegate Methods

-(void)HRCreateProfileViewWasDismissedWithProfile:(HRProfile *)profile {

    if (!_profiles) {
        _profiles = [[NSMutableArray alloc] init];
    }
    [_profiles insertObject:profile atIndex:0];
    [self saveUserDefaults];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark Button press events

- (IBAction)settingsButtonPressed:(id)sender {
    HRSettingsViewController *settingsViewController = [[UIStoryboard storyboardWithName:HRStoryboardMain bundle:nil]  instantiateViewControllerWithIdentifier:HRSettingsStoryboardIdentifier];

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark Segue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:HRProfileDetailsSegueIdentifier]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] setProfile:_profiles[indexPath.row]];
    }
}

#pragma mark Save User Defaults

-(void) saveUserDefaults {
    
    NSMutableArray *jsonArray = [[NSMutableArray alloc] init];
    for (HRProfile *profile in _profiles) {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:[profile profileName] forKey:HRJSONKeyProfileName];
        NSMutableArray *accountsJSONArray = [[NSMutableArray alloc] init];
        for (HRAbstractAccount *account in [profile accounts]) {
            [accountsJSONArray addObject:[account toNSDistionary]];
        }
        
        [dictionary setValue:accountsJSONArray forKey:HRJSONKeyAccounts];
        [jsonArray addObject:dictionary];
    }
    
    NSData *jsonData = [NSKeyedArchiver archivedDataWithRootObject:jsonArray];
    [[NSUserDefaults standardUserDefaults] setObject:jsonData forKey:HRUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadProfiles {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:HRUserDefaultsKey];
    NSArray *savedJSONArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSMutableArray *profilesData = [[NSMutableArray alloc] init];
    for (NSDictionary *JSONDictionary in savedJSONArray) {
        HRProfile *profile = [[HRProfile alloc] init];
        [profile setProfileName:[JSONDictionary valueForKey:HRJSONKeyProfileName]];
        NSArray *savedAccounts = [JSONDictionary valueForKey:HRJSONKeyAccounts];
        NSMutableArray *accounts = [[NSMutableArray alloc] init];
        for (NSDictionary *accountDictionary in savedAccounts) {
            NSString *accountName = [accountDictionary valueForKey:HRJSONKeyAccountName];
            [accounts addObject:[_supportedAccounts objectForKey:accountName]];
        }
        [profile setAccounts:accounts];
        [profilesData addObject:profile];
    }
    
    _profiles = [NSMutableArray arrayWithArray:profilesData];
}

@end
