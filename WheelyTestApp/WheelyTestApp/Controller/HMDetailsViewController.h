//
//  HMDetailsViewController.h
//

#import "HMBaseViewController.h"

@class HMItem;

@interface HMDetailsViewController : HMBaseViewController

@property (nonatomic, strong) HMItem *item;
@property (weak, nonatomic) IBOutlet UIView *titleContainerView;
@property (weak, nonatomic) IBOutlet UILabel *titleValueLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;


@end
