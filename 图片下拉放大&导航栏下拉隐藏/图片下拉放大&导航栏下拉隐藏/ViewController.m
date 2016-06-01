//
//  ViewController.m
//  图片下拉放大&导航栏下拉隐藏
//
//  Created by visoft  on 16/6/1.
//  Copyright © 2016年 visoft . All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Color.h"


#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kHeadImageHeight 200

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)UITableView * tableView;

@property(nonatomic,strong)NSMutableArray * dataArray;

@property(nonatomic,strong)UIImageView * imageView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图片下拉放大&导航栏下拉隐藏";
    //设置导航条透明
    [self setNavigationBarClear];
    //添加TableView
    [self createTableView];
    //添加表头视图
    [self addTableHeadView];

}
-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
        [_dataArray addObject:@"测试1"];
        [_dataArray addObject:@"测试2"];
        [_dataArray addObject:@"测试3"];
        [_dataArray addObject:@"测试4"];
    }
    return _dataArray;

}
-(void)setNavigationBarClear
{

    //给导航条设置空的背景图
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去除导航条变空后导航条留下的黑线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

}
-(void)createTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;

    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    
    self.tableView = tableView;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    tableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:tableView];

}
-(void)addTableHeadView
{

    self.imageView = [[UIImageView alloc]init];
    
    self.imageView.frame = CGRectMake(0, -kHeadImageHeight, kScreenWidth, kHeadImageHeight);
    
    self.imageView.image = [UIImage imageNamed:@"background"];
    
    [self.tableView addSubview:self.imageView];
    
    //设置图片的模式
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    //解决设置UIViewContentModeScaleAspectFill图片超出边框的问题
    self.imageView.clipsToBounds = YES;

    self.tableView.contentInset = UIEdgeInsetsMake(kHeadImageHeight, 0, 0, 0);


}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"ID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;

}
/**
 *  核心代码
 *
 *  @param scrollView scrollView
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",self.tableView.contentOffset.y);

    CGFloat offSet_Y = self.tableView.contentOffset.y;
    
    if (offSet_Y<-kHeadImageHeight) {
        //获取imageView的原始frame
        CGRect frame = self.imageView.frame;
        //修改y
        frame.origin.y = offSet_Y;
        //修改height
        frame.size.height = -offSet_Y;
        //重新赋值
        self.imageView.frame = frame;

    }
    //tableView相对于图片的偏移量
    CGFloat reoffSet = offSet_Y + kHeadImageHeight;
    
    NSLog(@"%f",reoffSet);
    //kHeadImageHeight-64是为了向上拉倒导航栏底部时alpha = 1
    CGFloat alpha = reoffSet/(kHeadImageHeight-64);
    
    NSLog(@"%f",alpha);
    
    if (alpha>=1) {
        alpha = 0.99;
    }
    UIImage *image = [UIImage imageWithColor:[UIColor colorWithRed:0.227 green:0.753 blue:0.757 alpha:alpha]];
    
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    




}

@end
