//
//  XHPoemViewController.m
//  ThirdLib
//
//  Created by 王博 on 2018/8/9.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

/*
 https://github.com/xenv/gushici
 */

#import "XHPoemViewController.h"
#import "XHPoemCollectionViewCell.h"
#import "XHPoemModel.h"
#import <KLCPopup/KLCPopup.h>
#import <AFNetworking/AFNetworking.h>
#import <YYModel/YYModel.h>
#import "XHPoemRandomModel.h"
#import "XHPoemRandomView.h"
@interface XHPoemViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *poemCV;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) XHPoemModel *model;
@property (nonatomic, strong) XHPoemRandomView *randomView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation XHPoemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.poemCV];
    [self.view addSubview:self.indicatorView];
    [_poemCV registerClass:[XHPoemCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([XHPoemCollectionViewCell class])];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -------------- data --------------

- (void)getData
{
    [_indicatorView startAnimating];
    AFURLSessionManager *manager = [AFURLSessionManager new];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.gushi.ci/"]];
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:urlRequest uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"%@", responseObject);
        [self parseString:responseObject];
    }];
    [task resume];
}


- (void)parseString:(id)responseObject
{
    NSDictionary *jsonDic = (NSDictionary *)responseObject;
    _model = [XHPoemModel yy_modelWithDictionary:jsonDic];
    self.dataArray = _model.list;
    [_poemCV reloadData];
    self.navigationItem.title = _model.welcome;
    [_indicatorView stopAnimating];
}

- (void)randomPoem:(NSString *)urlStr
{
    [self.indicatorView startAnimating];
    AFURLSessionManager *manager = [AFURLSessionManager new];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];

    NSURLSessionDataTask *task = [manager dataTaskWithRequest:urlRequest uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self parseRandom:responseObject];
    }];
    [task resume];
}

- (void)parseRandom:(id)responseObject
{
    NSDictionary *jsonDic = (NSDictionary *)responseObject;
    XHPoemRandomModel *rModel = [XHPoemRandomModel yy_modelWithDictionary:jsonDic];
    if (!_randomView) {
        _randomView = [[XHPoemRandomView alloc] init];
    }
    _randomView.model = rModel;
    [self.indicatorView stopAnimating];
    
}

#pragma mark -------------- UICollectionViewDataSource --------------

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XHPoemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XHPoemCollectionViewCell class]) forIndexPath:indexPath];
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.nameStr = dic.allKeys.firstObject;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

#pragma mark -------------- UICollectionViewDelegate --------------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.indicatorView.animating) {
        return;
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    [self randomPoem:dic.allValues.firstObject];
}

#pragma mark -------------- UICollectionViewDelegateFlowLayout --------------

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (self.view.bounds.size.width - 4 * 5) / 3;
    return (CGSize){width, 30};
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return (UIEdgeInsets){5, 5, 5, 5};
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
#pragma mark -------------- getter --------------

- (UICollectionView *)poemCV
{
    if (!_poemCV) {
        _poemCV = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        _poemCV.delegate = self;
        _poemCV.dataSource = self;
        _poemCV.backgroundColor = [UIColor whiteColor];
        
    }
    return _poemCV;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.hidesWhenStopped = YES;
        _indicatorView.center = self.view.center;

    }
    return _indicatorView;
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
