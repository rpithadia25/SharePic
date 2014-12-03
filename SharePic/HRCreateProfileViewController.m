//
//  HRCreateProfileViewController.m
//  SharePic
//
//  Created by Rakshit Pithadia on 12/3/14.
//  Copyright (c) 2014 Harsh Shah, Rakshit Pithadia. All rights reserved.
//

#import "HRCreateProfileViewController.h"

@interface HRCreateProfileViewController ()

@end

@implementation HRCreateProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Create Profile";
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileName"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProfileName"];
    }

    UITextField *profileNameField = [[UITextField alloc] initWithFrame:CGRectMake(120, 7, 185, 30)];
    profileNameField.delegate = self;
    profileNameField.adjustsFontSizeToFitWidth = YES;
    profileNameField.placeholder = @"Enter Profile Name";
    profileNameField.keyboardType = UIKeyboardTypeDefault;
    profileNameField.returnKeyType = UIReturnKeyDone;
    profileNameField.tag = 0;
    profileNameField.clearButtonMode = UITextFieldViewModeAlways;
    
    profileNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    profileNameField.clearButtonMode = UITextFieldViewModeAlways;
    [profileNameField setEnabled:YES];
    
    [cell.contentView addSubview:profileNameField];
    
    cell.textLabel.text = @"Profile Name";
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
