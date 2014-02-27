//
//  CKViewController.m
//  cakely
//
//  Created by Adam Gluck on 1/26/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import "CKLoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CKServerInteraction.h"
#import "CKAppDelegate.h"
#import "CKHeadlinesViewController.h"

@interface CKLoginViewController () <CKServerInteractionDelegate, FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet FBLoginView *fbLoginView;
@property (strong, nonatomic) CKServerInteraction * server;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation CKLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fbLoginView.delegate = self;
}

#pragma mark - FBLoginView Delegate

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user
{
    NSLog(@"fetched user");
    FBAccessTokenData * accessTokenData = [[FBSession activeSession] accessTokenData];
    NSString * accessTokenString = accessTokenData.accessToken;
    [self.server storeFBOAuthToken:accessTokenString];
    [self.server storeFacebookID:user.id];
    [self _postLoginToServer];
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    NSLog(@"showing user");
    // post to server if we have all their data
    [self _postLoginToServer];
}

#pragma mark - handle local data errors

- (void)loginView:(FBLoginView *)loginView handleError: (NSError *)error
{
    UIAlertView * facebookError = [[UIAlertView alloc] initWithTitle:@"Facebook error" message:@"We need you to login to Facebook so we can figure out the content you like!" delegate:self cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
    [facebookError show];
}

-(void)handleLoginError:(NSError *)error
{
    if (error.code == CKServerMissingDeviceToken){
        // store a blank device token
        // TODO: Find a better way of handling this in the future... such as testing for device token and sending
        NSLog(@"missing device token");
        [self.server storeDeviceToken:@""];
        [self _postLoginToServer];
    }
    // ELSE: rely on delegate to handle the facebook error
}

#pragma mark - CKServerInteraction delegate

// this functions like a recursive function
// once we know we have all the local data, we need to post to sever until we get a 201 response
-(void)userLoginResponse:(NSHTTPURLResponse *)response error:(NSError *)error
{
    // if not response no server connection
    if (!response){
        NSLog(@"no response");
        UIAlertView * noConnection = [[UIAlertView alloc] initWithTitle:@"Couldn't connect to server." message:@"Please check your internet connection and re-open the app to try again." delegate:self cancelButtonTitle:@"Thanks." otherButtonTitles: nil];
        [noConnection show];
        [self _postLoginToServer];
        return;
    }
    
    NSInteger statusCode = response.statusCode;
    NSLog(@"userLoginResponse = %ld", (long)statusCode);
    if (statusCode == 201){
        NSLog(@"statusCode == 201");
        [[CKServerInteraction sharedServer] setLoginStatus:YES];
        UINavigationController * initialController = (UINavigationController *)[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        [[UIApplication sharedApplication] delegate].window.rootViewController = initialController;
    } else {
        // unknown error occured
        // for now just keep posting, better handling in the future
        [self _postLoginToServer];
    }
}

#pragma mark - CKServerInteraction wrappers

-(void)_postLoginToServer
{
    NSError * error;
    [self.server postUserLogin:&error];
    if (error){
        [self handleLoginError:error];
    } else {
        self.fbLoginView.hidden = YES;
        [self.activityIndicator startAnimating];
    }
}

#pragma mark - lazy instantiation

-(CKServerInteraction *)server
{
    if (!_server){
        _server = [CKServerInteraction sharedServer];
        _server.delegate = self;
    }
    return _server;
}

#pragma mark - additional boiler plate

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
