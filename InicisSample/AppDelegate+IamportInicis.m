//
//  AppDelegate+IamportInicis.m
//  InicisSample
//
//  Created by jang on 2015. 10. 1..
//  Copyright (c) 2015년 jang. All rights reserved.
//

#import "AppDelegate+IamportInicis.h"

@implementation AppDelegate (IamportInicis)

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //iOS6에서 세션끊어지는 상황 방지하기 위해 쿠키 설정. (iOS설정에서 사파리 쿠키 사용 설정도 필요)
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    
    return YES;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //ISP호출인지부터 체크
    NSString* URLString = [NSString stringWithString:[request.URL absoluteString]];
    //APP STORE URL 경우 openURL 함수를 통해 앱스토어 어플을 활성화 한다.
    BOOL bAppStoreURL = ([URLString rangeOfString:@"phobos.apple.com" options:NSCaseInsensitiveSearch].location != NSNotFound);
    BOOL bAppStoreURL2 = ([URLString rangeOfString:@"itunes.apple.com" options:NSCaseInsensitiveSearch].location != NSNotFound);
    if(bAppStoreURL || bAppStoreURL2) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    //ISP 호출하는 경우
    if([URLString hasPrefix:@"ispmobile://"]) {
        NSURL *appURL = [NSURL URLWithString:URLString];
        if([[UIApplication sharedApplication] canOpenURL:appURL]) {
            [[UIApplication sharedApplication] openURL:appURL];
        } else {
            [self showAlertViewWithEvent:@"모바일 ISP가 설치되어 있지 않아\nApp Store로 이동합니다." tagNum:99];
            return NO;
        }
    }
    
    //기타(금결원 실시간계좌이체 등)
    NSString *strHttp = @"http://";
    NSString *strHttps = @"https://";
    NSString *reqUrl=[[request URL] absoluteString]; NSLog(@"webview 에 요청된 url==>%@",reqUrl);
    if (!([reqUrl hasPrefix:strHttp]) && !([reqUrl hasPrefix:strHttps])) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

-(void)showAlertViewWithEvent:(NSString*)_msg tagNum:(NSInteger)tag
{
    UIAlertView *v = [[UIAlertView alloc]initWithTitle:@"알림"
                                               message:_msg
                                               delegate:self cancelButtonTitle:@"확인"
                                      otherButtonTitles:nil];
    v.tag = tag;
    [v show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 99) {
        // ISP 앱 스토어로 이동
        NSString* URLString = @"https://itunes.apple.com/app/mobail-gyeolje-isp/id369125087?mt=8";
        NSURL* storeURL = [NSURL URLWithString:URLString]; [[UIApplication sharedApplication] openURL:storeURL];
    }
}

@end
