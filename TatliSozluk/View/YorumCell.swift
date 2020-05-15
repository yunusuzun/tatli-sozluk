//
//  YorumCell.swift
//  TatliSozluk
//
//  Created by Yunus Uzun on 11.05.2020.
//  Copyright © 2020 yunus. All rights reserved.
//

import UIKit
import FirebaseAuth

class YorumCell: UITableViewCell {
    @IBOutlet weak var lblKullaniciAdi: UILabel!
    @IBOutlet weak var lblTarih: UILabel!
    @IBOutlet weak var lblYorum: UILabel!
    @IBOutlet weak var imgSecenekler: UIImageView!
    
    var delegate: YorumDelegate?
    var secilenYorum: Yorum!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func gorunumAyarla(yorum: Yorum, delegate: YorumDelegate) {
        lblKullaniciAdi.text = yorum.kullaniciAdi
        lblYorum.text = yorum.yorumText
        
        let tarihFormat = DateFormatter()
        tarihFormat.dateFormat = "dd MM YYYY, hh:mm"
        let eklenmeTarihi = tarihFormat.string(from: yorum.eklenmeTarihi)
        lblTarih.text = eklenmeTarihi
        
        imgSecenekler.isHidden = true
        imgSecenekler.isUserInteractionEnabled = true
        secilenYorum = yorum
        self.delegate = delegate
        
        if yorum.kullaniciId == Auth.auth().currentUser?.uid {
            imgSecenekler.isHidden = false
            let tap = UITapGestureRecognizer(target: self, action: #selector(imgYorumSeceneklerTapped))
            imgSecenekler.addGestureRecognizer(tap)
        }
    }
    
    @objc func imgYorumSeceneklerTapped() {
        delegate?.seceneklerYorumPressed(yorum: secilenYorum)
    }
}

protocol YorumDelegate {
    func seceneklerYorumPressed(yorum: Yorum)
}
