//
//  SevenBag.swift
//  TetrisEngine
//
//  Created by Kostas on 29/11/2025.
//

// https://tetris.wiki/Random_Generator

public class SevenBag<T: Hashable> {
    private var elements: Set<T>
    private var storage: [T]

    public init(things: Set<T>) {
        self.elements = things
        self.storage = Array(things).shuffled()
    }

    public var next: T? {
        if storage.isEmpty {
            storage = Array(elements).shuffled()
        }

        return storage.removeFirst()
    }
}
