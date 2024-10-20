//
//  APIService.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import Foundation

struct APIResponse: Decodable {
    let statusCode: Int
    let body: String
}


enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingError
    case invalidResponse
}

class APIService {
    static let shared = APIService()

    private init() {}

    private let apiURL = URL(string: "https://zyb452y3nk.execute-api.us-west-2.amazonaws.com/dev/generateCard")

    func generateCard(courseTitle: String, courseDescription: String, correctCount: Int, incorrectCount: Int, previousQuestions: [CardModel]) async throws -> CardModel {
            guard let url = apiURL else { throw APIError.invalidURL }

            // Generate the prompt
            let prompt = PromptGenerator.generatePrompt(
                courseTitle: courseTitle,
                courseDescription: courseDescription,
                correctCount: correctCount,
                incorrectCount: incorrectCount,
                previousQuestions: previousQuestions
            )

            // Prepare request with AWS credentials and prompt
            let payload: [String: Any] = [
                "prompt": prompt,
                "awsAccessKeyId": Secrets.shared.get(key: "AWS_ACCESS_KEY_ID"),
                "awsSecretAccessKey": Secrets.shared.get(key: "AWS_SECRET_ACCESS_KEY"),
                "awsSessionToken": Secrets.shared.get(key: "AWS_SESSION_TOKEN")
            ]

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])

            let (data, response) = try await URLSession.shared.data(for: request)

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON: \(jsonString)")
            }

            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                throw APIError.invalidResponse
            }

            // Decode the top-level API response
            let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)

            // Convert the body string to Data
            guard let bodyData = apiResponse.body.data(using: .utf8) else {
                throw APIError.decodingError
            }

            // Decode the CardModel from the body data
            let card = try JSONDecoder().decode(CardModel.self, from: bodyData)
            return card
        }
    
    func validateLongAnswer(
            title: String,
            description: String,
            testCases: [CardModel.TestCase],
            userAnswer: String,
            explanation: String
        ) async throws -> Bool {
            guard let url = apiURL else { throw APIError.invalidURL }

            let prompt = PromptGenerator.generateValidationPrompt(title: title, description: description, testCases: testCases, userAnswer: userAnswer, explanation: explanation)

            let payload: [String: Any] = [
                "prompt": prompt,
                "awsAccessKeyId": Secrets.shared.get(key: "AWS_ACCESS_KEY_ID"),
                "awsSecretAccessKey": Secrets.shared.get(key: "AWS_SECRET_ACCESS_KEY"),
                "awsSessionToken": Secrets.shared.get(key: "AWS_SESSION_TOKEN")
            ]

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: [])

            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response JSON: \(jsonString)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                throw APIError.invalidResponse
            }
            
            let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)

            return apiResponse.body.lowercased() == "true"
        }
}
