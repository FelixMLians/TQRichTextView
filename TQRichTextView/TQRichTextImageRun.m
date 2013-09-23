//
//  TQRichTextImageRun.m
//  TQRichTextViewDemo
//
//  Created by fuqiang on 13-9-21.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import "TQRichTextImageRun.h"
#import <CoreText/CoreText.h>

@implementation TQRichTextImageRun

- (void)replaceTextWithAttributedString:(NSMutableAttributedString*) attString
{
    //删除替换的占位字符
    [attString deleteCharactersInRange:NSMakeRange(self.range.location, 1)];
    
    CTRunDelegateCallbacks emojiCallbacks;
    emojiCallbacks.version      = kCTRunDelegateVersion1;
    emojiCallbacks.dealloc      = TQRichTextRunEmojiDelegateDeallocCallback;
    emojiCallbacks.getAscent    = TQRichTextRunEmojiDelegateGetAscentCallback;
    emojiCallbacks.getDescent   = TQRichTextRunEmojiDelegateGetDescentCallback;
    emojiCallbacks.getWidth     = TQRichTextRunEmojiDelegateGetWidthCallback;

    
    NSMutableAttributedString *imageAttributedString = [[NSMutableAttributedString alloc] initWithString:@" "];
    
    //
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&emojiCallbacks, (__bridge void*)self);
    [imageAttributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(0, 1)];
    CFRelease(runDelegate);
    //
    [imageAttributedString addAttribute:@"TQRichTextAttribute" value:self range:NSMakeRange(0, 1)];
    
    [attString insertAttributedString:imageAttributedString atIndex:self.range.location];
}

#pragma mark - RunDelegateCallback
void TQRichTextRunEmojiDelegateDeallocCallback(void *refCon)
{
    
}

//--上行高度
CGFloat TQRichTextRunEmojiDelegateGetAscentCallback(void *refCon)
{
    TQRichTextImageRun *run =(__bridge TQRichTextImageRun *) refCon;
    return run.originalFont.ascender * 1.2;
}

//--下行高度
CGFloat TQRichTextRunEmojiDelegateGetDescentCallback(void *refCon)
{
    TQRichTextImageRun *run =(__bridge TQRichTextImageRun *) refCon;
    return run.originalFont.descender * 1.2;
}

//-- 宽
CGFloat TQRichTextRunEmojiDelegateGetWidthCallback(void *refCon)
{
    TQRichTextImageRun *run =(__bridge TQRichTextImageRun *) refCon;
    return (run.originalFont.ascender - run.originalFont.descender) * 1.2;
}

@end
