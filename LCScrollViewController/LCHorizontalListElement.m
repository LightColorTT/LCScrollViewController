//
//  LCHorizontalListElement.m
//  LCHorizontalScrollView
//
//  Created by Vio on 16.03.17.
//  Copyright © 2017 LightColor. All rights reserved.
//

#import "LCHorizontalListElement.h"

static NSInteger const kDefaultOffset = 30;
static NSInteger const kDefaultOffsetButton = 61;

@interface LCHorizontalListElement () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation LCHorizontalListElement

- (id)init {
    if (self) {
        self.selectedIndexNow = self.selectedButtonIndex;
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.bounces = NO;
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.pagingEnabled = NO;
        _contentView = [UIView new];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _buttons = [NSMutableArray array];
        _scrollView.delegate = self;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.scrollView removeConstraints:self.scrollView.constraints];
        [self.contentView removeConstraints:self.scrollView.constraints];
        [self.scrollView setNeedsLayout];
        [self.contentView setNeedsLayout];
        [self addSubview:_scrollView];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_scrollView]|"
                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_scrollView)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_scrollView]|"
                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_scrollView)]];
        [self.scrollView setNeedsLayout];
        [_scrollView addSubview:_contentView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:0.0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:0.0]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|"
                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_contentView)]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|"
                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_contentView)]];
        
        [self.contentView setNeedsLayout];
    }
    return self;
}


- (void)restructuring {
    NSInteger indexSelectButton = self.selectedButtonIndex;
    for(int i = 0; i < self.buttons.count; i++){
        if([self.buttons[i] frame].origin.x - kDefaultOffset < (self.scrollView.contentOffset.x + self.frame.size.width/2) &&
           (self.scrollView.contentOffset.x + self.frame.size.width/2) < ([self.buttons[i] frame].origin.x + [self.buttons[i] frame].size.width + kDefaultOffset)) {
            indexSelectButton = i;
        }
        
    }
    if (indexSelectButton < 0){
        indexSelectButton = 0;
    }
    if (indexSelectButton >= [self.buttons count]) {
        indexSelectButton = (NSInteger)[self.buttons count] - 1;
    }
    
    [self selectedButtonFirstClick:indexSelectButton];
    
}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self restructuring];
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self restructuring];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (!self.scrollView.isDragging){
        self.selectedIndexNow = self.selectedButtonIndex;
        if ([self.delegate respondsToSelector:@selector(selectionList:getSelectedIndexButton:)]) {
            [self.delegate selectionList:self getSelectedIndexButton:self.selectedIndexNow];
        }
    }
}

-(void) buttonClick {
    if ([self.delegate respondsToSelector:@selector(selectionList:getSelectedIndexButton:)]) {
        [self.delegate selectionList:self getSelectedIndexButton:self.selectedIndexNow];
    }
}


- (void)reloadData {
    for (UIButton *button in self.buttons) {
        [button removeFromSuperview];
    }
    [self.buttons removeAllObjects];
    NSInteger totalButtons = [self.dataSource numberOfItemsInSelectionList:self];
    
    if (totalButtons < 1) {
        return;
    }
    NSInteger n = 0;
    UIButton *previousButton;
    for (NSInteger index = 0; index < totalButtons; index++) {
        NSString *buttonTitle = [self.dataSource selectionList:self titleForItemWithIndex:index];
        
        UIButton *button = [self selectionListButtonWithTitle:buttonTitle];
        [self.contentView addSubview:button];
        [self.contentView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:button
                                         attribute:NSLayoutAttributeCenterY
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                         attribute:NSLayoutAttributeCenterY
                                         multiplier:1.0
                                         constant:0.0]];
        if (previousButton) {
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousButton]-padding-[button]"
                                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                     metrics:@{@"padding" : @(kDefaultOffsetButton)}
                                                                                       views:NSDictionaryOfVariableBindings(previousButton, button)]];
        } else {
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[button]"
                                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                     metrics:@{@"margin" : @(self.frame.size.width/2-button.frame.size.width/2+1)}
                                                                                       views:NSDictionaryOfVariableBindings(button)]];
            
            
        }
        previousButton = button;
        [self.buttons addObject:button];
    }
    
    n = previousButton.frame.size.width/2;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousButton]-margin-|"
                                                                             options:NSLayoutFormatDirectionLeadingToTrailing
                                                                             metrics:@{@"margin" : @(self.frame.size.width/2-n+1)}
                                                                               views:NSDictionaryOfVariableBindings(previousButton)]];
    [self selectedButtonFirstClick:self.selectedButtonIndex];
}

- (void)redrawButton{
    
    UIButton *previousButton;
    NSInteger n;
    for (NSInteger index = 0; index < self.buttons.count; index++) {
        UIButton *button = self.buttons[index];
        [self.contentView addConstraint:[NSLayoutConstraint
                                         constraintWithItem:button
                                         attribute:NSLayoutAttributeCenterY
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self.contentView
                                         attribute:NSLayoutAttributeCenterY
                                         multiplier:1.0
                                         constant:0.0]];
        [self.contentView addSubview:button];
        if (previousButton) {
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousButton]-padding-[button]"
                                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                     metrics:@{@"padding" : @(60)}
                                                                                       views:NSDictionaryOfVariableBindings(previousButton, button)]];
        } else {
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-margin-[button]"
                                                                                     options:NSLayoutFormatDirectionLeadingToTrailing
                                                                                     metrics:@{@"margin" : @(self.frame.size.width/2-button.frame.size.width/2+1)}
                                                                                       views:NSDictionaryOfVariableBindings(button)]];
            
        }
        previousButton = button;
        [self.buttons addObject:button];
    }
    
    n = previousButton.frame.size.width/2;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousButton]-margin-|"
                                                                             options:NSLayoutFormatDirectionLeadingToTrailing
                                                                             metrics:@{@"margin" : @(self.frame.size.width/2-n+1)}
                                                                               views:NSDictionaryOfVariableBindings(previousButton)]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.buttons.count) {
        [self reloadData];
    }
}

- (UIButton *)selectionListButtonWithTitle:(NSString *)buttonTitle {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonWasTapped:) forControlEvents:UIControlEventTouchDown];  //click on button
    button.translatesAutoresizingMaskIntoConstraints = NO; // placing button on the view
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor colorWithRed:165.0f/255.0f
                                          green:169.0f/255.0f
                                           blue:180.0f/255.0f
                                          alpha:1.0f] forState:UIControlStateNormal];
    return button;
}


- (void)selectedButtonFirstClick:(NSInteger)index {
    [self.buttons[index] sendActionsForControlEvents:UIControlEventTouchDown];
}

- (IBAction)buttonWasTapped:(id)sender {
    UIButton *oldSelectButton = self.buttons[self.selectedButtonIndex];
    UIButton *newSelectButton = (UIButton*)sender;
    NSInteger index = [self.buttons indexOfObject:sender];
    [self layoutIfNeeded];
    [oldSelectButton setTitleColor:[UIColor colorWithRed:165.0f/255.0f
                                                   green:169.0f/255.0f
                                                    blue:180.0f/255.0f
                                                   alpha:1.0f] forState:UIControlStateNormal];
    [newSelectButton setTitleColor:[UIColor colorWithRed:38.0f/255.0f
                                                   green:42.0f/255.0f
                                                    blue:49.0f/255.0f
                                                   alpha:1.0f] forState:UIControlStateNormal];
    self.selectedButtonIndex = index;
    
    [self.scrollView scrollRectToVisible:CGRectInset(newSelectButton.frame, -self.frame.size.width/2 + newSelectButton.frame.size.width/2, 0)animated:YES];
    if ([self.delegate respondsToSelector:@selector(selectionList:didSelectButtonWithIndex:)]) {  //change label in view
        [self.delegate selectionList:self didSelectButtonWithIndex:index];
    }
}


@end
