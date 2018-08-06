//
//  MICarList_VC.m
//  MobIndustry_TestProject
//
//  Created by Konstantin on 06.08.2018.
//  Copyright © 2018 SKS. All rights reserved.
//

#import "MICarList_VC.h"
#import "MICarListTVCell.h"
#import "MICarList_Presenter.h"
#import "MICarList_Model.h"

static int const HeaderTag = 111;
static int const HeaderHeight = 50;
static int const CellHeight = 130;
static NSString* const ArrowName = @"arrow";

@interface MICarList_VC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) MICarList_Presenter *presenter;
@property (strong, nonatomic) NSMutableArray *carsName;
@property (strong, nonatomic) NSMutableArray *carsInfo;
@property (assign) NSInteger expandedSectionHeaderNumber;
@property (assign) UITableViewHeaderFooterView *expandedSectionHeader;
@end

@implementation MICarList_VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.textView.hidden = YES;
    self.expandedSectionHeaderNumber = -1;
    
    _presenter = [MICarList_Presenter new];
    [_presenter initWithView:self];
    [_presenter getData];
}

- (IBAction)refreshDataFromServer:(id)sender
{
    [self refreshTabelView];
    [_presenter refreshTabelViewDataFromServer];
}

- (IBAction)fetchDataFromDBA:(id)sender
{
    [self refreshTabelView];
    [_presenter refreshTabelViewDataFromDBA];
}

- (IBAction)getTaskInfo:(id)sender
{
    self.textView.text = [_presenter getTaskInfo];
    [self infoShow];
}

-(void)infoShow
{
    if(self.textView.isHidden)
    {
        self.textView.hidden = NO;
    }
    else
    {
        self.textView.hidden = YES;
    }
}

-(void)updateViewWithData:(NSDictionary *)dataDict
{
    self.carsName = dataDict[@"carsName"];
    self.carsInfo = dataDict[@"carsInfo"];
    [self.tableView reloadData];
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.carsName.count > 0)
    {
        return [self.carsName count];
    }
    else
    {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.expandedSectionHeaderNumber == section)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(self.carsName.count)
    {
        return [self.carsName objectAtIndex:section];
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HeaderHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [UIColor colorWithRed:0.25 green:0.78 blue:0.96 alpha:1.0];
    header.textLabel.textColor = [UIColor whiteColor];
    UIImageView *viewWithTag = [self.view viewWithTag:HeaderTag + section];
    if (viewWithTag)
    {
        [viewWithTag removeFromSuperview];
    }
    CGSize headerFrame = self.view.frame.size;
    UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(headerFrame.width - 32, 13, 18, 18)];
    theImageView.image = [UIImage imageNamed:ArrowName];
    theImageView.tag = HeaderTag + section;
    [header addSubview:theImageView];
    header.tag = section;
    UITapGestureRecognizer *headerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderWasTouched:)];
    [header addGestureRecognizer:headerTapGesture];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MICarListTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MICarListTVCellID" forIndexPath:indexPath];
    MICarList_Model *model = [self.carsInfo objectAtIndex:indexPath.section];
    cell.carName.text = model.car_model;
    cell.carDescription.text = model.car_type;
    cell.carDriver.text = model.owner_name;
    cell.carDriverPhone.text = model.owner_phone;
    cell.colorName.textColor = model.carInverse_color;
    cell.colorName.text = model.car_NameColor;
    cell.colorView.layer.cornerRadius = 40;
    cell.colorView.layer.borderColor = cell.colorName.textColor.CGColor;
    cell.colorView.layer.borderWidth = 2.0f;
    cell.colorView.clipsToBounds = YES;
    cell.colorView.backgroundColor = model.car_color;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)updateTableViewRowDisplay:(NSArray *)arrayOfIndexPaths
{
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

-(void)refreshTabelView
{
    self.expandedSectionHeaderNumber = -1;
    [self.carsInfo removeAllObjects];
    [self.carsName removeAllObjects];
}

#pragma mark - Expand/Collapse

- (void)sectionHeaderWasTouched:(UITapGestureRecognizer *)sender
{
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)sender.view;
    NSInteger section = headerView.tag;
    UIImageView *eImageView = (UIImageView *)[headerView viewWithTag:HeaderTag + section];
    self.expandedSectionHeader = headerView;
    
    if(self.expandedSectionHeaderNumber == -1)
    {
        self.expandedSectionHeaderNumber = section;
        [self tableViewExpandSection:section withImage: eImageView];
    }
    else
    {
        if (self.expandedSectionHeaderNumber == section)
        {
            [self tableViewCollapeSection:section withImage: eImageView];
            self.expandedSectionHeader = nil;
        }
        else
        {
            UIImageView *cImageView  = (UIImageView *)[self.view viewWithTag:HeaderTag + self.expandedSectionHeaderNumber];
            [self tableViewCollapeSection:self.expandedSectionHeaderNumber withImage: cImageView];
            [self tableViewExpandSection:section withImage: eImageView];
        }
    }
}

- (void)tableViewCollapeSection:(NSInteger)section withImage:(UIImageView *)imageView
{
    self.expandedSectionHeaderNumber = -1;
    [UIView animateWithDuration:0.4 animations:^{
        imageView.transform = CGAffineTransformMakeRotation((0.0 * M_PI) / 180.0);
    }];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)tableViewExpandSection:(NSInteger)section withImage:(UIImageView *)imageView
{
    [UIView animateWithDuration:0.4 animations:^{
        imageView.transform = CGAffineTransformMakeRotation((180.0 * M_PI) / 180.0);
    }];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    self.expandedSectionHeaderNumber = section;
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

@end
