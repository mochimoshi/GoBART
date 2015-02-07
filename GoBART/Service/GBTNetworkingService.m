//
//  GBTNetworkingService.m
//  GoBART
//
//  Created by Tim Hsieh on 2/6/15.
//  Copyright (c) 2015 Chromatiqa. All rights reserved.
//

#import "GBTNetworkingService.h"
#import <AFNetworking/AFNetworking.h>
#import "GBTTrip.h"
#import "GBTLeg.h"

@interface GBTNetworkingService ()<NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableArray *xmlTripArray;
@property (strong, nonatomic) NSMutableDictionary *xmlAttributeDictionary;
@property (strong, nonatomic) NSMutableDictionary *response;
@property (strong, nonatomic) NSString *elementName;
@property (strong, nonatomic) NSMutableString *outstring;
@property (strong, nonatomic) GBTTrip *currTrip;
@property (strong, nonatomic) NSMutableArray *tripArray;

@end

@implementation GBTNetworkingService

static NSString *kPublicKey = @"MW9S-E7SL-26DU-VV8V";

static NSString *kArriveCommand = @"arrive";
static NSString *kDepartCommand = @"depart";
static NSString *kEtdCommand = @"etd";

static NSString *kRoutesBaseURL = @"http://api.bart.gov/api/sched.aspx?";
static NSString *kTrainsBaseURL = @"http://api.bart.gov/api/etd.aspx?";

+ (instancetype)sharedNetworkingService {
    
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

//
- (void)getRoutesWithOrig:(NSString *)orig atDest:(NSString *)dest atTime:(NSDate *)date withCommand:(NSString *)command {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    NSString *dateQuery = [formatter stringFromDate:date];
    [formatter setDateFormat:@"HH:mm+a"];
    NSString *timeQuery = [formatter stringFromDate:date];

    NSString *routesURL = [NSString stringWithFormat:@"%@cmd=%@&key=%@&orig=%@&dest=%@&date=%@&time=%@", kRoutesBaseURL, command, kPublicKey, orig, dest, dateQuery, timeQuery];
    NSURL *url = [NSURL URLWithString:routesURL];
    
    NSURL *url = [NSURL URLWithString:kRoutesBaseURL];
    url = [url URLByAppendingPathComponent:[NSString stringWithFormat:@"cmd=%@&orig=%@&dest=%@&date=%@&time=%@", command, orig, dest, dateQuery, timeQuery]];
    [self getRequestWithURL:url];
}

- (void)getTrainsWithStation:(NSString *)station {
    NSURL *url = [NSURL URLWithString:kTrainsBaseURL];
    url = [url URLByAppendingPathComponent:[NSString stringWithFormat:@"cmd=%@&orig=%@&key=%@", kEtdCommand, station, kPublicKey]];
    [self getRequestWithURL:url];
}

- (void)getRequestWithURL:(NSURL *)url {
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
        GBTTrip *trip = [[GBTTrip alloc] initTripWithAttributes:attributeDict];
        [self.xmlTripArray addObject:trip];
        self.currTrip = trip;
    }
    else if ([qName isEqualToString:@"leg"]) {
        GBTLeg *leg = [[GBTLeg alloc] initLegWithAttributes:attributeDict];
        [self.currTrip.tripLegsArray addObject:leg];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!self.elementName) return;
    [self.outstring appendFormat:@"%@", string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"xmlTripArray: %@", self.xmlTripArray);
}

@end
