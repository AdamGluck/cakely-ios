//
//  CKHeadlinesViewController.m
//  cakely
//
//  Created by Adam Gluck on 1/26/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import "CKHeadlinesViewController.h"

@interface CKHeadlinesViewController () <UIGestureRecognizerDelegate>

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
    self.view.backgroundColor =[UIColor colorWithRed:83.0/255.0 green:108.0/255.0 blue:148.0/255.0 alpha:0.8f];
    //self.navigationController.interactivePopGestureRecognizer.delegate = self;
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
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HeadlineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITextView * cellTextView = (UITextView *)[cell viewWithTag:1];
    cellTextView.font = [UIFont fontWithName:@"DuruSans-Regular" size:14.0f];
    cellTextView.textColor = [UIColor colorWithRed:32.5/255.0 green:40.0/255.0 blue:42.5/255.0 alpha:1.0f];
    return cell;
}

#define HEADER_VIEW_HEIGHT 30.0

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, HEADER_VIEW_HEIGHT)];
    headerView.backgroundColor = [UIColor colorWithRed:83.0/255.0 green:108.0/255.0 blue:148.0/255.0 alpha:0.8f];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, 320.0, 20.0)];
    headerLabel.text = @"Top News Selected For You";
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:headerLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_VIEW_HEIGHT;
}

@end
