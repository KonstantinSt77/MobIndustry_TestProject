//
//  MICarList_DBAModel.h
//  MobIndustry_TestProject
//
//  Created by Kostya on 07.08.2018.
//  Copyright © 2018 SKS. All rights reserved.
//

#import "RLMArray.h"
#import <Realm/Realm.h>
#import "MICarList_Model.h"
#import <UIKit/UIKit.h>

@interface MICarList_DBAModel : RLMObject
@property (strong, nonatomic) NSString *car_id;
@property (strong, nonatomic) NSString *car_type;
@property (strong, nonatomic) NSString *car_model;
@property (strong, nonatomic) NSString *car_color;
@property (strong, nonatomic) NSString *car_NameColor;
@property (strong, nonatomic) NSString *owner_id;
@property (strong, nonatomic) NSString *owner_name;
@property (strong, nonatomic) NSString *owner_phone;
@end
