//
//  CKContentViewController.m
//  cakely
//
//  Created by Adam Gluck on 2/24/14.
//  Copyright (c) 2014 Adam Gluck. All rights reserved.
//

#import "CKContentViewController.h"

@interface CKContentViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *previewLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *articleLoadingBar;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UIView *coverLoadingView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSTimer * timer;
@property (weak, nonatomic) IBOutlet UIView *navigationBar;

// navigation bar buttons
// TODO: Make a seperate class for this
@property (strong, nonatomic) UIButton * backButton;
@property (strong, nonatomic) UIButton * forwardButton;

@end

@implementation CKContentViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(tickProgressBar:) userInfo:nil repeats:YES];
    [self configureLoadingBar];
    [self configureLoadingLabel];
    [self configurePreviewLabel];
    [self configureTapGesture];
    [self configureUIWebViewNavigationBar];
}

-(void)viewDidAppear:(BOOL)animated
{
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:self.article.url];
    [self.webView loadRequest:urlRequest];
}

#pragma mark - View Lifecycle helpers
-(void)configureLoadingLabel
{
    self.loadingLabel.font = [UIFont fontWithName:@"Merriweather" size:13.0f];
}

-(void)configurePreviewLabel
{
    self.previewLabel.text = self.article.description;
    self.previewLabel.font = [UIFont fontWithName:@"Merriweather" size:13.0f];
    [self.previewLabel sizeToFit];
    self.previewLabel.frame = CGRectMake(self.previewLabel.frame.origin.x, self.articleLoadingBar.frame.origin.y + self.articleLoadingBar.frame.size.height + 20.0, self.previewLabel.frame.size.width, self.previewLabel.frame.size.height);
}

-(void)configureLoadingBar
{
    self.articleLoadingBar.progress = 0.0;
}

-(void)configureTapGesture
{
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideNavigationBar:)];
    tapGesture.delegate = self;
    [self.webView addGestureRecognizer:tapGesture];
}

-(void)configureUIWebViewNavigationBar
{
    CGSize buttonSize = CGSizeMake(21.0, 13.0);
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(16.0, self.navigationBar.center.y, buttonSize.width, buttonSize.height)];
    [self.backButton setImage:[UIImage imageNamed:@"Safari_Back_Not_Selectable"] forState:UIControlStateDisabled];
    [self.backButton setImage:[UIImage imageNamed:@"Safari_Back_Selectable"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backSelected:) forControlEvents:UIControlEventTouchUpInside];
    self.backButton.enabled = NO;
    [self.view addSubview:self.backButton];
    
    self.forwardButton = [[UIButton alloc] initWithFrame:CGRectMake(58.0, self.navigationBar.center.y, buttonSize.width, buttonSize.height)];
    [self.forwardButton setImage:[UIImage imageNamed:@"Safari_Forward_Not_Selectable"] forState:UIControlStateDisabled];
    [self.forwardButton setImage:[UIImage imageNamed:@"Safari_Forward_Selectable"] forState:UIControlStateNormal];
    [self.forwardButton addTarget:self action:@selector(forwardSelected:) forControlEvents:UIControlEventTouchUpInside];
    self.forwardButton.enabled = NO;
    [self.view addSubview:self.forwardButton];
    
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self handleWebViewLoading];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    self.backButton.enabled = webView.canGoBack;
    self.forwardButton.enabled = webView.canGoForward;
    
    return YES;
}

#pragma mark - Loading Sequence Helpers


-(void)handleWebViewLoading
{
    [self.timer invalidate];
    self.articleLoadingBar.progress = 1.0;
    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionAllowAnimatedContent animations:^{ self.coverLoadingView.alpha = 0.0; } completion:nil];
}

-(void)tickProgressBar:(NSTimer *)timer
{
    NSUInteger randomProgressJolt = arc4random_uniform(20);
    float progressIncrement = randomProgressJolt / 100.0;
    self.articleLoadingBar.progress += progressIncrement;
    if (self.articleLoadingBar.progress >= .95){
        self.articleLoadingBar.progress = .95;
       [timer invalidate];
    }
}

#pragma mark - UIButton methods

-(void)forwardSelected:(UIButton *)button
{
    [self.webView goForward];
}

-(void)backSelected:(UIButton *)button
{
    [self.webView goBack];
}

#pragma mark - Tap Gesture Delegate and Selector

-(void)hideNavigationBar:(UITapGestureRecognizer *)recognizer
{
    BOOL hidden = self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:!hidden animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:!hidden];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
