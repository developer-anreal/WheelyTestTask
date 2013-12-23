//
// ModelObjectFactory.m
//

#import "ModelObjectFactory.h"
#import "HMModelObjectFactory.h"

@implementation ModelObjectFactory

+ (id<ObjectFactoryProtocol>)HMObjectsFactory {
  return [HMModelObjectFactory instance];
}

@end