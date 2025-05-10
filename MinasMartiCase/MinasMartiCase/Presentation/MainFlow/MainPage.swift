//
//  MainPage.swift
//  MinasMartiCase
//
//  Created by Mina Namlı on 8.05.2025.
//

import UIKit
import MapKit

class MainPage: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapBackView: UIView!
    
    @IBOutlet weak var playPauseButtonView: UIView!
    @IBOutlet weak var playPauseButtonImageView: UIImageView!
    @IBOutlet weak var restartButtonView: UIView!
    @IBOutlet weak var restartButtonImageView: UIImageView!
    
    private var isTracking = true
    private let mainPageVM = MainPageViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setMapView()
        setBindings()
        setUI()
        startLocationTracking()
        checkSavedRoute()
    }

    private func setMapView(){
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.showsCompass = false
        mapView.showsScale = false
        mapView.pointOfInterestFilter = .excludingAll
    }
    
    private func setBindings(){
        NotificationCenter.default.addObserver(self,selector: #selector(handleCoordinateUpdate(_:)), name: .didReceiveNewCoordinate,object: nil)
    }
    
    private func startLocationTracking(){
        mainPageVM.requestPermission()
        mainPageVM.startTracking()
    }
    
    private func checkSavedRoute() {
        let savedCoordinates = mainPageVM.getSavedRoute()
        guard savedCoordinates.count >= 2 else { return }

        mainPageVM.coordinates = savedCoordinates

        if let current = mainPageVM.getCurrentLocation() {
            let lastSaved = savedCoordinates.last!
            let savedCLLocation = CLLocation(latitude: lastSaved.latitude, longitude: lastSaved.longitude)
            let currentLocation = CLLocation(latitude: current.latitude, longitude: current.longitude)
            let distance = currentLocation.distance(from: savedCLLocation) // metre cinsinden

            if distance > 1000 {
                let alert = UIAlertController(title: Constants.PopTitles.continueWithRouteTitle, message: Constants.PopTitles.continueWithRouteMessage, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: Constants.AppStr.yes, style: .default, handler: { _ in
                    self.drawSavedRoute()
                }))
                
                alert.addAction(UIAlertAction(title: Constants.AppStr.no, style: .cancel, handler: { _ in
                    self.mainPageVM.resetRoute(newLocCoordinate: nil)
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.mapView.removeOverlays(self.mapView.overlays)
                    self.mainPageVM.clearSavedRoute()
                }))
                
                self.present(alert, animated: true)
            } else {
                drawSavedRoute()
            }
        }
    }

    private func drawSavedRoute() {
        for coord in mainPageVM.coordinates {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coord
            mapView.addAnnotation(annotation)
        }
        drawPolyline()
    }
    
    @objc func handleCoordinateUpdate(_ sender: Notification){
        guard let userInfo = sender.userInfo,let coordinate = userInfo["coordinate"] as? CLLocationCoordinate2D else { return }
        
        restartButtonImageView.alpha = 1
        restartButtonView.isUserInteractionEnabled = true

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        drawPolyline()
    }
    
    private func drawPolyline() {
        let coordinates = mainPageVM.coordinates
        guard coordinates.count >= 2 else { return }

        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)

        restartButtonImageView.alpha = 1
        restartButtonView.isUserInteractionEnabled = true
    }

    private func setUI(){
        mapBackView.clipsToBounds = true
        mapBackView.layer.cornerRadius = 12
        
        for backView in [playPauseButtonView,restartButtonView]{
            backView?.isUserInteractionEnabled = true
            backView?.backgroundColor = .white
            backView?.addButtonShadow(radius: 7)
        }
        
        playPauseButtonImageView.setSystemImage(imgName: "pause.fill", tintColor: AppStyle.color(for: .iconColor))
        restartButtonImageView.setSystemImage(imgName: "arrow.clockwise", tintColor: AppStyle.color(for: .iconColor))
        restartButtonImageView.alpha = 0.3
        restartButtonView.isUserInteractionEnabled = false

        let playPauseGest = UITapGestureRecognizer(target: self, action: #selector(playPauseTapped))
        playPauseButtonView.addGestureRecognizer(playPauseGest)
        
        let restartGest = UITapGestureRecognizer(target: self, action: #selector(restartTapped))
        restartButtonView.addGestureRecognizer(restartGest)
    }

    @objc func playPauseTapped() {
        isTracking.toggle()
        updatePlayPauseUI(isTracking: isTracking)
    }
    
    private func updatePlayPauseUI(isTracking: Bool){
        if isTracking {
            playPauseButtonImageView.setSystemImage(imgName: "pause.fill", tintColor: AppStyle.color(for: .iconColor))
            mainPageVM.startTracking()
        } else {
            playPauseButtonImageView.setSystemImage(imgName: "play.fill", tintColor: AppStyle.color(for: .iconColor))
            mainPageVM.stopTracking()
        }
    }
    
    @objc func restartTapped(){
        self.restartButtonImageView.alpha = 0.3

        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)

        if let coordinate = mainPageVM.getCurrentLocation() {
            mainPageVM.resetRoute(newLocCoordinate: coordinate)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            
            mainPageVM.coordinates.append(coordinate)
            drawPolyline()
        }else{
            mainPageVM.resetRoute(newLocCoordinate: nil)
        }
    }

}

extension MainPage: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.lineWidth = 6
            renderer.strokeColor = AppStyle.color(for: .martiGreen)
            renderer.lineCap = .round
            renderer.lineJoin = .round
            renderer.alpha = 0.9
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "marker"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if view == nil {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            view?.annotation = annotation
        }
        view?.canShowCallout = true
        view?.markerTintColor = .white
        view?.glyphText = "🛴"
        
        let mapsButton = UIButton(type: .detailDisclosure)
        view?.rightCalloutAccessoryView = mapsButton
        
        return view
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let coordinate = view.annotation?.coordinate else { return }
        
        mainPageVM.stopTracking()
        updatePlayPauseUI(isTracking: false)
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else { return }
            
            let title = placemark.subLocality ?? "Konum"
            let subtitle = [placemark.locality, placemark.administrativeArea, placemark.country]
                .compactMap { $0 }
                .joined(separator: ", ")
            
            if let pointAnnotation = view.annotation as? MKPointAnnotation {
                pointAnnotation.title = title
                pointAnnotation.subtitle = subtitle
            }

        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        mainPageVM.startTracking()
        updatePlayPauseUI(isTracking: true)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let coordinate = view.annotation?.coordinate else { return }

        let alert = UIAlertController(title: Constants.PopTitles.openMapsTitle, message: Constants.PopTitles.openMapsMessage, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: Constants.PopTitles.appleMaps, style: .default, handler: { _ in
            let placemark = MKPlacemark(coordinate: coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = view.annotation?.title ?? "Seçilen Konum"
            mapItem.openInMaps(launchOptions: [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
            ])
        }))
        
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            alert.addAction(UIAlertAction(title: Constants.PopTitles.googleMaps, style: .default, handler: { _ in
                let urlString = "comgooglemaps://?q=\(coordinate.latitude),\(coordinate.longitude)&zoom=14&views=traffic"
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            }))
        }else {
            alert.addAction(UIAlertAction(title: Constants.PopTitles.googleMapsFromStore, style: .default, handler: { _ in
                if let appStoreURL = URL(string: "https://apps.apple.com/app/id585027354") {
                    UIApplication.shared.open(appStoreURL)
                }
            }))
        }

        alert.addAction(UIAlertAction(title: Constants.AppStr.cancel, style: .cancel))
        self.present(alert, animated: true)
    }

}
