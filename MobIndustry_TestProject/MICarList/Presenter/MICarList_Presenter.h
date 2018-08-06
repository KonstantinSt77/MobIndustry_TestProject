//
//  MICarList_Presenter.h
//  MobIndustry_TestProject
//
//  Created by Konstantin on 06.08.2018.
//  Copyright © 2018 SKS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MICarList_Presenter : NSObject
-(void)initWithView:(id)view;
-(void)getData;
-(void)refreshTabelViewDataFromServer;
-(void)refreshTabelViewDataFromDBA;
@end
