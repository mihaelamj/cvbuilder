import SwiftUI

struct RoleEditorView: View {
    @Binding var role: Role
    @State private var title: String
    @State private var selectedSeniority: Role.Seniority
    
    init(role: Binding<Role>) {
        self._role = role
        self._title = State(initialValue: role.wrappedValue.title)
        self._selectedSeniority = State(initialValue: role.wrappedValue.seniority)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Role Details")) {
                TextField("Job Title", text: $title)
                
                Picker("Seniority Level", selection: $selectedSeniority) {
                    Text("Intern").tag(Role.Seniority.intern)
                    Text("Junior").tag(Role.Seniority.junior)
                    Text("Mid-Level").tag(Role.Seniority.mid)
                    Text("Senior").tag(Role.Seniority.senior)
                    Text("Lead").tag(Role.Seniority.lead)
                    Text("Principal").tag(Role.Seniority.principal)
                    Text("Chief").tag(Role.Seniority.chief)
                }
                .pickerStyle(MenuPickerStyle())
            }
            
            Section {
                Button("Save Role") {
                    role = Role(
                        id: role.id, // Preserve the existing ID
                        title: title,
                        seniority: selectedSeniority
                    )
                }
            }
        }
        .navigationTitle("Edit Role")
    }
}

// This view shows a list of predefined roles but also allows creating custom ones
struct RoleSelectionView: View {
    @Binding var selectedRole: Role
    @State private var showingCustomRoleEditor = false
    
    // Common predefined roles
    let predefinedRoles = [
        Role.juniorIOS,
        Role.midIOS,
        Role.seniorIOS,
        Role.leadIOS,
        Role(title: "Android Developer", seniority: .junior),
        Role(title: "Android Developer", seniority: .mid),
        Role(title: "Android Developer", seniority: .senior),
        Role(title: "Full Stack Developer", seniority: .mid),
        Role(title: "Full Stack Developer", seniority: .senior),
        Role(title: "Data Scientist", seniority: .mid),
        Role(title: "Product Manager", seniority: .senior),
        Role(title: "UX Designer", seniority: .mid)
    ]
    
    var body: some View {
        List {
            Section(header: Text("Predefined Roles")) {
                ForEach(predefinedRoles, id: \.id) { role in
                    HStack {
                        Text(role.name)
                        Spacer()
                        if selectedRole.id == role.id {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedRole = role
                    }
                }
            }
            
            Section {
                Button("Create Custom Role") {
                    showingCustomRoleEditor = true
                }
            }
        }
        .navigationTitle("Select Role")
        .sheet(isPresented: $showingCustomRoleEditor) {
            NavigationView {
                RoleEditorView(role: $selectedRole)
                    .navigationBarItems(
                        trailing: Button("Done") {
                            showingCustomRoleEditor = false
                        }
                    )
            }
        }
    }
}
