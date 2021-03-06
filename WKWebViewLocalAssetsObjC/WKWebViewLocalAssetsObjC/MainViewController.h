//
//  MainViewController.h
//  WKWebViewLocalAssetsObjC
//
//  Created by Sergey Vasilevkin on 09/03/2019.
//  Copyright © 2019 Sergey Vasilevkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <MessageUI/MessageUI.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainViewController : UIViewController <WKScriptMessageHandler, WKNavigationDelegate, MFMailComposeViewControllerDelegate>

@end

NS_ASSUME_NONNULL_END
