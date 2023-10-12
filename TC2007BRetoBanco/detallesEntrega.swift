//
//  detallesEntrega.swift
//  TC2007BRetoBanco
//
//  Created by user241186 on 10/5/23.
//

import SwiftUI
import Firebase

struct detallesEntrega: View {
    let delivery: Delivery
    let db = Firestore.firestore()
    let bundleRef: DocumentReference
    

    @State private var users: [User] = []
    @State private var despensaNames: [String] = [] // Store the names of despensa  despensa
    @State private var selectedDespensa: [String: String] = [:]
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    @Environment(\.presentationMode) var presentationMode
    
    init(delivery: Delivery){
        self.delivery = delivery
        self.bundleRef = db.collection("userbundle").document(delivery.relatedUsers)
    }
    
    var body: some View {
        VStack {
            Text("Detalles entrega")
                .font(.largeTitle)
                .padding(.bottom)
            
            
            // Display delivery details here (e.g., delivery.direction, delivery.date, etc.)
            
            HStack {
                Text("Nombre")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(.trailing, 50) // Adjust spacing as needed
                Text("Asistencia")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(.trailing, 45)
                Text("Despensa")
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
                                // Toggle the attendance field for the current user
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
                        VStack{
                            Menu(selectedDespensa[user.id] ?? "Despensa") {
                                ForEach(despensaNames, id: \.self){ item in
                                    Button(item){
                                        selectedDespensa[user.id] = item
                                        if let index = users.firstIndex(where: { $0.id == user.id }) {
                                            // Update the user's despensa value
                                            users[index].despensa = item
                                            print("Updated despensa for user \(user.firstName) \(user.lastName) (ID: \(user.id)) to: \(item)")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .frame(width: 400)
            HStack{
                Button(action:{crearReporte()}){
                    Text("Confirmar Entrega")
                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
                .alert(isPresented: $isShowingAlert){
                    Alert(
                        title: Text(alertMessage),
                        message: nil,
                        dismissButton: .default(Text("Ok")){
                            if alertMessage == "Reporte creado con exito"{
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    )
                }
            }
            .onAppear {
                fetchUserData()
                fetchDespensaData()
            }
        }
    }
    
    // MARK: - Fetch Functions
    
    private func fetchDespensaData() {
        FirestoreManager.getDespensa { despensas in
            DispatchQueue.main.async {
                self.despensaNames = despensas.map { $0.id }
            }
        }
    }
    
    private func fetchUserData() {
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
    
    private func fetchUserByID(_ userID: String) {
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
    private func crearReporte() {
        
        // We assume that the first worker in the array is the main  worker.
        let mainWorkerID = delivery.responsibleUsers.first ?? ""
        let reportID = "\(delivery.direction.replacingOccurrences(of: " ", with: ""))\(delivery.date)\(mainWorkerID)"
        
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
                    "responsibleUsers": delivery.responsibleUsers
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

struct UserReport {
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
