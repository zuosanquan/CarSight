//
//  CellFrame.m
//  CrazyCar
//
//  Created by Edward on 16/2/29.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "CellFrame.h"
#import "EBHotNewModel.h"
@implementation CellFrame

- (void)setModel:(EBHotNewModel *)model{
    _model = model;
    if (model.type == 3) {
        if ([model.picCover containsString:@";"]) {
            self.cellHeight = kHotNewCellHeight;
        }else{
            self.cellHeight = 3 * kHotNewCellNormalHeight;
        }
        
    }else{
        self.cellHeight = kHotNewCellNormalHeight;
    }
}

@end
