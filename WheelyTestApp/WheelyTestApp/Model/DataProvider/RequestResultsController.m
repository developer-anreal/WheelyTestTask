//
// RequestResultsController.m
//

#import "RequestResultsController.h"
#import "ItemWrapperProtocol.h"
#import "HMModelObjectFactory.h"

@implementation RequestResultsController {
  NSMutableArray *objects;
  DataProvider *dataProvider;
}

- (id)init {
  if (self = [super init]) {
    objects = [NSMutableArray array];
    [objects addObject:@[]];
  }
  
  return self;
}

- (id)initWithDataProvider:(DataProvider *)provider {
  if (self = [self init]) {
    dataProvider = provider;
  }
  
  return self;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
  return objects[indexPath.section][indexPath.row];
}

- (NSArray *)allObjects {
  return [NSArray arrayWithArray:objects];
}

- (void)requestData {
  [dataProvider loadDataWithCompletion:^(NSError *error, NSData *data) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self parseResponseData:data andError:error];
    });
  }];
}

- (void)load {
  [objects removeAllObjects];
  [objects addObject:@[]];
  [self requestData];
}

- (void)makeItemDiff:(NSArray *)newObjects {
  [self.delegate controllerWillChangeContent:self];
  
  // Для данной выдачи принимаем, что section всегда 0
  
  NSIndexSet *indexesSetForDeletion = [objects[0] indexesOfObjectsPassingTest:^BOOL(id oldObj, NSUInteger idx, BOOL *stop) {
    NSUInteger index = [newObjects[0] indexOfObjectPassingTest:^BOOL(id newObj, NSUInteger idx, BOOL *stop) {
      return [[oldObj itemId] isEqualToString:[newObj itemId]];
    }];
    
    return index == NSNotFound;
  }];
  
  NSIndexSet *indexesSetForInsertion = [newObjects[0] indexesOfObjectsPassingTest:^BOOL(id newObj, NSUInteger idx, BOOL *stop) {
    NSUInteger index = [objects[0] indexOfObjectPassingTest:^BOOL(id oldObj, NSUInteger idx, BOOL *stop) {
      return [[oldObj itemId] isEqualToString:[newObj itemId]];
    }];
    
    return index == NSNotFound;
  }];
  
//  NSIndexSet *indexesSetForUpdate = [newObjects indexesOfObjectsPassingTest:^BOOL(id newObj, NSUInteger idx, BOOL *stop) {
//    NSUInteger index = [objects indexOfObjectPassingTest:^BOOL(id oldObj, NSUInteger idx, BOOL *stop) {
//      return [[oldObj itemId] isEqualToString:[newObj itemId]];
//    }];
//    
//    return index == NSNotFound;
//  }];
  
  NSArray *oldObjects = [NSArray arrayWithArray:objects];
  
  objects = [NSMutableArray arrayWithArray:newObjects];
  
  NSArray *itemsForDeletion = [objects[0] objectsAtIndexes:indexesSetForDeletion];
  
  for (id<ItemWrapperProtocol> item in itemsForDeletion) {
    [self.delegate controller:self
              didChangeObject:item
                  atIndexPath:[NSIndexPath indexPathForItem:[oldObjects[0] indexOfObject:item] inSection:0]
                forChangeType:RequestResultsChangeDelete
                 newIndexPath:nil];
  }
  
  NSArray *itemsForInsertion = [newObjects[0] objectsAtIndexes:indexesSetForInsertion];
  
  for (id<ItemWrapperProtocol> item in itemsForInsertion) {
    [self.delegate controller:self
              didChangeObject:item
                  atIndexPath:nil
                forChangeType:RequestResultsChangeInsert
                 newIndexPath:[NSIndexPath indexPathForItem:[newObjects[0] indexOfObject:item] inSection:0]];
  }
  
  [self.delegate controllerDidChangeContent:self];
}

- (void)parseResponseData:(NSData *)data andError:(NSError *)error {
  NSError *jsonError;
  NSArray *jsonItems = [NSJSONSerialization JSONObjectWithData:data
                                                            options:0
                                                              error:&jsonError];
  
  NSMutableArray *newObjects = [NSMutableArray array];
  
  for (NSDictionary *d in jsonItems) {
    id<ItemWrapperProtocol> item = [[HMModelObjectFactory instance] createItemFromData:d];
    if (item) {
      [newObjects addObject:item];
    } else {
      Log(@"Returns nil object for: %@", d);
    }
  }
  
  [self makeItemDiff:@[newObjects]];
  
  Log(@"%@", jsonItems);
}


@end