//
//  EBModifyNickName.m
//  CrazyCar
//
//  Created by Edward on 16/3/7.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBModifyNickName.h"

@interface EBModifyNickName()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nickNameField;

@end

@implementation EBModifyNickName

- (void)viewDidLoad{
    [super viewDidLoad];
    CGFloat marginW = 10;
    self.nickNameField = [[UITextField alloc] initWithFrame:CGRectMake(marginW, 10, WIDTH - 2 * marginW, 40)];
    self.nickNameField.text = self.nickName;
    self.nickNameField.borderStyle = UITextBorderStyleRoundedRect;
    self.nickNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.nickNameField addTarget:self action:@selector(textFieldValueChang:) forControlEvents:UIControlEventEditingChanged];
//    self.nickNameField.delegate = self;
    [self.view addSubview:self.nickNameField];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nickNameField.frame), CGRectGetMaxY(self.nickNameField.frame) + 5, CGRectGetWidth(self.nickNameField.frame), CGRectGetHeight(self.nickNameField.frame))];
    label.text = @"昵称为1-10个汉字,支持中英文、数字";
    label.font = [UIFont headViewSmallFont];
    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont headViewNormalTextFont];
    [saveButton addTarget:self action:@selector(saveNickName:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    
}

- (void)saveNickName:(UIButton *)button{
    if (self.nickNameField.text.length == 0) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"" message:@"温馨提示" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:0 handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alter addAction:action];
        [self presentViewController:alter animated:YES completion:nil];
    }else{
        self.nickName = self.nickNameField.text;
        if ([self.modifyDelegate conformsToProtocol:@protocol(EBModifyNickNameDelegate) ]) {
            [self.modifyDelegate modifyNickNameSuccess:self andNickName:self.nickName];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)textFieldValueChang:(UITextField *)textField{
    if (textField.text.length > 10) {
        textField.text = [textField.text substringToIndex:10];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.nickNameField resignFirstResponder];
}

@end
