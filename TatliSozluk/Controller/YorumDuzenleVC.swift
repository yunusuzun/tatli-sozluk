//
//  YorumDuzenleVC.swift
//  TatliSozluk
//
//  Created by Yunus Uzun on 14.05.2020.
//  Copyright © 2020 yunus. All rights reserved.
//

import UIKit
import FirebaseFirestore

class YorumDuzenleVC: UIViewController {
    @IBOutlet weak var txtYorum: UITextView!
    
    var yorumVerisi: (secilenYorum: Yorum, secilenFikir: Fikir)!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtYorum.text = yorumVerisi.secilenYorum.yorumText!
    }

    @IBAction func btnGuncelleTapped(_ sender: Any) {
        guard let yorumText = txtYorum.text, txtYorum.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty != true else { return }
        
        Firestore.firestore().collection(Fikirler_Ref).document(yorumVerisi.secilenFikir.documentId).collection(Yorumlar_Ref).document(yorumVerisi.secilenYorum.documentId).updateData([Yorum_Text: yorumText]) { (error) in
            if let error = error {
                debugPrint("yorum güncellenemedi: \(error.localizedDescription)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
