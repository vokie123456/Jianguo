/*!
 @header    UITableViewCellEx.m
 @abstract  封装下划线及Cell的点击效果
 @author    dasmaster
 @version   2.1.0 2012/11/02 Creation
 */

#import "UITableViewCellEx.h"
#import "UIImage+Additions.h"
#import "UIView+Autolayout.h"

@interface UITableViewCellEx()

@property (nonatomic,strong) UIView *lineView;

@end

@implementation UITableViewCellEx

- (void)setPreferWidth:(float)preferWidth
{
    if (_preferWidth != preferWidth) {
        _preferWidth = preferWidth;
        self.width = preferWidth;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawCellDefault];
    }
    return self;
}

- (void)awakeFromNib
{
     [self drawCellDefault];
}

- (void)drawCellStyleThick
{
    //点击效果
    UIView *cellSelectedimageView = [[UIView alloc] initWithFrame:self.frame];
    cellSelectedimageView.backgroundColor = BACKCOLORGRAY;
    self.selectedBackgroundView = cellSelectedimageView;
    
    self.backgroundColor = WHITECOLOR;
    self.contentView.backgroundColor = WHITECOLOR;
    
    UIView *line = [UIView autolayoutView];
    line.backgroundColor = BACKCOLORGRAY;
    [self.contentView addSubview:line];
    
    NSString *vfl0 = @"V:[line(15)]-0-|";
    NSString *vfl1 = @"H:|-0-[line]-0-|";
    NSDictionary *views = NSDictionaryOfVariableBindings(line);
    NSArray *constraintArray0 = [NSLayoutConstraint constraintsWithVisualFormat:vfl0 options:NSLayoutFormatAlignAllLeft metrics:nil views:views];
    NSArray *constraintArray1 = [NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:NSLayoutFormatAlignAllLeft metrics:nil views:views];
    [self.contentView addConstraints:constraintArray0];
    [self.contentView addConstraints:constraintArray1];
    self.lineView = line;
    
    
};


- (void)drawCellDefault
{
    //点击效果
    UIView *cellSelectedimageView = [[UIView alloc] initWithFrame:self.frame];
    cellSelectedimageView.backgroundColor = BACKCOLORGRAY;
    self.selectedBackgroundView = cellSelectedimageView;

    self.backgroundColor = WHITECOLOR;
    self.contentView.backgroundColor = WHITECOLOR;

    UIView *line = [UIView autolayoutView];
    line.backgroundColor = BACKCOLORGRAY;
    [self.contentView addSubview:line];
    
    NSString *vfl0 = @"V:[line(0.5)]-0-|";
    NSString *vfl1 = @"H:|-15-[line]-0-|";
    NSDictionary *views = NSDictionaryOfVariableBindings(line);
    NSArray *constraintArray0 = [NSLayoutConstraint constraintsWithVisualFormat:vfl0 options:NSLayoutFormatAlignAllLeft metrics:nil views:views];
    NSArray *constraintArray1 = [NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:NSLayoutFormatAlignAllLeft metrics:nil views:views];
    [self.contentView addConstraints:constraintArray0];
    [self.contentView addConstraints:constraintArray1];
    
    self.lineView = line;
};

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

// 为了避免cell高亮的时候，背景色消失的问题
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    UIColor *lineViewColor = self.lineView.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    self.lineView.backgroundColor = lineViewColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    UIColor *lineViewColor = self.lineView.backgroundColor;
    [super setSelected:selected animated:animated];
    self.lineView.backgroundColor = lineViewColor;
}

@end
