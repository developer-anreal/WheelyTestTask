//
// ObjectFactoryProtocol.h
//

#import <Foundation/Foundation.h>
#import "ItemWrapperProtocol.h"

@protocol ObjectFactoryProtocol

@required

- (id<ItemWrapperProtocol>)createItemFromData:(id)itemData;

@end