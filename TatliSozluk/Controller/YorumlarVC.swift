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
                Kullanici_Adi: self.kullaniciAdi!,
                Kullanici_Id: Auth.auth().currentUser?.uid ?? ""
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
            cell.gorunumAyarla(yorum: yorumlar[indexPath.row], delegate: self)
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "yorumDuzenleSegue" {
            if let hedefVC = segue.destination as? YorumDuzenleVC {
                if let yorumVeri = sender as? (secilenYorum: Yorum, secilenFikir: Fikir) {
                    hedefVC.yorumVerisi = yorumVeri
                }
            }
        }
    }
}

extension YorumlarVC: YorumDelegate {
    func seceneklerYorumPressed(yorum: Yorum) {
        let alert = UIAlertController(title: "Yorum Düzenle", message: "Düzenle veya sil", preferredStyle: UIAlertController.Style.actionSheet)
        let sil = UIAlertAction(title: "Sil", style: UIAlertAction.Style.default) { (action) in
//            self.firestore.collection(Fikirler_Ref).document(self.secilenFikir.documentId).collection(Yorumlar_Ref).document(yorum.documentId).delete { (error) in
//                if let error = error {
//                    debugPrint("yorum silinemedi: \(error.localizedDescription)")
//                } else {
//                    alert.dismiss(animated: true, completion: nil)
//                }
//            }
            
            self.firestore.runTransaction({ (transaction, error) -> Any? in
                let secilenFikirKayit: DocumentSnapshot
                
                do {
                    try secilenFikirKayit = transaction.getDocument(self.firestore.collection(Fikirler_Ref).document(self.secilenFikir.documentId))
                } catch let error as NSError {
                    debugPrint("fikir silinemedi: \(error.localizedDescription)")
                    return nil
                }
                
                guard let eskiYorumSayisi = (secilenFikirKayit.data()?[Yorum_Sayisi] as? Int) else { return nil }
                transaction.updateData([Yorum_Sayisi: eskiYorumSayisi - 1], forDocument: self.fikirRef)
                let silinecekYorumRef = self.firestore.collection(Fikirler_Ref).document(self.secilenFikir.documentId).collection(Yorumlar_Ref).document(yorum.documentId)
                transaction.deleteDocument(silinecekYorumRef)
                return nil
            }) { (nesne, error) in
                if let hata = error {
                    debugPrint("yorum silinemedi: \(hata.localizedDescription)")
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        let duzenle = UIAlertAction(title: "Düzenle", style: UIAlertAction.Style.default) { (action) in
            self.performSegue(withIdentifier: "yorumDuzenleSegue", sender: (yorum, self.secilenFikir))
            self.dismiss(animated: true, completion: nil)
        }
        let iptal = UIAlertAction(title: "İptal", style: UIAlertAction.Style.cancel) { (action) in
            
        }
        alert.addAction(sil)
        alert.addAction(duzenle)
        alert.addAction(iptal)
        present(alert, animated: true, completion: nil)
    }
}
