//
//  ImagesVC.m
//  Demo
//
//  Created by Justin Raney on 10/12/14.
//  Copyright (c) 2014 Justin Raney. All rights reserved.
//
//  Some code adapted from Parse "Saving Images" tutorial code https://parse.com/tutorials/saving-images with the following copyright:
/*  Copyright (c) 2012 Parse Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
//
//
//

#import "ImagesVC.h"
#import <Parse/Parse.h>
#include <stdlib.h>

@interface ImagesVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@end

@implementation ImagesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cameraButtonTapped:(id)sender
{
	// Check for camera
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES) {
		// Create image picker controller
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		
		// Set source to the camera
		imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
		
		// Delegate is self
		imagePicker.delegate = self;
		
		// Show image picker
		[self presentViewController:imagePicker animated:YES completion:nil];
	}
	else{
		// Device has no camera
		UIImage *image;
		int r = arc4random() % 5;
		switch (r) {
			case 0:
				image = [UIImage imageNamed:@"ParseLogo.jpg"];
				break;
			case 1:
				image = [UIImage imageNamed:@"Crowd.jpg"];
				break;
			case 2:
				image = [UIImage imageNamed:@"Desert.jpg"];
				break;
			case 3:
				image = [UIImage imageNamed:@"Lime.jpg"];
				break;
			case 4:
				image = [UIImage imageNamed:@"Sunflowers.jpg"];
				break;
			default:
				break;
		}
		
		// Resize image
		UIGraphicsBeginImageContext(CGSizeMake(320, 480));
		[image drawInRect: CGRectMake(0, 0, 320, 480)];
		UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		self.imagePreview.image = smallImage;
		
		NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
		[self uploadImage:imageData];
	}
}

- (void)uploadImage:(NSData *)imageData
{
	
	self.progressLabel.hidden = NO;
	self.progressLabel.text = @"Uploading - 0%";
	
	PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
	
	// Save PFFile
	[imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (!error) {
			
			// Create a PFObject around a PFFile and associate it with the current user
			PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
			[userPhoto setObject:imageFile forKey:@"imageFile"];
			
			// Set the access control list to current user for security purposes
			userPhoto.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
			
			PFUser *user = [PFUser currentUser];
			[userPhoto setObject:user forKey:@"user"];
			
			[userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
				if (!error) {
					// success!
					self.progressLabel.text = @"Image Uploaded";
				}
				else{
					// Log details of the failure
					NSLog(@"Error: %@ %@", error, [error userInfo]);
				}
			}];
		}
		else{
			
			// Log details of the failure
			NSLog(@"Error: %@ %@", error, [error userInfo]);
		}
	} progressBlock:^(int percentDone) {
		// Update your progress spinner here. percentDone will be between 0 and 100.
		self.progressLabel.text = [NSString stringWithFormat:@"Uploading - %i%%", percentDone];
	}];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	// Access the uncropped image from info dictionary
	UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
	// Dismiss controller
	[picker dismissViewControllerAnimated:YES completion:nil];
	
	// Resize image
	UIGraphicsBeginImageContext(CGSizeMake(320, 480));
	[image drawInRect: CGRectMake(0, 0, 320, 480)];
	UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	// Upload image
	NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
	[self uploadImage:imageData];
}



@end
