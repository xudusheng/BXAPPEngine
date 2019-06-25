//
//  BXSwitchLanguageViewController.m
//  NLAppEngine
//
//  Copyright © 2017 NeuLion. All rights reserved.
//

#import "BXSwitchLanguageViewController.h"
#import "BXConfigManager.h"
#import "BXLocalizableManager.h"

#import "UIApplication+BXAddition.h"
#import "UIAlertController+BXAddition.h"


@implementation BXLanguageItem

@end

static UIFont * textFont = nil;
static UIFont * subTextFont = nil;
static UIColor * textColor = nil;
static UIColor * subTextColor = nil;
static CGFloat rowHeight = 55;
static CGFloat tickSize = 20;
static UIColor * tickColor = nil;
static BOOL internalRefeshMode = NO;
static BXChangeLanguageBlock changeLanguageBlock = nil;

@interface BXSwitchLanguageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray * languageItemArray;
@property (nonatomic, strong) BXLanguageItem * currentSelectedItem;

@end

@implementation BXSwitchLanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createLanguageData];
    [self initUI];
    [self refreshUI];
}
#pragma mark - Public methods

+ (BXLanguageItem *)currentSelectedItem
{
    __block BXLanguageItem * selectItem = nil;
    
    NSString *languageKey = [BXLocalizableManager getAppDefaultLanguage];
    NSArray * localLanguageArray = [BXConfigManager sharedManager].configItem.language.allKeys;
    NSString * currentSelectedKey = [BXLocalizableManager matchSimilarLanguageWithSelectedLanuage:languageKey localLanguageArray:localLanguageArray];
    
    [[BXConfigManager sharedManager].configItem.language enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        BXUrlItem *urlItem = dic[@"nl.feed.localization"];
        
        if ([currentSelectedKey isEqualToString:key]) {
            
            BXLanguageItem * item = [BXLanguageItem new];
            item.language = key;
            item.primaryName = [urlItem paramsValueBykey:@"primaryName"];
            item.secondaryName = [urlItem paramsValueBykey:@"secondaryName"];
            id order = [urlItem paramsValueBykey:@"order"];
            if ([order isKindOfClass:[NSNumber class]]) {
                item.order = order;
            }else if ([order isKindOfClass:[NSString class]]) {
                item.order = [NSNumber numberWithInt:[(NSString *)order intValue]];
            }
            item.url = urlItem.url;
    
            selectItem = item;
            *stop = YES;
            return;
        }
    }];
    
    return selectItem;
}

+ (void)setTextFont:(UIFont *)font
{
    textFont = font;
}

+ (void)setSubTextFont:(UIFont *)font
{
    subTextFont = font;
}

+ (void)setTextColor:(UIColor *)color
{
    textColor = color;
}

+ (void)setSubTextColor:(UIColor *)color
{
    subTextColor = color;
}

+ (void)setRowHeight:(CGFloat)height
{
    rowHeight = height;
}

+ (void)setTickSize:(CGFloat)size
{
    tickSize = size;
}

+ (void)setTickColor:(UIColor *)color
{
    tickColor = color;
}

+ (void)setInternalRefeshMode:(BOOL)flag
{
    internalRefeshMode = flag;
}

+ (void)customChangeLanguageBlock:(BXChangeLanguageBlock)block
{
    changeLanguageBlock = block;
}

#pragma mark - Private methods

- (void)refreshUI
{
    [self.mainTaleView reloadData];
}

- (void)initUI
{
    self.mainTaleView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mainTaleView];
    [self nlView:self.mainTaleView fillInContentView:self.view sideDistance:0];
    self.mainTaleView.delegate = self;
    self.mainTaleView.dataSource = self;
    self.mainTaleView.tableFooterView = [[UIView alloc] init];
}

- (void)createLanguageData
{
    NSMutableArray * languageArray = [NSMutableArray array];
    [[BXConfigManager sharedManager].configItem.language enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        BXUrlItem *urlItem = dic[@"xd.feed.localization"];

        BXLanguageItem * item = [BXLanguageItem new];
        item.language = key;
        item.primaryName = [urlItem paramsValueBykey:@"primaryName"];
        item.secondaryName = [urlItem paramsValueBykey:@"secondaryName"];
        id order = [urlItem paramsValueBykey:@"order"];
        if ([order isKindOfClass:[NSNumber class]]) {
            item.order = order;
        }else if ([order isKindOfClass:[NSString class]]) {
            item.order = [NSNumber numberWithInt:[(NSString *)order intValue]];
        }
        item.url = urlItem.url;
        
        [languageArray addObject:item];
    }];
    
    [languageArray sortUsingComparator:^NSComparisonResult(BXLanguageItem * _Nonnull obj1, BXLanguageItem * _Nonnull obj2) {
        return [obj1.order compare:obj2.order];
    }];
    
    self.languageItemArray = languageArray;
    
    self.currentSelectedItem = [BXSwitchLanguageViewController currentSelectedItem];
}

- (void)nlView:(UIView *)view fillInContentView:(UIView *)contentView sideDistance:(CGFloat)sideDistance
{
    UIView * selfView = view;
    
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSArray * constraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideDistance-[selfView]-sideDistance-|" options:0 metrics:@{@"sideDistance":@(sideDistance)} views:NSDictionaryOfVariableBindings(selfView)];
    NSArray *constraintArray2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-sideDistance-[selfView]-sideDistance-|" options:0 metrics:@{@"sideDistance":@(sideDistance)} views:NSDictionaryOfVariableBindings(selfView)];
    [contentView addConstraints:constraintArray];
    [contentView addConstraints:constraintArray2];
}

- (void)switchLanguageWithItem:(BXLanguageItem *)item
{
    [BXLocalizableManager saveAppDefaultLanguage:item.language];
    
    if (internalRefeshMode) {
        
        if (changeLanguageBlock) {
            
            changeLanguageBlock(item);
            
        }else {
            
            self.currentSelectedItem = [BXSwitchLanguageViewController currentSelectedItem];
            [self refreshUI];
            
#warning show HUD
            [[BXLocalizableManager sharedManager] updateLocalizableFileWithServerURL:item.url finished:^(NSError *error) {
#warning hide HUD
                
            }];
            
        }
        
    }else {
        
        exit(0);
        
    }
    
}

#pragma mark - UITableViewDelegate/DataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.languageItemArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reuseIdentifier = @"LanguageCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        
        if (textFont) {
            cell.textLabel.font = textFont;
        }
        if (textColor) {
            cell.textLabel.textColor  = textColor;
        }
        if (subTextFont) {
            cell.textLabel.font = subTextFont;
        }
        if (subTextColor) {
            cell.textLabel.textColor  = subTextColor;
        }
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"✓";
        label.font = [UIFont systemFontOfSize:tickSize];
        label.hidden = YES;
        if (tickColor) {
            label.textColor = tickColor;
        }
        cell.accessoryView = label;
        
    }
    
    BXLanguageItem * item = [self.languageItemArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = item.primaryName;
    cell.detailTextLabel.text = item.secondaryName;
    
    cell.accessoryView.hidden = ![self.currentSelectedItem.language isEqualToString:item.language];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BXLanguageItem * item = [self.languageItemArray objectAtIndex:indexPath.row];
    
    NSString * doTitle = internalRefeshMode?BXLocalizedString(@"nl.ui.ok",@"OK"):BXLocalizedString(@"nl.ui.exitapp",@"Exit App");
    
    __weak typeof (self) weakSelf = self;
    [UIAlertController showAlertInViewController:self
                                       withTitle:[UIApplication sharedApplication].appBundleName
                                         message:BXLocalizedString(@"nl.message.changelanguage",nil)
                               cancelButtonTitle:doTitle
                               otherButtonTitles:@[BXLocalizedString(@"nl.ui.nothanks",@"No, Thanks")]
                                        tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                            
                                            [tableView deselectRowAtIndexPath:indexPath animated:YES];
                                            
                                            if (buttonIndex == controller.cancelButtonIndex) {
                                                
                                                [weakSelf switchLanguageWithItem:item];
                                                
                                            }else if (buttonIndex == controller.firstOtherButtonIndex) {
                                                
                                            }
                                        }];
}

@end
