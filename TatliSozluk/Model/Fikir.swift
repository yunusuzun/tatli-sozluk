//
//  Fikir.swift
//  TatliSozluk
//
//  Created by Yunus Uzun on 11.05.2020.
//  Copyright © 2020 yunus. All rights reserved.
//

import Foundation

class Fikir {
    private(set) var kullaniciAdi: String!
    private(set) var eklenmeTarihi: Date!
    private(set) var fikirText: String!
    private(set) var yorumSayisi: Int!
    private(set) var begeniSayisi: Int!
    private(set) var documentId: String!
    
    init(kullaniciAdi: String, eklenmeTarihi: Date, fikirText: String, yorumSayisi: Int, begeniSayisi: Int, documentId: String) {
        self.kullaniciAdi = kullaniciAdi
        self.eklenmeTarihi = eklenmeTarihi
        self.fikirText = fikirText
        self.yorumSayisi = yorumSayisi
        self.begeniSayisi = begeniSayisi
        self.documentId = documentId
    }
}
