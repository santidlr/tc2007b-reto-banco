//
//  detallesEntrega.swift
//  TC2007BRetoBanco
//
//  Created by user241186 on 10/5/23.
//

import SwiftUI
import Firebase

struct detallesEntrega: View {
    let delivery: Delivery // All of this code happens "inside a single instance of delivery"
    let db = Firestore.firestore() // Configuring Firestore that we need
    let bundleRef: DocumentReference // Calling the users bundle where we get all the users related to the delivery
    

    @State private var users: [User] = [] //
    @State private var despensaNames: [String] = [] // We store just the names, the parsing can be done in another place
    @State private var responsibleUsersNames: [String] = []
    @State private var selectedDespensa: [String: String] = [:] // We use it to change the button and add it to the report
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode // This is how we close the window after finishing the report
    
    init(delivery: Delivery){
        self.delivery = delivery
        self.bundleRef = db.collection("userbundle").document(delivery.relatedUsers)
    }
    
    var body: some View {
        VStack {
            Text("Crear Entrega")
                .font(.largeTitle)
                .padding(.bottom)
            
            Text(delivery.direction)
                .font(.body)
                .foregroundColor(.blue)
            
            Text(delivery.id)
                .font(.body)
                .foregroundColor(.blue)
                .padding(.bottom)

            HStack {
                Text("Nombre")
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .padding(.trailing, 50)
                Text("Asistencia")
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .padding(.trailing, 45)
                Text("Despensa")
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
            
            List {
                ForEach(users, id: \.id) { user in
                    HStack(alignment: .center, spacing: 15){
                        HStack(alignment: .center, spacing: 0){
                            Text(user.firstName)
                                .font(.subheadline)
                                .foregroundColor(.black)
                            + Text(" ")
                            + Text(user.lastName)
                                .font(.subheadline)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        VStack{
                            Button(action: {
                                // We toggle attendance for the user in here.
                                if let index = self.users.firstIndex(where: { $0.id == user.id }) {
                                    self.users[index].attendance.toggle()
                                    print("Attendance toggled for user with ID \(user.id). New value: \(self.users[index].attendance)")
                                }
                            }) {
                                Text(user.attendance ? "Presente" : "Faltante")
                                    .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(user.attendance ? .orange : .black)
                            }
                        }
                        Spacer()
                        .toggleStyle(.button)
                        .tint(.red)
                        VStack{ // Here we can select the pantry archetype that each user will be recieving
                            Menu(selectedDespensa[user.id] ?? "Despensa") {
                                ForEach(despensaNames, id: \.self){ item in
                                    Button(item){
                                        selectedDespensa[user.id] = item
                                        if let index = users.firstIndex(where: { $0.id == user.id }) {
                                            // We update the user's despensa value
                                            users[index].despensa = item
                                            print("Updated despensa for user \(user.firstName) \(user.lastName) (ID: \(user.id)) to: \(item)")
                                        }
                                    }
                                }
                            }
                            .background(Color.gray.opacity(0.2))
                            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                            .foregroundColor(.orange)
                            .cornerRadius(8)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .frame(width: 400)
            HStack{ // This button calls crearReporte which will save every value changed withing the users and create a delivery report
                Button(action:{crearReporte()}){
                    Text("Confirmar Entrega")
                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
                .alert(isPresented: $isShowingAlert){ // Alert to notify the user the report creation success or failure.
                    Alert(
                        title: Text(alertMessage),
                        message: nil,
                        dismissButton: .default(Text("Ok")){
                            if alertMessage == "Reporte creado con exito"{
                                markDeliveryAsCompleted() // We mark the delivery as completed so it doesnt show in pending deliveries in previous screen
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    )
                }
            }
            .onAppear { // We fetch the user data and the despensa data every time the screen is opened.
                fetchUserData()
                fetchResponsibleUsersNames()
                fetchDespensaData()
            }
        }
    }
    
    // MARK: - Fetch Functions
    
    private func fetchDespensaData() { // Fetching uses despensa data.
        FirestoreManager.getDespensa { despensas in
            DispatchQueue.main.async {
                self.despensaNames = despensas.map { $0.id }
            }
        }
    }
    
    private func fetchUserData() { // Fetching all the users IDs within a bundle
        users.removeAll()
        bundleRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching bundle document: \(error)")
                return
            }
            
            if let data = snapshot?.data(),
               let userIDs = data["users"] as? [String] {
                for userID in userIDs {
                    fetchUserByID(userID)
                }
            }
        }
    }
    
    private func fetchUserByID(_ userID: String) { // We find these users by the IDs found in the user bundle of the specific delivery
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user document: \(error)")
                return
            }
            if let data = snapshot?.data(),
               let id = data["id"] as? String,
               let firstname = data["first"] as? String,
               let lastname = data["last"] as? String,
               let born = data["born"] as? Int,
               var attendance = data["attendance"] as? Bool,
               let despensa = data["despensa"] as? String
            {
                let user = User(id: id, firstName: firstname, lastName: lastname, born: born, attendance: attendance, despensa: despensa)
                
                attendance = false
                self.users.append(user)
                print("User appended: \(user)")
            }
        }
    }
    
    private func markDeliveryAsCompleted() { // Each delivery has an intrinsic value that marks if its completed or not, here we mark it as completed.
        let documentID = delivery.id
        
        db.collection("deliveries").document(documentID).updateData([
            "isCompleted": true
        ]) { error in
            if let error = error {
                print("Error updating delivery as completed: \(error)")
            } else {
                print("Delivery marked as completed in Firestore.")
                // You can perform any additional actions here after marking the delivery as completed.
            }
        }
    }
    
    private func fetchResponsibleUsersNames() {
        responsibleUsersNames.removeAll()
        for userID in delivery.responsibleUsers {
            FirestoreManager.getWorkerByID(workerID: userID) { worker in
                if let worker = worker {
                    let name = "\(worker.firstname) \(worker.lastName)"
                    responsibleUsersNames.append(name)
                    print("Responsible user fetched succesfully with: \(userID) ")
                }else{
                    let name = userID
                    responsibleUsersNames.append(name)
                }
            }
        }
    }
    
    private func crearReporte() { // We grab the attendance status and delivered pantry of each user, as well as some other info and create a report in the DB.
        
        // This ID makes the report easier to find
        let reportID = "\(delivery.direction.replacingOccurrences(of: " ", with: ""))\(delivery.date)"
        
        // Check if a report with the same ID already exists
        db.collection("reportesdeentrega").document(reportID).getDocument { snapshot, error in
            if let error = error {
                print("Error checking for existing report: \(error)")
                return
            }
            
            if snapshot?.exists == true {
                print("A report with the same name already exists. Skipping report creation.")
                alertMessage = "Este reporte ya existe"
                isShowingAlert = true
            } else {
                // Gather the selected data
                let date = delivery.date
                let direction = delivery.direction
                let userReports: [UserReport] = users.map { user in
                    return UserReport(
                        id: user.id,
                        firstName: user.firstName,
                        lastName: user.lastName,
                        attendance: user.attendance,
                        despensa: user.despensa
                    )
                }
                
                // Create the report dictionary
                let reportData: [String: Any] = [
                    "date": date,
                    "direction": direction,
                    "users": userReports.map { $0.dictionary },
                    "responsibleUsers": responsibleUsersNames
                ]
                
                // Send the report data to Firestore with the custom reportID
                db.collection("reportesdeentrega").document(reportID).setData(reportData) { error in
                    if let error = error {
                        alertMessage = "Fallo al crear reporte"
                        print("Error creating the report: \(error)")
                    } else {
                        alertMessage = "Reporte creado con exito"
                        print("Report created successfully with ID: \(reportID)")
                    }
                    isShowingAlert = true
                }
            }
        }
    }
}

struct UserReport { // Some structs to manage memory better and make everything easier
    let id: String
    let firstName: String
    let lastName: String
    let attendance: Bool
    let despensa: String

    var dictionary: [String: Any] {
        return [
            "id": id,
            "firstName": firstName,
            "lastName": lastName,
            "attendance": attendance,
            "despensa": despensa,
        ]
    }
}
