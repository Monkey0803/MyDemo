//
//  FMDBViewController.m
//  ThirdLib
//
//  Created by 王博 on 2018/7/11.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "FMDBViewController.h"
#import "Pan.h"
@import FMDB.FMDB;

@interface FMDBViewController ()
@property (nonatomic, strong) Pan *panView;
@end

@implementation FMDBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:(arc4random() % 255 / 255.0) green:(arc4random() % 255 / 255.0) blue:(arc4random() % 255 / 255.0) alpha:.7];
    [self createDataBase:@"test"];
    [self beiPath];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"clear" style:UIBarButtonItemStyleDone target:self action:@selector(clearAction)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)clearAction
{
    [_panView remove];
}

- (void)beiPath
{
    _panView = [[Pan alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_panView];
}




- (void)createDataBase:(NSString *)dataBaseName
{
    NSString *rootPath = NSHomeDirectory();
    NSLog(@"%@", rootPath);
    rootPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"%@", rootPath);
    NSString *path = [[rootPath stringByAppendingPathComponent:dataBaseName] stringByAppendingPathExtension:@"sqlite"];
    FMDatabase *dbase = [FMDatabase databaseWithPath:path];
    BOOL openSuccess = [dbase open];
    if (openSuccess) {
        NSLog(@"数据库打开成功");
    }else{
        NSLog(@"数据库打开失败");
    }
    
    BOOL connection = dbase.goodConnection;
    if (connection) {
        NSLog(@"数据库打开中");
    }else{
        NSLog(@"数据库关闭中");
    }
//    db.lastError;
//    db.userVersion;
//    db.applicationID;
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        BOOL closeSuccess = [db close];
//        if (closeSuccess) {
//            NSLog(@"数据库关闭成功");
//        }else{
//            NSLog(@"数据库关闭失败");
//        }
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            BOOL connection = db.goodConnection;
//            if (connection) {
//                NSLog(@"数据库打开中");
//            }else{
//                NSLog(@"数据库关闭中");
//            }
//        });
//    });
    
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
//    [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
//        if ([db open]) {
//            BOOL flag = [db executeUpdate:@"create table if not exists table_Name (msgID integer, msgType varchar(6), msgTitle text,scaned boolean, primary key (msgID, msgType));"];
////
//            if (flag) {
////                NSLog(@"表创建成功");
////                //增加一条数据列
//                if (![db columnExists:@"msgDetail" inTableWithName:@"table_Name"]) {
//                    //alter table 表名 add 键名 类型
//                    [db executeUpdate:@"alter table table_Name add msgDetail text;"];
//                }
//                if (![db columnExists:@"msgTime" inTableWithName:@"table_Name"]) {
//                    [db executeUpdate:@"alter table table_Name add msgTime text"];
//                }
//                //向表中添加数据
//                for (NSInteger i = 0; i < 10; i++) {
//                    NSString *type = @"P";
//                    if (i % 3 == 0) {
//                        type = @"P";
//                    }else if (i % 3 == 1){
//                        type = @"0";
//                    }else if (i % 3 == 2) {
//                        type = @"1";
//                    }
////                    //insert into 表名 (键1，键2，。。。。) values (值1， 值2，。。。。)
//                    NSString *sql = [NSString stringWithFormat:@"insert into '%@' (msgID, msgType, msgTitle, scaned, msgTime, msgDetail) values ('%ld', '%@', '%@', '%@', '%@', '%@');", @"table_Name", arc4random() % 10 + i, type, @"title", @YES, @"20180808 18:30", @"detail"];
//                    [db executeUpdate:sql];
//                }
//
//
//
////                NSString *deleteSQL = [NSString stringWithFormat:@"delete from '%@' where '%@' = '%d';", @"table_Name", @"msgID", 675];
////                [db executeUpdate:deleteSQL];
//
//
//            }else{
//                NSLog(@"表创建失败");
//            }
//            NSLog(@"lastErrorMessage = %@, error = %@", db.lastErrorMessage, db.lastError);
//        }
//
//    }];
//    [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
//        if ([db open]) {
//            NSString *deleteSQL = [NSString stringWithFormat:@"delete from %@ where %@ = '%d'", @"table_Name", @"msgID", 675];
//            BOOL delete = [db executeUpdate:deleteSQL];
//            NSLog(@"delete = %d", delete);
//            NSLog(@"lastErrorMessage = %@, error = %@", db.lastErrorMessage, db.lastError);
//
//        //修改数据
//            NSString *updateSql = [NSString stringWithFormat:@"update %@ set %@='%@' where %@='%d'",@"table_Name", @"msgTitle", @"new title", @"msgID", 10];
//           BOOL update = [db executeUpdate:updateSql];
//            NSLog(@"update = %d", update);
//
//
//            [db close];
//        }
//    }];
    
    //查询
    __block NSInteger num = 0;
    __block NSMutableArray *muArray = @[].mutableCopy;
    [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql = [NSString stringWithFormat:@"select * from table_Name where scaned = '%@' and msgType = '%@';", @YES, @"P"];
        NSString *sql1 = [NSString stringWithFormat:@"select * from table_Name order by msgTime desc "];
        FMResultSet *set = [db executeQueryWithFormat:sql,sql1, nil];
        while ([set next]) {
            NSString *sss = [NSString stringWithFormat:@"%@, %@", [set stringForColumn:@"msgTime"], [set stringForColumn:@"msgType"]];
            [muArray addObject:sss];
            num++;
        }
        [db close];
    }];

    NSLog(@"num = %ld, muArray = %ld", num, muArray.count);
   
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
