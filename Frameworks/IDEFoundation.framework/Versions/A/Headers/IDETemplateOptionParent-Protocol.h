// Headers generated with ktool v1.3.0
// https://github.com/cxnder/ktool | pip3 install k2l
// Platform: MACOS | Minimum OS: 12.0.0 | SDK: 13.3.0



@protocol IDETemplateOptionParent

@property (readonly, copy) NSString *identifier;
@property (retain, nonatomic) IDEWorkspace *workspace;

- (void)valueDidChangeForOption:(id)arg0;
- (id)identifier;
- (id)workspace;

@end
