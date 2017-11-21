//
//  BaseTaskNetwork.m
//
//  Created by Le Cong on 5/13/16.
//
//

#import "BaseTaskNetwork.h"
#import "AFNetworking.h"

@interface BaseTaskNetwork()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSURLSessionConfiguration *configuration;

@end

@implementation BaseTaskNetwork {
    NSURLSessionDataTask *_task;
}

- (id)init {
    self = [super init];
    if (self) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [_manager.requestSerializer setTimeoutInterval:30];
        
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

- (void)requestWithBlockSucess:(BlockSuccess)success andBlockFailure:(BlockFailure)failure {
    NSMutableURLRequest *request = [self getRequest];
    
    _task = [_manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (failure) {
                failure(error.localizedDescription);
            }
            return;
        }
        if (success) {
            success([self dataWithResponse:responseObject]);
        }
    }];
    [_task resume];
}

- (void)downloadJSONSuccess:(BlockSuccess)success andFailure:(BlockFailure)failure {
    NSURL *URL = [NSURL URLWithString:[self urlString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [_manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *fileUrl = [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtURL:fileUrl error:nil];
        return fileUrl;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        if (!error) {
            id jsonResponse = [self jsonFromFileUrl:filePath];
            id data = [self dataWithResponse:jsonResponse];
            success(data);
        } else {
            failure(error.localizedDescription);
        }
    }];
    [downloadTask resume];
}

- (void)downloadFileSuccess:(BlockSuccess)success andFailure:(BlockFailure)failure {
    [self downloadFileWithProgress:nil success:success andFailure:failure];
}

- (void)downloadFileWithProgress:(BlockProgress)blockProgress success:(BlockSuccess)success andFailure:(BlockFailure)failure {
    NSURL *URL = [NSURL URLWithString:[self pathFileDownload]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [_manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        if (!error) {
            success(filePath);
        } else {
            failure(error.localizedDescription);
        }
    }];
    
    [_manager setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (blockProgress) {
                CGFloat downloadProgress = (float)totalBytesWritten / (float)totalBytesExpectedToWrite;
                blockProgress(downloadProgress);
            }
        });
    }];
    [downloadTask resume];
}

- (void)upLoadFileWith:(BlockSuccess)success andFailuer:(BlockFailure)failure {
    NSData *data = [self imageUpload];
    NSString *name = [self parameterOfFile];
    NSMutableURLRequest *request =
    [[AFHTTPRequestSerializer serializer]
     multipartFormRequestWithMethod: [self getMethod]
     URLString: [self urlString]
     parameters: [self parameters]
     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
         [formData appendPartWithFileData:data
                                     name:name
                                 fileName:@"avatar.jpeg"
                                 mimeType:@"png/jped"];
     } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager uploadTaskWithStreamedRequest:request
                                               progress:^(NSProgress * _Nonnull uploadProgress) {
                                                   
                                               } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                   if (error) {
                                                       if (failure) {
                                                           failure(error.localizedDescription);
                                                       }
                                                       return;
                                                   }
                                                   if (success) {
                                                       success([self dataWithResponse:responseObject]);
                                                       
                                                   }
                                               }];
    
    [uploadTask resume];
}

#pragma mark - Private Method

- (id)jsonFromFileUrl:(NSURL *)fileUrl {
    NSData *data = [NSData dataWithContentsOfURL:fileUrl];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (NSMutableURLRequest *)getRequest {
    NSString *urlString             = [self urlString];
    NSDictionary *parameters        = [self parameters];
    NSString *method                = [self getMethod];
    NSMutableURLRequest *request    = [self requestWithMethod:method
                                                    urlString:urlString
                                                andParameters:parameters];
    return request;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 urlString:(NSString *)urlString
                             andParameters:(NSDictionary *)parameters {
    return [[AFHTTPRequestSerializer serializer] requestWithMethod:method
                                                         URLString:urlString
                                                        parameters:parameters error:nil];
}

- (NSString *)getMethod {
    return [self method];
}

#pragma mark - Method Override Sub Class

- (NSString *)urlString {
    //    return [NSString stringWithFormat:@"%@%@",@"http://192.168.1.100:8080/studyapp", [self path]];
    return [NSString stringWithFormat:@"%@%@",@"http://studyapp.transoftvietnam.com", [self path]];
}

- (NSString *) parameterOfFile {
    return @"";
}

- (NSData *) imageUpload {
    return nil;
}

- (NSString *) pathFileDownload {
    return @"";
}

- (NSString *)path {
    return @"";
}

- (NSString *)method {
    return GET;
}

- (NSDictionary *)parameters {
    return nil;
}

- (id)dataWithResponse:(id)response {
    return response;
}

@end
