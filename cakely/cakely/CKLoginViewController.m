//
//  CKViewController.m
//  cakely
//
//  Created by Adam Gluck on 1/26/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import "CKLoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface CKLoginViewController ()

@end

@implementation CKLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
    [self performSegueWithIdentifier:@"toArticleDisplay" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
