//
//  PayViewController.m
//  ThirdLib
//
//  Created by 王博 on 2018/7/13.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "PayViewController.h"
@import PassKit;
@interface PayViewController ()
@property (nonatomic, strong) NSUndoManager *undoM;
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 10.3, *)) {
        //判断设备是否支持Apple pay
        BOOL deviceSu = [PKPaymentAuthorizationViewController canMakePayments];
        if (deviceSu) {
            //判断是否可以进行支付
            BOOL canPay = [PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkVisa, PKPaymentNetworkIDCredit]];
            if (canPay) {
                
            }
        }
        
    } else {
        // Fallback on earlier versions
    }
    
    
    _undoM = [[NSUndoManager alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:NSUndoManagerDidUndoChangeNotification object:_undoM];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:NSUndoManagerDidRedoChangeNotification object:_undoM];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"redo" style:UIBarButtonItemStyleDone target:self action:@selector(redoAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"undo" style:UIBarButtonItemStyleDone target:self action:@selector(undoAction)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark -------------- 通知 --------------

- (void)showAlert:(NSNotification *)noti
{
    NSString *name = noti.name;
    NSUndoManager *manager = (NSUndoManager *)noti.object;
    if ([name isEqualToString:NSUndoManagerDidRedoChangeNotification]) {
        
    }else if ([name isEqualToString:NSUndoManagerDidUndoChangeNotification]) {
        
    }
}

#pragma mark -------------- Action --------------

- (void)redoAction
{
    
}

- (void)undoAction
{
    
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
