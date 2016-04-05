//
//  EBCarListSearchController.m
//  CrazyCar
//
//  Created by Edward on 16/3/10.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBCarListSearchController.h"
#import "EBSearchResultModel.h"
#import "EBCarEachBrandController.h"

@interface EBCarListSearchController()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation EBCarListSearchController

- (NSMutableArray *)resultArray{
    if (!_resultArray) {
        _resultArray = @[].mutableCopy;
    }
    return _resultArray;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell_ID"];
    }
    EBSearchResultModel *model = _resultArray[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EBSearchResultModel *model = self.resultArray[indexPath.row];
    EBCarEachBrandController *brandVC = [EBCarEachBrandController new];
    brandVC.seriseId = [model.brandId integerValue];
    brandVC.title = model.name;
    brandVC.isSearch = true;
    [self.presentingViewController.navigationController pushViewController:brandVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.resultArray.count != 0) {
        [self.resultArray removeAllObjects];
    }
}
@end
