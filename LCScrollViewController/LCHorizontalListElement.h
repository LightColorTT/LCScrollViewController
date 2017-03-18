//
//  LCHorizontalListElement.h
//  LCHorizontalScrollView
//
//  Created by Vio on 16.03.17.
//  Copyright © 2017 LightColor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HorizontalScrollViewListElementsDataSource;
@protocol HorizontalScrollViewListElementsDelegate;

@interface LCHorizontalListElement : UIView

@property (nonatomic) NSInteger selectedButtonIndex;
@property (nonatomic) NSUInteger selectedIndexNow;

@property (nonatomic, weak) id<HorizontalScrollViewListElementsDataSource> dataSource;
@property (nonatomic, weak) id<HorizontalScrollViewListElementsDelegate> delegate;

- (void)reloadData;
- (void)selectedButtonFirstClick:(NSInteger)index;
- (void)buttonClick;

@end

@protocol HorizontalScrollViewListElementsDataSource <NSObject>

- (NSInteger)numberOfItemsInSelectionList:(LCHorizontalListElement *)selectionList;
- (NSString *)selectionList:(LCHorizontalListElement *)selectionList titleForItemWithIndex:(NSInteger)index;

@end

@protocol HorizontalScrollViewListElementsDelegate <NSObject>

- (void)selectionList:(LCHorizontalListElement *)selectionList didSelectButtonWithIndex:(NSInteger)index;
- (void)selectionList:(LCHorizontalListElement *)selectionList getSelectedIndexButton:(NSInteger)index;

@end
