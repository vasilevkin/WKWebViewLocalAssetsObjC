//
//  MainViewController.m
//  WKWebViewLocalAssetsObjC
//
//  Created by Sergey Vasilevkin on 09/03/2019.
//  Copyright © 2019 Sergey Vasilevkin. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic, assign) WKWebView *webView;
@property (nonatomic, assign) UIButton *loadHtmlAsFileButton;
@property (nonatomic, assign) UIButton *loadHtmlAsStringButton;
@property (nonatomic, assign) UIButton *zoomButton;
@property (nonatomic, assign) UIButton *runJavaScriptButton;
@property (nonatomic, assign) BOOL zoomEnabled;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureUI];
    [self addActions];
    
    // Refresh main view
    [self.view layoutIfNeeded];
    
    self.webView.navigationDelegate = self;
    
    // Add ScriptMessageHandler in JavaScript:
    // window.webkit.messageHandlers.JavaScriptObserver.postMessage(message)
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"JavaScriptObserver"];
    self.zoomEnabled = YES;

    [self loadWebViewContent];
}

#pragma mark - Private

- (void)configureUI {
    
    // UI constants
    CGFloat const kSizeMainStackViewOffset = 8;
    CGFloat const kButtonHeight = 50;
    CGFloat const kStackViewSpacing = 8;
    CGFloat const kFontSizeButtonText = 15;
    
    NSString * const kTitleLoadHtmlAsFileButton = @"Load html as File";
    UIColor * const kColorLoadHtmlAsFileButton = [UIColor colorWithRed:4/255.0 green:51/255.0 blue:255/255.0 alpha:1.0];
    UIColor * const kColorLoadHtmlAsFileButtonText = [UIColor whiteColor];
    
    NSString * const kTitleLoadHtmlAsStringButton = @"Load html as String";
    UIColor * const kColorLoadHtmlAsStringButton = [UIColor colorWithRed:148/255.0 green:33/255.0 blue:146/255.0 alpha:1.0];
    UIColor * const kColorLoadHtmlAsStringButtonText = [UIColor whiteColor];
    
    NSString * const kTitleZoomButton = @"Zoom ON";
    UIColor * const kColorZoomButton = [UIColor colorWithRed:0 green:249/255.0 blue:0 alpha:1.0];
    UIColor * const kColorZoomButtonText = [UIColor darkGrayColor];
    
    NSString * const kTitleRunJavaScriptButton = @"Run JavaScript";
    UIColor * const kColorRunJavaScriptButton = [UIColor colorWithRed:0 green:249/255.0 blue:0 alpha:1.0];
    UIColor * const kColorRunJavaScriptButtonText = [UIColor whiteColor];
    
    // Main Stack View
    UIStackView *mainStackView = [[UIStackView alloc] init];
    mainStackView.axis = UILayoutConstraintAxisVertical;
    mainStackView.alignment = UIStackViewAlignmentFill;
    mainStackView.distribution = UIStackViewDistributionFill;
    mainStackView.spacing = kStackViewSpacing;
    mainStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:mainStackView];
    // Layout for Main Stack View
    UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
    [mainStackView.leadingAnchor constraintEqualToAnchor:guide.leadingAnchor constant:kSizeMainStackViewOffset].active = YES;
    [mainStackView.topAnchor constraintEqualToAnchor:guide.topAnchor constant:kSizeMainStackViewOffset].active = YES;
    [guide.trailingAnchor constraintEqualToAnchor:mainStackView.trailingAnchor constant:kSizeMainStackViewOffset].active = YES;
    [guide.bottomAnchor constraintEqualToAnchor:mainStackView.bottomAnchor constant:kSizeMainStackViewOffset].active = YES;
    
    // Web View
    WKWebView *webView = [[WKWebView alloc] init];
    webView.backgroundColor = [UIColor lightGrayColor];
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    self.webView = webView;
    [mainStackView addArrangedSubview:webView];
    
    // Load html as File and Load html as String Stack View
    UIStackView *loadHtmlFileAndLoadHtmlStringStackView = [[UIStackView alloc] init];
    loadHtmlFileAndLoadHtmlStringStackView.axis = UILayoutConstraintAxisHorizontal;
    loadHtmlFileAndLoadHtmlStringStackView.alignment = UIStackViewAlignmentFill;
    loadHtmlFileAndLoadHtmlStringStackView.distribution = UIStackViewDistributionFillEqually;
    loadHtmlFileAndLoadHtmlStringStackView.spacing = kStackViewSpacing;
    loadHtmlFileAndLoadHtmlStringStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [mainStackView addArrangedSubview:loadHtmlFileAndLoadHtmlStringStackView];
    
    // Load html as File Button
    UIButton *loadHtmlAsFileButton = [[UIButton alloc] init];
    loadHtmlAsFileButton.backgroundColor = kColorLoadHtmlAsFileButton;
    [loadHtmlAsFileButton setTitleColor:kColorLoadHtmlAsFileButtonText forState:UIControlStateNormal];
    [loadHtmlAsFileButton setTitle:kTitleLoadHtmlAsFileButton forState:UIControlStateNormal];
    [loadHtmlAsFileButton.titleLabel setFont:[UIFont systemFontOfSize:kFontSizeButtonText]];
    loadHtmlAsFileButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.loadHtmlAsFileButton = loadHtmlAsFileButton;
    [loadHtmlFileAndLoadHtmlStringStackView addArrangedSubview:loadHtmlAsFileButton];
    // Layout for Load html as File Button
    [loadHtmlAsFileButton.heightAnchor constraintEqualToConstant:kButtonHeight].active = YES;
    
    // Load html as String Button
    UIButton *loadHtmlAsStringButton = [[UIButton alloc] init];
    loadHtmlAsStringButton.backgroundColor = kColorLoadHtmlAsStringButton;
    [loadHtmlAsStringButton setTitleColor: kColorLoadHtmlAsStringButtonText forState:UIControlStateNormal];
    [loadHtmlAsStringButton setTitle:kTitleLoadHtmlAsStringButton forState:UIControlStateNormal];
    [loadHtmlAsStringButton.titleLabel setFont:[UIFont systemFontOfSize:kFontSizeButtonText]];
    loadHtmlAsStringButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.loadHtmlAsStringButton = loadHtmlAsStringButton;
    [loadHtmlFileAndLoadHtmlStringStackView addArrangedSubview:loadHtmlAsStringButton];
    // Layout for Load html as String Button
    [loadHtmlAsStringButton.heightAnchor constraintEqualToConstant:kButtonHeight].active = YES;
    
    // Zoom and Run Javascript Stack View
    UIStackView *zoomAndRunJavascriptStackView = [[UIStackView alloc] init];
    zoomAndRunJavascriptStackView.axis = UILayoutConstraintAxisHorizontal;
    zoomAndRunJavascriptStackView.alignment = UIStackViewAlignmentFill;
    zoomAndRunJavascriptStackView.distribution = UIStackViewDistributionFillProportionally;
    zoomAndRunJavascriptStackView.spacing = kStackViewSpacing;
    zoomAndRunJavascriptStackView.translatesAutoresizingMaskIntoConstraints = NO;
    [mainStackView addArrangedSubview:zoomAndRunJavascriptStackView];
    
    // Zoom Button
    UIButton *zoomButton = [[UIButton alloc] init];
    zoomButton.backgroundColor = kColorZoomButton;
    [zoomButton setTitleColor:kColorZoomButtonText forState:UIControlStateNormal];
    [zoomButton setTitle:kTitleZoomButton forState:UIControlStateNormal];
    zoomButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.zoomButton = zoomButton;
    [zoomAndRunJavascriptStackView addArrangedSubview:zoomButton];
    // Layout for Zoom Button
    [zoomButton.heightAnchor constraintEqualToConstant:kButtonHeight].active = YES;
    
    // Run JavaScript Button
    UIButton *runJavaScriptButton = [[UIButton alloc] init];
    runJavaScriptButton.backgroundColor = kColorRunJavaScriptButton;
    [runJavaScriptButton setTitleColor: kColorRunJavaScriptButtonText forState:UIControlStateNormal];
    [runJavaScriptButton setTitle:kTitleRunJavaScriptButton forState:UIControlStateNormal];
    runJavaScriptButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.runJavaScriptButton = runJavaScriptButton;
    [zoomAndRunJavascriptStackView addArrangedSubview:runJavaScriptButton];
    // Layout for Run JavaScript Button
    [runJavaScriptButton.heightAnchor constraintEqualToConstant:kButtonHeight].active = YES;
}

/// Load local html resource as File or as String
- (void)loadWebViewContent: (NSString *)file asFile:(BOOL)asFile {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:file ofType:@"html" inDirectory:@"LocalWebAssets"];
    if ([filePath isEqual: @""]) {
        NSLog(@"Unable to load local html file: %@", file);
        return;
    }
    
    if (asFile) {
        // load local file
        NSURL *filePathURL = [NSURL fileURLWithPath:filePath];
        NSURL *fileDirectoryURL = [filePathURL URLByDeletingLastPathComponent];
        [self.webView loadFileURL:filePathURL allowingReadAccessToURL:fileDirectoryURL];
    } else {
        @try {
            // load html string. baseURL is required for local files to load correctly
            NSString *html = [NSString stringWithContentsOfFile:filePath encoding:kCFStringEncodingUTF8 error:nil];
            [self.webView loadHTMLString:html baseURL:[[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"LocalWebAssets"]];
        }
        @catch (NSException *exception) {
            NSLog(@"Unable to load local html resource as string");
        }
    }
}

- (void)loadWebViewContent {
    [self loadWebViewContent:@"index" asFile:YES];
}

- (void)addActions {
    [self.loadHtmlAsFileButton addTarget:self
                                  action:@selector(loadWebViewContentAsFile)
                        forControlEvents:UIControlEventTouchUpInside];
    [self.loadHtmlAsStringButton addTarget:self
                                    action:@selector(loadWebViewContentAsString)
                          forControlEvents:UIControlEventTouchUpInside];
    [self.zoomButton addTarget:self
                        action:@selector(tapZoomButton)
              forControlEvents:UIControlEventTouchUpInside];
    [self.runJavaScriptButton addTarget:self
                                 action:@selector(tapRunJavascript)
                       forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Button actions

- (void)loadWebViewContentAsFile {
    [self loadWebViewContent:@"htmlAsFile" asFile:YES];
}

- (void)loadWebViewContentAsString {
    [self loadWebViewContent:@"htmlAsString" asFile:YES];
}

- (void)tapZoomButton {
    if (self.zoomEnabled) {
        self.zoomEnabled = NO;
        [self.zoomButton setTitle:@"Zoom OFF" forState:UIControlStateNormal];
        [self.zoomButton setBackgroundColor:UIColor.redColor];
        
        // Disable zoom in web view
        // I wish NSString has more simple concatenation
        NSString *source = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",
                            @"var meta = document.createElement('meta');",
                            @"meta.name = 'viewport';",
                            @"meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';",
                            @"var head = document.getElementsByTagName('head')[0];",
                            @"head.appendChild(meta);"];

        WKUserScript *script  = [[WKUserScript alloc] initWithSource:source injectionTime: WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        
        [self.webView.configuration.userContentController addUserScript:script];
        [self.webView reload];
    } else {
        self.zoomEnabled = YES;
        
        [self.zoomButton setTitle:@"Zoom ON" forState:UIControlStateNormal];
        [self.zoomButton setBackgroundColor:UIColor.greenColor];
        
        // Enable zoom in web view
        [self.webView.configuration.userContentController removeAllUserScripts];
        [self.webView reload];
    }
}

- (void)tapRunJavascript {
    NSString *script = @"textMessageJS()";
    
    [self.webView evaluateJavaScript:script completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"evaluateJavaScript error: %@", error.localizedDescription);
        } else {
            NSLog(@"evaluateJavaScript result: %@", result);
        }
    }];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    // Callback from JavaScript:
    // window.webkit.messageHandlers.JavaScriptObserver.postMessage(message)
    NSString *text = message.body;
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Message from JavaScript"
                                          message:text
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        NSLog(@"OK");
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
