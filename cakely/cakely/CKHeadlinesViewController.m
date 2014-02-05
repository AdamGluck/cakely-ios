//
//  CKHeadlinesViewController.m
//  cakely
//
//  Created by Adam Gluck on 1/26/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import "CKHeadlinesViewController.h"

@interface CKHeadlinesViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIFont * headlineFont;
@property (strong, nonatomic) UIColor * headlineColor;

@property (strong, nonatomic) UIFont * tagsFont;
@property (strong, nonatomic) UIColor * tagsColor;

@property (strong, nonatomic) UIImage * seperatorLine;

@end

@implementation CKHeadlinesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HeadlineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UILabel * headlineLabel = (UILabel *)[cell viewWithTag:1];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];

    paragraphStyle.lineSpacing = 3.0f;
    
    headlineLabel.attributedText = [[NSAttributedString alloc]
                                       initWithString:@"Why Is The American Dream Dead In The South?" attributes: @{
                                       NSFontAttributeName: self.headlineFont,
                                       NSForegroundColorAttributeName: self.headlineColor,
                                       NSKernAttributeName: @0.33,
                                       NSParagraphStyleAttributeName: paragraphStyle}];
    
    UILabel * tagsLabel = (UILabel *)[cell viewWithTag:2];
    tagsLabel.attributedText = [[NSAttributedString alloc]
                                initWithString:@"Politics, Economics, Education"
                                attributes:@{
                                NSFontAttributeName: self.tagsFont,
                                NSForegroundColorAttributeName: self.tagsColor,
                                NSKernAttributeName: @0.33}];
    
    UIImageView * lineImageView = (UIImageView *)[cell viewWithTag:3];
    lineImageView.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0f];
    return cell;
}

-(UIFont *)headlineFont{
    if (!_headlineFont){
        _headlineFont = [UIFont fontWithName:@"SourceSansPro-Regular" size:15.0f];
        
    }
    return _headlineFont;
}

-(UIColor *)headlineColor{
    if (!_headlineColor){
        _headlineColor = [UIColor colorWithRed:18.0/255.0 green:20.0/255.0 blue:23.0/255.0 alpha:1.0f];
    }
    return _headlineColor;
}

-(UIFont *)tagsFont{
    if (!_tagsFont){
        _tagsFont = [UIFont fontWithName:@"SourceSansPro-Regular" size:12.0f];
    }
    return _tagsFont;
}

-(UIColor *)tagsColor{
    if (!_tagsColor){
        _tagsColor = [UIColor colorWithRed:95.0/255.0 green:101.0/255.0 blue:112.0/255.0 alpha:1.0f];
    }
    return _tagsColor;
}

-(UIImage *)seperatorLine{
    if (!_seperatorLine){
        _seperatorLine = [UIImage imageNamed:@"Line"];
        NSLog(@"%f, %f", _seperatorLine.size.width, _seperatorLine.size.height);
    }
    return _seperatorLine;
}

@end
