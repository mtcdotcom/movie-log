//
//  Record+Action.m
//  MovieScore
//
//  Created by mtcdotcom on 12/01/01.
//  Copyright 2011 mtcdotcom All rights reserved.
//

#import "Record.h"

@implementation Record (Action)

- (void)sendTweet
{
    Class twClass = NSClassFromString(@"TWTweetComposeViewController");
    if (!twClass) {
        return;
    }
    SLComposeViewController *twclass = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    NSString *tweetTxt  = [NSString stringWithFormat:
                           @"『%@』 %@",
                           [self nilText:mtitle_],
                           [self emptyText:memo_]
                           ];
    [twclass setInitialText:tweetTxt];
    if  (isLoadPhoto_) {
        [twclass addImage:photoImage_];
    }
    [twclass setCompletionHandler:^(SLComposeViewControllerResult result) {
        if (result == SLComposeViewControllerResultDone) {
            NSString *message = @"Tweet成功";
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:nil 
                                                             message:message
                                                            delegate:nil
                                                   cancelButtonTitle:@"閉じる"
                                                   otherButtonTitles:nil] autorelease];
            [alert show];
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    [self presentViewController:twclass animated:YES completion: nil];
    twclass = nil;
}

- (void)sendMail
{
    MFMailComposeViewController *mailPicker = [[[MFMailComposeViewController alloc] init] autorelease];
    mailPicker.mailComposeDelegate = self;
    NSString *subject = [NSString stringWithFormat:@"[movie] %@", [self nilText:mtitle_]];
    NSString *message = [NSString stringWithFormat:
                         @"タイトル : %@\n点数 : %@ 点\n制作国 : %@\nジャンル : %@\n場所 : %@\n上映時間 : %@ 分\n金額 : %@ 円\n登録日 : %@\nメモ : %@",
                         [self nilText:mtitle_],
                         score_,
                         [self nilText:country_],
                         [self nilText:genre_],
                         [self nilText:place_],
                         time_,
                         amount_,
                         [self nilText:date_],
                         [self nilText:memo_]];
    [mailPicker setSubject:subject];
    [mailPicker setMessageBody:message isHTML:NO];
    [self presentViewController:mailPicker animated:YES completion: nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result){
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                            message:@"送信成功"
                                                           delegate:nil 
                                                  cancelButtonTitle:nil 
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
            break;
        }
        case MFMailComposeResultFailed:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                            message:@"送信失敗"
                                                           delegate:nil 
                                                  cancelButtonTitle:nil 
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
            break;
        }
        default:
            break;
    }

    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)mailAndTweet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.delegate = self;
    actionSheet.tag = TAG_NO_MAIL_AND_TWEET;
    
    [actionSheet addButtonWithTitle:@"メール送信"];

    Class twClass = NSClassFromString(@"TWTweetComposeViewController");
    if (twClass) {
        [actionSheet addButtonWithTitle:@"Tweet"];
        actionSheet.cancelButtonIndex = 2;
    } else {
        actionSheet.cancelButtonIndex = 1;
    }
    [actionSheet addButtonWithTitle:@"キャンセル"];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view.window];
}

- (void)dispImage:image
{
    UIImageView *photo = [[[UIImageView alloc]
                           initWithFrame:CGRectMake(self.view.frame.size.width - 112.0 - 20.0, 10.0, 112.0, 112.0)] autorelease];
    photo.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    photo.image = image;
    photo.tag = TAG_NO_PHOTO;
    if ([self.view subviews]) {
        [[self.view viewWithTag:TAG_NO_PHOTO]removeFromSuperview];
    }
    CALayer *layer = [photo layer];
    [layer setMasksToBounds:YES];
    [self.view addSubview:photo];
}

- (void)dispPhoto:image
{
    [self dispImage:image];
}

- (void)dispNoPhoto
{
    UIImage *image = [UIImage imageNamed:@"nophoto.png"];
    [self dispImage:image];
}

- (void)deletePhoto
{
    if ([self.view subviews]) {
        [[self.view viewWithTag:TAG_NO_PHOTO]removeFromSuperview];
    }
    photoImage_  = nil;
    isLoadPhoto_ = FALSE;
    if (objectId_) {
        isUpdatePhoto_ = FALSE;
    }
}

- (void)photo
{
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] init] autorelease];
    actionSheet.delegate = self;
    actionSheet.tag = TAG_NO_PHOTO;
    
    [actionSheet addButtonWithTitle:@"写真を撮る"];
    [actionSheet addButtonWithTitle:@"ライブラリから選択"];
    if (isLoadPhoto_) {
        [actionSheet addButtonWithTitle:@"写真の削除"];
    }
    [actionSheet addButtonWithTitle:@"キャンセル"];
    if (isLoadPhoto_) {
        actionSheet.destructiveButtonIndex = 2;
        actionSheet.cancelButtonIndex = 3;
    } else {
        actionSheet.cancelButtonIndex = 2;
    }
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showInView:self.view.window];
}

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case TAG_NO_MAIL_AND_TWEET:
        {
            Class twClass = NSClassFromString(@"TWTweetComposeViewController");
            if (twClass) {
                switch (buttonIndex) {
                    case 0:
                        [self sendMail];
                        break;
                    case 1:
                        [self sendTweet];
                        break;
                    case 2:
                        break;
                    default:
                        break;
                }
            } else {
                switch (buttonIndex) {
                    case 0:
                        [self sendMail];
                        break;
                    case 1:
                        break;
                    default:
                        break;
                }
            }
            break;
        }
        case TAG_NO_PHOTO:
        {
            UIImagePickerControllerSourceType sourceType = 99;
            switch (buttonIndex) {
                case 0:
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    if (isLoadPhoto_) {
                        [self deletePhoto];
                    }
                    break;
                case 3:
                    break;
                default:
                    break;
            }
            if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {  
                return;
            }
            if (!(sourceType == UIImagePickerControllerSourceTypeCamera ||
                    sourceType == UIImagePickerControllerSourceTypePhotoLibrary)) {
                return;
            }
            UIImagePickerController *imagePicker;
            imagePicker = [[[UIImagePickerController alloc] init] autorelease];
            imagePicker.sourceType    = sourceType;
            imagePicker.delegate      = self;
            imagePicker.allowsEditing = YES;
            [self presentViewController:imagePicker animated:YES completion: nil];
            break;
        }
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingImage:(UIImage*)image editingInfo:(NSDictionary*)editingInfo
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self dispPhoto:image];
    photoImage_ = image;
    [photoImage_ retain];
    isLoadPhoto_ = TRUE;
    if (objectId_) {
        isUpdatePhoto_ = TRUE;
    }
}


@end
