//
//  FikirCell.swift
//  TatliSozluk
//
//  Created by Yunus Uzun on 11.05.2020.
//  Copyright © 2020 yunus. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class FikirCell: UITableViewCell {
    @IBOutlet weak var lblKullaniciAdi: UILabel!
    @IBOutlet weak var lblFikirText: UILabel!
    @IBOutlet weak var lblEklenmeTarihi: UILabel!
    @IBOutlet weak var lblBegeniSayisi: UILabel!
    @IBOutlet weak var imgBegeni: UIImageView!
    @IBOutlet weak var lblYorumSayisi: UILabel!
    @IBOutlet weak var imgSecenekler: UIImageView!
    
    var secilenFikir: Fikir!
    var delegate: FikirDelegate?
    
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
    
    func gorunumAyarla(fikir: Fikir, delegate: FikirDelegate?) {
        secilenFikir = fikir
        lblKullaniciAdi.text = fikir.kullaniciAdi
        lblFikirText.text = fikir.fikirText
        lblBegeniSayisi.text = String(fikir.begeniSayisi)
        lblYorumSayisi.text = String(fikir.yorumSayisi)
        
        let tarihFormat = DateFormatter()
        tarihFormat.dateFormat = "dd MM YYYY, hh:mm"
        let eklenmeTarihi = tarihFormat.string(from: fikir.eklenmeTarihi)
        lblEklenmeTarihi.text = eklenmeTarihi
        
        self.delegate = delegate
        imgSecenekler.isHidden = true
        imgSecenekler.isUserInteractionEnabled = true
        
        if fikir.kullaniciId == Auth.auth().currentUser?.uid {
            imgSecenekler.isHidden = false
            let tap = UITapGestureRecognizer(target: self, action: #selector(imgBegeniSeceneklerTapped))
            imgSecenekler.addGestureRecognizer(tap)
        }
    }
    
    @objc func imgBegeniSeceneklerTapped() {
        delegate?.seceneklerFikirPressed(fikir: secilenFikir)
    }
}


protocol FikirDelegate {
    func seceneklerFikirPressed(fikir: Fikir)
}
