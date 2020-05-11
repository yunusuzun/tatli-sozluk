//
//  GirisVC.swift
//  TatliSozluk
//
//  Created by Yunus Uzun on 11.05.2020.
//  Copyright © 2020 yunus. All rights reserved.
//

import UIKit
import FirebaseAuth

class GirisVC: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtParola: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func btnGirisTapped(_ sender: Any) {
        guard let email = txtEmail.text,
            let parola = txtParola.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: parola) { (kullanici, error) in
            if let error = error {
                debugPrint("oturum açılmadı: \(error.localizedDescription)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
