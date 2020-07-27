//
//  AppDelegate.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 4/17/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import Firebase
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    let locationManager = CLLocationManager()
    let center = UNUserNotificationCenter.current()
    var background = false
    var locationPermissionGranted = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        

//        locationManager.delegate = self
//        locationManager.allowsBackgroundLocationUpdates = true
//        locationManager.pausesLocationUpdatesAutomatically = false
//
//        if launchOptions != nil {
//            background = true
//            checkLocationPermission(executeLocationManager: false)
//            startMySignificantLocationChanges()
//            showPush(body: "Launched from location updated")
//        }else {
//            background = false
//            locationManager.distanceFilter = 1
//            checkLocationPermission()
//        }
        
        FirebaseApp.configure()
        changeLang()
        return true
    }
    
    private func changeLang() {
        LanguageManager.shared.loadLanguages()
        let languages = LanguageManager.shared.getLanguages()
        LanguageManager.shared.changeLanguage(language: languages[1])
    }

    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        let fbURL = ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        let gURL = GIDSignIn.sharedInstance().handle(url)
        
        return fbURL || gURL
    }
    
    private func checkLocationPermission(executeLocationManager : Bool = true) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                locationPermissionGranted = true
                if executeLocationManager {
                    checkNotificationPermission()
                    locationManager.startUpdatingLocation()
                }
            @unknown default:
                if executeLocationManager {
                    locationManager.requestAlwaysAuthorization()
                }
                break
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    private func checkNotificationPermission() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                }
        }
    }
    
    private func sendToServer(lat : Double, lon : Double) {

        let semaphore = DispatchSemaphore (value: 0)
        
        var request = URLRequest(url: URL(string: "https://nal.vn/testgps?lat=\(lat)&lon=\(lon)")!,timeoutInterval: Double.infinity)
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.addValue("PHPSESSID=cj75a7egis4k52lmo0rs0islu3", forHTTPHeaderField: "Cookie")

        request.httpMethod = "GET"
        

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()

    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
    }
    
    func changeLocationToBackground() {
        background = true
        if locationPermissionGranted {
            locationManager.stopUpdatingLocation()
            startMySignificantLocationChanges()
        }
    }
    
    func changeLocationToForeground() {
        background = false
        if locationPermissionGranted {
            locationManager.startUpdatingLocation()
            locationManager.stopMonitoringSignificantLocationChanges()
        }
    }
    
    
    func startMySignificantLocationChanges() {
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() || !locationPermissionGranted{
            print("Can't start monitoring Significant Location")
            return
        }
        locationManager.startMonitoringSignificantLocationChanges()
        print("Started monitoring Significant Location")
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let cllocation = locations.first else {
            return
        }
        let location = Location(coordinate: cllocation.coordinate)
        print("Did location update Lat = \(location.coordinate!.latitude) Lon = \(location.coordinate!.longitude)")
        
        if background {
            showPush(body: "Background update")
        }
        sendToServer(lat: location.coordinate!.latitude, lon: location.coordinate!.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showPush(body: "Location error")
    }
        
    func showPush(body : String) {
        let content = UNMutableNotificationContent()
        content.title = "📌Hey!"
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "Identifier", content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            break
        case .authorizedWhenInUse:
            locationPermissionGranted = true
            checkNotificationPermission()
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationPermissionGranted = true
            checkNotificationPermission()
            manager.startUpdatingLocation()
            break
        case .restricted:
            break
        case .denied:
            break
        default:
            break
        }
    }
}

