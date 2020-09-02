//
//  FikirEkleVC.swift
//  TatliSozluk
//
//  Created by Yunus Uzun on 8.05.2020.
//  Copyright © 2020 yunus. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class FikirEkleVC: UIViewController {
    @IBOutlet weak var sgmntKategoriler: UISegmentedControl!
    @IBOutlet weak var txtKullaniciAdi: UITextField!
    @IBOutlet weak var txtFikir: UITextView!
    @IBOutlet weak var btnPaylas: UIButton!
    
    let placeholder = "Fikir..."
    var secilenKategori = Kategoriler.Eglence.rawValue
    var kullaniciAdi: String = "misafir"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnPaylas.layer.cornerRadius = 5
        txtFikir.layer.cornerRadius = 5
        txtFikir.layer.borderWidth = 1
        txtFikir.layer.borderColor = UIColor.lightGray.cgColor
        txtFikir.text = placeholder
        txtFikir.textColor = UIColor.lightGray
        txtFikir.delegate = self
        txtKullaniciAdi.isEnabled = false
        if let adi = Auth.auth().currentUser?.displayName {
            kullaniciAdi = adi
            txtKullaniciAdi.text = kullaniciAdi
        }
    }
    
    @IBAction func btnPaylasPressed(_ sender: Any) {
        guard txtFikir.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty != true else { return }
        
        Firestore.firestore().collection("Fikirler").addDocument(data: [
            Kategori: secilenKategori,
            Begeni_Sayisi: 0,
            Yorum_Sayisi: 0,
            Fikir_Text: txtFikir.text!,
            Eklenme_Tarihi: FieldValue.serverTimestamp(),
            Kullanici_Adi: kullaniciAdi,
            Kullanici_Id: Auth.auth().currentUser?.uid ?? ""
        ]) { (error) in
            if let error = error {
                print("Döküman hatası: \(error.localizedDescription)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func sgmntKategoriDegisti(_ sender: Any) {
        switch sgmntKategoriler.selectedSegmentIndex {
        case 0:
            secilenKategori = Kategoriler.Eglence.rawValue
        case 1:
            secilenKategori = Kategoriler.Absurt.rawValue
        case 2:
            secilenKategori = Kategoriler.Gundem.rawValue
        default:
            secilenKategori = Kategoriler.Eglence.rawValue
        }
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
