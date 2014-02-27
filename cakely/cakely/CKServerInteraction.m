//
//  CKServerInteraction.m
//  cakely
//
//  Created by Adam Gluck on 2/25/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import "CKServerInteraction.h"

@interface CKServerInteraction() <NSURLSessionDataDelegate>

@property (strong, nonatomic) NSUserDefaults * defaults;

@end

@implementation CKServerInteraction

static CKServerInteraction * sharedServer = nil;
static dispatch_once_t onceToken;

#pragma mark - Singleton
+(CKServerInteraction *)sharedServer
{
    dispatch_once(&onceToken, ^{
        sharedServer = [[self alloc] init];
    });
    return sharedServer;
};

#pragma mark - Constants
#pragma mark - URLs

-(NSString *)userURLString
{
    return @"http://cakely-backend.herokuapp.com/user/";
}

#pragma mark - Keys
//{"facebook_id" : $facebook_id, "oauth_token": $oauth_token, "device_token": $phone_id}
#define FACEBOOK_ID_KEY "facebook_id"
#define FB_OAUTH_TOKEN_KEY "oauth_token"
#define DEVICE_TOKEN_KEY "device_token"
#define IS_LOGGED_IN_KEY "is_logged_in_key"

#pragma mark - NSUserDefaults
#pragma mark - Defaults Getters

-(NSString *)facebookID
{
    return [self.defaults objectForKey:@FACEBOOK_ID_KEY];
}

-(NSString *)fbOAuthToken
{
    return [self.defaults objectForKey:@FB_OAUTH_TOKEN_KEY];
}

-(NSString *)deviceToken
{
    return [self.defaults objectForKey:@DEVICE_TOKEN_KEY];
}

-(BOOL)isLoggedIn
{
    return [self.defaults boolForKey:@IS_LOGGED_IN_KEY];
}

#pragma mark - Defaults Setters
-(void)storeFacebookID:(NSString *)facebookID
{
    [self.defaults setObject:facebookID forKey:@FACEBOOK_ID_KEY];
}

-(void)storeFBOAuthToken:(NSString *)fbOAuthToken
{
    [self.defaults setObject:fbOAuthToken forKey:@FB_OAUTH_TOKEN_KEY];
}

-(void)storeDeviceToken:(NSString *)deviceToken
{
    [self.defaults setObject:deviceToken forKey:@DEVICE_TOKEN_KEY];
}

-(void)setLoginStatus:(BOOL)loggedIn
{
    [self.defaults setBool:loggedIn forKey:@IS_LOGGED_IN_KEY];
}

#pragma mark - Server Post
#pragma mark - Public Post Method

-(BOOL)postUserLogin:(NSError **)error
{
    NSMutableURLRequest * request = [self userLoginRequest];
    if (request){
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(userLoginResponse:error:)])
                    [self.delegate userLoginResponse:httpResponse error:error];
            });
        }];
        [postDataTask resume];
        return YES;
    }
    
    if (error){
        *error = [self serverInteractionLoginDetailError];
    }
    return NO;
}


#pragma mark - Post To Server Helpers

-(NSMutableURLRequest *)userLoginRequest
{
    if ([self validateLoginDetails]){
        NSURL * postURL = [NSURL URLWithString:[self userURLString]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        request.HTTPMethod = @"POST";
        NSError * error;
        NSDictionary * postBody = @{@FACEBOOK_ID_KEY: [self facebookID], @FB_OAUTH_TOKEN_KEY: [self fbOAuthToken], @DEVICE_TOKEN_KEY: [self deviceToken]};
        NSData * data = [NSJSONSerialization dataWithJSONObject:postBody
                                                        options:kNilOptions error:&error];
        request.HTTPBody = data;
        return request;
    }
    return nil;
}

#pragma mark - Validation

-(BOOL)validateLoginDetails
{
    return [self facebookID] && [self fbOAuthToken] && [self deviceToken];
}

#pragma mark - Custom Error Handling

-(NSError *)serverInteractionLoginDetailError
{
    CKServerInteractionErrorCode errorCode = [self loginErrorCode];
    NSDictionary * userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Missing login details", nil)};
    NSError * error = [NSError errorWithDomain:@"CKServerInteractionError" code:errorCode userInfo:userInfo];
    return error;
}

-(CKServerInteractionErrorCode)loginErrorCode
{
    CKServerInteractionErrorCode errorCode;
    if (![self facebookID] && ![self fbOAuthToken] && ![self deviceToken]){
        errorCode = CKServerMissingAllDetails;
    } else if (![self deviceToken]){
        errorCode = CKServerMissingDeviceToken;
    } else if (![self facebookID] || ![self fbOAuthToken]){
        errorCode = CKServerMissingFacebookData;
    } else {
        errorCode = CKServerUnknownError;
    }
    return errorCode;
}

#pragma mark - Server Get
#pragma mark - Get Articles

-(void)getUserArticles:(NSError **)error
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@=%@", [self userURLString], @FACEBOOK_ID_KEY, [self facebookID]];
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
    NSURLSessionDataTask *jsonData = [session dataTaskWithURL:[NSURL URLWithString:urlString]completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
            NSArray * dataResponse = (NSArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(userArticleResponse:data:error:)]){
                    [self.delegate userArticleResponse:(NSHTTPURLResponse*)response data:dataResponse error:error];
                }
            });
    }];
    [jsonData resume];
}

#pragma mark - lazy instantiation

-(NSUserDefaults *)defaults
{
    if (!_defaults){
        _defaults = [[NSUserDefaults alloc] init];
    }
    return _defaults;
}

@end
