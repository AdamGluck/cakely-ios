//
//  CKHeadlinesViewController.m
//  cakely
//
//  Created by Adam Gluck on 1/26/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import "CKHeadlinesViewController.h"
#import "ArticleAnimation.h"
#import "CKServerInteraction.h"
#import "CKArticle.h"
#import "CKContentViewController.h"

@interface CKHeadlinesViewController () <UIGestureRecognizerDelegate, CKServerInteractionDelegate>

@property (strong, nonatomic) UIFont * headlineFont;
@property (strong, nonatomic) UIColor * headlineColor;
@property (strong, nonatomic) UIFont * tagsFont;
@property (strong, nonatomic) UIColor * tagsColor;
@property (strong, nonatomic) UIImage * seperatorLine;
@property (strong, nonatomic) ArticleAnimation * animation;
@property (strong, nonatomic) NSArray * articles;

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
    self.navigationController.delegate = self;
    self.navigationController.navigationBar.translucent = NO;
    [CKServerInteraction sharedServer].delegate = self;
    [[CKServerInteraction sharedServer] getUserArticles:nil];
}

-(void)userArticleResponse:(NSHTTPURLResponse *)response data:(NSArray *)data error:(NSError *)error
{
    if (!error){
        NSMutableArray * mutableArticles = [NSMutableArray array];
        for (NSDictionary * articleDictionary in data){
            CKArticle * article = [[CKArticle alloc] init];
            article.title = articleDictionary[@"title"];
            article.description = articleDictionary[@"description"];
            article.url = [NSURL URLWithString:articleDictionary[@"url"]];
            [mutableArticles addObject:article];
        }
        self.articles = [mutableArticles copy];
        [self.tableView reloadData];
    } else {
        [[CKServerInteraction sharedServer] getUserArticles:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HeadlineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CKArticle * article = (CKArticle *)self.articles[indexPath.row];
    UILabel * headlineLabel = (UILabel *)[cell viewWithTag:1];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];

    paragraphStyle.lineSpacing = 3.0f;
    
    headlineLabel.attributedText = [[NSAttributedString alloc]
                                       initWithString:article.title attributes: @{
                                       NSFontAttributeName: self.headlineFont,
                                       NSForegroundColorAttributeName: self.headlineColor,
                                       NSKernAttributeName: @0.33,
                                       NSParagraphStyleAttributeName: paragraphStyle}];
    
    UILabel * descriptionLabel = (UILabel *)[cell viewWithTag:2];
    descriptionLabel.attributedText = [[NSAttributedString alloc]
                                initWithString:article.description
                                attributes:@{
                                NSFontAttributeName: self.tagsFont,
                                NSForegroundColorAttributeName: self.tagsColor,
                                NSKernAttributeName: @0.33}];
    
    UIImageView * lineImageView = (UIImageView *)[cell viewWithTag:3];
    lineImageView.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0f];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.animation.selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    self.animation.contentOffset = tableView.contentOffset;
    [self pushContentController];
}

#pragma mark - Push Methods

-(void)pushContentController {
    UIViewController * contentController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"contentController"];
    [self.navigationController pushViewController:contentController animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[CKContentViewController class]]){
        NSIndexPath * selectedIndexPath = [self.tableView indexPathForSelectedRow];
        CKArticle * article = self.articles[selectedIndexPath.row];
        CKContentViewController * contentController = (CKContentViewController *)segue.destinationViewController;
        contentController.contentURL = article.url;
    }
}

#pragma mark - Navigation controller delegate

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    switch (operation) {
        case UINavigationControllerOperationPush:
            self.animation.animationType = AnimationTypePresent;
            return self.animation;
        case UINavigationControllerOperationPop:
            self.animation.animationType = AnimationTypeDismiss;
            return self.animation;
        default: return nil;
    }
}

#pragma mark - Lazy Instantiation

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
    }
    return _seperatorLine;
}

-(ArticleAnimation *)animation{
    if (!_animation){
        _animation = [[ArticleAnimation alloc] init];
    }
    return _animation;
}

-(NSArray *)articles
{
    if (!_articles){
        _articles = [NSArray array];
    }
    return _articles;
}

@end
