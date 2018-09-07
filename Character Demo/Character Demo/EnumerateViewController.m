//
//  EnumerateViewController.m
//  Character Demo
//
//  Created by 王博 on 2018/5/29.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "EnumerateViewController.h"

@interface EnumerateViewController ()
@property (nonatomic, strong) UITextView *showL;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, copy) NSArray *segArray;
@end

@implementation EnumerateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"枚举";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.showL];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -------------- action --------------

- (void)choiceAction:(UISegmentedControl *)seg
{
    NSStringEnumerationOptions op = NSStringEnumerationByWords;

    if (seg.selectedSegmentIndex == 0) {
        op = NSStringEnumerationByLines;
    }else if (seg.selectedSegmentIndex == 1){
        op = NSStringEnumerationByParagraphs;
    }else if (seg.selectedSegmentIndex == 2){
        op = NSStringEnumerationByComposedCharacterSequences;
    }else if (seg.selectedSegmentIndex == 3){
        op = NSStringEnumerationByWords;
    }else if (seg.selectedSegmentIndex == 4){
        op = NSStringEnumerationBySentences;
    }else if (seg.selectedSegmentIndex == 5){
        op = NSStringEnumerationReverse;
    }else if (seg.selectedSegmentIndex == 6){
        op = NSStringEnumerationSubstringNotRequired;
    }else if (seg.selectedSegmentIndex == 7){
        op = NSStringEnumerationLocalized;
    }
    NSMutableString *muStr = @"".mutableCopy;
    NSString *s = @"The weather on \U0001F30D is \U0001F31E today.";
    // The weather on 🌍 is 🌞 today.
    NSRange fullRange = NSMakeRange(0, [s length]);
    [s enumerateSubstringsInRange:fullRange
                          options:op
                       usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
     {
         NSLog(@"substring = %@,\n substringRange = %@\n,enclosingRange = %@,\n", substring, NSStringFromRange(substringRange), NSStringFromRange(enclosingRange));
         [muStr appendString:@"|"];
         NSString *str = [NSString stringWithFormat:@"substring = %@,\n substringRange = %@,\nenclosingRange = %@\n", substring, NSStringFromRange(substringRange), NSStringFromRange(enclosingRange)];
         [muStr appendString:str];
         
     }];
    self->_showL.text = [NSString stringWithFormat:@"被枚举的字符串：%@\n%@",s, muStr.copy];

}

#pragma mark -------------- getter --------------

- (NSArray *)segArray
{
    if (!_segArray) {
        _segArray = @[@"Lines", @"Paragraphs", @"ComposedCharacterSequences", @"Words", @"Sentences", @"Reverse", @"SubstringNotRequired", @"Localized" ];
    }
    return _segArray;
}

- (UISegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:self.segArray];
//        _segmentedControl.apportionsSegmentWidthsByContent = YES;
        _segmentedControl.tintColor = [UIColor redColor];
        [_segmentedControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:12], NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont italicSystemFontOfSize:14], NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
        [_segmentedControl addTarget:self action:@selector(choiceAction:) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.frame = CGRectMake(10, 20 + CGRectGetHeight(self.navigationController.navigationBar.frame) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), CGRectGetWidth(self.view.frame) - 10 * 2, 50);
        
    }
    return _segmentedControl;
}

- (UITextView *)showL
{
    if (!_showL) {
        _showL = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_segmentedControl.frame), CGRectGetMaxY(_segmentedControl.frame) + 20, CGRectGetWidth(_segmentedControl.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_segmentedControl.frame) - 20 * 2)];
        _showL.backgroundColor = [UIColor lightGrayColor];
        
        _showL.textColor = [UIColor blackColor];
        _showL.font = [UIFont italicSystemFontOfSize:15];
        _showL.textAlignment = NSTextAlignmentCenter;
        
        
    }
    return _showL;
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
