//
//  DownloadCell.m
//  FDownloadIOS
//
//  Created by Apple on 20/11/21.
//

#import "DownloadCell.h"

@interface DownloadCell () <FDownloadTaskDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView * progressView;
@property (weak, nonatomic) IBOutlet UILabel * progressLabel;
@property (weak, nonatomic) IBOutlet UILabel * stateLabel;
@property (weak, nonatomic) IBOutlet UILabel * titleLabel;

@end

@implementation DownloadCell

- (void)setDownloadTask:(FDownloadTask *)downloadTask
{
    if (_downloadTask != downloadTask) {
        _downloadTask.delegate = nil;
        _downloadTask = downloadTask;
        _downloadTask.delegate = self;
        [self refreshState];
        [self refreshProgress];
    }
}

- (void)taskStateDidChange:(FDownloadTask *)task
{
    [self refreshState];
}

- (void)taskProgressDidChange:(FDownloadTask *)task
{
    [self refreshProgress];
}

- (void)refreshState
{
    self.titleLabel.text = _downloadTask.title;
    NSString * text = nil;
    switch (self.downloadTask.state) {
        case FDownloadTaskStateNone:
            text = @"None";
            break;
        case FDownloadTaskStateWaiting:
            text = @"Waiting...";
            break;
        case FDownloadTaskStateRunning:
            text = @"Running...";
            break;
        case FDownloadTaskStateSuspend:
            text = @"Suspend";
            break;
        case FDownloadTaskStateFinished:
            text = @"Finished";
            break;
        case FDownloadTaskStateCanceled:
            text = @"Canceled";
            break;
        case FDownloadTaskStateFailured:
            text = @"Failured";
            break;
    }
    self.stateLabel.text = text;
}

- (void)refreshProgress
{
    float progress = self.downloadTask.progress;
    int64_t current = self.downloadTask.totalBytesWritten;
    int64_t total = self.downloadTask.totalBytesExpectedToWrite;
    NSString * text = [NSString stringWithFormat:@"%lld / %lld", current, total];
    self.progressView.progress = progress;
    self.progressLabel.text = text;
}

@end
