//
//  LCScrollViewController.m
//  LCScrollViewController
//
//  Created by Vio on 18.03.17.
//  Copyright © 2017 LightColor. All rights reserved.
//

#import "LCScrollViewController.h"
#import "LCGenerateScrollView.h"
#import "LCTableViewControllerOne.h"
#import "LCTableViewControllerTwo.h"

@interface LCScrollViewController () <LCGenerateScrollViewDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *workSpaceView;
@property (strong, nonatomic) NSMutableArray* arrayTableView;
@property (strong, nonatomic) UITableView* selectedTableView;

@property (strong, nonatomic) LCGenerateScrollView *creater;
@end

@implementation LCScrollViewController

- (void)setting1 {
    //UITableViewController* one = [[LCTableViewControllerOne alloc] initWithView:self.workSpaceView];
    UITableView* oneTemp = [[UITableView alloc] initWithFrame:self.workSpaceView.bounds style:UITableViewStylePlain];
    oneTemp.delegate = self;
    oneTemp.dataSource = self;
    oneTemp.tag = 0;
    
    //UITableViewController* two = [[LCTableViewControllerTwo alloc] initWithView:self.workSpaceView];
    UITableView* twoTemp = [[UITableView alloc] initWithFrame:self.workSpaceView.bounds style:UITableViewStyleGrouped];
    twoTemp.delegate = self;
    twoTemp.dataSource = self;
    twoTemp.tag = 1;
    
    [self.arrayTableView addObject:oneTemp];
    [self.arrayTableView addObject:twoTemp];
}
- (NSMutableArray *)arrayTableView {
    if (!_arrayTableView) {
        _arrayTableView = [NSMutableArray new];
    }
    return _arrayTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setting1];
    [self addDateScrollView];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.creater createScrollView:self.mainScrollView];
    
}
- (void)createGradientViaView:(UIView *)view {
    CAGradientLayer *gradientMask = [CAGradientLayer layer];
    gradientMask.frame = view.bounds;
    gradientMask.startPoint = CGPointMake(0.0, 0.5);   // start at left middle
    gradientMask.endPoint = CGPointMake(1.0, 0.5);
    gradientMask.colors = @[(id)[UIColor darkGrayColor].CGColor,
                            (id)[UIColor lightGrayColor].CGColor,
                            (id)[UIColor whiteColor].CGColor,
                            (id)[UIColor lightGrayColor].CGColor,
                            (id)[UIColor darkGrayColor].CGColor];
    gradientMask.locations = @[@0.0, @0.20, @0.50, @0.80, @1.0];
    [view.layer addSublayer:gradientMask];
    
}

- (void)addDateScrollView {
    self.creater = [[LCGenerateScrollView alloc] init];
    [self.mainScrollView layoutIfNeeded];
    [self createGradientViaView:self.mainScrollView];
    [self.creater createScrollViewWithTableViewController:[self.arrayTableView copy]];
    self.creater.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    NSLog(@"viewWillLayoutSubviews");
}
- (void)didChangeIndexScrollView:(UITableView *)tableView {
    self.selectedTableView = tableView;
    NSLog(@"%ld",tableView.tag);
    [self.workSpaceView layoutSubviews];
    [self.selectedTableView layoutIfNeeded];
    [tableView reloadData];
    [self.workSpaceView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self.workSpaceView addSubview:self.selectedTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (tableView.tag) {
        case 0:
            return 5;
        case 1:
            return 10;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 0) {
        UITableViewCell* cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellOne"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellOne"];
        }
        
        cell.textLabel.text = @"TABLEVIEW TAG 0";
        return cell;
    }
    if (tableView.tag == 1) {
        UITableViewCell* cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellTwo"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellTwo"];
        }
        
        cell.textLabel.text = @"TABLEVIEW TAG 1";
        return cell;
    }
    UITableViewCell* cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Default"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Default"];
    }
    
    cell.detailTextLabel.text = @"Default";
    return cell;
}
@end
