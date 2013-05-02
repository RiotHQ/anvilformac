#import "NVStatusItemView.h"
#import <QuartzCore/QuartzCore.h>

@interface NVStatusItemView ()

@property (nonatomic, strong) NSArray *pasteboardTypes;
@property (strong) NSStatusItem *statusItem;

@end


@implementation NVStatusItemView

@synthesize statusItem = _statusItem;
@synthesize image = _image;
@synthesize alternateImage = _alternateImage;
@synthesize isHighlighted = _isHighlighted;
@synthesize action = _action;
@synthesize target = _target;

#pragma mark -

- (id)initWithStatusItem:(NSStatusItem *)statusItem {
    
    CGFloat itemWidth = [statusItem length];
    CGFloat itemHeight = [[NSStatusBar systemStatusBar] thickness];
    NSRect itemRect = NSMakeRect(0.0, 0.0, itemWidth, itemHeight);
    self = [super initWithFrame:itemRect]; // Doesnt seem to set height
    
    if (self != nil) {
        
        self.pasteboardTypes = [NSArray arrayWithObjects:@"com.apple.pasteboard.promised-file-url", @"public.file-url", nil];
        [self registerForDraggedTypes:self.pasteboardTypes];
        self.statusItem = statusItem;
        self.statusItem.view = self;
    }
    
    return self;
}

-(NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender{
    
    return NSDragOperationCopy;
}

-(BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender{
    
    return YES;
}

-(BOOL)performDragOperation:(id <NSDraggingInfo>)sender{
    
    for (NSPasteboardItem *item in [sender draggingPasteboard].pasteboardItems) {
        
        NSString *filePath = nil;
        for (NSString *type in self.pasteboardTypes) {
            
            if ([item.types containsObject:type]) {
      
                filePath = [item stringForType:type];
            }
        }
        
        if (filePath) {
            
            NSURL *url = [NSURL URLWithString:filePath];
            if (self.delegate && [self.delegate respondsToSelector:@selector(statusItemView:didReceiveDropURL:)]) {
                
                [self.delegate statusItemView:self didReceiveDropURL:url];
            }
            
            return YES;
        }
    }

    return YES;
}

- (void)draggingEnded:(id<NSDraggingInfo>)sender {
    
}

#pragma mark -

- (void)drawRect:(NSRect)dirtyRect {
    
	[self.statusItem drawStatusBarBackgroundInRect:dirtyRect withHighlight:NO];
        
    if (self.showHighlightIcon) {
        
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"AppleAquaColorVariant"] == 6) {
            [[NSColor colorWithPatternImage:[NSImage imageNamed:@"GraphiteHighlight"]] setFill];
        }
        else {
            [[NSColor colorWithPatternImage:[NSImage imageNamed:@"AquaHighlight"]] setFill];
        }
           
        NSRectFill(dirtyRect);
    }
    
    NSImage *icon = self.showHighlightIcon ? self.alternateImage : self.image;
    NSSize iconSize = [icon size];
    NSRect bounds = self.bounds;
        
    CGFloat iconX = roundf((NSWidth(bounds) - iconSize.width) / 2);
    CGFloat iconY = roundf((NSHeight(bounds) - iconSize.height) / 2);
    NSPoint iconPoint = NSMakePoint(iconX, iconY);
        
    [icon drawAtPoint:iconPoint fromRect:dirtyRect operation:NSCompositeSourceOver fraction:1.0];
    
    [self setNeedsDisplay:YES];
}

#pragma mark -
#pragma mark Mouse tracking

- (void)mouseDown:(NSEvent *)theEvent {
    
    [NSApp sendAction:self.action to:self.target from:self];
}

- (void)rightMouseDown:(NSEvent *)theEvent {
    
    [NSApp sendAction:self.rightClickAction to:self.target from:self];
}

- (BOOL)needsDisplay {
    
    return YES;
}

#pragma mark -
#pragma mark Accessors

- (void)setHighlighted:(BOOL)newFlag {
    if (_isHighlighted == newFlag) return;
    _isHighlighted = newFlag;
    [self setNeedsDisplay:YES];
}

- (void)setShowHighlightIcon:(BOOL)showHighlightIcon {
    
    if (_showHighlightIcon == showHighlightIcon) {
        return;
    }
    
    _showHighlightIcon = showHighlightIcon;
    [self setNeedsDisplay:YES];
}

#pragma mark -

- (void)setImage:(NSImage *)newImage {
    if (_image != newImage) {
        _image = newImage;
        [self setNeedsDisplay:YES];
    }
}

- (void)setAlternateImage:(NSImage *)newImage {
    if (_alternateImage != newImage) {
        _alternateImage = newImage;
        if (self.isHighlighted) {
            [self setNeedsDisplay:YES];
        }
    }
}

#pragma mark -

- (NSRect)globalRect {
    NSRect frame = [self frame];
    frame.origin = [self.window convertBaseToScreen:frame.origin];
    return frame;
}

@end
