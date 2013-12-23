//
// ModelObjectFactory.h
//

#import <Foundation/Foundation.h>
#import "ObjectFactoryProtocol.h"

@interface ModelObjectFactory : NSObject

+ (id<ObjectFactoryProtocol>)HMObjectsFactory;

@end