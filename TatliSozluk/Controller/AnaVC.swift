//
//  ViewController.swift
//  TatliSozluk
//
//  Created by Yunus Uzun on 8.05.2020.
//  Copyright © 2020 yunus. All rights reserved.
//

import UIKit
import Firebase

class AnaVC: UIViewController {
    @IBOutlet weak var sgmntKategoriler: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private var fikirler = [Fikir]()
    private var fikirlerCollectionRef: CollectionReference!
    private var fikirlerListener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fikirlerCollectionRef = Firestore.firestore().collection(Fikirler_Ref)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        fikirlerListener.remove()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fikirlerListener = fikirlerCollectionRef.addSnapshotListener { (snapshot, error) in
            if let error = error {
                debugPrint("kayıtları getiremedi: \(error.localizedDescription)")
            } else {
                self.fikirler.removeAll()
                guard let snap = snapshot else { return }
                for document in snap.documents {
                    let data = document.data()
                    
                    let kullaniciAdi = data[Kullanici_Adi] as? String ?? "Misafir"
                    let eklenmeTarihi = data[Eklenme_Tarihi] as? Date ?? Date()
                    let fikirText = data[Fikir_Text] as? String ?? ""
                    let yorumSayisi = data[Yorum_Sayisi] as? Int ?? 0
                    let begeniSayisi = data[Begeni_Sayisi] as? Int ?? 0
                    let documentId = document.documentID
                    
                    let yeniFikir = Fikir(kullaniciAdi: kullaniciAdi, eklenmeTarihi: eklenmeTarihi, fikirText: fikirText, yorumSayisi: yorumSayisi, begeniSayisi: begeniSayisi, documentId: documentId)
                    
                    self.fikirler.append(yeniFikir)
                }
                
                self.tableView.reloadData()
            }
        }
    }
}

extension AnaVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fikirler.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "fikirCell", for: indexPath) as? FikirCell {
            cell.gorunumAyarla(fikir: fikirler[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

