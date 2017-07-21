//
//  ViewController.m
//  超级猜图
//
//  Created by 李建兵 on 2017/6/23.
//  Copyright © 2017年 李建兵. All rights reserved.
//

#import "ViewController.h"
#import "ljbQuestion.h"
@interface ViewController ()
//所有问题的数据都在这个数组中
@property(nonatomic,strong)NSArray *questions;

//控制题目索引
@property(nonatomic,assign)int index;
//记录头像按钮的原始frame
@property(nonatomic,assign)CGRect iconFram;

@property (weak, nonatomic) IBOutlet UILabel *tupianxuho;
@property (weak, nonatomic) IBOutlet UIButton *btnscore;
@property (weak, nonatomic) IBOutlet UILabel *lbltitie;
@property (weak, nonatomic) IBOutlet UIButton *btntuxiang;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (weak, nonatomic) IBOutlet UIView *daan;

@property (weak, nonatomic) IBOutlet UIView *oper;


//用来引用那个“阴影”按钮的属性
@property (weak, nonatomic)UIButton * cove;

- (IBAction)btnNextcllck;

- (IBAction)bigiage:(id)sender;

- (IBAction)tuxiangdianji:(id)sender;


@end

@implementation ViewController
//懒加载
-(NSArray*)questions
{
    if(_questions == nil)
    {
        //加载数据
        NSString*path = [[NSBundle mainBundle]pathForResource:@"ljbapp.plist" ofType:nil];
        NSArray * arrayDict = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray * arrayModel = [NSMutableArray array];
        //遍历吧字典转模型
        for (NSDictionary *dict in arrayDict) {
            ljbQuestion *model = [ljbQuestion questionwithDict:dict];
            [arrayModel addObject:model];
            
        }
        _questions = arrayModel;
    }
    return _questions;
}
//改变状态栏的颜色为白色
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
//隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = -1;
    [self nextQues];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//点击下一题
- (IBAction)btnNextcllck {
    [self nextQues];
}
//显示大图
- (IBAction)bigiage:(id)sender {
    //记录一下头像的原始frame
    self.iconFram = self.btntuxiang.frame;
    //1.创建大小与self.view一样的按钮，吧这个按钮作为一个阴影
    UIButton * btncover = [[UIButton alloc]init];
    //设置按钮的大小
    btncover.frame = self.view.bounds;
    //设置按钮背景色
    btncover.backgroundColor = [UIColor blackColor];
    //设置按钮的透明度
    btncover.alpha = 0.0;
    //吧按钮加到self.view中
    [self.view addSubview:btncover];
    //为阴影按钮注册一个单机事件
    [btncover addTarget:self action:@selector(samllimag) forControlEvents:UIControlEventTouchUpInside];
    //
    //
    
    //2.把图片设置到阴影上面
    //吧self view 中所有的子控件中，只把self btntuxiang显示到最上面
    [self.view bringSubviewToFront:self.btntuxiang];
    
    //通过self.cove来引用btnCove
    self.cove = btncover;
    //3.通过动画的方式吧图片变大
    CGFloat iconw = self.view.frame.size.width;
    CGFloat iconh = iconw;
    CGFloat iconx = 0;
    CGFloat icony = (self.view.frame.size.height - iconh)*0.5;
    [UIView animateWithDuration:0.7 animations:^{
        //设置图片的新的frame
        self.btntuxiang.frame = CGRectMake(iconx, icony, iconw, iconh);
        btncover.alpha = 0.6;
    }];
        //
    //
    //
    
    
}

- (IBAction)tuxiangdianji:(id)sender {
    if(self.cove == nil)
    {
        [self bigiage:nil];
        
    }
    else
    {
        [self samllimag];
    }
}


//阴影单击事件
-(void)samllimag
{
   //1.设置btntxiang按钮的frame还原
   // self.btntuxiang.frame = self.iconFram;
     //2.让阴影按钮的透明度变成0
    //3.移除阴影按钮
    //[self.cove removeFromSuperview];
    //
    //动画效果
    [UIView animateWithDuration:0.8 animations:^{
        //1.设置btntxiang按钮的frame还原
        self.btntuxiang.frame = self.iconFram;
         //2.让阴影按钮的透明度变成0
        self.cove.alpha = 0.0;
    } completion:^(BOOL finished) {
        if(finished)
        {
            //3.移除阴影按钮
            [self.cove removeFromSuperview];
            //当头像图片变成小图以后，在吧self.cover 设置成nil
            self.cove = nil;
        }
    }];
    
}
//下一题
-(void)nextQues
{
    //让索引加一
    self.index++;
    
    //根据模型获取当前数据
    ljbQuestion *model = self.questions[self.index];
    //根据模型设置数据
    [self makwanswerButtons:model];
    
    //5.动态创建答案按钮
    [self makwanswerButtonu:model];
   
    // 动态创建待选按钮
    [self makeoptionsButen:model]; 
    
}
//创建待选按钮
-(void)makeoptionsButen:(ljbQuestion*)model
{
    //1.清除待选按钮的view中的所有东西
    [self.oper.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //2.获取当前题目的待选文字的数组
    NSArray *woeds = model.options;
    
    //待选按钮的位置
    CGFloat optionw = 35;
    CGFloat optionh = 35;
    //每个按钮之间的间距
    CGFloat margin = 10;
    //每行多少个按钮
    int columns = 7;
    //计算出每行第一个按钮距离左边的距离
    CGFloat marginleft = (self.oper.frame.size.width-columns*optionw-(columns-1)*margin)/2;
    
    
    //3.根据待选文字循环的来创建按钮
    for(int i= 0;i<woeds.count;i++)
    {
        //创建一个按钮
        UIButton * btnopt = [[UIButton alloc ]init];
        //设置按钮背景
        [btnopt setBackgroundImage:[UIImage imageNamed:@"bjt"] forState:UIControlStateNormal];
        [btnopt setBackgroundImage:[UIImage imageNamed:@"hbai"] forState:UIControlStateHighlighted];
        //设置按钮文字
        [btnopt setTitle:woeds[i] forState:UIControlStateNormal];
        //设置文字颜色为黑色
        [btnopt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //计算当前按钮的例的索引和行索引
        int colidx = i%columns;
        int rowidx = i/columns;
        CGFloat optionx = marginleft+colidx*(optionw+margin);
        CGFloat optiony = 0+rowidx*( optionh+margin);
        //设置按钮的frame
        btnopt.frame = CGRectMake(optionx, optiony , optionw, optionh);
        //吧按钮添加到视图中
        [self.oper addSubview:btnopt];
        //
    }
}

-(void)makwanswerButtons:(ljbQuestion*)model
{
    //吧模型数据设置到控件上
    self.tupianxuho.text = [NSString stringWithFormat:@"%d/%ld",(self.index+1),self.questions.count];
    self.lbltitie.text = model.title;
    [self.btntuxiang setImage:[UIImage imageNamed:model.lcon] forState:UIControlStateNormal];
    //设置到达最后一题以后，禁用下一题按钮
    self.btnNext.enabled = (self.index!=self.questions.count-1);

}
//创建答案按钮
-(void)makwanswerButtonu:(ljbQuestion*)model
{
    //5.0清除答案按钮
    //while (self.daan.subviews.firstObject) {
    //  [self.daan.subviews.firstObject removeFromSuperview];
    //}
    //这句话的意思：让subviews这个数组的每个对象，分别调用一次removeFromSuperview的方法，内部执行了循环，无需我们循环
    [self.daan.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    //5.1获取当前按钮的文字
    NSInteger len =  model.answer.length;
    //设置按钮的frame
    CGFloat margin = 10;//每个按钮之间的间距
    CGFloat answerw = 35;
    CGFloat answerh = 35;
    CGFloat answery = 0;
    CGFloat margjinleft = (self.daan.frame.size.width-(len*answerw)-(len-1)*margin)/2;
    //5.2循环创建答案按钮，有几个文字创建几个按钮
    for(int i=0;i<len;i++)
    {
        //创建按钮
        UIButton * btnanswer = [[UIButton alloc]init];
        //设置按钮背景图
        [btnanswer setBackgroundImage:[UIImage imageNamed:@"bjt"] forState:UIControlStateNormal];
        [btnanswer setBackgroundImage:[UIImage imageNamed:@"habi"] forState:UIControlStateHighlighted];
        //设置按钮的frame
        CGFloat answerx = margjinleft+i*(answerw+margin);
        btnanswer.frame = CGRectMake(answerx, answery, answerw, answerh);
        
        //吧按钮加到answer中
        [self.daan addSubview:btnanswer];
        
    }
  
}
@end
