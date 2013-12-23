//
//  Common.m
//

#include <sys/xattr.h>
#import "MBProgressHUD.h"
#import "Common.h"

UIColor *UIColorFromHex(int hexColor) {
  UIColor *colorResult = [UIColor colorWithRed:(hexColor >> 16 & 0xFF) / 255. green:(hexColor >> 8 & 0xFF) / 255. blue:(hexColor >> 0 & 0xFF) / 255. alpha:1];
  return colorResult;
}

BOOL isIPad() {
  UIDevice *device = [UIDevice currentDevice];

  if ([device respondsToSelector:@selector(userInterfaceIdiom)]) {
    UIUserInterfaceIdiom idiom = [device userInterfaceIdiom];
    switch (idiom) {
      case UIUserInterfaceIdiomPhone:
        return NO;  ///< iPhone
      case UIUserInterfaceIdiomPad:
        return YES;  ///< iPad
      default:
        return NO;  ///< Unknown idiom
    }
  }
  /// old device
  return NO;
}

BOOL isRetina() {
  if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]
          && [[UIScreen mainScreen] scale] == 2)
    return YES;  ///< iPhone 4
  /// other devices
  return NO;
}

BOOL addSkipBackupAttributeToFile(NSString *filePath) {
  const char *path = [filePath fileSystemRepresentation];
  const char *attrName = "com.apple.MobileBackup";
  u_int8_t attrValue = 1;

  int result = setxattr(path, attrName, &attrValue, sizeof(attrValue), 0, 0);
  return result == 0;
}

NSString *criticalDataPath() {
  NSString *path = [LibraryPath
          stringByAppendingPathComponent:@"Private Documents/CriticalData"];

  if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    if (error) {
      DLog(@"%@", [error localizedDescription]);
      return nil;
    }
  }
  return path;
}

NSString *offlineDataPath() {
  NSString *path = [LibraryPath stringByAppendingPathComponent:
          @"Private Documents/OfflineData"];

  if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    if (error) {
      DLog(@"%@", [error localizedDescription]);
      return nil;
    }
    if (!addSkipBackupAttributeToFile(path))
      return nil;
  }
  return path;
}

id loadNib(Class aClass, NSString *nibName, id owner) {
  NSArray *niblets = [[NSBundle mainBundle] loadNibNamed:nibName
                                                   owner:owner
                                                 options:NULL];

  for (id niblet in niblets)
    if ([niblet isKindOfClass:aClass])
      return niblet;

  return nil;
}

CGSize CGSizeScaledToFitSize(CGSize size1, CGSize size2) {
  float w, h;

  float k1 = size1.height / size1.width;
  float k2 = size2.height / size2.width;

  if (k1 > k2) {
    w = roundf(size1.width * size2.height / size1.height);
    h = size2.height;
  } else {
    w = size2.width;
    h = roundf(size1.height * size2.width / size1.width);
  }
  return CGSizeMake(roundf(w), roundf(h));
}

CGSize CGSizeScaledToFillSize(CGSize size1, CGSize size2) {
  float w, h;

  float k1 = size1.height / size1.width;
  float k2 = size2.height / size2.width;

  if (k1 > k2) {
    w = size2.width;
    h = roundf(size1.height * size2.width / size1.width);
  } else {
    w = roundf(size1.width * size2.height / size1.height);
    h = size2.height;
  }
  return CGSizeMake(roundf(w), roundf(h));
}

CGRect CGRectWithSize(CGSize size) {
  CGRect rect = CGRectZero;
  rect.size = size;
  return rect;
}

CGRect CGRectFillRect(CGRect rect1, CGRect rect2) {
  CGRect rect;
  rect.size = CGSizeScaledToFillSize(rect1.size, rect2.size);
  rect.origin.x = roundf(rect2.origin.x + 0.5 * (rect2.size.width - rect.size.width));
  rect.origin.y = roundf(rect2.origin.y + 0.5 * (rect2.size.height - rect.size.height));
  return rect;
}

void ShowAlert(NSString *title, NSString *message) {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                  message:message
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
  [alert show];
}

#pragma mark HUD impl

void showHUD(UIView *view, NSString *text) {
  __block MBProgressHUD *hud = nil;

  dispatch_async(dispatch_get_main_queue(), ^{
    hud = [MBProgressHUD showHUDAddedTo:view ? view : [UIApplication sharedApplication].delegate.window
                               animated:YES];
    if (text) {
      hud.labelText = text;
    }
  });
}

void hideHUD(UIView *view) {
  dispatch_async(dispatch_get_main_queue(), ^{
    [MBProgressHUD hideHUDForView:view ? view : [UIApplication sharedApplication].delegate.window
                         animated:YES];
  });
}







