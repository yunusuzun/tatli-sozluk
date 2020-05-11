//
//  KaydolVC.swift
//  TatliSozluk
//
//  Created by Yunus Uzun on 11.05.2020.
//  Copyright © 2020 yunus. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class KaydolVC: UIViewController {
    @IBOutlet weak var txtKullanciAdi: UITextField!
    @IBOutlet weak var txtMail: UITextField!
    @IBOutlet weak var txtParola: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func btnKaydolTapped(_ sender: Any) {
        guard let email = txtMail.text,
            let kullaniciAdi = txtKullanciAdi.text,
            let parola = txtParola.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: parola) { (bilgiler, error) in
            if let error = error {
                debugPrint("kullanıcı oluşturulamadı: \(error.localizedDescription)")
            }
            
            let changeRequest = bilgiler?.user.createProfileChangeRequest()
            changeRequest?.displayName = kullaniciAdi
            changeRequest?.commitChanges(completion: { (error) in
                if let error = error {
                    debugPrint("kullanıcı adı oluşturulamadı: \(error.localizedDescription)")
                }
            })
            
            guard let kullaniciId = bilgiler?.user.uid else { return }
            
            Firestore.firestore().collection(Kullanicilar_Ref).document(kullaniciId).setData([
                Kullanici_Adi: kullaniciAdi,
                Kullanici_Olusturulma_Tarihi: FieldValue.serverTimestamp()
            ], completion: { (error) in
                if let error = error {
                    debugPrint("kullanici eklenemedi: \(error.localizedDescription)")
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
        }
    }
    
    @IBAction func btnVazgecTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
