//
//  CallbackDelegate.h
//  IntellectHome
//
//  Created by 吴卓 on 15/12/23.
//  Copyright © 2015年 吴卓. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CallbackDelegate <NSObject>
- (void)callbackData:(id)data RequestCode:(NSInteger)requestCode;

- (void)callbackError:(id)error;
@end
