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
                    return "Long Answer (\(status)): \(card.title): \(card.description)"
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
            
            **Instructions:**
                - **Avoid Repetition**: Do not repeat any of the previous questions listed above.
                - **Rotate Question Types**: Ensure a good mix of True/False, Multiple Choice, Short Answer, and Long Answer questions to keep the user engaged. Avoid consecutive questions of the same type.
                - **Leverage Incorrect Responses**: If a concept has been answered incorrectly multiple times, ask a similar question at an easier level.
                - **Introduce New Concepts**: If the user has correctly answered several questions, introduce slightly more advanced or new topics.
                - **Handle Case Sensitivity**: Use **Long Answer** instead of Short Answer for questions where multiple valid answers might exist, especially in coding or subjective topics.
                - **Edge Case Handling**: If insufficient data is available, start with True/False or Multiple Choice questions to gauge the user’s level.
                - If the user has many incorrect answers, provide simpler questions to build confidence.
                - If the user is performing well, offer more challenging questions to help them grow.
            
            Choose the appropriate card type based on the following:
                1. **True/False**: For simple statements the user can verify as true or false.
                2. **Multiple Choice**: For questions with four possible answers, indicating the correct answer’s index.
                3. **Short Answer**: Use only for precise, case-sensitive responses. Avoid this if multiple correct answers could exist.
                4. **Long Answer**: Use for coding problems or open-ended questions. In coding courses, create a LeetCode-style problem with two test cases the user's solution should pass. Adjust complexity based on the user's performance.
            
            In addition to the question and answer, provide an **explanation** of the correct answer, helping the user understand the logic or concept behind it.
            
            **DO NOT DO THE SAME TYPE OF QUESTION MORE THEN 3 TIMES IN A ROW, THE PREVIOUS QUESTIONS ARE IN ORDER**
            
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
            
            - **Long Answer** (TESTCASE ONLY FOR CODING PROBLEMS DON'T INCLUDE IT FOR REGULAR PROBLEMS) Card**:
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
            You are a problem evaluator.
            
            Evaluate the following response for correctness.
            
            **Problem Title**: \(title)
            **Problem Description**: \(description)
            
            **Example Test Cases**:
            \(formattedTestCases)
            
            **User's Answer**:
            \(userAnswer)
            
            **Problem Explanation**:
            \(explanation)
            
            Determine whether the user's answer is correct based on the problem and example test cases (if its a coding question).
            Respond with **only one word**: "true" if the answer is correct or "false" if it is incorrect.
            Avoid any additional commentary or formatting beyond the single word response.
            """
    }
}
