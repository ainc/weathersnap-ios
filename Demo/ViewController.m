//
//  ViewController.m
//  Demo
//
//  Created by Justin Raney on 10/4/14.
//  Copyright (c) 2014 Justin Raney. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (weak, nonatomic) IBOutlet UILabel *myLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)updateText {
	self.myLabel.text = self.myTextField.text;
	[self.myTextField resignFirstResponder];
	
}

- (IBAction)buttonPressed:(id)sender {
	[self updateText];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[self updateText];
	
	return YES;
}

@end
