//
//  MICarList_Model.h
//  MobIndustry_TestProject
//
//  Created by Konstantin on 06.08.2018.
//  Copyright © 2018 SKS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MICarList_Model : NSObject
@property (strong, nonatomic) NSString *car_id;
@property (strong, nonatomic) NSString *car_type;
@property (strong, nonatomic) NSString *car_model;
@property (strong, nonatomic) id car_color;
@property (strong, nonatomic) id carInverse_color;
@property (strong, nonatomic) NSString *car_NameColor;
@property (strong, nonatomic) NSString *owner_id;
@property (strong, nonatomic) NSString *owner_name;
@property (strong, nonatomic) NSString *owner_phone;

@end
