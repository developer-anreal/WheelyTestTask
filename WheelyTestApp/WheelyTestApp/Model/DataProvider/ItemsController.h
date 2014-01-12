//
// ItemsController.h
//

#import <Foundation/Foundation.h>

#define DEFAULT_UPDATE_INTERVAL 10.
#define WEBSERVICE_URL @"http://crazy-dev.wheely.com"

typedef enum {
  RequestResultsChangeInsert = 0,
  RequestResultsChangeDelete,
  RequestResultsChangeUpdate,
  RequestResultsChangeMove
} RequestResultsChangeType;

@protocol ItemsControllerDelegate;

@interface ItemsController : NSObject {
}

- (id)objectAtIndex:(NSUInteger)index;
- (void)load;

@property (readonly) NSArray *allObjects;
@property (weak) id<ItemsControllerDelegate> delegate;
@property (assign, nonatomic) NSUInteger updateInterval;

@end

@protocol ItemsControllerDelegate <NSObject>
@optional
- (void)controllerDidLoadData:(ItemsController *)controller;
- (void)controllerWillChangeContent:(ItemsController *)controller;
- (void)controllerDidChangeContent:(ItemsController *)controller;
- (void)controller:(ItemsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(RequestResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
@end