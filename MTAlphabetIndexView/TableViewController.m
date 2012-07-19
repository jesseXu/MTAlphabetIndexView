//
//  TableViewController.m
//  MTAlphabetIndexView
//
//  Created by jesse on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TableViewController.h"
#import "MTAlphabetIndexView.h"

@interface TableViewController ()<MTAlphabetIndexViewDelegate>

@property (nonatomic, retain) NSArray *dataArray;

@end

@implementation TableViewController

@synthesize dataArray = _dataArray;

- (void)dealloc
{
    [_dataArray release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

        
        //fake data for test
        NSMutableArray *dataArray = [NSMutableArray array];
        for (int i = 0; i < 26; i++)
        { 
            if (rand() % 10 > 1)
            {
                NSMutableArray *rowArray = [NSMutableArray array];
                for (int j = 0; j < rand()%5 + 5; j ++)
                {
                    [rowArray addObject:[NSString stringWithFormat:@"%c%d", 'A' + i, rand()%100]];
                }

                [dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSString stringWithFormat:@"%c", 'A' + i], @"title",
                                      rowArray, @"rowArray", nil]];
            }
                
        }
        
        self.dataArray = dataArray;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSDictionary *dict = [self.dataArray objectAtIndex:section];
    return [[dict objectForKey:@"rowArray"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSArray *rowArray = [[self.dataArray objectAtIndex:[indexPath section]] objectForKey:@"rowArray"];
    cell.textLabel.text = [rowArray objectAtIndex:[indexPath row]];
    
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSDictionary *dict = [self.dataArray objectAtIndex:section];
//    return [dict objectForKey:@"title"];
//}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = [self.dataArray objectAtIndex:section];

    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor lightGrayColor];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10.0f, 0, 0);
    button.tag = section;
    [button addTarget:self action:@selector(sectionDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:[dict objectForKey:@"title"] forState:UIControlStateNormal];
    
    return [button autorelease];
}


#pragma mark - 

- (void)sectionDidClick:(id)sender
{
    MTAlphabetIndexView *indexView = [[MTAlphabetIndexView alloc] initWithFrame:self.view.bounds];
    indexView.delegate = self;
    for (NSDictionary *dict in self.dataArray)
    {
        NSString *title = [dict objectForKey:@"title"];
        [indexView setIndex:[title characterAtIndex:0] - 'A' + 1 enabled:YES];
    }
    
    [self.view addSubview:indexView];
    [indexView release];
    
    [indexView show];
}


#pragma mark - MTAlphabetIndexView delegate

- (void)alphabetIndexView:(MTAlphabetIndexView *)indexView alphabetDidSelect:(NSInteger)index
{
    NSString *selectAlphabet = [indexView alphabetAtIndex:index];
    
    for (int i = 0; i < self.dataArray.count; i++)
    {
        NSDictionary *dict = [self.dataArray objectAtIndex:i];
        if ([selectAlphabet isEqualToString:[dict objectForKey:@"title"]])
        {
            NSIndexPath *targetPath = [NSIndexPath indexPathForRow:0 inSection:i];
            [self.tableView scrollToRowAtIndexPath:targetPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            break;
        }
    }
}

@end
