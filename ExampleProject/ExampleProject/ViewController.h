//
//  ViewController.h
//  ExampleProject
//
//  Created by Walid Hossain on 29/10/19.
//  Copyright © 2019 Walid Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpreadsheetView_ObjC/SpreadsheetView-ObjC-umbrella.h>

@interface ViewController : UIViewController <SpreadsheetViewDelegate,SpreadsheetViewDataSource>


@property (nonatomic, strong) IBOutlet SpreadsheetView   *spreadsheetView;

@end

