//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftAWSLambdaRuntime open source project
//
// Copyright (c) 2020 Apple Inc. and the SwiftAWSLambdaRuntime project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftAWSLambdaRuntime project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//
import AWSLambdaRuntime
import AWSLambdaEvents
import Foundation
import NIO

let jsonHeaders = [
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "OPTIONS,GET,POST,PUT,DELETE",
    "Access-Control-Allow-Credentials": "true",
]

Lambda.run(APIGatewayProxyLambda())

struct APIGatewayProxyLambda: EventLoopLambdaHandler {
    public typealias In = APIGateway.V2.Request
    public typealias Out = APIGateway.V2.Response

    public func handle(context: Lambda.Context, event: APIGateway.V2.Request) -> EventLoopFuture<APIGateway.V2.Response> {
        context.logger.debug("hello, api gateway!")
        guard let handler = Handler.current else {
            return context.eventLoop.makeFailedFuture(ApiError.whatever)
        }
        
        switch handler {
        case .talkingAboutPost:
            let talkingAboutPost = TalkingAboutPost()
            return talkingAboutPost.handle(context: context, event: event)
        case .hiredPost:
            let hiredPost = HiredPost()
            return hiredPost.handle(context: context, event: event)
        }
    }
}

struct TalkingAboutPost: EventLoopLambdaHandler {
    
    typealias In = APIGateway.V2.Request
    typealias Out = APIGateway.V2.Response
    
    struct Person: Codable {
        let name: String
    }
    
    struct MessageResponse: Codable {
        let message: String
    }
    
    
    func handle(context: Lambda.Context, event: APIGateway.V2.Request) -> EventLoopFuture<APIGateway.V2.Response> {

        if let jsonData = event.body?.data(using: .utf8) {
            let person = try! JSONDecoder().decode(Person.self, from: jsonData)
            
            
            var body: String = "{}"
            let reponse = MessageResponse(message: "We are talking about: \(person.name)")
            if let data = try? JSONEncoder().encode(reponse) {
                body = String(data: data, encoding: .utf8) ?? body
            }
            
            return context.eventLoop.makeSucceededFuture(
                APIGateway.V2.Response(
                    statusCode: .ok,
                    headers: jsonHeaders,
                    body: body
                )
            )
        } else {
            return context.eventLoop.makeFailedFuture(ApiError.whatever)
        }
    }
}

struct HiredPost: EventLoopLambdaHandler {
    
    typealias In = APIGateway.V2.Request
    typealias Out = APIGateway.V2.Response
    
    struct Person: Codable {
        let name: String
    }
    
    struct MessageResponse: Codable {
        let message: String
    }
    
    
    func handle(context: Lambda.Context, event: APIGateway.V2.Request) -> EventLoopFuture<APIGateway.V2.Response> {

        if let jsonData = event.body?.data(using: .utf8) {
            let person = try! JSONDecoder().decode(Person.self, from: jsonData)
            
            
            var body: String = "{}"
            let reponse = MessageResponse(message: "\(person.name) is hired!")
            if let data = try? JSONEncoder().encode(reponse) {
                body = String(data: data, encoding: .utf8) ?? body
            }
            
            return context.eventLoop.makeSucceededFuture(
                APIGateway.V2.Response(
                    statusCode: .ok,
                    headers: jsonHeaders,
                    body: body
                )
            )
        } else {
            return context.eventLoop.makeFailedFuture(ApiError.whatever)
        }
    }
}



enum ApiError: Error {
    case whatever
}
