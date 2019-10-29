//
//  ViewController.m
//  ExampleProject
//
//  Created by Walid Hossain on 29/10/19.
//  Copyright © 2019 Walid Hossain. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.spreadsheetView = [[SpreadsheetView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.spreadsheetView];
    
    self.spreadsheetView.backgroundColor = UIColor.clearColor;
    UIView* backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = UIColor.clearColor;
    self.spreadsheetView.backgroundView = backgroundView;
    self.spreadsheetView.overlayView.backgroundColor = UIColor.clearColor;
    
    self.spreadsheetView.delegate = self;
    self.spreadsheetView.dataSource = self;
    self.spreadsheetView.bounces = NO;
    self.spreadsheetView->circularScrollingOptions.direction = 0;
    self.spreadsheetView->circularScrollingOptions.tableStyle = 0;
    self.spreadsheetView->circularScrollingOptions.headerStyle = 0;
    
    self.spreadsheetView.gridStyle = [[GridStyle alloc] initWithWidth:1.0 color:UIColor.blackColor];
    
    [self.spreadsheetView registerCellClass:[Cell class] forCellWithReuseIdentifier:@"DemoCell"];
}

#pragma mark - SpreadsheetViewDataSource

-(NSUInteger)numberOfColumnsInSpreadsheetView:(SpreadsheetView *)spreadsheetView{
    return 100;
}

-(NSUInteger)numberOfRowsInSpreadsheetView:(SpreadsheetView *)spreadsheetView{
    return 100;
}

-(CGFloat)spreadsheetView:(SpreadsheetView *)spreadsheetView widthForColumn:(NSUInteger)column{
    return 80.0f;
}

-(CGFloat)spreadsheetView:(SpreadsheetView *)spreadsheetView heightForRow:(NSUInteger)row{
    return 40.0f;
}

-(Cell *)spreadsheetView:(SpreadsheetView *)spreadsheetView cellForItemAt:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"DemoCell";
    Cell *cell = [spreadsheetView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = UIColor.lightGrayColor;
    return cell;
}





-(NSArray *)mergedCellsInSpreadsheetView:(SpreadsheetView *)spreadsheetView
{
    return nil;
}

-(NSUInteger)frozenColumnsInSpreadsheetView:(SpreadsheetView *)spreadsheetView{
    return 0;
}

-(NSUInteger)frozenRowsInSpreadsheetView:(SpreadsheetView *)spreadsheetView{
    return 0;
}


@end
