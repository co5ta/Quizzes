//
//  Question.h
//  Quizzes
//
//  Created by co5ta on 16/12/2020.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Question : NSObject
@property NSString *title;
@property NSString *response;
@property NSArray<NSString*> *options;
@end

NS_ASSUME_NONNULL_END
