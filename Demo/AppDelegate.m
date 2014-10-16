//
//  AppDelegate.m
//  Demo
//
//  Created by Justin Raney on 10/4/14.
//  Copyright (c) 2014 Justin Raney. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	
	
	[Parse setApplicationId:@"E1utBNrHz0UQtiIgla8hvIjnbmNH8oYw7FeTInCE" clientKey:@"ILSMGGnqUSEUB62MCGYnqCgmtqRmj7Pmjr6M6rFo"];
	
	// Wipe out old user defaults
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"objectIDArray"]){
		[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"objectIDArray"];
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	// Simple way to create a user or log in the existing user
	// For your app, you will probably want to present your own login screen
	PFUser *currentUser = [PFUser currentUser];
	
	if (!currentUser) {
		// Dummy username and password
		PFUser *user = [PFUser user];
		user.username = @"AIncU";
		user.password = @"password";
		user.email = @"demo@awesomeincu.com";
		
		[user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
			if (error) {
				// Assume the error is because the user already existed.
				[PFUser logInWithUsername:@"AIncU" password:@"password"];
			}
		}];
	}
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
