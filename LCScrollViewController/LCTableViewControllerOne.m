//
//  LCTableViewControllerOne.m
//  LCScrollViewController
//
//  Created by Vio on 18.03.17.
//  Copyright © 2017 LightColor. All rights reserved.
//

#import "LCTableViewControllerOne.h"

@interface LCTableViewControllerOne ()

@end

@implementation LCTableViewControllerOne
- (instancetype)initWithView:(UIView *)initialView {
    self = [super init];
    if (self) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tag = 0;
        self.tableView.frame = initialView.bounds;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellOne"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellOne"];
    }
    cell.detailTextLabel.text = @"TABLEVIEW TAG 0";
    return cell;
}

@end
