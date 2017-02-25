/*!
 @header    UITableViewCellEx.h
 @abstract  封装下划线及Cell的点击效果
 @author    dasmaster
 @version   2.1.0 2012/11/02 Creation
 */

#import <UIKit/UIKit.h>

#define kExCellIdentifier (@"UITableViewCellEx")

/*!
 @class
 @abstract  封装下划线及Cell的点击效果
 */
@interface UITableViewCellEx : UITableViewCell

@property (nonatomic,assign) float preferWidth;

- (void)drawCellDefault;
- (void)drawCellStyleThick;
@end
