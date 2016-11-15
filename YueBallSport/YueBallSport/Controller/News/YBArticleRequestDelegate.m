//
//  YBArticleRequestDelegate.m
//  YueBallSport
//
//  Created by Minlay on 16/11/14.
//  Copyright © 2016年 YueBall. All rights reserved.
//

#import "YBArticleRequestDelegate.h"
#import "SNImageUrlManager.h"

@interface YBArticleRequestDelegate ()
@property(nonatomic,copy)SNGotImageBlock myImageBlock;
@end
@implementation YBArticleRequestDelegate
- (void)requestArticleWithArticleId:(NSString *)articleId articleUrl:(NSString *)articleUrl articleBlock:(SNGotArticleBlock)articleBlock {
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://wu.she-cheng.com/thinkphp/News/article?newsId=%@",articleId];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //生成连接
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    //建立连接并接收返回数据(异步执行)
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSDictionary *json;
         if (data){
             json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         }else{
             articleBlock(NO,nil);
             return;
         }
         /* Parse successful. */
         if (connectionError)
         {
             articleBlock(NO,nil);
         }
         /* Error. */
         else
         {
             articleBlock(YES,json);
         }
     }];
}

- (NSString *)localImageUrlFromSNArticleImage:(SNArticleImage *)image {
    return image.url;
}
/**
 *  下载正文图片
 *
 */
- (void)loadArticleImages:(NSArray *)images callbackBlock:(SNGotImageBlock)callbackBlock
{
    if(!_myImageBlock)
    {
        self.myImageBlock = callbackBlock;
    }
    for(SNArticleImage *image in images)
    {
        [self performSelector:@selector(downloadImage:) withObject:image afterDelay:0];
    }
}

- (void)downloadImage:(SNArticleImage *)image
{
    NSString *finalUrl = [SNImageUrlManager articleImgUrl:image];
    SNArticleTempImage *cacheImage = [[SNArticleTempImage alloc]init];
    cacheImage.imageTag = image.tagId;
    cacheImage.url = finalUrl;
    self.myImageBlock(cacheImage);
}
@end
