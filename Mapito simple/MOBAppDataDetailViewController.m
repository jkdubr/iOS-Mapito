//
//  MOBAppDataDetailViewController.m
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 04/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import "MOBAppDataDetailViewController.h"

#import "App.h"
#import "Item.h"

@interface MOBAppDataDetailViewController ()

@end

@implementation MOBAppDataDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.formValues = [[NSMutableDictionary alloc] init];
    [self setEditingForm:NO];
    
    NSLog(@"data %@",self.detail.o_data);
    
    NSMutableArray * temp = [[NSMutableArray alloc] init];
    for (NSMutableDictionary * t in self.detail.app.o_formConfigItems) {
        NSMutableDictionary * t1 = [NSMutableDictionary dictionaryWithDictionary:t];
        NSString *key;
        if ([t[@"name"] isKindOfClass:[NSString class]]) {
            key = t[@"name"];
        }else{
            key = [t[@"name"] stringValue];
        }
        
        if (self.detail.o_data[key] && ![self.detail.o_data[key] isKindOfClass:[NSNull class]] ) {
            t1[@"value"] = self.detail.o_data[key];
        }
        [temp addObject:t1];
    }
    
    self.formConfigItems = temp;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[[GAI sharedInstance] defaultTracker] send:[[[GAIDictionaryBuilder createAppView] set:@"App Data Detail"
                                                                                    forKey:kGAIScreenName] build]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
