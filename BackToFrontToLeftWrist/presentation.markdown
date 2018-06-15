# Front to Back to Left Wrist

Basic hello example:
```
func getHello(request: HTTPRequest, response: HTTPResponse) {

}
```

Add desired properties to `Restaurant` model:
```
var id: Int = 0
var name: String = ""
var phoneNumber: String = ""
var latitude: Float = 0.0
var longitude: Float = 0.0
var website: String = ""
```

Tell `StORM` the name of our table:
```
override open func table() -> String { return "restaurants" }
```

Next we need to tell the server how to convert a table row to our object:
```
override func to(_ this: StORMRow) {
    id = this.data["id"] as? Int ?? 0
    name = this.data["name"] as? String ?? ""
    phoneNumber = this.data["phonenumber"] as? String ?? ""
    website = this.data["website"] as? String ?? ""

    let latString = this.data["latitude"] as? String ?? ""
    latitude = Float(latString) ?? 0.0

    let lonString = this.data["longitude"] as? String ?? ""
    longitude = Float(lonString) ?? 0.0
}
```

While unnecessary, we can create a simple function to give us all the rows:
```
func rows() -> [Restaurant] {
    var rows = [Restaurant]()
    for i in 0..<self.results.rows.count {
        let row = Restaurant()
        row.to(self.results.rows[i])
        rows.append(row)
    }
    return rows
}
```

Finally, we're going to add a function that lets us represent our object as a `Dictionary` for use in JSON:
```
func asDictionary() -> [String: Any] {
    return [
        "id": self.id,
        "name": self.name,
        "phoneNumber": self.phoneNumber,
        "latitude": self.latitude,
        "longitude": self.longitude,
        "website": self.website,
    ]
}
```

Adding our model object to main makes sure the database adds it on launch:
```
let restaurant = Restaurant()
try? restaurant.setup()
```

Next we're going to build an endpoint to create `Restaurants`:
```
static func create(request: HTTPRequest, response: HTTPResponse) {
    do {

    } catch let error {
        response.completed(status: .internalServerError)
        print(error)
    }
}
```

To save time, we're going to create multiple `Restaurants` at once:
```
guard let requestJson = try request.postBodyString?.jsonDecode() as? [[String: Any]] else {
    response.setBody(string: "Missing or Bad Parameter")
            .completed(status: .badRequest)

    return
}
```

Next, we want to loop through the POST body to pull out the JSON representing our `Restaurants`:
```
for json in requestJson {

}
```

Again, we'll guard to make sure the JSON is formatted in the way we expect:
```
guard let name = json["name"] as? String,
    let phoneNumber = json["phoneNumber"] as? String,
    let latitude = json["latitude"] as? Float,
    let longitude = json["longitude"] as? Float,
    let website = json["website"] as? String else {

    response.setBody(string: "Missing or Bad Parameter")
            .completed(status: .badRequest)
    return
}
```

We'll construct a `Restaurant` object from the values we pulled out of the JSON:
```
let restaurant = Restaurant()
restaurant.name = name
restaurant.phoneNumber = phoneNumber
restaurant.latitude = Float(latitude)
restaurant.longitude = Float(longitude)
restaurant.website = website
```

Next we'll want to save that object to our database:
```
try restaurant.save { id in
    restaurant.id = id as! Int
}
```

Finally, we'll have the server tell our users that everything went ok:
```
response.completed(status: .created)
```

Since we'll have many endpoints, We'll create a function that returns all the routes for this structure and add our new route:
```
static func allRoutes() -> Routes {
    var routes = Routes()

    routes.add(method: .post, uri: "/restaurants", handler: create)

    return routes
}
```

If we've done everything correctly, we should be able to add the route to our server and enter in our seed data using Postman:
```
routes.add(RestaurantRoutes.allRoutes())
```

Now that we have data in our database, let's retrieve it:
```
static func getAll(request: HTTPRequest, response: HTTPResponse) {
    do {

    } catch let error as StORMError {
        response.setBody(string: error.string())
                .completed(status: .internalServerError)
    } catch let error {
        response.setBody(string: "\(error)")
                .completed(status: .internalServerError)
    }
}
```

We'll create a reference to the object we're looking for and ask `StORM` to find all of them:
```
let objectQuery = Restaurant()
try objectQuery.findAll()
```

Then we'll loop through everything that was found and build our response JSON:
```
var responseJson: [[String: Any]] = []

for row in objectQuery.rows() {
    responseJson.append(row.asDictionary())
}
```

Finally, we'll ask `Perfect` to return a response containing all of our `Restaurants`:
```
try response.setBody(json: responseJson)
            .completed(status: .ok)
```

Again we'll add the route. And if everything went right, we should be able to get our data back using Postman:
```
routes.add(method: .get, uri: "/restaurants", handler: getAll)
```

We should also be able to see the list of `Restaurants` populating in our app now:
```
```

Next in the UI is to create a `Reservation`. To do so, we'll follow pretty much the same steps as we did with `Restaurants`:
```
var id: Int = 0
var restaurantId: Int = 0
var _restaurant: Restaurant = Restaurant()
var date: String = ""
var partySize: Int = 0
```

We'll need another table. This time for `Reservations`:
```
override open func table() -> String { return "reservations" }
```

We'll create our `to` function, again allowing us to convert a table row to our object:
```
override func to(_ this: StORMRow) {
    guard let restaurantId = this.data["restaurantid"] as? Int else { return }

    self.id = this.data["id"] as? Int ?? 0
    self.restaurantId = restaurantId
    self.date = this.data["date"] as? String ?? ""
    self.partySize = this.data["partysize"] as? Int ?? 0
}
```

We'll also make the rows function in case we need to get all `Reservations`:
```
func rows() -> [Reservation] {
    var rows = [Reservation]()
    for i in 0..<self.results.rows.count {
        let row = Reservation()
        row.to(self.results.rows[i])
        rows.append(row)
    }

    return rows
}
```

And we'll make a function that returns a `Reservation` as a `Dictionary` for use in JSON:
```
func asDictionary() -> [String: Any] {
    let restaurant = Restaurant()
    try? restaurant.get(self.restaurantId)

    guard restaurant.id > 0 else { return [:] }

    return [
        "id": self.id,
        "restaurant": restaurant.asDictionary(),
        "date": self.date,
        "partySize": self.partySize,
    ]
}
```

Like with `Restaurant` we'll want to make sure Reservation gets setup on server launch:
```
let reservation = Reservation()
try? reservation.setup()
```

Now that we have the object setup, we need to make the endpoint that will create a `Reservation` for our users:
```
static func createReservation(request: HTTPRequest, response: HTTPResponse) {
    do {

    } catch let error {
        print(error)
    }
}
```

Just as before, any time we receive data, we want to make sure it's as expected:
```
guard let json = try request.postBodyString?.jsonDecode() as? [String: Any],
    let restaurantId = json["restaurantId"] as? Int,
    let date = json["date"] as? String,
    let partySize = json["partySize"] as? Int else {

    response.setBody(string: "Missing or Bad Parameter")
            .completed(status: .badRequest)
    return
}
```

As important as checking the JSON, we also want to make sure we have the `Restaurant` in our database:
```
let restaurant = Restaurant()
try restaurant.get(restaurantId)

guard restaurant.id != 0 else {
    response.setBody(string: "Restaurant Not Found").completed(status: .notFound)
    return
}
```

We'll construct our `Reservation` object from the data passed in:
```
let reservation = Reservation()
reservation.restaurantId = restaurant.id
reservation.date = date
reservation.partySize = partySize
```

Save it to the database:
```
try reservation.save { id in
    reservation.id = id as! Int
}
```

And return it the successfully created `Reservation` in our server's response:
```
try response.setBody(json: reservation.asDictionary())
            .completed(status: .ok)
```

Again, because we'll have many routes, we'll create a function that returns all routes for this handler:
```
static func allRoutes() -> Routes {
    var routes = Routes()

    return routes
}
```

And we'll add the `createReservation` endpoint we just coded:
```
routes.add(method: .post, uri: "/reservation", handler: createReservation)
```

We'll need to again add the routes to our server:
```
routes.add(ReservationRoutes.allRoutes())
```

Now, if we've done everything right, we should be able to create a `Reservation` using Postman. But why don't we try it in the app:
```
```

Let's go ahead and create an endpoint that allows a user to cancel their `Reservation`:
```
static func deleteReservation(request: HTTPRequest, response: HTTPResponse) {

}
```

Before anything, we want to make sure that the user has passed us the ID of the `Reservation` they want to cancel:
```
guard let id = Int(request.urlVariables["id"] ?? "0"), id > 0 else {
    response.completed(status: .badRequest)
    return
}
```

We'll create a reference to our data object for `StORM` to query against -- returning an error if that fails:
```
let reservation = Reservation()

do {
    try reservation.get(id)

} catch let error {
    print(error)
    response.completed(status: .badGateway)
}
```

And if the Reservation is present in our database, we should be able to delete it. Or respond with an error if it's not:
```
if reservation.id != 0 {
    try reservation.delete()
    response.completed(status: .accepted)
} else {
    response.setBody(string: "Reservation Not Found").completed(status: .notFound)
    return
}
```

With that all coded up, we just need to add the route to our `allRoutes` function:
```
routes.add(method: .delete, uri: "/reservation/{id}", handler: deleteReservation)
```


/***********************/
      Watch Stuff
/************************/


Now we need a way to pass `Reservation` data from our to our Watch Extension.:
```
```

To do that, we'll create `WatchManager` and make it conform to `WCSessionDelegate`:
```
extension WatchManager: WCSessionDelegate {

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("App: activationDidCompleteWith")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("App: sessionDidBecomeInactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("App: sessionDidDeactivate")
    }
}
```

To make sure we can send it to the watch, we'll have to check if the user has a watch:
```
func isSupported() -> Bool {
    if WCSession.isSupported() {
        WCSession.default.delegate = self
        WCSession.default.activate()
        return true
    }

    return false
}
```

And to make sure we're not unnecessarily checking, we'll add a check to see if we've already activated the session:
```
guard WCSession.default.activationState != .activated else { return true }
```

The last thing we want the `WatchManager` to do is send data to the watch:
```
func send(json: [String: Any]) {
    if WCSession.default.activationState == .activated && WCSession.default.isReachable {
        WCSession.default.sendMessage(json, replyHandler: nil)
    }
}
```

Next we'll want to make sure we send the `Reservation` to the watch when it's created:
```
```

To do this, we'll add some code to the `save` function in `CreateReservationViewController`:
```
if WatchManager.main.isSupported() {
    WatchManager.main.send(json: reservation)
}
```

And we'll want to add a similar block of code in the `cancelReservation` function in `ReservationDetailsViewController`:
```
if WatchManager.main.isSupported() {
    WatchManager.main.send(json: [:])
}
```

Now we're ready to consume the data sent to the watch in `ReservationDetailsInterfaceController`'s `awake` function:
```
WCSession.default.delegate = self
WCSession.default.activate()
```

And we'll need to conform to `WCSessionDelegate`:
```
extension ReservationDetailsInterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message)
    }
}
```

This time, instead of just printing stuff, we're going to store the message to `UserDefaults`
```
UserDefaults.standard.set(message, forKey: "reservation")
```

Now that the data being sent is saved, we'll want a way to retrieve it:
```
func retrieveReservation() {
    self.reservation = nil

    guard let message = UserDefaults.standard.object(forKey: "reservation") as? [String: Any],
          let data = try? JSONSerialization.data(withJSONObject: message, options: .prettyPrinted),
          let reservation = try? JSONDecoder().decode(Reservation.self, from: data) else { return }

    self.reservation = reservation
}
```

Finally, when the view `willActive` we want to add the data to our UI:
```
retrieveReservation()

if let reservation = reservation {
    restaurantNameLabel.setText(reservation.restaurant.name)

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy, HH:mm"

    let reservationDate = dateFormatter.date(from: reservation.date)!
    let components = Calendar.current.dateComponents([.hour, .minute], from: reservationDate)

    reservationTimeLabel.setText("at: \(components.hour!):\(components.minute!)")
}
```

Because the main UI is setup to be paged, `MapInterfaceController` will also need to be a `WCSessionDelegate`:
```
extension MapInterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith")
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print(message)

        UserDefaults.standard.set(message, forKey: "reservation")
    }
}
```

It will also need to be able to retrieve the data from `UserDefaults`:
```
func retrieveRestaurant() {
    self.restaurant = nil

    guard let message = UserDefaults.standard.object(forKey: "reservation") as? [String: Any],
        let data = try? JSONSerialization.data(withJSONObject: message, options: .prettyPrinted),
        let reservation = try? JSONDecoder().decode(Reservation.self, from: data) else { return }

    self.restaurant = reservation.restaurant
}
```

And when it `awake`s we'll again want to set up the session:
```
WCSession.default.delegate = self
WCSession.default.activate()
```

Then we'll want to retrieve the data and setup the UI when `MapInterfaceController` `willActive`:
```
retrieveRestaurant()

guard let restaurant = restaurant else { return }

map.addAnnotation(CLLocationCoordinate2D(latitude: restaurant.latitude,
                                         longitude: restaurant.longitude),
                  with: .green)
map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: restaurant.latitude,
                                                                longitude: restaurant.longitude),
                                 span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)))
```                                 

Now, to make this watch app more useful than just a way to view `Reservation` data:
```
```

`EditReservationInterfaceController` will be a modal. So we'll need to segue from `ReservationDetailsInterfaceController`:
```
override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
    guard let reservation = reservation else { return nil }
    return reservation
}
```

Because `EditReservationInterfaceController` is just two buttons, all we have to do is make sure that it has a `Reservation`:
```
guard let reservation = context as? Reservation else { return }
self.reservation = reservation
```

We need that `Reservation` so we can send it as we segue to our `StepperInterfaceController`:
```
override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
    guard let reservation = self.reservation  else { return nil }

    return (segueIdentifier, reservation)
}
```

Inside of `StepperInterfaceController`'s `awake` function we again want to make sure our context is right:
```
guard let editContext = context as? EditObject else { return }
```

Now that we have the correct context, we want to pull out the two parts of it:
```
usage = editContext.usage
reservation = editContext.reservation

guard reservation != nil else { return }
```

And we'll set up the UI with the correct data for usage:
```
if usage == "party" {
    valueLabel.setText("\(reservation!.partySize)")
} else if usage == "time" {

    dateFormatter.dateFormat = "MM/dd/yyyy, HH:mm"
    let reservationDate = dateFormatter.date(from: reservation!.date)!
    let components = Calendar.current.dateComponents([.hour, .minute], from: reservationDate)
    let time = String(format: "%02i:%02i", components.hour!, components.minute!)

    valueLabel.setText(time)
}
```

We need to make one last endpoint so our users can update their `Reservation`:
```
static func updateReservation(request: HTTPRequest, response: HTTPResponse) {

}
```

First we'll need to make sure that we're being passed a `Reservation.id` from the caller:
```
guard let id = Int(request.urlVariables["id"] ?? "0"), id > 0 else {
    response.completed(status: .badRequest)
    return
}
```

Next we're going to want to make sure we've been sent some JSON that holds the properties we need to update:
```
do {
    guard let json = try request.postBodyString?.jsonDecode() as? [String: Any]  else {
        response.setBody(string: "Missing or Bad Parameter")
                .completed(status: .badRequest)
        return
    }
} catch {
    print(error)
    response.completed(status: .badGateway)
}
```

Then we'll make a reference to our object, ask `StORM` to retrieve the specific `Reservation`, and check to see if it's real:
```
let reservation = Reservation()
try reservation.get(id)

guard reservation.id != 0 else {
    response.setBody(string: "Reservation does not exist").completed(status: .notFound)
    return
}
```

Now that we've retrieved the correct object, we can modify it with the properties passed in:
```
if let newPartySize = json["partySize"] as? Int {
    reservation.partySize = newPartySize
}

if let newDate = json["date"] as? String {
    reservation.date = newDate
}
```

We'll save our updated `Reservation` in place and return it to our users:
```
try reservation.save()
try response.setBody(json: reservation.asDictionary())
            .completed(status: .ok)
```

All that's left it to make sure we add our new route to `allRoutes`:
```
routes.add(method: .put, uri: "/reservation/{id}", handler: updateReservation)
```  

Now that we have an endpoint to hit, we can call it as the user leaves the screen:
```
override func didDeactivate() {
    super.didDeactivate()

}
```

We'll build our `request`:
```
var request = URLRequest(url: URL(string: "http://\(baseURL):8080/reservation/\(reservation!.id)")!)
request.httpMethod = "PUT"
```

Then we'll create the payload and add it to the `request`:
```
let payload: [String: Any] = ["partySize": reservation!.partySize,
                              "date": reservation!.date]
request.httpBody = try! JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
```

Next we'll create a data task and start it:
```
let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

}
task.resume()
```

Finally, we'll check that the update worked and save the `response` in case the user makes more edits:
```
guard error == nil, data != nil else { print(error.debugDescription); return}
guard let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? [String: Any] else { return }

UserDefaults.standard.set(json, forKey: "reservation")
```

If we don't want our users only swiping, we can let them use the digital crown by conforming to `WKCrownDelegate`:
```
extension StepperInterfaceController: WKCrownDelegate {
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        if rotationalDelta > 0 {
            plusTapped()
        } else {
            minusTapped()
        }
    }
}
```

To use this, we'll need to set `StepperInterfaceController` as the delegate when `awake`:
```
crownSequencer.delegate = self
```

And give the `crownSequencer` focus when `StepperInterfaceController` `willActivate`:
```
crownSequencer.focus()
```
