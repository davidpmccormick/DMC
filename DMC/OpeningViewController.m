//
//  OpeningViewController.m
//  DMC
//
//  Created by Freelance 2 on 19/02/2013.
//  Copyright (c) 2013 Freelance 2. All rights reserved.
//

#import "OpeningViewController.h"

@interface OpeningViewController ()

@end

@implementation OpeningViewController

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
    [_busStopInputField becomeFirstResponder];
    [self.navigationController.navigationBar setNeedsLayout];
    
    
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"satinweave.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ( sender == _goButton) {
        BusViewController *bvc = [segue destinationViewController];
        [bvc setBusStopNumber:[_busStopInputField text]];
    } else {
        OpeningViewController *ovc = self;
        InfoViewController *ivc = [segue destinationViewController];
        [ivc setParentView:ovc];
    }
}

@end
