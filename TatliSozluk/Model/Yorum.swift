//
//  Yorum.swift
//  TatliSozluk
//
//  Created by Yunus Uzun on 11.05.2020.
//  Copyright © 2020 yunus. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Yorum {
    private(set) var kullaniciAdi: String!
    private(set) var eklenmeTarihi: Date!
    private(set) var yorumText: String!
    
    init(kullaniciAdi: String, eklenmeTarihi: Date, yorumText: String) {
        self.kullaniciAdi = kullaniciAdi
        self.eklenmeTarihi = eklenmeTarihi
        self.yorumText = yorumText
    }
    
    class func yorumlariGetir(snapshot: QuerySnapshot?) -> [Yorum] {
        var yorumlar = [Yorum]()
        guard let snap = snapshot else { return yorumlar }
        
        for kayit in snap.documents {
            let veri = kayit.data()
            let kullaniciAdi = veri[Kullanici_Adi] as? String ?? "Misafir"
            let ts = veri[Eklenme_Tarihi] as? Timestamp ?? Timestamp()
            let eklenmeTarihi = ts.dateValue()
            let yorumText = veri[Yorum_Text] as? String ?? ""
            let yeniYorum = Yorum(kullaniciAdi: kullaniciAdi, eklenmeTarihi: eklenmeTarihi, yorumText: yorumText)
            yorumlar.append(yeniYorum)
        }
        return yorumlar
    }
}
