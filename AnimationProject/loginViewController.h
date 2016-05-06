//
//  loginViewController.h
//  AnimationProject
//
//  Created by Vladyslav Gusakov on 4/10/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
- (IBAction)login:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *wrongCredentialsLabel;

@end
