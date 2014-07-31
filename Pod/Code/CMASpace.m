//
//  CMASpace.m
//  ManagementSDK
//
//  Created by Boris Bügling on 15/07/14.
//  Copyright (c) 2014 Boris Bügling. All rights reserved.
//

#import "CDAClient+Private.h"
#import "CDAResource+Management.h"
#import "CMASpace+Private.h"

@interface CMASpace ()

@property (nonatomic) CDAClient* apiClient;;

@end

#pragma mark -

@implementation CMASpace

@dynamic name;

#pragma mark -

-(CDAClient *)client {
    return self.apiClient;
}

-(void)setClient:(CDAClient *)client {
    NSParameterAssert(client);
    self.apiClient = [client copyWithSpace:self];
}

-(CDARequest *)createAssetWithFields:(NSDictionary *)fields
                             success:(CMAAssetFetchedBlock)success
                             failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client postURLPath:@"assets"
                            headers:nil
                         parameters:@{ @"fields": fields }
                            success:success
                            failure:failure];
}

-(CDARequest *)createAssetWithIdentifier:(NSString*)identifier
                                  fields:(NSDictionary *)fields
                                 success:(CMAAssetFetchedBlock)success
                                 failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client putURLPath:[@"assets" stringByAppendingPathComponent:identifier]
                           headers:nil
                        parameters:@{ @"fields": fields }
                           success:success
                           failure:failure];
}

-(CDARequest *)createContentTypeWithName:(NSString*)name
                                  fields:(NSArray*)fields
                                 success:(CMAContentTypeFetchedBlock)success
                                 failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);

    NSArray* fieldsAsDictionaries = fields ? [fields valueForKey:@"dictionaryRepresentation"] : @[];

    return [self.client postURLPath:@"content_types"
                            headers:nil
                         parameters:@{ @"name": name, @"fields": fieldsAsDictionaries }
                            success:success
                            failure:failure];
}

-(CDARequest *)createEntryOfContentType:(CMAContentType*)contentType
                             withFields:(NSDictionary *)fields
                                success:(CMAEntryFetchedBlock)success
                                failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client postURLPath:@"entries"
                            headers:@{ @"X-Contentful-Content-Type": contentType.identifier }
                         parameters:@{ @"fields": fields }
                            success:success
                            failure:failure];
}

-(CDARequest *)createEntryOfContentType:(CMAContentType *)contentType
                         withIdentifier:(NSString *)identifier
                                 fields:(NSDictionary *)fields
                                success:(CMAEntryFetchedBlock)success
                                failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client putURLPath:[@"entries" stringByAppendingPathComponent:identifier]
                           headers:@{ @"X-Contentful-Content-Type": contentType.identifier }
                        parameters:@{ @"fields": fields }
                           success:success
                           failure:failure];
}

-(CDARequest *)deleteWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performDeleteToFragment:@"" withSuccess:success failure:failure];
}

-(CDARequest *)fetchAssetWithIdentifier:(NSString *)identifier
                                success:(CMAAssetFetchedBlock)success
                                failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client fetchAssetWithIdentifier:identifier
                                         success:^(CDAResponse *response, CDAAsset *asset) {
                                             if (success) {
                                                 success(response, (CMAAsset*)asset);
                                             }
                                         } failure:failure];
}

-(CDARequest *)fetchContentTypesWithSuccess:(CDAArrayFetchedBlock)success
                                    failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client fetchContentTypesWithSuccess:success failure:failure];
}

-(CDARequest *)fetchContentTypeWithIdentifier:(NSString *)identifier
                                      success:(CMAContentTypeFetchedBlock)success
                                      failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client fetchContentTypeWithIdentifier:identifier
                                               success:^(CDAResponse *response,
                                                         CDAContentType *contentType) {
                                                   if (success) {
                                                       success(response, (CMAContentType*)contentType);
                                                   }
                                               } failure:failure];
}

-(CDARequest *)fetchEntryWithIdentifier:(NSString *)identifier
                                success:(CDAEntryFetchedBlock)success
                                failure:(CDARequestFailureBlock)failure {
    NSParameterAssert(self.client);
    return [self.client fetchEntryWithIdentifier:identifier success:success failure:failure];
}

-(CDARequest *)updateWithSuccess:(void (^)())success failure:(CDARequestFailureBlock)failure {
    return [self performPutToFragment:@""
                       withParameters:@{ @"name": self.name }
                              success:success
                              failure:failure];
}

-(NSString *)URLPath {
    return @"";
}

@end
