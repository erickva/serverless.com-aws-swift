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

// IMPORTANT!!
// When using API Gateway, I don't know why, but
// it will wrap our JSON request into a property called "body"
// This means, if you are passing {"name":"My Name"} in your request,
// API Gateway will transform it into {"body":{"name":"My Name"}, ...}
// This is why we need to extract our Object from body.
// WARNING: Because of this, when testing the function in AWS Console,
// where you pass a proper JSON, without the "body", your test will fail.
// This will only work when calling through the API Gateway
// A custom Decodable would have to be implemented if you want it to work
// in all scenarios.

private struct Request: Codable {
    let person: Person
    enum CodingKeys: String, CodingKey {
      case person = "body"
    }
}

private struct Person: Codable {
  let name: String
}

private struct Response: Codable {
  let message: String
}

Lambda.run { (context, request: Request, callback: @escaping (Result<Response, Error>) -> Void) in
    context.logger.debug("Alo vc!!")
    callback(.success(Response(message: "\(request.person.name)")))
}
