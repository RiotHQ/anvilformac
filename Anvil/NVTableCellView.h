//
//  NVTableCellView.h
//  Anvil
//
//  Created by Elliott Kember on 16/09/2012.
//  Copyright (c) 2012 Riot. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NVLayeredImageView.h"
#import "NVLabel.h"

@interface NVTableCellView : NSTableCellView

@property (weak, nonatomic) IBOutlet NVLabel *textField;
@property (weak, nonatomic) IBOutlet NVLabel *localLabel;
@property (weak, nonatomic) IBOutlet NVLayeredImageView *faviconImageView;

@end
