//
//  InfoViewController.m
//  DMC
//
//  Created by David McCormick on 21/02/2013.
//  Copyright (c) 2013 Freelance 2. All rights reserved.
//

#import "InfoViewController.h"
#import "OpeningViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"linedpaper.png"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    // redisplay keyboard
    [[self.parentView busStopInputField] becomeFirstResponder];
}


@end
