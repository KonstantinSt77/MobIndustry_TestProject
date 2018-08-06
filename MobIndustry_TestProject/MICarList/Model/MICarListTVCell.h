//
//  MICarListTVCell.h
//  MobIndustry_TestProject
//
//  Created by Konstantin on 06.08.2018.
//  Copyright © 2018 SKS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MICarListTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *colorName;
@property (weak, nonatomic) IBOutlet UILabel *carName;
@property (weak, nonatomic) IBOutlet UILabel *carDescription;
@property (weak, nonatomic) IBOutlet UILabel *carDriver;
@property (weak, nonatomic) IBOutlet UILabel *carDriverPhone;
@end
