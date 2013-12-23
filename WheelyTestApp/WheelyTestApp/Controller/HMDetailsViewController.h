//
//  HMDetailsViewController.h
//

#import "HMBaseViewController.h"
#import "ItemWrapperProtocol.h"

@interface HMDetailsViewController : HMBaseViewController

@property (nonatomic, strong) id<ItemWrapperProtocol> item;
@property (weak, nonatomic) IBOutlet UIView *titleContainerView;
@property (weak, nonatomic) IBOutlet UILabel *titleValueLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;


@end
