//
// ItemsController.m
//

#import "ItemsController.h"
#import "WebService.h"
#import "HMItem.h"

@implementation ItemsController {
  NSMutableArray *objects;
  WebService *dataProvider;
  NSTimer *timer;
}

- (id)init {
  if (self = [super init]) {
    objects = [NSMutableArray array];
    _updateInterval = DEFAULT_UPDATE_INTERVAL;
    dataProvider = [[WebService alloc] initWithWebServiceUrl:WEBSERVICE_URL];
  }
  
  return self;
}

- (id)objectAtIndex:(NSUInteger)index {
  return objects[index];
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
    dispatch_async(dispatch_queue_create("Pase data", DISPATCH_QUEUE_SERIAL), ^{
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
    dispatch_async(dispatch_get_main_queue(), ^{
  });

  NSSet *newSet = [NSSet setWithArray:newObjects];
  NSSet *oldSet = [NSSet setWithArray:objects];

  __block NSMutableSet *newItemIds = [NSMutableSet setWithSet:[newSet valueForKey:@"itemId"]];
  [newItemIds minusSet:[oldSet valueForKey:@"itemId"]];
  __block NSMutableSet *oldItemIds = [NSMutableSet setWithSet:[oldSet valueForKey:@"itemId"]];
  [oldItemIds minusSet:[newSet valueForKey:@"itemId"]];

  __block NSArray *oldValues = [NSArray arrayWithArray:objects];
  __block NSArray *newValues = [NSArray arrayWithArray:newObjects];

  void (^performChange)(NSSet *, NSArray *, RequestResultsChangeType) = ^(NSSet *set, NSArray *array, RequestResultsChangeType type) {
    [set enumerateObjectsUsingBlock:^(id idobj, BOOL *stop) {
      NSUInteger idx = [array indexOfObjectPassingTest:^BOOL(id itemobj, NSUInteger cidx, BOOL *stop) {
        return [[itemobj itemId] isEqualToString:idobj];
      }];
      if (idx != NSNotFound) {
        NSIndexPath *indexPath = nil;
        NSIndexPath *newIndexPath = nil;
        if (type == RequestResultsChangeDelete) {
          indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        } else {
          newIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        }
        [self.delegate controller:self
                  didChangeObject:array[idx]
                      atIndexPath:indexPath
                    forChangeType:type
                     newIndexPath:newIndexPath];
//        dispatch_sync(dispatch_get_main_queue(), ^{
//          [self.delegate controller:self
//                    didChangeObject:array[idx]
//                        atIndexPath:indexPath
//                      forChangeType:type
//                       newIndexPath:newIndexPath];
//        });
      }
    }];
  };

  performChange(oldItemIds, oldValues, RequestResultsChangeDelete);
  performChange(newItemIds, newValues, RequestResultsChangeInsert);

  objects = [NSMutableArray arrayWithArray:newObjects];

  // существующие объекты не изменяются
  // в случае их изменения по аналогии с удалением и созданием,
  // находим в новых те объекты, которые уже существовали и для которых,
  // поменялся либо title, либо text. для них вызываем метод делегата.

  dispatch_async(dispatch_get_main_queue(), ^{
    [self.delegate controllerDidChangeContent:self];
  });
}

- (void)parseResponseData:(NSData *)data andError:(NSError *)error {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.delegate controllerDidLoadData:self];
  });

  NSError *jsonError;
  NSArray *jsonItems = [NSJSONSerialization JSONObjectWithData:data
                                                            options:0
                                                              error:&jsonError];
  
  NSMutableArray *newObjects = [NSMutableArray array];
  
  for (NSDictionary *d in jsonItems) {
    HMItem *item = [[HMItem alloc] initItemWithDictionary:d];
    if (item) {
      [newObjects addObject:item];
    } else {
      NSLog(@"Returns nil object for: %@", d);
    }
  }
  
  [self makeItemDiff:newObjects];
  
  NSLog(@"All objects = %@\nNew objects count = %d", jsonItems, jsonItems.count);
}

@end