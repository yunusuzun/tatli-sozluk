//
//  FikirEkleVC.swift
//  TatliSozluk
//
//  Created by Yunus Uzun on 8.05.2020.
//  Copyright © 2020 yunus. All rights reserved.
//

import UIKit

class FikirEkleVC: UIViewController {
    @IBOutlet weak var sgmntKategoriler: UISegmentedControl!
    @IBOutlet weak var txtKullaniciAdi: UITextField!
    @IBOutlet weak var txtFikir: UITextView!
    @IBOutlet weak var btnPaylas: UIButton!
    
    let placeholder = "Fikir..."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnPaylas.layer.cornerRadius = 5
        txtFikir.layer.cornerRadius = 5
        txtFikir.layer.borderWidth = 1
        txtFikir.layer.borderColor = UIColor.lightGray.cgColor
        txtFikir.text = placeholder
        txtFikir.textColor = UIColor.lightGray
    }
    
    @IBAction func btnPaylasPressed(_ sender: Any) {
    }
    
    @IBAction func sgmntKategoriDegisti(_ sender: Any) {
    }
}

extension FikirEkleVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
            textView.textColor = .darkGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            txtFikir.textColor = .lightGray
            textView.text = placeholder
        }
    }
}
