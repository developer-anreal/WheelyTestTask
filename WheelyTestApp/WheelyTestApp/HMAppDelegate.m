//
//  HMAppDelegate.m
//

#import "HMAppDelegate.h"
#import "UIFunctions.h"
#import "HMWheelViewController.h"

@implementation HMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.navController = [[UINavigationController alloc] init];
  self.window.backgroundColor = [UIColor whiteColor];
  self.window.rootViewController = self.navController;
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:UINamed(@"Main") bundle:nil];
  HMWheelViewController *mainVC = [storyboard instantiateInitialViewController];
  [self.navController setViewControllers:@[mainVC] animated:YES];
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
