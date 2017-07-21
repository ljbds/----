//
//  ljbQuestion.h
//  超级猜图
//
//  Created by 李建兵 on 2017/6/24.
//  Copyright © 2017年 李建兵. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ljbQuestion : NSObject
@property(nonatomic,copy)NSString* answer;
@property(nonatomic,copy)NSString* lcon;
@property(nonatomic,copy)NSString* title;
@property(nonatomic,strong)NSArray *options;

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)questionwithDict:(NSDictionary*)dict;


@end
