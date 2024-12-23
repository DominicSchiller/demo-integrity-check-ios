extension Dictionary {
    /// Map the dicionary's keys to new one using the transform closure.
    /// - Parameter transform: The closure to map the existing key to a new key.
    /// - Returns: Dictionary with mapped keys.
    func mapKeys<NewKey: Hashable>(_ transform: (Key) throws -> NewKey) rethrows -> [NewKey: Value] {
        return try Dictionary<NewKey, Value>(
            uniqueKeysWithValues: self.map { (key, value) in
                (try transform(key), value)
            }
        )
    }
}
