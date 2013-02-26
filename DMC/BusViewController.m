//
//  BusViewController.m
//  DMC
//
//  Created by Freelance 2 on 19/02/2013.
//  Copyright (c) 2013 Freelance 2. All rights reserved.
//

#import "BusViewController.h"

@interface BusViewController ()

@end

@implementation BusViewController

NSArray *busArray;
NSArray *busStrings;
NSString *theTime;
NSMutableArray *busObjectsArray;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)busesAtStopNumber {
    NSString *busString1 = @"http://countdown.api.tfl.gov.uk/interfaces/ura/instant_V1?StopCode1=";
    NSString *busString2 = [busString1 stringByAppendingString:[self busStopNumber]];
    NSString *busString3 = [busString2 stringByAppendingString:@"&ReturnList=EstimatedTime,LineID,StopPointName"];
    NSURL *busDataURL = [NSURL URLWithString:busString3];
    
    NSString *busDataString = [[NSString alloc]initWithContentsOfURL:busDataURL encoding:NSUTF8StringEncoding error:nil];
    
    
    busArray = [busDataString componentsSeparatedByString:@"["];
    
    busObjectsArray = [[NSMutableArray alloc]init];
    Bus *aBus = [[Bus alloc]init];
    
    if (!busArray) {
        NSLog(@"%@ is not a valid bus stop number",_busStopNumber);
    } else {
        int counter = 0;
        for (NSString *bus in busArray) {
            busStrings = [bus componentsSeparatedByString:@","];
            if (counter == 1) { // first item contains bus stop info
                NSLog(@"URA version response type is %@",[busStrings objectAtIndex:0]); // 4
            }
            if (counter > 1) { // remaining items are buses
                if (counter == 2) { // only set navbar title once
                    NSString *stopNameInQuotes = [busStrings objectAtIndex:1];
                    // strip the quotes off the stop title
                    NSString *stopName = [stopNameInQuotes stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    self.navigationItem.title = stopName;
                }
                float secondsSince1970 = ([[busStrings objectAtIndex:3] floatValue]/1000);
                NSString *theNumberInQuotes = [busStrings objectAtIndex:2];
                // strip the quotes off the bus number
                NSString *theNumber = [theNumberInQuotes stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"h:mm a"];
                NSString *theTime = [NSString stringWithFormat:@"%@",
                                         [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:secondsSince1970]]];
                
                [aBus setBusNumber:theNumber];
                [aBus setBusTime:theTime];
                [busObjectsArray addObject:aBus];
                // alloc and init another Bus to reuse 'aBus' pointer
                aBus = [[Bus alloc]init];
                
            }
            counter ++;
        }
    }
}

-(void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];

    
    [self busesAtStopNumber];
    
    [self.tableView reloadData];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
                                 [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    
    
    [refresh endRefreshing];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl addTarget:self
                        action:@selector(refreshView:)
                        forControlEvents:UIControlEventValueChanged];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"satinweave.png"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self busesAtStopNumber];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return ([busObjectsArray count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"busCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Bus *currentBus = [busObjectsArray objectAtIndex:indexPath.row];
    UILabel *busNumberLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *busTimeLabel = (UILabel *)[cell viewWithTag:101];
    [busNumberLabel setText:[currentBus busNumber]];
    [busTimeLabel setText:[currentBus busTime]];
    
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    
    return cell;
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cellbg.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cellbg.png"];
    } else {
        background = [UIImage imageNamed:@"cellbg.png"];
    }
    
    return background;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
