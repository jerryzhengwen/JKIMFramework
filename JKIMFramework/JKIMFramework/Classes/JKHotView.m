//
//  JKHotView.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/8/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKHotView.h"
#import "JKHotModel.h"
#import "JKBundleTool.h"

@implementation JKHotView
-(instancetype)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        [self createTableView];
    }
    return self;
}
-(void)createTableView {
    self.tableView.layer.cornerRadius = 5.0f;
    self.tableView.clipsToBounds = YES;
    [self addSubview:self.tableView];
    //设置tableView的背景图
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.frame =self.tableView.bounds;
    NSString *bundlePatch =  [JKBundleTool initBundlePathWithImage];
    NSString *filePatch = [bundlePatch stringByAppendingPathComponent:@"chatfrom_bg_normal"];
    imageView.image  = [UIImage imageWithContentsOfFile:filePatch];
    imageView.image = [imageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(35, 20, 10, 10)];
    [self.tableView setBackgroundView:imageView];
}
-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hotArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString *jkCell = @"jkCell";
    JKHotViewCell * cell = [tableView dequeueReusableCellWithIdentifier:jkCell];
    if (!cell) {
        cell = [[JKHotViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:jkCell];
    }
    JKHotModel * hotModel = self.hotArray[indexPath.row];
    cell.title = hotModel.question;
    cell.backgroundColor = [UIColor clearColor];
    cell.userInteractionEnabled = YES;
    return cell;
}
-(void)setHotArray:(NSArray *)hotArray {
    _hotArray = hotArray;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 41;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JKHotModel * model = self.hotArray[indexPath.row];
    if (self.hotMsgBlock) {
        self.hotMsgBlock(model.question);
    }
}
@end
