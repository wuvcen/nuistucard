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
                self.tableData = [NSMutableArray arrayWithArray:response[@"Array"]];
                [self.tableView reloadData];
            }
        }
        [self.tableView.header endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [self.tableView.header endRefreshing];
        
    }];
}

- (void)getMoreData {
    
    self.currentPage ++;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *postData = @{@"type":self.currentNews,@"page":[NSString stringWithFormat:@"%ld",self.currentPage]};
    
    [manager POST:@"http://shenjingstudio.com/ucard/CSNews.php" parameters:postData success:^(AFHTTPRequestOperation *opeation, id response){
        if (response) {
            if ([response[@"status"] isEqualToString:@"OK"]) {
                if (self.tableData) {
                    [self.tableData addObjectsFromArray:response[@"Array"]];
                }else {
                    self.tableData = response[@"Array"];
                }
                [self.tableView reloadData];
            }
        }
        [self.tableView.footer endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [self.tableView.footer endRefreshing];
        
    }];

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
