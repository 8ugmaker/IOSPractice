//
//  ViewController.m
//  WeChatUIDemo
//
//  Created by huyanxin on 2020/7/20.
//  Copyright © 2020 huyanxin. All rights reserved.
//

#import "ViewController.h"
#import "CellModel.h"
#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height

@interface ViewController ()

@property(nonatomic, strong) NSArray *dataSource;
@property(nonatomic, retain) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, WIDTH, HEIGHT) style:UITableViewStylePlain];
    _tableView.rowHeight = 70;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

//懒加载
- (NSArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSArray alloc] init];
        NSMutableArray *modelArray = [[NSMutableArray alloc] init];
        [self readJson:^(NSArray *arr, NSError *error) {
            for (NSDictionary *dic in arr) {
                CellModel *model = [CellModel dataInject:dic];
                [modelArray addObject:model];
            }
        }];
        _dataSource = modelArray;
    }
    return _dataSource;
}

- (void)readJson:(void (^)(NSArray *arr, NSError *error))completion
{
    //资源文件
    NSString * jsonPath = [[NSBundle mainBundle] pathForResource:@"sessions" ofType:@".json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:jsonPath];
    NSError *error;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error == nil) {
        completion(arr, nil);
    } else {
        completion(nil, error);
    }
}

- (UIImage *)getImageFromURL:(NSString *)url
{
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *pic = [UIImage imageWithData:data];
    return pic;
}

#pragma mark --代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //复用池查找
    static NSString *ID = @"messageCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID];
    CellModel *model = self.dataSource[indexPath.row];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        //头像
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        iconView.tag = 1;
        [cell.contentView addSubview:iconView];
        //未读消息数
        UIView *badgeView = [[UIView alloc] initWithFrame:CGRectMake(50, 5, 20, 20)];
        badgeView.tag = 2;
        if ([model.unreadCount intValue] > 0) {
            [cell.contentView addSubview:badgeView];
        }
        UILabel *unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        unreadLabel.tag = 3;
        [badgeView addSubview:unreadLabel];
        //标题
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 150, 20)];
        nameLabel.tag = 4;
        [cell.contentView addSubview:nameLabel];
        //消息概要
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, 200, 20)];
        messageLabel.tag = 5;
        [cell.contentView addSubview:messageLabel];
        //时间戳
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(320, 10, 80, 20)];
        timeLabel.tag = 6;
        [cell.contentView addSubview:timeLabel];
    }
    //头像
    UIImageView *iconView = (UIImageView *)[cell.contentView viewWithTag:1];
    iconView.image = [self getImageFromURL:model.iconURL];
    //未读数
    UIView *badgeView = [cell.contentView viewWithTag:2];
    UILabel *unreadLabel = [cell.contentView viewWithTag:3];
    badgeView.layer.cornerRadius = 10;
    badgeView.backgroundColor = [UIColor redColor];
    unreadLabel.text = [NSString stringWithFormat:@"%@",model.unreadCount];
    unreadLabel.textColor = [UIColor whiteColor];
    unreadLabel.font = [UIFont fontWithName:@"System Font Regular" size:12];
    unreadLabel.center = CGPointMake(CGRectGetMidX(badgeView.bounds), CGRectGetMidY(badgeView.bounds));
    unreadLabel.textAlignment = NSTextAlignmentCenter;
    //标题
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:4];
    nameLabel.text = model.name;
    //消息概要
    UILabel *messageLabel = (UILabel *)[cell.contentView viewWithTag:5];
    messageLabel.text = model.message;
    messageLabel.textColor = [UIColor grayColor];
    //时间戳
    UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:6];
    NSArray *timeArray = [model.time componentsSeparatedByString:@" "];
    timeLabel.text = [[timeArray lastObject] substringToIndex:5];
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.font = [UIFont fontWithName:@"System Font Regular" size:15];
    
    return cell;
}

@end
