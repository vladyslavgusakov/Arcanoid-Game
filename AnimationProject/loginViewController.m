//
//  loginViewController.m
//  AnimationProject
//
//  Created by Vladyslav Gusakov on 4/10/16.
//  Copyright © 2016 Vladyslav Gusakov. All rights reserved.
//

#import "loginViewController.h"
#import "ViewController.h"

static NSString *kWebsite = @"http://ec2-54-213-220-48.us-west-2.compute.amazonaws.com:8080/validate.jsp";
static NSString *kWebsiteSuccess = @"http://ec2-54-213-220-48.us-west-2.compute.amazonaws.com:8080/success.html";

@interface loginViewController () {
    ViewController *mainController;
    BOOL success;
}

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mainController = (ViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURL *url = [NSURL URLWithString:kWebsite];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *params = [NSString stringWithFormat:@"username=%@&password=%@", self.username.text, self.password.text];
    request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // The server answers with an error because it doesn't receive the params
        NSLog(@"response: %@", response.URL);
        
        if ([[response.URL absoluteString] isEqualToString:kWebsiteSuccess]) {
            NSLog(@"popover");
            success = TRUE;
            
        }
        else {
            success = FALSE;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success == TRUE) {
                mainController.usr = self.username.text;
                
                [self presentViewController:mainController animated:YES completion:nil];
            } else {
                self.wrongCredentialsLabel.hidden = NO;
            }
        });
    }];
    
    [postDataTask resume];

}


@end
