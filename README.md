# Genel Bakış

Bu iOS uygulaması, MapKit ve CoreLocation kullanarak gerçek zamanlı konum takibi, rota çizimi ve konum bazlı marker yerleştirme işlevlerini içerir. Uygulama MVVM mimarisiyle yapılandırılmıştır ve arka planda konum izleme desteğiyle donatılmıştır.

---

# Özellikler

- Gerçek zamanlı konum takibi
- Her 100 metrede bir özel marker yerleştirme
- Harita üzerinde çizilen rota (Polyline)
- Marker'a tıklanınca adres bilgisi (reverse geocoding)
- Apple Maps / Google Maps ile harici yönlendirme
- Kullanıcı tarafından başlatılabilir/durdurulabilir konum takibi
- Rota sıfırlama ve devam ettirme seçeneği
- Uygulama yeniden açıldığında rota yükleme desteği (UserDefaults)
- Uygulama arka planda çalışırken konum takibi desteği

---

# Teknik Detaylar

- **Mimari**: MVVM
- **Programlama Dili**: Swift
- **Harita**: Apple MapKit
- **Konum Takibi**: CoreLocation + CLLocationManager
- **Veri Saklama**: UserDefaults
- **Arka Plan Desteği**: Info.plist UIBackgroundModes → location
- **Rota Çizimi**: MKPolyline + MKOverlayRenderer
- **Adres Dönüşümü**: CLGeocoder ile reverse geocoding
- **UI**: UIKit + Storyboard
- **Versiyon Kontrol**: Git + GitHub

---

# Kaynaklar

- Apple Developer - CLLocationManager  
  https://developer.apple.com/documentation/corelocation/cllocationmanager

- Medium - MapKit Drawing a Route (Tianna Henry)  
  https://tiannahenrylewis.medium.com/mapkit-drawing-a-route-on-a-map-swift-uikit-1c851d754617

- YouTube - MapKit ile rota çizimi  
  https://www.youtube.com/watch?v=czmgGFkXzHE

- Medium - MKPolyline Overlay with Swift  
  https://medium.com/@nayananp/mkpolyline-overlay-using-swift-9b00d696edd6

- StackOverflow - Store CLLocationCoordinate2D to UserDefaults  
  https://stackoverflow.com/questions/18910612/store-cllocationcoordinate2d-to-nsuserdefaults

- Medium - Polyline Decode & Draw (SwiftUI MapKit)  
  https://medium.com/%40mauvazquez/decoding-a-polyline-and-drawing-it-with-swiftui-mapkit-611952bd0ecb

---

# Not

- Uygulamanın konum izleme özelliği hem ön planda hem arka planda çalışacak şekilde yapılandırılmıştır.
- Rota takibi sırasında uygulama arka planda çalışsa bile 100 metrelik değişiklikler marker ve polyline ile kaydedilir.
- Rota sıfırlanmadıkça, uygulama yeniden başlatıldığında önceki rota kullanıcıya sunulur.

---

# Kurulum Notları

- Xcode 14 ve üzeri sürümde açılabilir.
- Info.plist dosyasına gerekli yetkiler (`NSLocationWhenInUseUsageDescription`, `NSLocationAlwaysAndWhenInUseUsageDescription`, `UIBackgroundModes`) eklenmiştir.
