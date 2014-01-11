//
// RequestResultsController.m
//

#import "RequestResultsController.h"
#import "WebService.h"

@implementation RequestResultsController {
  NSMutableArray *objects;
  WebService *dataProvider;
  NSTimer *timer;
}

- (id)init {
  if (self = [super init]) {
    objects = [NSMutableArray array];
    [objects addObject:@[]];
    _updateInterval = DEFAULT_UPDATE_INTERVAL;
  }
  
  return self;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
  return objects[indexPath.section][indexPath.row];
}

- (NSArray *)allObjects {
  return [NSArray arrayWithArray:objects];
}

- (void)setUpdateInterval:(NSUInteger)timeInterval {
  if (timeInterval == _updateInterval) return;
  
  _updateInterval = timeInterval;
  
  if (timer.isValid) {
    [timer invalidate];
  }
  
  timer = [NSTimer timerWithTimeInterval:self.updateInterval
                                  target:self
                                selector:@selector(requestData:)
                                userInfo:nil
                                 repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)requestData:(NSTimer *)timer {
  [dataProvider loadDataWithCompletion:^(NSError *error, NSData *data) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self parseResponseData:data andError:error];
    });
  }];
}

- (void)load {
  if (timer.isValid) {
    [timer invalidate];
  }
  
  [self requestData:nil];
  
  timer = [NSTimer timerWithTimeInterval:self.updateInterval
                                  target:self
                                selector:@selector(requestData:)
                                userInfo:nil
                                 repeats:YES];
  [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
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
  
  NSArray *oldObjects = [NSArray arrayWithArray:objects];
  
  objects = [NSMutableArray arrayWithArray:newObjects];
  
  NSArray *itemsForDeletion = [oldObjects[0] objectsAtIndexes:indexesSetForDeletion];
  
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
  
  // существующие объекты не изменяются
  // в случае их изменения по аналогии с удалением и созданием,
  // находим в новых те объекты, которые уже существовали и для которых,
  // поменялся либо title, либо text. для них вызываем метод делегата.
  
  [self.delegate controllerDidChangeContent:self];
}

- (void)parseResponseData:(NSData *)data andError:(NSError *)error {
  [self.delegate controllerDidLoadData:self];
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
  
  Log(@"All objects = %@\nNew objects count = %d", jsonItems, jsonItems.count);
}

@end