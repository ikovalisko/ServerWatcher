//
//  ConfigurationController.h
//  ServerWatcher
//
//  Created by Ivan Kovalisko on 19.11.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServerConfiguration;

@interface ConfigurationController : UITableViewController <UITextFieldDelegate> {
    ServerConfiguration *serverConfiguration;
    
    @private
    UITextField *editField_;
}

@property (retain, nonatomic) ServerConfiguration *serverConfiguration;

@end
