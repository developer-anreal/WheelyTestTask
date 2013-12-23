//
//  HMWheelViewController.m
//

#import "HMWheelViewController.h"
#import "DataProviderFactory.h"
#import "RequestResultsController.h"
#import "ItemWrapperProtocol.h"

@interface HMWheelViewController()<RequestResultsControllerDelegate> {
  DataProvider *dataProvider;
  RequestResultsController *resultsController;
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
  
  dataProvider = [DataProviderFactory dataProviderByType:WebServiceDataProviderType];
  resultsController = [[RequestResultsController alloc] initWithDataProvider:dataProvider];
  resultsController.delegate = self;
  
  [resultsController load];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)reloadInfoButtonTapped:(id)sender {
  
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  id<ItemWrapperProtocol> item = [resultsController objectAtIndexPath:indexPath];
  
  cell.textLabel.text = [item title];
  cell.detailTextLabel.text = [item text];
  
  cell.detailTextLabel.font = [UIFont italicSystemFontOfSize:cell.detailTextLabel.font.pointSize];
}

#pragma mark - UITableViewDelegate impl



#pragma mark - UITableViewDataSource impl

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[resultsController allObjects] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[resultsController allObjects][section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellId = @"CrazyWheelCellIIdentifier";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
  
  [self configureCell:cell atIndexPath:indexPath];
  
  return cell;
}

#pragma mark - RequestResultsControllerDelegate impl

- (void)controllerWillChangeContent:(RequestResultsController *)controller {
  [self.tableView beginUpdates];
}


- (void)controller:(RequestResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(RequestResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
  
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

- (void)controllerDidChangeContent:(RequestResultsController *)controller {
  [self.tableView endUpdates];
}

@end