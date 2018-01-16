//
//  ViewController.m
//  YS_TextureDEMO
//
//  Created by geys1991 on 2018/1/5.
//  Copyright © 2018年 geys1991. All rights reserved.
//

#import "ViewController.h"
#import "HGHomeFeedModel.h"
#import "HGCategoryCollectionModel.h"
#import "HGHomeCollectionCellNode.h"
#import "YSHomeGoodsInfoCellNode.h"
#import "YSHomeGoodsModel.h"


@interface ViewController ()  <ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) ASTableNode *tableViewNode;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger page;

@end

@implementation ViewController

-(instancetype)init
{
    self = [super initWithNode: self.tableViewNode];
    if ( self ) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.node.automaticallyManagesSubnodes = YES;
    }
    return self;
}

#pragma mark - request methods

- (void)loadPageWithContext:(ASBatchContext *)context withPage:(NSInteger)currentPage
{
    @weakify(self)
    [self requestDataComplete:^(NSArray *newDataArray) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableIndexSet *indexPaths = [[NSMutableIndexSet alloc] init];
            NSInteger existingNumberOfPhotos = [self.dataSource count];
            
            [newDataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ( [obj isKindOfClass:[NSDictionary class]] && ( [[obj objectForKey: @"type"] isEqualToString: @"collection"] || [[obj objectForKey: @"type"] isEqualToString: @"goods"] ) ) {
                    HGHomeFeedModel *feed = [[HGHomeFeedModel alloc] initWithJSONDic:obj];
                    if (feed.feedType != HGHomeFeedTypeUnknown && (feed.feedItems.count || feed.feedItem)) {
                    }
                    [self.dataSource addObject:feed];
                }
            }];
            
            NSInteger newTotalNumberOfPhotos = [self.dataSource count];
            for (NSInteger section = existingNumberOfPhotos; section < newTotalNumberOfPhotos; section ++) {
                [indexPaths addIndex: section];
            }
            
            [self.tableView insertSections: indexPaths withRowAnimation: UITableViewRowAnimationNone];
            if (context) {
                [context completeBatchFetching:YES];
            }
        });
    } withPage: currentPage];
}

- (void)requestDataComplete:(void(^)(NSArray *newDataArray))complete withPage:(NSInteger)currentPage
{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString: @"https://v.lehe.com/"]];
    [manager POST: @"v7/home/feeds" parameters: @{@"p" : @(currentPage),
                                                  @"cver" : @"7.2.0"
                                                  } progress: nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *data = [responseObject objectForKey: @"data"];
        NSArray *list = [data objectForKey: @"list"];
        
        if ( list.count > 0 ) {
            self.page = currentPage;
        }
        
        if ( complete ) {
            complete(list);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"");
    }];
}

#pragma mark - ASTableDataSource

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode
{
    return [self.dataSource count];
}

- (BOOL)shouldBatchFetchForTableNode:(ASTableNode *)tableNode
{
    return YES;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 0.01f)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 10.f)];
    footerView.backgroundColor = [UIColor lightGrayColor];
    return footerView;
}

- (ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HGHomeFeedModel *feedModel = [self.dataSource objectAtIndex:indexPath.section];
    
    if ( feedModel.feedType == HGHomeFeedTypeGoods ) {
        YSHomeGoodsModel *dataModel = [[YSHomeGoodsModel alloc] initWithJSONDic:feedModel.feedItem];
        YSHomeGoodsInfoCellNode *cellNode = [[YSHomeGoodsInfoCellNode alloc] initWithGoodsModel: dataModel];
        cellNode.backgroundColor = [UIColor whiteColor];
        cellNode.selectionStyle = UITableViewCellSelectionStyleNone;
        return cellNode;
    }else {
        HGCategoryCollectionModel *dataModel = [[HGCategoryCollectionModel alloc] initWithJSONDic:feedModel.feedItem];
        HGHomeCollectionCellNode *cellNode = [[HGHomeCollectionCellNode alloc] initWithCollectionModel: dataModel];
        cellNode.backgroundColor = [UIColor whiteColor];
        cellNode.selectionStyle = UITableViewCellSelectionStyleNone;
        return cellNode;
    }
}

#pragma mark - ASTableDelegate methods

// Receive a message that the tableView is near the end of its data set and more data should be fetched if necessary.
- (void)tableNode:(ASTableNode *)tableNode willBeginBatchFetchWithContext:(ASBatchContext *)context
{
    [context beginBatchFetching];
    [self loadPageWithContext:context withPage: self.page + 1];
}

#pragma mark - setter && getter

- (ASTableNode *)tableViewNode
{
    if ( !_tableViewNode ) {
        _tableViewNode = [[ASTableNode alloc] initWithStyle: UITableViewStyleGrouped];
        _tableViewNode.leadingScreensForBatching = 4;
        _tableViewNode.delegate = self;
        _tableViewNode.dataSource = self;
    }
    return _tableViewNode;
}

- (NSMutableArray *)dataSource
{
    if ( !_dataSource ) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (UITableView *)tableView
{
    return self.tableViewNode.view;
}

@end
