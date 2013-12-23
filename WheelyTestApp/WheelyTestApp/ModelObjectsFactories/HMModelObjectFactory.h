//
// HMModelObjectFactory.h
//

#import <Foundation/Foundation.h>
#import "ObjectFactoryProtocol.h"

@interface HMModelObjectFactory : NSObject<ObjectFactoryProtocol>

+ (instancetype)instance;

@end