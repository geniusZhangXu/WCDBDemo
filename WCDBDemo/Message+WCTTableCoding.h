//
//  Message+WCTTableCoding.h
//  WCDBDemo
//
//  Created by Zhangxu on 2017/8/17.
//  Copyright © 2017年 Zhangxu. All rights reserved.
//

#import "Message.h"
#import <WCDB/WCDB.h>

@interface Message (WCTTableCoding) <WCTTableCoding>


// 需要绑定到表中的字段在这里声明，在.mm中去绑定
WCDB_PROPERTY(localID)
WCDB_PROPERTY(content)
WCDB_PROPERTY(createTime)
WCDB_PROPERTY(modifiedTime)




@end
