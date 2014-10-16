//
//  WebVC.m
//  Demo
//
//  Created by Justin Raney on 10/14/14.
//  Copyright (c) 2014 Justin Raney. All rights reserved.
//

#import "WebVC.h"

@interface WebVC ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation WebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	// create a web request from a home url string
	NSString *homeUrlString = @"http://www.google.com";
	NSURL *homeUrl = [NSURL URLWithString:homeUrlString];
	NSURLRequest *homeRequest = [NSURLRequest requestWithURL:homeUrl];
	
	[self.webView loadRequest:homeRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
	
	// show a loading indicator
	[self.activityIndicator startAnimating];
	
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	
	// hide the loading indicator
	[self.activityIndicator stopAnimating];
	
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	
	// hide the loading indicator
	[self.activityIndicator stopAnimating];
	
	NSLog(@"%@", error.localizedDescription);
}

@end
