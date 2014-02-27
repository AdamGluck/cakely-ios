//
//  CKArticle.h
//  cakely
//
//  Created by Adam Gluck on 2/27/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKArticle : NSObject

@property (strong, nonatomic) NSString * description;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSURL * url;

@end
