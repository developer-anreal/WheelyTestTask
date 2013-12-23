//
//  HMWheelViewController.m
//  WheelyTestApp
//
//  Created by Anton Serov on 23/12/13.
//  Copyright (c) 2013 hexmasters. All rights reserved.
//

#import "HMWheelViewController.h"

@interface HMWheelViewController ()

@end

@implementation HMWheelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {

  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIBarButtonItem *reloadInfoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                    target:self
                                                                                    action:@selector(reloadInfoButtonTapped:)];
  
  self.navigationItem.rightBarButtonItem = reloadInfoButton;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)reloadInfoButtonTapped:(id)sender {
  
}

#pragma mark - UITableViewDelegate impl

#pragma mark - UITableViewDataSource impl

@end