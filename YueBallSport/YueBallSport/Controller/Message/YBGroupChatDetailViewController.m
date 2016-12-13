//
//  YBGroupChatDetailViewController.m
//  YueBallSport
//
//  Created by 韩森 on 2016/12/13.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBGroupChatDetailViewController.h"

@interface YBGroupChatDetailViewController ()
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)NSMutableArray * sourceArray;

@end

@implementation YBGroupChatDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"";
    
    
}
-(void)initSubViews{
    
}


-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_scrollView];
        _scrollView.alwaysBounceVertical = YES;
    }
    return _scrollView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
