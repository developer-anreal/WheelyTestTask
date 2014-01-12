//
//  HMWheelViewController.m
//

#import "HMWheelViewController.h"
#import "ItemsController.h"
#import "HMDetailsViewController.h"
#import "MBProgressHUD.h"
#import "HMItem.h"

@interface HMWheelViewController()<ItemsControllerDelegate> {
  ItemsController *resultsController;
}

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
  
  resultsController = [[ItemsController alloc] init];
  resultsController.delegate = self;
  
  [self loadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (void)loadData {
  [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
  [resultsController load];
}

- (IBAction)reloadInfoButtonTapped:(id)sender {
  [self loadData];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  HMItem *item = [resultsController objectAtIndex:indexPath.row];

  cell.textLabel.text = item.itemTitle;
  cell.detailTextLabel.text = item.itemText;
  
  cell.detailTextLabel.font = [UIFont italicSystemFontOfSize:cell.detailTextLabel.font.pointSize];
}

#pragma mark - UITableViewDelegate impl

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UITableViewDataSource impl

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [resultsController allObjects].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellId = @"CrazyWheelCellIIdentifier";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
  
  [self configureCell:cell atIndexPath:indexPath];
  
  return cell;
}

#pragma mark - RequestResultsControllerDelegate impl

- (void)controllerWillChangeContent:(ItemsController *)controller {
  [self.tableView beginUpdates];
}


- (void)controller:(ItemsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(RequestResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
  
  UITableView *tableView = self.tableView;
  
  switch(type) {
    case RequestResultsChangeInsert:
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case RequestResultsChangeDelete:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case RequestResultsChangeUpdate:
      [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
      break;
      
    case RequestResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:[NSArray
                                         arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:[NSArray
                                         arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controllerDidChangeContent:(ItemsController *)controller {
  [self.tableView endUpdates];
}

- (void)controllerDidLoadData:(ItemsController *)controller {
  [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].delegate window] animated:YES];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"DetailsSegueId"]) {
    HMDetailsViewController *vc = (HMDetailsViewController *)segue.destinationViewController;
    vc.item = [resultsController objectAtIndex:[self.tableView indexPathForCell:sender]];
  }
}

@end