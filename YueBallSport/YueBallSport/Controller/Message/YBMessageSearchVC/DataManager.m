//
//  DataManager.m
//  UISearchController&UISearchDisplayController
//
//  Created by zml on 15/12/2.
//  Copyright © 2015年 zml@lanmaq.com. All rights reserved.
//

#import "DataManager.h"
#import "DemoModel.h"
#import "MJExtension.h"
@implementation DataManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        self.testDataArray = [self createTestDataArray];
    }
    return self;
}

-(NSArray *)createTestDataArray
{
    NSArray *testModels = @[
                            [DemoModel  modelWithName:@"冬雨无情却有情" friendId:@"野猪林足球俱乐部" imageData:UIImageJPEGRepresentation([UIImage imageNamed:@"1.jpeg"], 0.3)],
                            ];
    /*
     
     
     [DemoModel  modelWithName:@"吴明思" friendId:@"北京人家足球俱乐部" imageData:UIImageJPEGRepresentation([UIImage imageNamed:@"2.jpg"], 0.3)],
     [DemoModel  modelWithName:@"吴孟达" friendId:@"北京天上人间俱乐部" imageData:UIImageJPEGRepresentation([UIImage imageNamed:@"3.jpg"], 0.3)],
     [DemoModel  modelWithName:@"Yu" friendId:@"6356347345" imageData:UIImageJPEGRepresentation([UIImage imageNamed:@"4.jpg"], 0.3)],
     [DemoModel  modelWithName:@"Feng" friendId:@"4764536456" imageData:UIImageJPEGRepresentation([UIImage imageNamed:@"5.jpg"], 0.3)],
     [DemoModel  modelWithName:@"Chen" friendId:@"734563465" imageData:UIImageJPEGRepresentation([UIImage imageNamed:@"6.jpg"], 0.3)],
     [DemoModel  modelWithName:@"Ru" friendId:@"534535345" imageData:UIImageJPEGRepresentation([UIImage imageNamed:@"7.jpg"], 0.3)],
     [DemoModel  modelWithName:@"Good" friendId:@"34534573457" imageData:UIImageJPEGRepresentation([UIImage imageNamed:@"8.jpg"], 0.3)]
     
     
     */
    return testModels;
}

-(NSArray *)queryFriendArray{
    
    //获取文件路径
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"getFriend"ofType:@"json"];
    
    //根据文件路径读取数据
    NSData *jdata = [[NSData alloc]initWithContentsOfFile:filePath];
    
    //格式化成json数据
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jdata options:NSJSONReadingMutableContainers error:nil];
    
    //    NSString * s = [[NSString alloc]initWithData:jdata encoding:NSUTF8StringEncoding];
    
    
    NSArray * arr = [jsonObject objectForKey:@"member"];
    
    NSArray * modelArr = [DemoModel mj_objectArrayWithKeyValuesArray:arr];
    
    
    return modelArr;
}

@end
