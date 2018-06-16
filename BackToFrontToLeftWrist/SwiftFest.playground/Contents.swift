//: Playground - noun: a place where people can play

import UIKit
import MapKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let conferencePoint = CLLocationCoordinate2D(latitude: 42.3439123, longitude: -71.0720662)
let kilometerSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)

let request = MKLocalSearchRequest()
request.region = MKCoordinateRegion(center: conferencePoint, span: kilometerSpan)
request.naturalLanguageQuery = "restaraunts"
let localSearch = MKLocalSearch(request: request)


localSearch.start { (response, error) in
    print("in closure")
    guard error == nil else {
        print("there was an error")
        return
    }
    
    if let result = response?.mapItems {
        print("\(result.count)")
    }
}

/*** trying to figure out how to only serve up most recent reservation **/

var lies = "04/21/2018, 16:53" > "04/22/2018, 16:53"
var truth = "04/21/2018, 16:53" < "04/22/2018, 16:53"

