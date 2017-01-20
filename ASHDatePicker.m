//
//  ASHDatePicker.m
//  ASHDatePicker
//
//  Created by Adam Hartford on 10/3/12.
//  Copyright (c) 2012 Adam Hartford. All rights reserved.
//

#import "ASHDatePicker.h"

@interface ASHDatePicker ()

@property (nonatomic, assign) SEL ownerAction;
@property (nonatomic, weak) id ownerTarget;

@end

@implementation ASHDatePicker

- (void)popoverDateAction
{
    self.dateValue = controller.datePicker.dateValue;
    [NSApp sendAction:_ownerAction to:_ownerTarget from:self];
}

- (void)dateAction {
    
    controller.datePicker.dateValue = self.dateValue;
    [NSApp sendAction:_ownerAction to:_ownerTarget from:self];
}

- (void)awakeFromNib
{
    _ownerAction = self.action;
    _ownerTarget = self.target;
    self.action = @selector(dateAction);
    self.target = self;

    controller = [[ASHDatePickerController alloc] init];
    controller.datePicker.action = @selector(popoverDateAction);
    
    _popover = [[NSPopover alloc] init];
    _popover.contentViewController = controller;
    _popover.behavior = NSPopoverBehaviorSemitransient;
    
    _preferredPopoverEdge = NSMaxXEdge;
}

- (void)mouseDown:(NSEvent *)theEvent
{
    [self becomeFirstResponder];
    [super mouseDown:theEvent];
}

- (BOOL)becomeFirstResponder
{
    if ([_popoverDelegate respondsToSelector:@selector(datePickerShouldShowPopover:)] && [_popoverDelegate datePickerShouldShowPopover:self]) {
    
        controller.datePicker.dateValue = self.dateValue;
        [_popover showRelativeToRect:self.bounds ofView:self preferredEdge:_preferredPopoverEdge];
    }

    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    [_popover close];
    return [super resignFirstResponder];
}

@end

@implementation ASHDatePickerController

@synthesize datePicker = _datePicker;

- (id)init
{
    self = [super init];
    if (self) {
        NSRect viewFrame = NSMakeRect(0.0f, 0.0f, 180.0f, 180.0f);
        NSView *popoverView = [[NSView alloc] initWithFrame:viewFrame];
        
        NSRect pickerFrame = NSMakeRect(22.0f, 17.0f, 139.0f, 148.0f);
        _datePicker = [[NSDatePicker alloc] initWithFrame:pickerFrame];
        _datePicker.datePickerStyle = NSClockAndCalendarDatePickerStyle;
        _datePicker.drawsBackground = NO;
        [_datePicker.cell setBezeled:NO];
        [popoverView addSubview:_datePicker];
        self.view = popoverView;
    }
    
    return self;
}

@end
