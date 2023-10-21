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
            // titulo y header
            Text("Crear Entrega")
                .font(Font.custom("Poppins-Medium", size: 48))
                .foregroundColor(.black)
                .frame(width: 357, height: 68, alignment: .leading)
                .padding(.bottom, 30)
            
            Text("Comunidad: \(delivery.direction)")
                .font(Font.custom("Poppins-Light", size: 20))
                .foregroundColor(.black)
                .frame(width: 357, height: 25, alignment: .leading)
            
            Text("Id: \(delivery.id)")
                .font(Font.custom("Poppins-Light", size: 20))
                .foregroundColor(Color(red: 0.95, green: 0.6, blue: 0))
                .frame(width: 357, height: 25, alignment: .leading)
                .padding(.bottom, 30)
            

            HStack {
                Text("Nombre")
                    .font(Font.custom("Poppins-Medium", size: 15))
                    .foregroundColor(Color(red: 0.95, green: 0.6, blue: 0))
                    .frame(width: 98, height: 26, alignment: .leading)
                
                Text("Asistencia")
                    .font(Font.custom("Poppins-Medium", size: 15))
                    .foregroundColor(Color(red: 0.95, green: 0.6, blue: 0))
                    .frame(width: 98, height: 26, alignment: .leading)
                
                Text("Despensa")
                    .font(Font.custom("Poppins-Medium", size: 15))
                    .foregroundColor(Color(red: 0.95, green: 0.6, blue: 0))
                    .frame(width: 98, height: 26, alignment: .leading)
            }
            .offset(y: 20)
            
            
            List {
                ForEach(users, id: \.id) { user in
                    HStack(alignment: .center, spacing: 15){
                        HStack(alignment: .center, spacing: 0){
                            Text(user.firstName + " " + user.lastName)
                                .font(Font.custom("Poppins-Regular", size: 15))
                                .foregroundColor(.black)
                                .frame(width: 98, height: 26, alignment: .leading)
                            
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
                                    .frame(width: 100, height: 40, alignment: .center)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                    .foregroundColor(user.attendance ? .black : .black)
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
                            .frame(width: 100, height: 40)
                            .background(Color.gray.opacity(0.1))
                            .foregroundColor(.black)
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
                        .font(Font.custom("Poppins-Regular", size: 15))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .frame(width: 267, height: 68, alignment: .center)
                }
                .foregroundColor(.clear)
                .frame(width: 200, height: 70, alignment: .center)
                .background(Color(red: 0.81, green: 0.05, blue: 0.18))
                .cornerRadius(8)
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
            Spacer()
                .frame(height: 50)
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
