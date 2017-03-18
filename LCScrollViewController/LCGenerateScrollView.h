//
//  LCGenerateScrollView.h
//  LCHorizontalScrollView
//
//  Created by Vio on 16.03.17.
//  Copyright © 2017 LightColor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LCGenerateScrollViewDelegate;

@interface LCGenerateScrollView : NSObject

@property (weak, nonatomic) id<LCGenerateScrollViewDelegate> delegate;

@property (strong, nonatomic) UITableView* controllerSelectNow;
@property (strong, nonatomic) UITableView* controllerLast;

- (void)createScrollView:(UIView *)newView;
- (void)createScrollViewWithTableViewController:(NSArray *)listTableViewController;

@end

@protocol LCGenerateScrollViewDelegate <NSObject>

- (void)didChangeIndexScrollView:(UITableView *)tableView;

@end
