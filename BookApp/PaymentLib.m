//
//  paymentLib.m
//  FQTest
//
//  Created by le kien on 1/23/18.
//  Copyright © 2018 zzf073. All rights reserved.
//

#import "PaymentLib.h"

@implementation PaymentLib

-(FuqianlaPay *)createPaymemtObject {
    [self configSDKSignParams];
    FuqianlaPay *manager = [FuqianlaPay sharedPayManager];
    manager.showPayStatusView = YES;
    manager.transactionParams = @{
                                  @"app_id": self.appID,
                                  @"order_no": self.orderId,
                                  @"amount": self.amount,
                                  @"subject": self.subject,
                                  @"body": self.body,
                                  @"notify_url": self.notifyUrl,
                                  @"optional": self.optional,
                                  };
    
    return manager;
}

#pragma mark-
#pragma mark------私有函数----

-(NSString*)merchAppSign:(NSString*)sourceString {
    FuqianlaPay *manager = [FuqianlaPay sharedPayManager];
    
    NSString *signStr = nil;
    manager.rsaKeyPath = [[NSBundle mainBundle] pathForResource:@"public_privatekey" ofType:@"p12"];
    manager.rsaKeyPassword = @"111111";
    id rsaKey = [(id)NSClassFromString(@"CERSAKey") performSelector:@selector(sharedRsaKey) withObject:nil];
    [rsaKey performSelector:@selector(loadPrivateKeyFromFile:password:) withObject:manager.rsaKeyPath withObject:manager.rsaKeyPassword];
    [rsaKey performSelector:@selector(loadPublicKeyFromString:) withObject:[manager valueForKeyPath:@"signVerifyKey"]];
    
    NSString*(*rsaSignFun)(id,SEL,NSString*);
    id x = NSClassFromString(@"CERSA");
    rsaSignFun=(NSString* (*)(id, SEL,NSString*)) [x methodForSelector:@selector(sha1PriRsaSign:)];
    signStr = rsaSignFun(x , @selector(sha1PriRsaSign:), sourceString);
    return signStr;
}

//配置签名信息
-(void)configSDKSignParams {
    FuqianlaPay *manager = [FuqianlaPay sharedPayManager];
    manager.dataSignInMerchApp = YES;
    manager.signType = @"rsa";
    
//    __weak typeof(manager) wManager = manager;
//    __weak typeof(self) wSelf = self;
    __block BOOL hasSigned = NO;
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:3];
    manager.dataSignResult = ^NSString*(NSString *sourceData){
        while (!hasSigned) {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
            if([[NSDate date] timeIntervalSinceDate:date] >0) {
                hasSigned = YES;
            }
            if(hasSigned) {
                return [self merchAppSign:sourceData];
            }
        }
        return [self merchAppSign:sourceData];
    };
}

-(NSString*)formatOrderId {
    int kNumber = 15;
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end
