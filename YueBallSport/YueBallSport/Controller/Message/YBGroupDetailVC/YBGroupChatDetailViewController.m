//
//  YBGroupChatDetailViewController.m
//  YueBallSport
//
//  Created by 韩森 on 2016/12/13.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBGroupChatDetailViewController.h"
#import "YBMessageModel.h"
#import "MJExtension.h"
#import "YBGroupChatDetailCollectionViewCell.h"

#define item_Width (SCREEN_WIDTH-20)/4-10
#define item_Height (SCREEN_WIDTH-20)/4-10+20

@interface YBGroupChatDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UIScrollView * scrollView;
@property (nonatomic,strong)NSMutableArray * sourceArray;
@property (nonatomic,strong)UICollectionView * collectionView;

@end

@implementation YBGroupChatDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"群聊详情";
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    
    
}

#pragma mark <UICollectionViewDataSource>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.sourceArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    static NSString * identity = @"cell";
    YBGroupChatDetailCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identity forIndexPath:indexPath];
    YBMessageModel * model  = self.sourceArray[indexPath.row];
    
    [cell setModel:model];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout * fLayout = [[UICollectionViewFlowLayout alloc]init];
        fLayout.minimumLineSpacing = 15;
        fLayout.minimumInteritemSpacing = 5;
        fLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        fLayout.itemSize = CGSizeMake(item_Width, item_Height);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:fLayout];
        _collectionView.alwaysBounceVertical = YES;
        [self.view addSubview:_collectionView];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"YBGroupChatDetailCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];

    }
    return _collectionView;
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

-(NSArray *)sourceArray{
    
    
    //获取文件路径
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"groupscource"ofType:@"json"];
    
    //根据文件路径读取数据
    NSData *jdata = [[NSData alloc]initWithContentsOfFile:filePath];
    
    //格式化成json数据
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jdata options:NSJSONReadingMutableContainers error:nil];
    
    //    NSString * s = [[NSString alloc]initWithData:jdata encoding:NSUTF8StringEncoding];
    
    
    NSArray * arr = [jsonObject objectForKey:@"member"];
    
    NSArray * modelArr = [YBMessageModel mj_objectArrayWithKeyValuesArray:arr];
    
    
    return modelArr;
    
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
