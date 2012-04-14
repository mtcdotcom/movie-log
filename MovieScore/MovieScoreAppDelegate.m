//
//  MovieScoreAppDelegate.m
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import "MovieScoreAppDelegate.h"

@implementation MovieScoreAppDelegate

@synthesize window;
@synthesize rootController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{	
    CGRect bounds = [[UIScreen mainScreen]bounds];
	window = [[UIWindow alloc] initWithFrame:bounds];
    
	MovieList* movieList = [[[MovieList alloc] init] autorelease];
	self.rootController = [[[UINavigationController alloc] initWithRootViewController:movieList] autorelease];

	[self.window addSubview:self.rootController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)dealloc
{
    self.rootController = nil;
    [super dealloc];
}
@end
