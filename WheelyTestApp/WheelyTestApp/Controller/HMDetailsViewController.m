//
//  HMDetailsViewController.m
//

#import "HMDetailsViewController.h"
#import "HMItem.h"

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

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(backButtonTapped:)];
  
  self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backButtonTapped:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)updateUIValues {
  self.title = self.item.itemTitle;
  
  self.titleValueLabel.text = self.item.itemTitle;
  self.textView.text = self.item.itemText;
}

- (void)setItem:(HMItem *)item {
  if (item == _item) return;
  
  _item = item;
  [self updateUIValues];
}

@end
