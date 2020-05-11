//
//  YorumCell.swift
//  TatliSozluk
//
//  Created by Yunus Uzun on 11.05.2020.
//  Copyright © 2020 yunus. All rights reserved.
//

import UIKit

class YorumCell: UITableViewCell {
    @IBOutlet weak var lblKullaniciAdi: UILabel!
    @IBOutlet weak var lblTarih: UILabel!
    @IBOutlet weak var lblYorum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func gorunumAyarla(yorum: Yorum) {
        lblKullaniciAdi.text = yorum.kullaniciAdi
        lblYorum.text = yorum.yorumText
        
        let tarihFormat = DateFormatter()
        tarihFormat.dateFormat = "dd MM YYYY, hh:mm"
        let eklenmeTarihi = tarihFormat.string(from: yorum.eklenmeTarihi)
        lblTarih.text = eklenmeTarihi
    }
}
