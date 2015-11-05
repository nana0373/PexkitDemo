//
//  ViewController.m
//  PexkitDemo
//
//  Created by apple on 15/11/3.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import <PexKit/PexKit.h>

@interface ViewController ()<ConferenceDelegate>
{
    __weak IBOutlet UITextField *addressBar;
    __weak IBOutlet UITextField *nameTF;
    __weak IBOutlet UITextField *passwordTF;
    __weak IBOutlet PexVideoView *videoView;
    __weak IBOutlet UITableView *rosterTableView;
    
    Conference    *conference;
    NSArray       *rosterList;
}

- (IBAction)joinClick:(id)sender;
- (IBAction)logoutClick:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 加入
- (IBAction)joinClick:(id)sender
{
    if (conference != nil)
    {
        [conference disconnectMedia:^(NSInteger ServiceError) {
            [conference releaseToken:^(NSInteger ServiceError) {
                conference = nil;
                NSLog(@"========%d",conference.isLoggedIn);
            }];
        }];
    }
    conference = [[Conference alloc] init];
    [conference connect:nameTF.text uri:addressBar.text pin:@"" completion:^(BOOL ok)
     {
        if (!ok)
        {
            return ;
        }
        [conference requestToken:^(NSInteger ServiceError)
         {
             switch (ServiceError) {
                 case 0:
                 {
                     conference.videoView = videoView;
                     [conference escalateMedia:^(NSInteger ServiceError0) {
                         switch (ServiceError0) {
                             case 0:
                             {
                                 conference.delegate = self;
                                 [conference listenForEventsWithFailonerror:YES];
                             }
                                 break;
                             default:
                                 NSLog(@"Got unhandled status of \(status)===%ld" ,(long)ServiceError);
                                 break;
                         }
                     }];
                 }
                     break;
                 default:
                     NSLog(@"Got unhandled status of \(status)===%ld" ,(long)ServiceError);
                     break;
             }
         }];
    }];
}

#pragma mark - 退出
- (IBAction)logoutClick:(id)sender
{
    [conference disconnectMedia:^(NSInteger ServiceError) {
        [conference releaseToken:^(NSInteger ServiceError) {
            conference = nil;
            NSLog(@"========%d",conference.isLoggedIn);
        }];
    }];
}

#pragma mark -ConferenceDelegate
- (void)rosterUpdate:(NSArray<Participant *> * __nonnull)rosterList0
{
    rosterList = rosterList0;
    [rosterTableView reloadData];
}
- (void)stageUpdate:(NSArray<Participant *> * __nonnull)stage
{


}

- (void)participantRemoved:(NSString * __nonnull)uuid
{


}

- (void)participantAdded:(Participant * __nonnull)participant
{

}

- (void)callDisconnected
{

}

- (void)participantChanged:(Participant * __nonnull)participant
{

}

- (void)participantSyncEnd:(NSArray<Participant *> * __nonnull)participants
{


}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [rosterList count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:@"RosterCell"];
    Participant *participant =rosterList[indexPath.row];
    cell.textLabel.text = participant.displayName;
    cell.detailTextLabel.text = participant.uri;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    Participant *participant =rosterList[indexPath.row];
//    //全部静音
//    [conference muteAll:^(NSInteger ServiceError) {
    //                NSLog(@"静音===%d",ServiceError);

//    }];
    // 某人静音
//    [conference muteParticipant:participant completion:^(NSInteger ServiceError) {
//        NSLog(@"静音===%ld",(long)ServiceError);
//        
//    }];
    [nameTF resignFirstResponder];
    [addressBar resignFirstResponder];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
