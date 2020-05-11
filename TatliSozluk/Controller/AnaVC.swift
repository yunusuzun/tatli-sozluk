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
            cell.gorunumAyarla(fikir: fikirler[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

