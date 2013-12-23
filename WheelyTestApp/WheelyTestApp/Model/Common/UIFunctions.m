//
//  UIFunctions.m
//

#import "UIFunctions.h"

NSString *UINamed(NSString *resource) {
  UIDevice *device = [UIDevice currentDevice];
  NSString *extension = [resource pathExtension];
  NSString *name = [resource stringByDeletingPathExtension];
  NSString *prefix = nil;
  switch (device.userInterfaceIdiom) {
    case UIUserInterfaceIdiomPhone:
      // iPhone
      prefix = @"iphone";
      break;
    case UIUserInterfaceIdiomPad:
      // iPad
      prefix = @"ipad";
      break;
    default:
      break;
      // unknown idiom
  }
  if (prefix) {
    if (extension.length) {
      return [NSString stringWithFormat:@"%@~%@.%@", name, prefix, extension];
    }
    return [NSString stringWithFormat:@"%@~%@", name, prefix];
  } else {
    return resource;
  }

}


