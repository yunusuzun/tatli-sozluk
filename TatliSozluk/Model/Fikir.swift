//
//  Fikir.swift
//  TatliSozluk
//
//  Created by Yunus Uzun on 11.05.2020.
//  Copyright © 2020 yunus. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Fikir {
    private(set) var kullaniciAdi: String!
    private(set) var eklenmeTarihi: Date!
    private(set) var fikirText: String!
    private(set) var yorumSayisi: Int!
    private(set) var begeniSayisi: Int!
    private(set) var documentId: String!
    private(set) var kullaniciId: String!
    
    init(kullaniciAdi: String, eklenmeTarihi: Date, fikirText: String, yorumSayisi: Int, begeniSayisi: Int, documentId: String, kullaniciId: String) {
        self.kullaniciAdi = kullaniciAdi
        self.eklenmeTarihi = eklenmeTarihi
        self.fikirText = fikirText
        self.yorumSayisi = yorumSayisi
        self.begeniSayisi = begeniSayisi
        self.documentId = documentId
        self.kullaniciId = kullaniciId
    }
    
    class func fikirGetir(snapshot: QuerySnapshot?) -> [Fikir] {
        var fikirler = [Fikir]()
        
        guard let snap = snapshot else { return fikirler }
        for document in snap.documents {
            let data = document.data()
            
            let kullaniciAdi = data[Kullanici_Adi] as? String ?? "Misafir"
            let ts = data[Eklenme_Tarihi] as? Timestamp ?? Timestamp()
            let eklenmeTarihi = ts.dateValue()
            let fikirText = data[Fikir_Text] as? String ?? ""
            let yorumSayisi = data[Yorum_Sayisi] as? Int ?? 0
            let begeniSayisi = data[Begeni_Sayisi] as? Int ?? 0
            let documentId = document.documentID
            let kullaniciId = data[Kullanici_Id] as? String ?? ""
            
            let yeniFikir = Fikir(kullaniciAdi: kullaniciAdi, eklenmeTarihi: eklenmeTarihi, fikirText: fikirText, yorumSayisi: yorumSayisi, begeniSayisi: begeniSayisi, documentId: documentId, kullaniciId: kullaniciId)
            
            fikirler.append(yeniFikir)
        }
        
        return fikirler
    }
}
