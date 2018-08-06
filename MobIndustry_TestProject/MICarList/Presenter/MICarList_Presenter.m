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

@interface MICarList_Presenter()
@property (strong, nonatomic) MICarList_VC *carListView;
@end

@implementation MICarList_Presenter

-(void)initWithView:(id)view
{
    _carListView = view;
}

- (void)getData
{
    NSArray *carsArray = [self getDataFromJSON];
    NSMutableArray *carsName = [NSMutableArray new];
    NSMutableArray *carsInfo = [NSMutableArray new];
    NSMutableDictionary *data = [NSMutableDictionary new];
    for (NSDictionary *car in carsArray)
    {
        MICarList_Model *model = [MICarList_Model new];
        model.car_id = car[@"car_id"];
        model.car_type = car[@"car_type"];
        model.car_model = car[@"car_model"];
        model.car_NameColor = car[@"car_color"];
        model.car_color = [self giveColorFromStringColor:[NSString stringWithFormat:@"%@Color",car[@"car_color"]]];
        model.carInverse_color = [self giveInverseColorFromStringColor:[NSString stringWithFormat:@"%@Color",car[@"car_color"]]];
        NSArray *owners = car[@"owners"];
        NSDictionary *ownerDict = owners.firstObject;
        model.owner_id = ownerDict[@"owner_id"];
        model.owner_name = ownerDict[@"owner_name"];
        model.owner_phone = ownerDict[@"owner_phone"];
        [carsName addObject:car[@"car_model"]];
        [carsInfo addObject:model];
    }
    [data setObject:carsName forKey:@"carsName"];
    [data setObject:carsInfo forKey:@"carsInfo"];
    [self saveDataToDBA:data];
    [_carListView updateViewWithData:data];
}

-(void)refreshTabelViewDataFromServer
{
    [self getData];
}

-(void)refreshTabelViewDataFromDBA
{
    
}

-(void)saveDataToDBA:(NSDictionary *)dict
{
    
}

-(NSString *)getTaskInfo
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TestTask" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    return content;
}

-(NSDictionary *)getDataFromDBA
{
    NSMutableDictionary *data = [NSMutableDictionary new];
    return data;
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
    int _countComponents = CGColorGetNumberOfComponents(colorRef);
    
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
