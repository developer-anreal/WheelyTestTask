//
//  HMDetailsViewController.m
//

#import <QuartzCore/QuartzCore.h>
#import "HMDetailsViewController.h"
#import "UILabel+Additions.h"

@interface HMDetailsViewController ()

@end

@implementation HMDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    self.edgesForExtendedLayout = UIRectEdgeNone;
  
  self.titleContainerView.layer.borderColor = [UIColor blackColor].CGColor;
  self.titleContainerView.layer.borderWidth = 1.;
  self.titleContainerView.layer.cornerRadius = 4.;
  
  self.textView.layer.borderColor = [UIColor blackColor].CGColor;
  self.textView.layer.borderWidth = 1.;
  self.textView.layer.cornerRadius = 4.;
  
  if (self.item) {
    [self updateUIValues];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)updateUIValues {
  self.title = [self.item title];
  
  self.titleValueLabel.text = [self.item title];
  self.textView.text = [self.item text];
}

- (void)setItem:(id<ItemWrapperProtocol>)item {
  if (item == _item) return;
  
  _item = item;
  [self updateUIValues];
}

@end
