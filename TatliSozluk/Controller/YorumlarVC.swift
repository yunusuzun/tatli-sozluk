//
//  YorumlarVC.swift
//  TatliSozluk
//
//  Created by Yunus Uzun on 11.05.2020.
//  Copyright © 2020 yunus. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class YorumlarVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtYorum: UITextField!
    
    var secilenFikir: Fikir!
    private var yorumlar = [Yorum]()
    private var fikirRef: DocumentReference!
    private let firestore = Firestore.firestore()
    private var kullaniciAdi: String!
    private var yorumlarListener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        fikirRef = firestore.collection(Fikirler_Ref).document(secilenFikir.documentId)
        
        if let adi = Auth.auth().currentUser?.displayName {
            kullaniciAdi = adi
        }
        
        self.view.klavyeAyarla()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        yorumlarListener = firestore.collection(Fikirler_Ref).document(secilenFikir.documentId).collection(Yorumlar_Ref).order(by: Eklenme_Tarihi, descending: false).addSnapshotListener({ (snapshot, error) in
            guard let snapshot = snapshot else {
                debugPrint("Yorumlar getirilemedi: \(error!.localizedDescription)")
                return
            }
            
            self.yorumlar.removeAll()
            self.yorumlar = Yorum.yorumlariGetir(snapshot: snapshot)
            self.tableView.reloadData()
        })
    }

    @IBAction func btnYorumTapped(_ sender: Any) {
        guard let yorumText = txtYorum.text else { return }
        
        firestore.runTransaction({ (transaction, error) -> Any? in
            let secilenFikirKayit: DocumentSnapshot
            
            do {
                try secilenFikirKayit = transaction.getDocument(self.firestore.collection(Fikirler_Ref).document(self.secilenFikir.documentId))
            } catch let error as NSError {
                debugPrint("hata: \(error.localizedDescription)")
                return nil
            }
            
            guard let eskiYorumSayisi = secilenFikirKayit.data()?[Yorum_Sayisi] as? Int else { return nil }
            
            transaction.updateData([Yorum_Sayisi: eskiYorumSayisi + 1], forDocument: self.fikirRef)
            
            let yeniYorumRef = self.firestore.collection(Fikirler_Ref).document(self.secilenFikir.documentId).collection(Yorumlar_Ref).document()
            transaction.setData([
                Yorum_Text: yorumText,
                Eklenme_Tarihi: FieldValue.serverTimestamp(),
                Kullanici_Adi: self.kullaniciAdi!
            ], forDocument: yeniYorumRef)
            
            return nil
        }) { (nesne, error) in
            if let error = error {
                print("hata transaction: \(error.localizedDescription)")
            } else {
                self.txtYorum.text = ""
            }
        }
    }
}

extension YorumlarVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yorumlar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "yorumlarCell", for: indexPath) as? YorumCell {
            cell.gorunumAyarla(yorum: yorumlar[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}
