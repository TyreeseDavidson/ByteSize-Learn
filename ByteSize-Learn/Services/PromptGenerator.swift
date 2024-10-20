//
//  PromptGenerator.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import Foundation

struct PromptGenerator {
    static func generatePrompt(courseTitle: String, courseDescription: String, correctCount: Int, incorrectCount: Int, previousQuestions: [CardModel]) -> String {
            
            // Format the previous questions to include their titles or descriptions
            let formattedPreviousQuestions = previousQuestions.map { card in
                let status: String
                switch card.isCorrect {
                case 1:
                    status = "Got it Correct!"
                case -1:
                    status = "Got it Wrong"
                case 3:
                    status = "Skipped"
                case _:
                    status = "Hasn't seen it yet"
                }
                
                switch card.type {
                case .TrueFalse:
                    return "True/False (\(status)): \(card.title): \(card.description)"
                case .MultipleChoice:
                    return "Multiple Choice (\(status)): \(card.title): \(card.description)"
                case .ShortAnswer:
                    return "Short Answer (\(status)): \(card.title): \(card.description)"
                case .LongAnswer:
                    return "Long Answer (Coding | \(status)): \(card.title): \(card.description)"
                case .Text:
                    return "Text: \(card.title)"
                }
            }.joined(separator: "\n")
            
            return """
            You are an educational content generator for the course titled "\(courseTitle)" with the following description:
            
            "\(courseDescription)"
            
            The user has answered \(correctCount) questions correctly and \(incorrectCount) questions incorrectly. Based on their performance, generate a new learning card that adapts to their current skill level.
            
            **Previous Questions Asked:**
            \(formattedPreviousQuestions)
            
            **Instruction:** Ensure that the new question does not repeat any of the previous questions listed above.
            
            Choose one of the following card types based on the user's performance, keep in mind what previous questions they got wrong or right and what they might need more practice on:
            
            1. **True/False**: Provide a statement that the user can verify as true or false.
            2. **Multiple Choice**: Provide a question with four possible answers, indicating the index of the correct answer.
            3. **Short Answer**: Provide a question that requires a brief textual response.
            4. **Long Answer (Coding Only)**: Provide a coding problem similar to LeetCode, including two example test cases that the user's solution should pass.
            
            Ensure the difficulty of the question is appropriate based on the user's performance: if they have more incorrect answers, provide an easier question; if they have more correct answers, you may provide a more challenging question.
            
            In addition to the question and answer, provide an **explanation** of the correct answer, helping the user understand the logic or concept behind it.
            
            Provide the information in the following JSON format, filling in only the relevant fields based on the card type:
            
            - **True/False Card**:
                ```json
                {
                    "type": "TrueFalse",
                    "title": "Statement Title",
                    "description": "Statement Description",
                    "truefalse": true,
                    "explanation": "Explanation of why the answer is true or false."
                }
                ```
            
            - **Multiple Choice Card**:
                ```json
                {
                    "type": "MultipleChoice",
                    "title": "Question Title",
                    "description": "Question Description",
                    "options": ["Option 1", "Option 2", "Option 3", "Option 4"],
                    "correctIndex": 1,
                    "explanation": "Explanation of why the correct option is correct."
                }
                ```
            
            - **Short Answer Card**:
                ```json
                {
                    "type": "ShortAnswer",
                    "title": "Question Title",
                    "description": "Question Description",
                    "answer": "Expected Answer",
                    "explanation": "Explanation of the correct answer."
                }
                ```
            
            - **Long Answer (Coding) Card**:
                ```json
                {
                    "type": "LongAnswer",
                    "title": "Problem Title",
                    "description": "Problem Description",
                    "testCases": [
                        {"input": "Test Input 1", "output": "Expected Output 1"},
                        {"input": "Test Input 2", "output": "Expected Output 2"}
                    ],
                    "explanation": "Explanation of the correct solution and test case results."
                }
                ```
            
            Ensure that the JSON is valid and matches the structure required for the selected card type.
            Ensure that the JSON output follows the exact structure provided, with no extra fields or formatting variations.
            ONLY PROVIDE THE JSON OUTPUT NOTHING ELSE
            """
        }
    
    static func generateValidationPrompt(title: String, description: String, testCases: [CardModel.TestCase], userAnswer: String, explanation: String) -> String {
        let formattedTestCases = testCases.map { testCase in
            "Input: \(testCase.input) → Output: \(testCase.output)"
        }.joined(separator: "\n")
        
        return """
            You are a coding problem evaluator.
            
            Evaluate the following response for correctness.
            
            **Problem Title**: \(title)
            **Problem Description**: \(description)
            
            **Example Test Cases**:
            \(formattedTestCases)
            
            **User's Answer**:
            \(userAnswer)
            
            **Problem Explanation**:
            \(explanation)
            
            Determine whether the user's answer is correct based on the problem and example test cases.
            Respond with **only one word**: "true" if the answer is correct or "false" if it is incorrect.
            Avoid any additional commentary or formatting beyond the single word response.
            """
    }
}
