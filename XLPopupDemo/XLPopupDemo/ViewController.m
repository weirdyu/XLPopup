//
//  ViewController.m
//  XLPopupDemo
//
//  Created by weirdyu on 2019/7/24.
//  Copyright © 2019 weirdyu. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "XLPopup.h"
#import "CustomPopupView.h"
#import "PopupStore.h"
#import "PresentatedViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"XLPopupDemo";
    [self setupDataSource];
    [self setupSubview];
}

- (void)setupSubview
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 60;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setupDataSource
{
    _dataSource = [PopupStore popupDataSource];
}

#pragma mark - Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    PopupStyle *style = _dataSource[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = style.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PopupStyle *style = _dataSource[indexPath.row];
    if (style.popupType == PopupTypeView) {
        [CustomPopupView showPopupViewWithShowType:style.showType maskType:style.maskType];
    }else {
        PresentatedViewController *vc = [PresentatedViewController new];
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.view.clipsToBounds = YES;
        vc.view.layer.cornerRadius = 10;
        // set viewController display size
        vc.preferredContentSize = CGSizeMake(vc.view.frame.size.width-60, vc.view.frame.size.height/2);
        XLPresentationController *presentation = [[XLPresentationController alloc] initWithPresentedViewController:vc presentingViewController:self.navigationController postion:XLPresentationPostionCenter showType:style.showType maskType:style.maskType];
        [presentation setupCustomFinalCenterBlock:^CGPoint{
            return CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        }];
        [presentation setupMaskViewTapBlock:^(UIViewController *presentedViewController) {
            [vc dismissViewControllerAnimated:YES completion:NULL];
        }];
        vc.transitioningDelegate = presentation;
        [self.navigationController presentViewController:vc animated:YES completion:NULL];
    }
}

@end
