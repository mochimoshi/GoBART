//
//  GBTNetworkingService.m
//  GoBART
//
//  Created by Tim Hsieh on 2/6/15.
//  Copyright (c) 2015 Chromatiqa. All rights reserved.
//

#import "GBTNetworkingService.h"

#import <AFNetworking/AFNetworking.h>

@interface GBTNetworkingService ()<NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableArray *xmlTripArray;
@property (strong, nonatomic) NSMutableDictionary *xmlAttributeDictionary;
@property (strong, nonatomic) NSMutableDictionary *response;
@property (strong, nonatomic) NSString *elementName;
@property (strong, nonatomic) NSMutableString *outstring;

@end

@implementation GBTNetworkingService

static NSString *kPublicKey = @"MW9S-E7SL-26DU-VV8V";

static NSString *kArriveCommand = @"arrive";
static NSString *kDepartCommand = @"depart";

static NSString *kRoutesBaseURL = @"http://api.bart.gov/api/sched.aspx?cmd=arrive&date=now";

+ (instancetype)sharedNetworkingService {
    
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

//
- (void)getRoutesWithOrig:(NSString *)orig dest:(NSString *)dest {
    NSURL *url = [NSURL URLWithString:kRoutesBaseURL];
    url = [url URLByAppendingPathComponent:[NSString stringWithFormat:@"cmd=%@&orig=%@&dest=%@&date=%@", kArriveCommand, orig, dest, @"now"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    if (!request) {
        NSLog(@"Malformed request");
    }

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    if (!operation.responseSerializer) {
        NSLog(@"nil");
    }

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSXMLParser *XMLParser = (NSXMLParser *)responseObject;
        [XMLParser setShouldProcessNamespaces:YES];
        XMLParser.delegate = self;
        [XMLParser parse];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error!", nil)
                                                        message:NSLocalizedString(@"Error while trying to reach server. Please try again later.", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Okay", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }];
    [operation start];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    self.xmlTripArray = [NSMutableArray array];
    self.xmlAttributeDictionary = [NSMutableDictionary dictionary];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    self.elementName = qName;
    if ([qName isEqualToString:@"trip"]) {
        NSLog(@"%@: departure:%@ arrival %@", qName, attributeDict[@"origTimeMin"], attributeDict[@"destTimeMin"]);
    }
    else if ([qName isEqualToString:@"leg"]) {
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!self.elementName) return;
    [self.outstring appendFormat:@"%@", string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([qName isEqualToString:@"schedule"]) {
        
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    return;
}

@end
