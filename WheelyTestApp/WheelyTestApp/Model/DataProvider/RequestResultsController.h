//
// RequestResultsController.h
//

#import <Foundation/Foundation.h>

#define DEFAULT_UPDATE_INTERVAL 10.

typedef enum {
  RequestResultsChangeInsert = 0,
  RequestResultsChangeDelete,
  RequestResultsChangeUpdate,
  RequestResultsChangeMove
} RequestResultsChangeType;

@protocol RequestResultsControllerDelegate;

@interface RequestResultsController : NSObject {
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (void)load;

@property (readonly) NSArray *allObjects;
@property (weak) id<RequestResultsControllerDelegate> delegate;
@property (assign, nonatomic) NSUInteger updateInterval;

@end

@protocol RequestResultsControllerDelegate <NSObject>
@optional
- (void)controllerDidLoadData:(RequestResultsController *)controller;
- (void)controllerWillChangeContent:(RequestResultsController *)controller;
- (void)controllerDidChangeContent:(RequestResultsController *)controller;
- (void)controller:(RequestResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(RequestResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;
@end