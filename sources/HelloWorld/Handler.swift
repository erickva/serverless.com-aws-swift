//
//  Handler.swift
//  
//
//  Created by Erick Vavretchek on 9/8/20.
//

import AWSLambdaRuntime

enum Handler: String {
    
    case talkingAboutPost = "TalkingAboutPost"
    case hiredPost = "HiredPost"
    
    static var current: Handler? {
        guard let handler = Lambda.env("_HANDLER") else {
            return nil
        }
        return Handler(rawValue: handler)
    }
}

