//
//  ViewController.m
//  HelloAVF_Final
//
//  Created by QinTuanye on 2019/3/22.
//  Copyright © 2019年 QinTuanye. All rights reserved.
//

#import "THViewController.h"
#import "THSpeechController.h"
#import <AVFoundation/AVFoundation.h>
#import "THBubbleCell.h"

@interface THViewController () <AVSpeechSynthesizerDelegate>
@property (strong, nonatomic) THSpeechController *speechController;
@property (strong, nonatomic) NSMutableArray *speechStrings;
@end

@implementation THViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 20.0f, 0.0f);
    self.speechController = [THSpeechController speechController];
    self.speechController.synthesizer.delegate = self;
    self.speechStrings = [NSMutableArray array];
    [self.speechController beginConversation];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.speechStrings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = indexPath.row % 2 == 0 ? @"YouCell" : @"AVFCell";
    THBubbleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.messageLabel.text = self.speechStrings[indexPath.row];
    return cell;
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance {
    [self.speechStrings addObject:utterance.speechString];
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.speechStrings.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

@end
