//
//  EBPictureModel.h
//  CrazyCar
//
//  Created by Edward on 16/3/9.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EBRequestStatusModel,EBPictureGroup,EBImagesModel;

@interface EBPictureModel : NSObject

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) EBRequestStatusModel *data;

@property (nonatomic, assign) NSInteger status;

@end

@interface EBRequestStatusModel : NSObject

@property (nonatomic, strong) NSArray<EBPictureGroup *> *list;

@end

@interface EBPictureGroup : NSObject

@property (nonatomic, assign) NSInteger PositionID;

@property (nonatomic, strong) NSArray<EBImagesModel *> *Images;

@property (nonatomic, assign) NSInteger Count;

@property (nonatomic, copy) NSString *PositionName;

@end

@interface EBImagesModel : NSObject

@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, assign) NSInteger carID;

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, assign) NSInteger imageID;

@end

