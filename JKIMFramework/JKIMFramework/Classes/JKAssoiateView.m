//
//  JKAssoiateView.m
//  JKIMSDKProject
//
//  Created by Jerry on 2019/8/12.
//  Copyright © 2019 于飞. All rights reserved.
//

#import "JKAssoiateView.h"
#import "JKDialogueHeader.h"
@implementation JKAssoiateView
-(void)createTableView {
    [self addSubview:self.tableView];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}
//-(void)setAssociateArr:(NSArray *)associateArr {
//    _associateArr = associateArr;
//    [self.tableView reloadData];
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.associateArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString *jkCell = @"associateCell";
    JKHotViewCell * cell = [tableView dequeueReusableCellWithIdentifier:jkCell];
    if (!cell) {
        cell = [[JKHotViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:jkCell];
    }
    cell.title = self.associateArr[indexPath.row];
    cell.keyWord = self.keyWord;
    cell.backgroundColor = UIColorFromRGB(0xFBFBFB);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.hotMsgBlock) {
        self.hotMsgBlock(self.associateArr[indexPath.row]);
    }
}
@end
