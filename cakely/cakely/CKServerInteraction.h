//
//  CKServerInteraction.h
//  cakely
//
//  Created by Adam Gluck on 2/25/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CKServerInteractionErrorCode){
    CKServerMissingFacebookData,
    CKServerMissingDeviceToken,
    CKServerMissingAllDetails,
    CKServerUnknownError
};

@protocol CKServerInteractionDelegate <NSObject>
@optional
-(void)userLoginResponse:(NSHTTPURLResponse *)response error:(NSError *)error;
-(void)userArticleResponse:(NSHTTPURLResponse *)response data:(NSArray *)data error:(NSError *)error;
@end

@interface CKServerInteraction : NSObject

// CKServerInteraction
+(CKServerInteraction *)sharedServer;

// These methods enable one to persistantly store this data
-(NSString *)facebookID;
-(NSString *)fbOAuthToken;
-(NSString *)deviceToken;
-(BOOL)isLoggedIn;

-(void)storeFacebookID:(NSString *)facebookID;
-(void)storeFBOAuthToken:(NSString *)fbOAuthToken;
-(void)storeDeviceToken:(NSString *)deviceToken;
-(void)setLoginStatus:(BOOL)loggedIn;

/**
 @abstract Posts critical user login information to the server.
 @discussion Make sure to call storeFacebookID:, storeFacebookOauthToken, and storeDeviceToken before calling. If it returns an error you can test error codes in CKServerInteractionErrorCode to handle response. Finally, it does not send a message to the server unless all that data is there, and will instead return an error. Basically, use NSError to handle local errors, and delegate callbacks to handle serve errors.
*/
-(BOOL)postUserLogin:(NSError **)error;
-(void)getUserArticles:(NSError **)error;

@property (weak, nonatomic) id <CKServerInteractionDelegate> delegate;

@end
