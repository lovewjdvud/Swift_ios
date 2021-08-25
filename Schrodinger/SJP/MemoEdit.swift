//
//  MemoEdit.swift
//  Schrodinger
//
//  Created by 송정평 on 2021/08/04.
//

protocol MemoEdit {
    func didMessageEditDone(_ controller: MemoViewController, message: String)
}
