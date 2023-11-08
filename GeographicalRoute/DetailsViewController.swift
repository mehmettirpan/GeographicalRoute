//
//  DetailsViewController.swift
//  GeographicalRoute
//
//  Created by Mehmet Tırpan on 23.07.2023.
//

import UIKit
import CoreData
import MapKit // mapview ı ve diğer map komutlarını kullanmak için lazım
import CoreLocation // konumu kullanmak için kütüphaneyi ekledil

// map view ile ilgili her hangi bir fonksiyona view controller içerisinden ulaşabilmemiz için delege sınıfını da ekledik
class DetailsViewController: UIViewController, UINavigationControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate  {

    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var noteTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    
//    konumla ilgili işlemleri yönetmemizi ele almamızı sağlayan işlem
    var locationManager = CLLocationManager()
    
    var chosenObjectName = ""
//    uuid yi option seçtik çünkü öbür taraftan atama yapsın biz buradan atama yapmayalaım
    var chosenObjectUUID : UUID?
    
    var chosenLatitude = Double()
    var chosenLongitude = Double() // burada bunları tanımladık sonrasında aşağıda selectLocation kısmında seçtiğimiz konumun enlem ve boylam değerlerinin atamasını yapacağız
    
    
    var annotationTitle = ""
    var annotationSubtitle = ""
    var annotationLatitude = Double()
    var annotationLongitude = Double()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self //delegransyonu view controller a verdik
//        alt satırda hata almamak için CLLocationManagerDelegate ı sınıfa eklememiz gerekiyordu, tıpkı diğerleri gibi
        locationManager.delegate = self // aynı işlemi bunun için de yaptık
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // konum hassasiyetini ayarladık şuan içinm en iyisini ayarladık ama en iyisi her zaman hem internet hem de şarj olarak daha çok harcama yapacaktır.
//    *****    konum kullandığımızı kullanıcıya bildirdik
//        ve aşağıdaki kullanırken konumu al seçeneği var ayrıca bunu düzgün ayarlamazsak ya da fazladan konum isteyecek şekilde koyacak olursak appStore a uygulamayı da yükleyemeyiz. *******
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() // konumu aldık daha doğrusu kullanıcı neredeyse o konumu gösterecek
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(selectLocation(gestureRecognizer:))) // aynı jest algılayıcılardaki gibi ama tabcontrol değil long press seçtik çünkü her bastığımızı değil de uzun süreli bastığımızı ya da basılı tuttuğumuz konbumu veri olarak alsın diye

        gestureRecognizer.minimumPressDuration = 1 //kaç saniye basılı tuttuğunda algılayacak süre
        mapView.addGestureRecognizer(gestureRecognizer)
        
        
        
        if chosenObjectName != ""{
            

            
//            Core Data seçilen ürün bilgilerini göster
            
//            print(chosenObjectUUID) // seçilen ürünün UUID kısmını çıktı olarak xcode da verir
            if let uuidString = chosenObjectUUID?.uuidString{
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let contex = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MapApp")
//                bu filtre mantıksal bazı sınır koyacaksınız ve arama buna göre yapılacak
//                id = %@ şuna eşit olanları getir demek
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
            
                do{
                    let results = try contex.fetch(fetchRequest)
                    
                    if results.count > 0 {
//                        diziye eklemeden sadece imageView textView ı filan yazdırmak için yaptık bu kısımı
                        for result in results as![NSManagedObject]{
                            
//                            // eğer ki uygulamada pin e tıklamak ve üstünde herhangi bir başlık görmek istemiyorsak bu tip yazım daha uygun ama eğer ki her şeyi coredata ya kaydetmek ve hiç bir şeyin boş kalmasını istemiyorsak diğer yazım türü daha doğru olacaktır daha doğrusu daha pratik olacaktır.
//
//                            if let name = result.value(forKey: "name") as? String{
//                                annotationTitle = name
//                            }
//
//                            if let note = result.value(forKey: "notes") as? String{
//                                annotationSubtitle = note
//                            }
//
//                            if let latitude = result.value(forKey: "latitude") as? Double{
//                                annotationLatitude = latitude
//                            }
//
//                            if let longitude = result.value(forKey: "longitude") as? Double{
//                                annotationLongitude = longitude
//                            }
//
//                            let annotation = MKPointAnnotation()
//                            annotation.title = annotationTitle
//                            annotation.subtitle = annotationSubtitle
//                            let coordinate = CLLocationCoordinate2D(latitude: annotationLatitude, longitude: annotationLongitude)
//                            annotation.coordinate = coordinate
//
//                            mapView.addAnnotation(annotation)
//                            nameTextField.text = annotationTitle
//                            noteTextField.text = annotationSubtitle
                            
//                           // aşağıdaki kısım listedeki yeri seçtiğimizde haritada pinin olduğu yere gitmemizi sağlıyor yani ekrandan yazdığımızı seçtiğimizde ekrana şlu anki konumun çıktısını değil de seçtiğimiz konumun yani pinin maps deki yerini çıktın olarak yazdıracaktır.
//                              locationManager.stopUpdatingLocation() // yani konumu güncellemeyi bırak
//
//                              let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//                              let region = MKCoordinateRegion(center: coordinate, span: span)
//                              mapView.setRegion(region, animated: true)

                            
                            
//                          //  bu aşağıdaki seçenekte de iç içe if komutları kullanarak kullanıcının bir öncekini kaydetmeden diğerini kaydedememesini sağladık
                            
                            if let name = result.value(forKey: "name") as? String{
                                annotationTitle = name

                                if let note = result.value(forKey: "notes") as? String{
                                    annotationSubtitle = note

                                    if let latitude = result.value(forKey: "latitude") as? Double{
                                        annotationLatitude = latitude

                                        if let longitude = result.value(forKey: "longitude") as? Double{
                                            annotationLongitude = longitude

//                                            // aşağıdaki kısımda genel olarak anatsyonun kordinatlarını kaydettikten sonra ana ekranda konuma bastığımızda bizi anatasyona götüren komutu yazdık yani pini haritada gösterdik
                                            let annotation = MKPointAnnotation()
                                            annotation.title = annotationTitle
                                            annotation.subtitle = annotationSubtitle
                                            let coordinate = CLLocationCoordinate2D(latitude: annotationLatitude, longitude: annotationLongitude) //annotation kordinatını burada verdik
                                            annotation.coordinate = coordinate

                                            mapView.addAnnotation(annotation)
                                            nameTextField.text = annotationTitle
                                            noteTextField.text = annotationSubtitle
                                            
//                                            // aşağıdaki kısım listedeki yeri seçtiğimizde haritada pinin olduğu yere gitmemizi sağlıyor yani ekrandan yazdığımızı seçtiğimizde ekrana şlu anki konumun çıktısını değil de seçtiğimiz konumun yani pinin maps deki yerini çıktın olarak yazdıracaktır.
                                            locationManager.stopUpdatingLocation() // yani konumu güncellemeyi bırak
                                            
                                            let span = MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006)
                                            let region = MKCoordinateRegion(center: coordinate, span: span)
                                            mapView.setRegion(region, animated: true)
                                        }
                                    }
                                }
                            }


                            
                        }
                    }
                    
                }catch{
                    printContent("you have to incorrect")
                }
                
                
            }
           
        } else{
            nameTextField.text = ""
            noteTextField.text = ""

        }
        

    }
    
//    // bu fonksiyonun içinde anatasyon açıp onu döndereceğiz
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "myAnnotation" // her Id istediğinde bunu kullanmak tekrar tekrar iş yapmamak için bu tanımlamayı yaptık
//        // tekrar kullanılanbilen anatasyon demek
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true// canShowCallot şu demek bizim oluşturacağımız anatasyon ekstra bir şey gösterebilir mi mesela buton
            pinView?.tintColor = .red // renk seçimi yaptık
            
            let button = UIButton(type: .detailDisclosure)  //detay gösterme butonu ekledik
            pinView?.rightCalloutAccessoryView = button  // callout ta ne göstereceğini seçeceğiz, sola ya da sağa yerleştirebiliriz
            
        }else{
            pinView?.annotation = annotation
        }
        return pinView
    }
    
//    // callout butonunun üstüne tıkladığımızda ne olacak onu yazacağımız fonksiyon
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if chosenObjectName != "" {
            
            var requestLocation = CLLocation(latitude: annotationLatitude, longitude: annotationLongitude) //lokasyonumuzu oluışturduk
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarkArray, Error in // güncel lokasyonumuzu verip kullanıcı dostu bir tanımı olan clgeocoder sınıfından oluşturarak kullandık çünkü aşağıda bizden placemarks istiyor
                
                if let placemarks = placemarkArray{
                    if placemarks.count > 0 {
                        let newPlacemark = MKPlacemark(placemark: placemarks[0])
                        let item = MKMapItem(placemark: newPlacemark) // harita öğesinin de nerede oluşturulacağı
                        item.name = self.annotationTitle // navigasyonu açmak için bir tane harita öğresi oluşturmamız gerek
                        
                        // aşağıyı navigasyonu açmak için yaptık
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving] // ne ile gideceğimizi sordu ve biz de araba ile gitsin seçeneğini seçtik daha doğrusu ilk seçenek ne olsun onu seçtik
                        item.openInMaps(launchOptions: launchOptions)
                    }
                    
                }
            } //CLGEcoder kordinatlarla adresler arasında belli bağlantılar yapmaya çalışır.
            // completionHandler işlem tamamlandıktan sonra ne yapacağı anlamına gelir
            
        }
    }
    
    
    @objc func selectLocation(gestureRecognizer : UILongPressGestureRecognizer){ // gestureRecognizer a fonksiyon içerisinde ulaşmak için burada parantez içerisine yazdık
        
        //jest algılayıcının durumunu ölçmek için kullanırız
        if gestureRecognizer.state == .began{ // jest algılayıcı başladı mı bitti mi hepsini görebilmek için
            
            let touchedPoint = gestureRecognizer.location(in: mapView) //dokunulan nokt == nereye dokunduğu
            let touchedCoordinate = mapView.convert(touchedPoint, toCoordinateFrom: mapView) // artık dokunulan kordinatı biliyoruz
            
            chosenLatitude = touchedCoordinate.latitude
            chosenLongitude = touchedCoordinate.longitude  // burada kullanıcının dokunduğu koordinatların enlem ve boylam değerlerini bir sayıya çevirdik ve değere atamasını yaptık
            
            let annotation = MKPointAnnotation() //işaretleme sistemi yani spesifik bnir noktaya uyguladığımız anatasyon demek
            annotation.coordinate = touchedCoordinate //yani burda gösterilecek
            annotation.title = nameTextField.text  //başlık nasıl gösterilecek
            annotation.subtitle = noteTextField.text
            mapView.addAnnotation(annotation)
        }
        
    }
    
//    konumların güncellendiği fonksiyon
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if chosenObjectName == ""{ // buradaki if seçeneğini seçtiğimiz haritayı açtıktan sonra tekrar tekrar konumu güncellemesin diye yaptık bu kodun devamı yukarıdaki anatasyon kısmında mevcut
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude) //konum oluşturduk
            //        mmap viewda bir yere gitmek değiştirmek istiyorsak alttakini yapmamız gerekli
            let span = MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006) // belirttiğimiz komutun yüksekliği yani büyüklüğü küçüklüğü değişecek
            let region = MKCoordinateRegion(center: location, span: span) // bölgeyi değiştir demek
            mapView.setRegion(region, animated: true)
        }
    }
        
        @IBAction func clickedSaveButton(_ sender: Any) {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate //appDelegate a erişmek ve kullanabilmek için bu kodu yazdık
            let context = appDelegate.persistentContainer.viewContext
            //        örneğin alışveriş listesi yapacağız ve bunu kaydedeceğiz ilk olarak bu nesneyi oluşturmamız lazım
            let mapApp = NSEntityDescription.insertNewObject(forEntityName: "MapApp", into: context)
            // core data içerisindeki entity lere ulaşmak için kullandık
            
            mapApp.setValue(nameTextField.text!, forKey: "name") // attribute deki değerlerin atamasını yapmak amacıyla bu kod dizinini yapıyoruz
            mapApp.setValue(noteTextField.text, forKey: "notes")
            // enlem ve boylamı alıp buraya taşımamız gerekli bunun için de yukarıda değişken oluşturduk  (latitute enlem demek, longitute boylam demek)
            mapApp.setValue(chosenLatitude, forKey: "latitude")
            mapApp.setValue(chosenLongitude, forKey: "longitude")  // bu değerler ile enlem ve boylamı hafızaya kaydettik
            
            //        universal unique id (UUID)
            mapApp.setValue(UUID(), forKey: "id")
            
            //        bu yaptıklarımızı kaydetmemiz gerekmekte şuan
            do{
                try context.save()
                print ("Data Saved Succesfully")
            } catch{
                print ("Data Error")
            }

            //yeni bir veri kaydettiğimi bildirip geri döndüğümüzde ekranı yenilenmesini sağladık. Haber göndermek için de notification center ı kullanabiliriz
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "inputtedData"), object: nil)
            
            self.navigationController?.popViewController(animated: true)// son oluşturduğumuz view controller ı stackten atıp bir önceki ekrana dönüş sağlıyor.
        }
        
        
}
