//
//  NewsVC.m
//  Rimi
//
//  Created by 王志龙 on 15/8/19.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "NewsVC.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "NewsCell.h"
#import <MJRefresh.h>
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>


@interface NewsVC () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *selectImg;
@property (assign, nonatomic) BOOL isSelectViewOpen;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) NewsCell *protocolCell;

@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong, nonatomic) NSArray *newsType;
@property (strong, nonatomic) NSString *currentNews;
@property (assign, nonatomic) NSUInteger currentPage;
@property (strong, nonatomic) NSString *lastUpdate;
@end


@implementation NewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSelectViewOpen = NO;
    self.selectView.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    self.selectView.layer.cornerRadius = 2;
    self.selectView.clipsToBounds = YES;
    [self.tableView addGestureRecognizer:self.tapGesture];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:@"newscell"];
    self.protocolCell = [self.tableView dequeueReusableCellWithIdentifier:@"newscell"];
    
    self.currentNews = self.newsType[0];
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    [self.tableView.header beginRefreshing];
    self.currentPage = 1;
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
}

- (void)hideSelectView:(BOOL)isHide {
    [UIView animateWithDuration:1 animations:^{
        self.selectView.hidden = !isHide;
    }];
    self.isSelectViewOpen = !self.isSelectViewOpen;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)openSelectView:(id)sender {
    if (self.isSelectViewOpen) {
        self.selectImg.image = [UIImage imageNamed:@"down4"];
    }else {
        self.selectImg.image = [UIImage imageNamed:@"up4"];
    }
    [self hideSelectView:!self.isSelectViewOpen];
}

- (void)handleTap {
    if (self.isSelectViewOpen) {
        self.selectImg.image = [UIImage imageNamed:@"down4"];
    }else {
        self.selectImg.image = [UIImage imageNamed:@"up4"];
    }
    if (self.isSelectViewOpen) {
        [self hideSelectView:!self.isSelectViewOpen];
    }
}

- (IBAction)selectNews:(id)sender {
    if (self.isSelectViewOpen) {
        self.selectImg.image = [UIImage imageNamed:@"down4"];
    }else {
        self.selectImg.image = [UIImage imageNamed:@"up4"];
    }
    UIButton *btn = sender;
    NSString *changeCurrent = self.newsType[btn.tag - 1];
    [self.selectBtn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
    [self hideSelectView:NO];
    if (changeCurrent != self.currentNews) {
        self.currentPage = 1;
        self.currentNews = changeCurrent;
        [self.tableView.header beginRefreshing];
    }
}

- (void)getData {
    NSLog(@"%@",self.currentNews);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *postData = @{@"type":self.currentNews,@"page":@"1"};
    
    [manager POST:@"http://shenjingstudio.com/ucard/CSNews.php" parameters:postData success:^(AFHTTPRequestOperation *opeation, id response){
        if (response) {
            if ([response[@"status"] isEqualToString:@"OK"]) {
                if (![[[response[@"Array"] objectAtIndex:0] objectForKey:@"title"] isEqualToString:self.lastUpdate]) {
                    self.tableData = [NSMutableArray arrayWithArray:response[@"Array"]];
                    [self.tableView reloadData];
                    self.lastUpdate = [[response[@"Array"] objectAtIndex:0] objectForKey:@"title"];
                }else {
                    [self showHudWithTitle:@"本栏目没有更新"];
                }
                
            }
        }
        [self.tableView.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [self.tableView.header endRefreshing];
        [self showHudWithTitle:@"获取失败"];
    }];
}

- (void)getMoreData {
    
    self.currentPage ++;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *postData = @{@"type":self.currentNews,@"page":[NSString stringWithFormat:@"%ld",self.currentPage]};
    
    [manager POST:@"http://shenjingstudio.com/ucard/CSNews.php" parameters:postData success:^(AFHTTPRequestOperation *opeation, id response){
        if (response) {
            if ([response[@"status"] isEqualToString:@"OK"]) {
                if ([response[@"Array"] count] == 0) {
                    [self showHudWithTitle:@"没有更多数据了"];
                }else {
                    if (self.tableData) {
                        [self.tableData addObjectsFromArray:response[@"Array"]];
                    }else {
                        self.tableData = response[@"Array"];
                    }
                    [self.tableView reloadData];
                }
            }
        }
        [self.tableView.footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [self.tableView.footer endRefreshing];
        [self showHudWithTitle:@"获取失败"];
    }];
    
}

- (void)showHudWithTitle:(NSString *)title {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud show:YES];
    [hud performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.5];
}
#pragma mark lazyload

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)];
    }
    return _tapGesture;
}

- (NSArray *)newsType {
    if (!_newsType) {
        _newsType = @[@"dnews",@"keyan",@"xuesheng",@"jiaowu",@"zhaojiu"];
    }
    return _newsType;
}


#pragma mark tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newscell"];
    cell.newsTitle.text = [self.tableData[indexPath.row] objectForKey:@"title"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCell *cell = self.protocolCell;
    cell.newsTitle.text = [self.tableData[indexPath.row] objectForKey:@"title"];
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return 1  + size.height;
}
@end
