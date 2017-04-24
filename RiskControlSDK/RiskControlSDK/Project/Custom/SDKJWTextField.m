//
//  SDKJWTextField.m
//  SDKJWTextField
//
//  Created by 梁家文 on 16/6/11.
//  Copyright © 2016年 梁家文. All rights reserved.
//

#define TextRule @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

#import "SDKJWTextField.h"
#import "SDKProjectHeader.h"
@interface SDKJWTextField()<UITextFieldDelegate>

@property (nonatomic, strong) NSString *tempText;
@property (nonatomic, assign) NSRange tempRange;
@property (nonatomic, strong) NSString *tempString;


@end

@implementation SDKJWTextField


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.max = @"99999999.99";
        self.maxLength = 7;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self];
    }
    return self;

}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return false;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.importStyle == TextFieldImportStyleNormal) {
        
    }else if (self.importStyle == TextFieldImportStyleNumber){
        return [self validateNumber:textField.text Range:range replacementString:string];
    }else if (self.importStyle == TextFieldImportStylePassword){
        
    }else if (self.importStyle == TextFieldImportStyleMoney){
        return [self validateMoney:textField Range:range replacementString:string];
    }else if (self.importStyle == TextFieldImportStyleMinMoney){
        return [self validateMinMoney:textField Range:range replacementString:string];
    }else if (self.importStyle == TextFieldImportStyleRightfulMoney){
        return [self validateRightfulMoney:textField Range:range replacementString:string];
    }else if (self.importStyle == TextFieldImportStyleNumberTwo){
        return [self validateNumberTwo:textField.text Range:range replacementString:string];
    }else if (self.importStyle == TextFieldImportStyleNumberandLetter){
//        return [self validateNumberandLetter:textField.text Range:range replacementString:string];
    }else{
        
    }
    !self.importBackString ? : self.importBackString (toBeString);
    return true;
}

#pragma mark - 限制输入长度 与 数字 字母
- (void)textFiledEditChanged:(NSNotification *)obj{
    
    if (self.importStyle==TextFieldImportStyleNumberandLetter) {
        UITextField *textField = (UITextField *)obj.object;
        NSString *toBeString = textField.text;
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        NSCharacterSet *charSet = [[NSCharacterSet characterSetWithCharactersInString:TextRule] invertedSet];
        NSString *tempText = [[textField.text componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
        BOOL canEdit = [textField.text isEqualToString:tempText];
        if (!position){
            if (canEdit) {
                if (toBeString.length > self.maxLength){
                    NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.maxLength];
                    if (rangeIndex.length == 1){
                        textField.text = [toBeString substringToIndex:self.maxLength];
                    }
                    else{
                        NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxLength)];
                        textField.text = [toBeString substringWithRange:rangeRange];
                    }
                }
            }else{
                if (toBeString.length == 1) {
                    textField.text = @"";
                }else{
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, toBeString.length - 1)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
        !self.importBackString ? : self.importBackString (toBeString);
    }
}

/**TextFieldImportStyleNumberandLetter
 *  字母和数字
 */
- (BOOL)validateNumberandLetter:(NSString*)number  Range:(NSRange)range replacementString:(NSString *)string {
    NSString *toBeString = [number stringByReplacingCharactersInRange:range withString:string];
    NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
        // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
        if (character < 48) return NO; // 48 unichar for 0
        if (character > 57 && character < 65) return NO; //
        if (character > 90 && character < 97) return NO;
        if (character > 122) return NO;
        
    }
    !self.importBackString ? : self.importBackString (toBeString);
    return YES;
}

/**TextFieldImportStyleNumberTwo
 *  整数限制，首位不可以为0
 */
- (BOOL)validateNumber:(NSString*)number  Range:(NSRange)range replacementString:(NSString *)string {
    NSString *toBeString = [number stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet * characterSet;
    characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    if (canChange == 0) {
        return canChange;
    }
    if (toBeString.length > self.maxLength) {
        return NO;
    }
    if (toBeString.length == 1) {//第一位不能为0
        if ([filtered isEqualToString:@"0"]) {
            return NO;
        }
    }
    !self.importBackString ? : self.importBackString (toBeString);
    return true;
}
/**
 *  整数限制，首位可以为0
 */
- (BOOL)validateNumberTwo:(NSString*)number  Range:(NSRange)range replacementString:(NSString *)string {
    NSString *toBeString = [number stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet * characterSet;
    characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    if (canChange == 0) {
        return canChange;
    }
    if (toBeString.length > self.maxLength) {
        return NO;
    }
    !self.importBackString ? : self.importBackString (toBeString);
    return true;
}
/**
 *  限制金钱输入格式  (输入格式：最低输入1.00)
 */
-(BOOL)validateMoney:(UITextField *)money Range:(NSRange)range replacementString:(NSString *)string{
    
    NSString *toBeString = [money.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([money.text rangeOfString:@"."].location == NSNotFound) {
        self.isDian = NO;
    }
    if ([string length] > 0) {
        
        if (toBeString.length > self.maxLength) {
            return NO;
        }
        unichar single = [string characterAtIndex:0];
        if ((single >= '0' && single <= '9') || single == '.') {
            if([money.text length] == 0){
                if(single == '.') {
                    [money.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (single == '0') {
                    [money.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            if (single == '.') {
                if(!self.isDian)
                {
                    self.isDian = YES;
                    !self.importBackString ? : self.importBackString (toBeString);
                    return YES;
                    
                }else{
                    [money.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (self.isDian) {
                    NSRange ran = [money.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        !self.importBackString ? : self.importBackString (toBeString);
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    !self.importBackString ? : self.importBackString (toBeString);
                    return YES;
                }
            }
        }else{
            [money.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else{
        !self.importBackString ? : self.importBackString (toBeString);
        return YES;
    }
}
/**
 *  限制金钱输入格式  (输入格式：最低输入0.00)
 */
-(BOOL)validateMinMoney:(UITextField *)money Range:(NSRange)range replacementString:(NSString *)string{
    
    NSString *toBeString = [money.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([money.text rangeOfString:@"."].location == NSNotFound) {
        self.isDian = NO;
    }
    if ([string length] > 0) {
        
        if (toBeString.length > self.maxLength) {
            return NO;
        }
        unichar single = [string characterAtIndex:0];
        if ((single >= '0' && single <= '9') || single == '.') {
            if([money.text length] == 0){
                if(single == '.') {
                    [money.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            if (single == '.') {
                if(!self.isDian)
                {
                    self.isDian = YES;
                    !self.importBackString ? : self.importBackString (toBeString);
                    return YES;
                    
                }else{
                    [money.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (self.isDian) {
                    NSRange ran = [money.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        !self.importBackString ? : self.importBackString (toBeString);
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    !self.importBackString ? : self.importBackString (toBeString);
                    return YES;
                }
            }
        }else{
            [money.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else{
        !self.importBackString ? : self.importBackString (toBeString);
        return YES;
    }
}
/**
 *  合法的小数金额限制
 */
-(BOOL)validateRightfulMoney:(UITextField *)money Range:(NSRange)range replacementString:(NSString *)string{
    
    NSString *toBeString = [money.text stringByReplacingCharactersInRange:range withString:string];
    
    _tempText = money.text;
    _tempRange = range;
    _tempString = string;
    
    if (string && string.length > 0) {
        // 输入
        if (_tempText.length == 0) {
            if ([string isEqualToString:@"."]) {
                _tempText = @"0";
                money.text = @"0";
                !self.importBackString ? : self.importBackString (toBeString);
                return YES;
            }else{
                !self.importBackString ? : self.importBackString (toBeString);
                return YES;
            }
            
        }else if (_tempText.length == 1){
            if ([_tempText isEqualToString:@"0"]) {
                if ([string isEqualToString:@"."]) {
                    !self.importBackString ? : self.importBackString (toBeString);
                    return YES;
                }else{
                    return NO;
                }
            }
        }
        // 输入后不可超过 '99999.99'
        if ([_tempText stringByAppendingString:string].floatValue > [_max floatValue]) {
            return NO;
        }
        // 不可超过8位
        if (_tempText.length >= _max.length) {
            return NO;
        }
        
        NSRange docRange = [_tempText rangeOfString:@"."];
        if (docRange.location != NSNotFound) {
            // 已输入小数点, 禁止再输入小数点
            if ([string isEqualToString:@"."]) {
                return NO;
            }
            // 小数点后位数
            NSUInteger decimals = _tempText.length - (docRange.location + docRange.length);
            if (decimals == 2) {
                // 小数点后两位,禁止输入任何字符
                return NO;
            }else if (decimals == 1){
                // 小数点后一位,禁止输入 '0'
                if ([string isEqualToString:@"0"]) {
                    return NO;
                }
            }
        }else{
            if (_tempText.length == 0) {
                // 第一位
                if ([string isEqualToString:@"."] || [string isEqualToString:@"0"]) {
                    return NO;
                }
            }
        }
    }
    !self.importBackString ? : self.importBackString (toBeString);
    return YES;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    
    NSString * selectorName = NSStringFromSelector(aSelector);
    if ([selectorName isEqualToString:@"customOverlayContainer"]) {
        NSLog(@"preventing self.delegate == self crash");
        return NO;
    }
    return [super respondsToSelector:aSelector];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end







// ======================================================================
@implementation SDKMNChineseField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder font:(UIFont *)font align:(NSTextAlignment)align {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.placeholder = placeHolder;
        self.textAlignment = align;
        self.font = font;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged:(NSNotification *)note {
    UITextField *field = (UITextField *)note.object;
    
    if (field == self) {
        !_sendValueBlock ? : _sendValueBlock(field.text);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end




