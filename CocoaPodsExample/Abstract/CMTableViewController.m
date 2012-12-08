//
//  CMTableViewController.m
//  CityMaps
//
//  Created by Paul Newman on 12/4/12.
//  Copyright (c) 2012 CityMaps. All rights reserved.
//

#import "CMTableViewController.h"
#import "CMFontsAndColors.h"

@interface CMTableViewController ()
{
	UITableViewStyle tableViewStyle;
}

@end

@implementation CMTableViewController


- (id)init
{
	if ((self = [super init]))
    {
		tableViewStyle = UITableViewStylePlain;
	}
	
	return self;
}

- (id)initWithTableStyle:(UITableViewStyle)style
{
    //NSLog(@"tableviewstyle: %@", style == UITableViewStyleGrouped ? @"grouped" : @"plain");
    
	if ((self = [super init]))
    {
		tableViewStyle = style;
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    // ensure navbar will be visible
    //[[self navigationController] setNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self layoutSubviews];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// NOTE: Only use this class with nibless view controllers
- (void)loadView
{
	[super loadView];
	
	if (!self.tableView)
    {
		self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:tableViewStyle];
		[self.tableView setDelegate:self];
		[self.tableView setDataSource:self];
        self.tableView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
                
        // This works
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 170)];
        //bg.backgroundColor = [UIColor redColor];
        bg.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"assets/images/temp/bg-dummy.png"]];
        self.tableView.backgroundView = bg;

		[[self view] addSubview:self.tableView];
	}
}

- (void)layoutSubviews
{
	CGRect selfFrame = [[self view] bounds];
    
    [self.tableView setFrame:selfFrame];
}

#pragma mark - UITableViewDelegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (!self.dataProvider || self.dataProvider.count == 0)
    {
		return 0;
	}
    
	id object = self.dataProvider[section];
	
	if ([object isKindOfClass:[NSArray class]])
    {
		return [object count];
	}
	else
    {
		return self.dataProvider.count;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return self.sections[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.sections && self.sections.count > 0 ? self.sections.count : 1;
}

#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Abstract
	
	[NSException raise:@"No Implementation"
				format:@"tableView:cellForRowAtIndexPath: must be defined in your subclass."];
    
	return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Abstract
    
	[NSException raise:@"No Implementation"
				format:@"tableView:heightForRowAtIndexPath: must be defined in your subclass."];
	
	return 0.0f;
}

- (UIView *)headerViewWithTitle:(NSString *)title
{
 	// create the parent view that will hold header Label
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(12.0, 5.0, 300.0, 30.0)];
	
	UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	headerLabel.font = [UIFont fontWithName:kCMFontsAndColors_HelveticaNeueFont size:14.0];
	headerLabel.frame = headerView.frame;
	headerLabel.text = title;
	[headerView addSubview:headerLabel];
    
	return headerView;
}

@end
