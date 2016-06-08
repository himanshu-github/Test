

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NGMenuCustomCell.h"

/**
 *  The class used to display the menu in left side panel.
 
    Conforms to UITableViewDelegate, UITableViewDataSource, WebDataManagerDelegate protocol.
 */
@interface MenuViewController: UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *menuTable;

/**
 *  Update the menu items basis loggedin or not loggedin user.
 */
-(void)updateMenu;

@end
