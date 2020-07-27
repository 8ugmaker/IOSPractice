//
//  ViewController.m
//  NetWorkDemo
//
//  Created by huyanxin on 2020/7/27.
//  Copyright © 2020 huyanxin. All rights reserved.
//

#import "ViewController.h"
#import "SessionWork.h"
#import "Model.h"

#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height

@interface ViewController ()

@property (nonatomic, strong)NSArray *messageList;
@property (nonatomic, retain)UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, WIDTH, HEIGHT) style:UITableViewStylePlain];
    _tableView.rowHeight = 70;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(300, 45, 60, 35)];
    [btn setTitle:@"refresh" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    btn.backgroundColor = [UIColor grayColor];
    [btn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

//获取图片
- (UIImage *)getImageFromURL:(NSString *)url
{
    NSURL *imageURL = [NSURL URLWithString:url];
    NSData *data = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}

//懒加载
- (NSArray *)messageList
{
    if (_messageList == nil) {
        _messageList = [[NSArray alloc] init];
        [self refresh];
    }
    return _messageList;
}

//刷新
- (void)refresh
{
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    [SessionWork getDataFromURL:^(NSArray *array){
        for (NSDictionary *dic in array) {
            Model *model = [Model dataInject:dic];
            [modelArray addObject:model];
        }
        self->_messageList = modelArray;
        NSLog(@"已刷新");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //复用池查找
    static NSString *ID = @"messageCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID];
    Model *model = self.messageList[indexPath.row];
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
    unreadLabel.text = [NSString stringWithFormat:@"%@", model.unreadCount];
    unreadLabel.textColor = [UIColor whiteColor];
    unreadLabel.font = [UIFont fontWithName:@"System Font Regular" size:12];
    unreadLabel.center = CGPointMake(CGRectGetMidX(badgeView.bounds), CGRectGetMidY(badgeView.bounds));
    unreadLabel.textAlignment = NSTextAlignmentCenter;
    if ([model.unreadCount intValue] == 0) {
        [badgeView removeFromSuperview];
    }
    //标题
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:4];
    nameLabel.text = model.name;
    //消息概要
    UILabel *messageLabel = (UILabel *)[cell.contentView viewWithTag:5];
    messageLabel.text = model.content;
    messageLabel.textColor = [UIColor grayColor];
    //时间戳
    UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:6];
    timeLabel.text = [[[model.time componentsSeparatedByString:@" "] lastObject] substringToIndex:5];
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.font = [UIFont fontWithName:@"System Font Regular" size:15];
    
    return cell;
}

@end
