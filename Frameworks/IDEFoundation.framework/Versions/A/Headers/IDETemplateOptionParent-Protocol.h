//
//     Generated by class-dump 3.5 (64 bit) (forked by @manicmaniac).
//
//  Copyright (C) 1997-2019 Steve Nygard.
//


@class IDETemplateOption, IDEWorkspace, NSString;

@protocol IDETemplateOptionParent<NSObject>
@property (retain, nonatomic) IDEWorkspace *workspace;
@property (readonly, copy) NSString *identifier;
- (void)valueDidChangeForOption:(IDETemplateOption *)arg1;
@end
