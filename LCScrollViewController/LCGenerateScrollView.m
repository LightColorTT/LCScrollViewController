//
//  LCGenerateScrollView.m
//  LCHorizontalScrollView
//
//  Created by Vio on 16.03.17.
//  Copyright © 2017 LightColor. All rights reserved.
//

#import "LCGenerateScrollView.h"
#import "LCHorizontalListElement.h"

@interface LCGenerateScrollView () <HorizontalScrollViewListElementsDelegate, HorizontalScrollViewListElementsDataSource>

@property (nonatomic, strong) LCHorizontalListElement *selectionList;
@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic) NSInteger firstSelectedButton;
@property (strong, nonatomic) UITableView* tableView;

@end

@implementation LCGenerateScrollView

- (void)createScrollViewWithTableViewController:(NSArray *)listTableViewController {
    self.selectionList = [LCHorizontalListElement new];
    self.selectionList.delegate = self;
    self.selectionList.dataSource = self;
    self.arrayData = [[NSArray arrayWithArray:listTableViewController] copy];
    self.controllerSelectNow = [self.arrayData objectAtIndex:0];
    self.controllerLast = [self.arrayData objectAtIndex:0];
}
- (void)createScrollView:(UIView *)newView {
    self.selectionList = [self.selectionList initWithFrame:newView.bounds];
    self.selectionList.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.selectionList layoutIfNeeded];
    [newView addSubview:self.selectionList];
    [self.selectionList buttonClick];
}

- (NSInteger)numberOfItemsInSelectionList:(LCHorizontalListElement *)selectionList {
    return self.arrayData.count;
}

- (NSString *)selectionList:(LCHorizontalListElement *)selectionList titleForItemWithIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"TableView %ld", index];
}

- (void)selectionList:(LCHorizontalListElement *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    
}

- (void)selectionList:(LCHorizontalListElement *)selectionList getSelectedIndexButton:(NSInteger)index{
    self.tableView = self.arrayData[index];
    [self.delegate didChangeIndexScrollView:self.tableView];
}
@end
