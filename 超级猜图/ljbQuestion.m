//
//  ljbQuestion.m
//  超级猜图
//
//  Created by 李建兵 on 2017/6/24.
//  Copyright © 2017年 李建兵. All rights reserved.
//

#import "ljbQuestion.h"

@implementation ljbQuestion
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if(self = [super init])
    {
        self.answer = dict[@"answer"];
        self.lcon = dict[@"lcon"];
        self.title = dict[@"title"];
        self.options = dict[@"options"];
    }
    return self;
}

+(instancetype)questionwithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
}
@end
