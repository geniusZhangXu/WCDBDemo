//
//  Message.mm
//  WCDBDemo
//
//  Created by Zhangxu on 2017/8/17.
//  Copyright © 2017年 Zhangxu. All rights reserved.
//

#import "Message.h"
#import "Message+WCTTableCoding.h"


@implementation Message


// 利用这个宏定义绑定到表的类
WCDB_IMPLEMENTATION(Message)

// 下面四个宏定义绑定到表中的字段
WCDB_SYNTHESIZE(Message, localID)
WCDB_SYNTHESIZE(Message, content)
WCDB_SYNTHESIZE(Message, createTime)
WCDB_SYNTHESIZE(Message, modifiedTime)

// 约束宏定义数据库的主键
WCDB_PRIMARY(Message, localID)

// 定义数据库的索引属性，它直接定义createTime字段为索引
// 同时 WCDB 会将表名 + "_index" 作为该索引的名称
WCDB_INDEX(Message, "_index", createTime)


@end





@interface Messagemanager()
{
    WCTDatabase * database;
}

@end


@implementation Messagemanager

+(instancetype)shareInstance{

    static Messagemanager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[Messagemanager alloc]init];
        
    });
    
    return instance;
}



-(BOOL)creatDataBaseWithName:(NSString *)tableName{
    
    //获取沙盒根目录
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"model.sqlite"];
    NSLog(@"path = %@",filePath);
    
    database = [[WCTDatabase alloc]initWithPath:filePath];
    // 数据库加密
    //NSData *password = [@"MyPassword" dataUsingEncoding:NSASCIIStringEncoding];
    //[database setCipherKey:password];
    //测试数据库是否能够打开
    if ([database canOpen]) {
        
        // WCDB大量使用延迟初始化（Lazy initialization）的方式管理对象，因此SQLite连接会在第一次被访问时被打开。开发者不需要手动打开数据库。
        // 先判断表是不是已经存在
        if ([database isOpened]) {
            
            if ([database isTableExists:tableName]) {
                
                NSLog(@"表已经存在");
                return NO;
                
            }else
                return [database createTableAndIndexesOfName:tableName withClass:Message.class];
        }
    }
    return NO;
}


-(BOOL)insertMessage{
   
    //插入
    Message *message = [[Message alloc] init];
    message.localID = 1;
    message.content = @"Hello, WCDB!";
    message.createTime = [NSDate date];
    message.modifiedTime = [NSDate date];
    /*
     INSERT INTO message(localID, content, createTime, modifiedTime)
     VALUES(1, "Hello, WCDB!", 1496396165, 1496396165);
     */
     return  [database insertObject:message  into:@"message"];
}



// WCTDatabase 事务操作，利用WCTTransaction
-(BOOL)insertMessageWithTransaction{
   
    
    BOOL ret = [database beginTransaction];
    ret = [self insertMessage];
    if (ret) {
        
        [database commitTransaction];
        
    }else
        
        [database rollbackTransaction];
    
    return ret;
}


// 另一种事务处理方法Block
-(BOOL)insertMessageWithBlock{
   
    BOOL commit  =  [database runTransaction:^BOOL{
      
         BOOL ret = [self insertMessage];
         if (ret) {
             
             return YES;
             
         }else
             return NO;
         
     } event:^(WCTTransactionEvent event) {
         
         NSLog(@"Event %d", event);
     }];
    return commit;
}




-(BOOL)deleteMessage{

    //删除
    //DELETE FROM message WHERE localID>0;
    return [database deleteObjectsFromTable:@"message" where:Message.localID > 0];
    
}


-(BOOL)updataMessage{

    //修改
    //UPDATE message SET content="Hello, Wechat!";
    Message *message = [[Message alloc] init];
    message.content = @"Hello, Wechat!";
    
    //下面这句在17号的时候和微信团队的人在学习群里面沟通过，这个方法确实是不存在的，使用教程应该会更新，要是没更新注意这个方法
    //BOOL result = [database updateTable:@"message" onProperties:Message.content withObject:message];
    return [database updateAllRowsInTable:@"message" onProperty:Message.content withObject:message];
}


//查询
-(NSArray *)seleteMessage{

    //SELECT * FROM message ORDER BY localID
    NSArray<Message *> * message = [database getObjectsOfClass:Message.class fromTable:@"message" orderBy:Message.localID.order()];
    
    return message;
    
}


@end



