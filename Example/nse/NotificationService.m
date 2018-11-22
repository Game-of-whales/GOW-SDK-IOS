#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    NSLog(@"NotificationService::didReceiveNotificationRequest");
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    NSString *attachmentUrlString = [request.content.userInfo objectForKey:@"image"];
    
    for(NSString *key in [request.content.userInfo allKeys]) {
        NSLog(@"NotificationService:dict %@ %@", key, [request.content.userInfo objectForKey:key]);
    }
    
    NSLog(@"NotificationService::attachmentUrlString %@", attachmentUrlString);
    
    if (![attachmentUrlString isKindOfClass:[NSString class]])
        return;
    
    NSLog(@"NotificationService::getting url");
    NSURL *url = [NSURL URLWithString:attachmentUrlString];
    if (!url)
        return;
    [url filePathURL];
    
    NSLog(@"NotificationService::downloading");
    [[[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"NotificationService::donwloaded");
            NSString *tempDict = NSTemporaryDirectory();
            NSString *attachmentID = [[[NSUUID UUID] UUIDString] stringByAppendingString:[response.URL.absoluteString lastPathComponent]];
            
            if(response.suggestedFilename)
                attachmentID = [[[NSUUID UUID] UUIDString] stringByAppendingString:response.suggestedFilename];
            
            NSLog(@"NotificationService::abs %@", location.filePathURL.absoluteString);
            
            
            /*NSError * err = NULL;
            NSFileManager * fm = [[NSFileManager alloc] init];
            BOOL result = [fm moveItemAtPath:attachmentID toPath:@"/tmp/dstpath.tt" error:&err];
            if(!result)
                NSLog(@"Error: %@", err);
            [fm release];
            */
            
            
            NSString *tempFilePath = [tempDict stringByAppendingPathComponent:attachmentID];
            NSLog(@"NotificationService::tempFilePath %@", tempFilePath);
            
            if ([[NSFileManager defaultManager] moveItemAtPath:location.path toPath:tempFilePath error:&error]) {
                UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:attachmentID URL:[NSURL fileURLWithPath:tempFilePath] options:nil error:&error];
                
                if (!attachment) {
                    NSLog(@"NotificationService::Create attachment error: %@", error);
                } else {
                    _bestAttemptContent.attachments = [_bestAttemptContent.attachments arrayByAddingObject:attachment];
                }
            } else {
                NSLog(@"NotificationService::Move file error: %@", error);
            }
        } else {
            NSLog(@"NotificationService::Download file error: %@", error);
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.contentHandler(self.bestAttemptContent);
        }];
    }] resume];
}

- (void)serviceExtensionTimeWillExpire {
    NSLog(@"NotificationService::serviceExtensionTimeWillExpire");
    self.contentHandler(self.bestAttemptContent);
}

@end
