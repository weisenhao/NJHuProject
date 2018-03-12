//
//  KeyboardHandleViewController.m
//  NJHuProject
//
//  Created by chrisbin on 12/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "KeyboardHandleViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

static const CGFloat topViewHeight = 60.f;

@interface KeyboardHandleViewController ()

@property (nonatomic, strong) UITextField *firstTextField;
@property (nonatomic, strong) UITextField *secondTextField;
@property (nonatomic, strong) IQKeyboardReturnKeyHandler *returnKeyHandler;

@property (nonatomic, strong) UIView *keyboardView;
@property (nonatomic, strong) UITextField *customTextField;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *bottomView;   // 自定义键盘

@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSNumber *curve;

@end

@implementation KeyboardHandleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    CGSize size = self.view.bounds.size;
    self.firstTextField.frame = CGRectMake(10, size.height - 100, size.width - 20, 30);
    [self.view addSubview:self.firstTextField];
    self.secondTextField.frame = CGRectMake(10, size.height - 50, size.width - 20, 30);
    [self.view addSubview:self.secondTextField];
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    
    self.keyboardView.frame = CGRectMake(0, size.height, size.width, topViewHeight);
    self.customTextField.frame = CGRectMake(10, 10, size.width - 70.f, 40.f);
    self.rightButton.frame = CGRectMake(size.width - 50.f, 20.f, 40.f, 20.f);
    [self.view addSubview:self.keyboardView];
    [self.keyboardView addSubview:self.customTextField];
    [self.keyboardView addSubview:self.rightButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"弹出键盘" style:UIBarButtonItemStylePlain target:self action:@selector(popKeyboard)];
    // 增加监听，当键盘出现或改变时收到消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 增加监听，当键盘退出时收到消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Target Action
- (void)photoAction {
    CGSize size = self.view.bounds.size;
    self.bottomView.frame = CGRectMake(0, 0, size.width, self.keyboardHeight);
    self.customTextField.inputView = self.customTextField.inputView ? nil : self.bottomView;
    [self.customTextField becomeFirstResponder];
}

- (void)popKeyboard {
    [self.customTextField becomeFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notice { // 获取键盘的高度
    // 键盘弹出后的frame的结构体对象
    NSValue *valueEndFrame = [[notice userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    // 得到键盘弹出后的键盘视图所在y坐标
    CGRect keyboardRect = [valueEndFrame CGRectValue];
    self.keyboardHeight = keyboardRect.size.height;
    
    CGSize size = self.view.bounds.size;
    self.keyboardView.frame = CGRectMake(0, size.height - topViewHeight, size.width, topViewHeight);
}

- (void)keyboardWillHide:(NSNotification *)notice { // 键盘退出时的操作代码
    CGSize size = self.view.bounds.size;
    self.keyboardView.frame = CGRectMake(0, size.height, size.width, topViewHeight);
}

#pragma mark - Property
- (UITextField *)firstTextField {
    if (_firstTextField == nil) {
        _firstTextField = [[UITextField alloc] init];
        _firstTextField.borderStyle = UITextBorderStyleBezel;
        _firstTextField.placeholder = @"我是占位文字";
    }
    return _firstTextField;
}

- (UITextField *)secondTextField {
    if (_secondTextField == nil) {
        _secondTextField = [[UITextField alloc] init];
        _secondTextField.borderStyle = UITextBorderStyleRoundedRect;
        _secondTextField.placeholder = @"我是占位文字";
    }
    return _secondTextField;
}

- (UIView *)keyboardView {
    if (_keyboardView == nil) {
        _keyboardView = [[UIView alloc] init];
        _keyboardView.backgroundColor = [UIColor redColor];
    }
    return _keyboardView;
}

- (UITextField *)customTextField {
    if (_customTextField == nil) {
        _customTextField = [[UITextField alloc] init];
        _customTextField.layer.borderColor = [UIColor grayColor].CGColor;
        _customTextField.layer.borderWidth = 0.5f;
        _customTextField.placeholder = @"请输入文本内容";
    }
    return _customTextField;
}

- (UIButton *)rightButton {
    if (_rightButton == nil) {
        _rightButton = [[UIButton alloc] init];
        [_rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_rightButton setTitle:@"照片" forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (UIView *)bottomView {
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor yellowColor];
    }
    return _bottomView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
