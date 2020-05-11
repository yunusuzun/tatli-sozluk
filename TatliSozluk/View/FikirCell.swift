//
//  FikirCell.swift
//  TatliSozluk
//
//  Created by Yunus Uzun on 11.05.2020.
//  Copyright © 2020 yunus. All rights reserved.
//

import UIKit
import FirebaseFirestore

class FikirCell: UITableViewCell {
    @IBOutlet weak var lblKullaniciAdi: UILabel!
    @IBOutlet weak var lblFikirText: UILabel!
    @IBOutlet weak var lblEklenmeTarihi: UILabel!
    @IBOutlet weak var lblBegeniSayisi: UILabel!
    @IBOutlet weak var imgBegeni: UIImageView!
    
    var secilenFikir: Fikir!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgBegeniTapped))
        imgBegeni.addGestureRecognizer(tap)
        imgBegeni.isUserInteractionEnabled = true
    }
    
    @objc func imgBegeniTapped() {
        // Firestore.firestore().collection(Fikirler_Ref).document(secilenFikir.documentId).setData([Begeni_Sayisi: secilenFikir.begeniSayisi + 1], merge: true)
        Firestore.firestore().document("\(Fikirler_Ref)/\(secilenFikir.documentId!)").updateData([Begeni_Sayisi: secilenFikir.begeniSayisi + 1])
    }
    
    func gorunumAyarla(fikir: Fikir) {
        secilenFikir = fikir
        lblKullaniciAdi.text = fikir.kullaniciAdi
        lblFikirText.text = fikir.fikirText
        lblBegeniSayisi.text = String(fikir.begeniSayisi)
        
        let tarihFormat = DateFormatter()
        tarihFormat.dateFormat = "dd MM YYYY, hh:mm"
        let eklenmeTarihi = tarihFormat.string(from: fikir.eklenmeTarihi)
        lblEklenmeTarihi.text = eklenmeTarihi
    }
}
