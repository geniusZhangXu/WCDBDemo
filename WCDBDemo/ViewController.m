//
//  ViewController.m
//  WCDBDemo
//
//  Created by Zhangxu on 2017/8/17.
//  Copyright © 2017年 Zhangxu. All rights reserved.
//

#import "ViewController.h"
#import "Message.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *creatButton;

@property (weak, nonatomic) IBOutlet UIButton *insertButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIButton *seleteButton;

@property (weak, nonatomic) IBOutlet UIButton *updateButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [_creatButton addTarget:self action:@selector(creatButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_insertButton  addTarget:self action:@selector(insertButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_seleteButton addTarget:self action:@selector(seleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_updateButton addTarget:self action:@selector(updateButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}

// 创建数据库
-(void)creatButtonClick{
  
   BOOL  result = [[Messagemanager shareInstance] creatDataBaseWithName:@"message"];
   NSLog(@"%@",((result == YES)?@"创建数据库成功":@"创建数据库失败"));
    
}


// 插入数据
-(void)insertButtonClick{

    BOOL  result = [[Messagemanager shareInstance] insertMessage];
    NSLog(@"%@",((result == YES)?@"数据插入成功":@"数据插入失败"));
    
}


// 删除
-(void)deleteButtonClick
{

    BOOL  result = [[Messagemanager shareInstance]deleteMessage];
    NSLog(@"%@",((result == YES)?@"删除数据成功":@"删除数据失败"));

}


// 查找数据
-(void)seleteButtonClick{

    NSArray * array = [[Messagemanager shareInstance]seleteMessage];
    NSLog(@"%@",array);
    
}


// 更新数据
-(void)updateButtonClick{

    BOOL  result = [[Messagemanager shareInstance]updataMessage];
    NSLog(@"%@",((result == YES)?@"修改数据成功":@"修改数据失败"));
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
