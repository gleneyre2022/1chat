//
//  RepeatChecker.swift
//  1chat
//
//  Created by OJZen on 2025/2/25.
//


class RepeatChecker {
    private let maxRepeatCount: Int
    private let minSubLength: Int
    private let maxSubLength: Int

    init(maxRepeatCount: Int = 10, minSubLength: Int = 12, maxSubLength: Int = 18) {
        self.maxRepeatCount = maxRepeatCount
        self.minSubLength = minSubLength
        self.maxSubLength = maxSubLength
    }

    /// 检测 tokens 数组中是否有大量重复的 token 序列
    func hasExcessiveRepetition(in tokens: [Int]) -> Bool {
        guard tokens.count >= minSubLength else { return false }

        for len in minSubLength...maxSubLength {
            if tokens.count < len { continue }

            var seen: [String: Int] = [:] // 使用字符串键值存储 token 序列哈希
            let tokenCount = tokens.count

            for i in 0...(tokenCount - len) {
                let subTokens = tokens[i..<(i + len)]
                let key = subTokens.map { String($0) }.joined(separator: ",") // 生成唯一 key
                seen[key, default: 0] += 1

                if seen[key]! >= maxRepeatCount {
                    print("检测到重复序列：\(subTokens) 重复了 \(maxRepeatCount) 次")
                    return true
                }
            }
        }
        return false
    }
}
