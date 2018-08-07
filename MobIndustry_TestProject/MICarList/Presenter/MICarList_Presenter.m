//
//  MICarList_Presenter.m
//  MobIndustry_TestProject
//
//  Created by Konstantin on 06.08.2018.
//  Copyright © 2018 SKS. All rights reserved.
//

#import "MICarList_Presenter.h"
#import "MICarList_VC.h"
#import "MICarList_Model.h"
#import <Realm/Realm.h>
#import "MICarList_DBAModel.h"

@interface MICarList_Presenter()
@property (strong, nonatomic) MICarList_VC *carListView;
@property RLMResults *realmArray;
@end

@implementation MICarList_Presenter

-(void)initWithView:(id)view
{
    _carListView = view;
    self.realmArray = [MICarList_DBAModel allObjects];
}

-(void)refreshTabelViewDataFromServer
{
    [self getData];
}

-(void)refreshTabelViewDataFromDBA
{
    [self getDataFromDBA];
}

- (void)getData
{
    NSArray *carsArray = [self getDataFromJSON];
    NSMutableArray *carsInfo = [NSMutableArray new];
    for (NSDictionary *car in carsArray)
    {
        MICarList_Model *model = [MICarList_Model new];
        model.car_id = [NSString stringWithFormat:@"%@",car[@"car_id"]];
        model.car_type = car[@"car_type"];
        model.car_model = car[@"car_model"];
        model.car_NameColor = car[@"car_color"];
        model.car_color = [NSString stringWithFormat:@"%@Color",car[@"car_color"]];
        NSArray *owners = car[@"owners"];
        NSDictionary *ownerDict = owners.firstObject;
        model.owner_id = [NSString stringWithFormat:@"%@",ownerDict[@"owner_id"]];
        model.owner_name = ownerDict[@"owner_name"];
        model.owner_phone = ownerDict[@"owner_phone"];
        [carsInfo addObject:model];
    }
    [self saveDataToDBA:carsInfo];
    [_carListView updateViewWithData:carsInfo];
}

-(void)saveDataToDBA:(NSArray *)array
{
    if(self.realmArray.count<array.count)
    {
        for (MICarList_Model *model in array)
        {
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            MICarList_DBAModel *favNewsDBA = [[MICarList_DBAModel alloc] init];
            favNewsDBA.car_id = model.car_id;
            favNewsDBA.car_type =  model.car_type;
            favNewsDBA.car_model =  [NSString stringWithFormat:@"%@ Realm",model.car_model];
            favNewsDBA.car_NameColor =  model.car_NameColor;
            favNewsDBA.car_color =  model.car_color;
            favNewsDBA.owner_id = model.owner_id;
            favNewsDBA.owner_name =  model.owner_name;
            favNewsDBA.owner_phone =  model.owner_phone;
            [realm addObject:favNewsDBA];
            [realm commitWriteTransaction];
        }
    }
}

-(void)getDataFromDBA
{
    NSMutableArray *carsInfo = [NSMutableArray new];
    for (MICarList_DBAModel *realmModel in self.realmArray)
    {
        MICarList_Model *model = [MICarList_Model new];
        model.car_id = realmModel.car_id;
        model.car_type =  realmModel.car_type;
        model.car_model =  realmModel.car_model;
        model.car_NameColor =  realmModel.car_NameColor;
        model.car_color =  realmModel.car_color;
        model.owner_id = realmModel.owner_id;
        model.owner_name =  realmModel.owner_name;
        model.owner_phone =  realmModel.owner_phone;
        [carsInfo addObject:model];
    }
    [_carListView updateViewWithData:carsInfo];
}

-(NSString *)getTaskInfo
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TestTask" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    return content;
}

- (NSArray *)getDataFromJSON
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cars" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}


-(UIColor *)giveColorFromStringColor:(NSString *)colorname
{
    SEL labelColor = NSSelectorFromString(colorname);
    UIColor *color = [UIColor performSelector:labelColor];
    return color;
}

-(UIColor *)giveInverseColorFromStringColor:(NSString *)colorname
{
    SEL labelColor = NSSelectorFromString(colorname);
    UIColor *color = [UIColor performSelector:labelColor];
    
   CGColorRef colorRef = [color CGColor];
    int _countComponents = (int)CGColorGetNumberOfComponents(colorRef);
    
    if (_countComponents == 4) {
        const CGFloat *_components = CGColorGetComponents(colorRef);
        CGFloat red = _components[0];
        CGFloat green = _components[1];
        CGFloat blue = _components[2];
        CGFloat alpha = _components[3];
        
        UIColor *newColor = [[UIColor alloc] initWithRed:(1.0 - red)
                                                   green:(1.0 - green)
                                                    blue:(1.0 - blue)
                                                   alpha:alpha];
          return newColor;
    }
    else if (_countComponents == 2)
    {
        const CGFloat *_components = CGColorGetComponents(colorRef);
        CGFloat red = _components[0];
        CGFloat green = _components[1];
        CGFloat blue = 0;
        CGFloat alpha = 1;
        
        UIColor *newColor = [[UIColor alloc] initWithRed:(1.0 - red)
                                                   green:(1.0 - green)
                                                    blue:(1.0 - blue)
                                                   alpha:alpha];
        return newColor;
    }
    return color;
}

@end
