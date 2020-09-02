//
//  ViewController.swift
//  TatliSozluk
//
//  Created by Yunus Uzun on 8.05.2020.
//  Copyright © 2020 yunus. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AnaVC: UIViewController {
    @IBOutlet weak var sgmntKategoriler: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    private var fikirler = [Fikir]()
    private var fikirlerCollectionRef: CollectionReference!
    private var fikirlerListener: ListenerRegistration!
    private var secilenKategori = Kategoriler.Eglence.rawValue
    private var listenerHandle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        fikirlerCollectionRef = Firestore.firestore().collection(Fikirler_Ref)
    }

    override func viewDidDisappear(_ animated: Bool) {
        if fikirlerListener != nil {
            fikirlerListener.remove()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        listenerHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(identifier: "loginVC")
                self.present(loginVC, animated: true, completion: nil)
            } else {
                self.setListener()
            }
        })
    }

    func setListener() {
        if secilenKategori == Kategoriler.Populer.rawValue {
            fikirlerListener = fikirlerCollectionRef.order(by: Eklenme_Tarihi, descending: true).addSnapshotListener { (snapshot, error) in
                if let error = error {
                    debugPrint("kayıtları getiremedi: \(error.localizedDescription)")
                } else {
                    self.fikirler.removeAll()
                    self.fikirler = Fikir.fikirGetir(snapshot: snapshot)
                    self.tableView.reloadData()
                }
            }
        } else {
            fikirlerListener = fikirlerCollectionRef.whereField(Kategori, isEqualTo: secilenKategori).order(by: Eklenme_Tarihi, descending: true).addSnapshotListener { (snapshot, error) in
                if let error = error {
                    debugPrint("kayıtları getiremedi: \(error.localizedDescription)")
                } else {
                    self.fikirler.removeAll()
                    self.fikirler = Fikir.fikirGetir(snapshot: snapshot)
                    self.tableView.reloadData()
                }
            }
        }


    }

    @IBAction func sgmntKategoriChange(_ sender: Any) {
        switch sgmntKategoriler.selectedSegmentIndex {
        case 0:
            secilenKategori = Kategoriler.Eglence.rawValue
        case 1:
            secilenKategori = Kategoriler.Absurt.rawValue
        case 2:
            secilenKategori = Kategoriler.Gundem.rawValue
        case 3:
            secilenKategori = Kategoriler.Populer.rawValue
        default:
            secilenKategori = Kategoriler.Eglence.rawValue
        }

        fikirlerListener.remove()
        setListener()
    }

    @IBAction func btnExitTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()

        do {
            try firebaseAuth.signOut()
        } catch let error as NSError {
            debugPrint("oturum kapatılamadı: \(error.localizedDescription)")
        }
    }
}

extension AnaVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fikirler.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "fikirCell", for: indexPath) as? FikirCell {
            cell.gorunumAyarla(fikir: fikirler[indexPath.row], delegate: self)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "yorumlarSegue", sender: fikirler[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "yorumlarSegue" {
            if let hedefVC = segue.destination as? YorumlarVC {
                if let secilenFikir = sender as? Fikir {
                    hedefVC.secilenFikir = secilenFikir
                }
            }
        }
    }
}


extension AnaVC: FikirDelegate {
    func seceneklerFikirPressed(fikir: Fikir) {
        let alert = UIAlertController(title: "Sil", message: "Fikrinisizi silmek mi istiyorsunuz?", preferredStyle: UIAlertController.Style.actionSheet)
        let silButton = UIAlertAction(title: "Sil", style: UIAlertAction.Style.default) { (action) in
            let yorumlarColRef = Firestore.firestore().collection(Fikirler_Ref).document(fikir.documentId).collection(Yorumlar_Ref)
            self.yorumlarıSil(yorumCollection: yorumlarColRef) { (error) in
                if let error = error {
                    debugPrint("fikir silinmedi: \(error.localizedDescription)")
                } else {
                    Firestore.firestore().collection(Fikirler_Ref).document(fikir.documentId).delete { (error) in
                        if let error = error {
                            debugPrint("fikir silinmedi: \(error.localizedDescription)")
                        } else {
                            alert.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }

        let iptal = UIAlertAction(title: "İptal", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(silButton)
        alert.addAction(iptal)
        present(alert, animated: true, completion: nil)
    }

    func yorumlarıSil(yorumCollection: CollectionReference, silinecekKayitSayisi: Int = 100, completion: @escaping (Error?) -> Void) {
        yorumCollection.limit(to: silinecekKayitSayisi).getDocuments { (kayit, error) in
            guard let kayitSetleri = kayit else {
                completion(error)
                return
            }

            guard kayitSetleri.count > 0 else {
                completion(nil)
                return
            }

            let batch = yorumCollection.firestore.batch()
            kayitSetleri.documents.forEach { batch.deleteDocument($0.reference) }
            batch.commit { (error) in
                if let error = error {
                    completion(error)
                } else {
                    self.yorumlarıSil(yorumCollection: yorumCollection, silinecekKayitSayisi: silinecekKayitSayisi, completion: completion)
                }
            }
        }
    }
}
