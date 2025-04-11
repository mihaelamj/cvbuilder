import Foundation

#if canImport(Ignite)
import Ignite

public struct IgniteRenderer {
    let cv: CV
    
    public init(cv: CV) {
        self.cv = cv
    }
    
    private func formatDate(_ date: Period.SimpleDate) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        let calendar = Calendar.current
        let components = DateComponents(year: date.year, month: date.month)
        let actualDate = calendar.date(from: components)!
        return formatter.string(from: actualDate)
    }
    
    @MainActor public var body: some HTML {
        Section {
            // Header with name and title
            Section {
                Text(cv.name)
                    .font(.title1)
                
                Text(cv.title)
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            
            // Contact Information
            Section {
                Text(cv.contactInfo.email)
                Text(cv.contactInfo.phone)
                Text(cv.contactInfo.location)
                
                if cv.contactInfo.linkedIn != nil || cv.contactInfo.github != nil || cv.contactInfo.website != nil {
                    List {
                        if let linkedIn = cv.contactInfo.linkedIn {
                            Link("LinkedIn", target: linkedIn)
                        }
                        
                        if let github = cv.contactInfo.github {
                            Link("GitHub", target: github)
                        }
                        
                        if let website = cv.contactInfo.website {
                            Link("Website", target: website)
                        }
                    }
                    .listMarkerStyle(.unordered(.automatic))
                    .margin(.leading, .medium)
                }
            }
            .margin(.vertical, .large)
            
            // Summary
            Section {
                Text("Summary")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(cv.summary)
            }
            .margin(.bottom, .large)
            .padding()
            
            // Experience
            Section {
                Text("Experience")
                    .font(.title3)
                    .fontWeight(.bold)
                
                ForEach(cv.experience) { experience in
                    Section {
                        Text(experience.company.name)
                            .font(.title4)
                            .fontWeight(.bold)
                        
                        Text(experience.role.title)
                            .font(.title5)
                        
                        Text("\(formatDate(experience.period.start)) - \(formatDate(experience.period.end))")
                            .foregroundStyle(.secondary)
                        
                        ForEach(experience.projects) { project in
                            Section {
                                Text(project.project.name)
                                    .fontWeight(.semibold)
                                
                                // Project descriptions
                                List {
                                    ForEach(project.project.descriptions) { description in
                                        Text(description)
                                    }
                                }
                                .listMarkerStyle(.unordered(.automatic))
                                .margin(.leading, .medium)
                                
                                if let urls = project.project.urls, !urls.isEmpty {
                                    // Project URLs
                                    List {
                                        ForEach(urls) { url in
                                            Link(url.absoluteString, target: url)
                                        }
                                    }
                                    .listMarkerStyle(.unordered(.automatic))
                                    .margin(.leading, .medium)
                                }
                                
                                if !project.project.techs.isEmpty {
                                    Section {
                                        ForEach(project.project.techs) { tech in
                                            Badge(tech.name)
                                                .margin(.trailing, .small)
                                        }
                                    }
                                }
                            }
                            .margin(.leading, .medium)
                        }
                        .padding()
                    }
                    .margin(.bottom, .large)
                }
                .padding()
            }
            .margin(.bottom, .large)
            .padding()
            
            // Education
            Section {
                Text("Education")
                    .font(.title3)
                    .fontWeight(.bold)
                
                ForEach(cv.education) { education in
                    Section {
                        Text(education.institution)
                            .font(.title4)
                            .fontWeight(.bold)
                        
                        Text(education.degree)
                        
                        Text("\(formatDate(education.period.start)) - \(formatDate(education.period.end))")
                            .foregroundStyle(.secondary)
                    }
                    .margin(.bottom, .medium)
                }
            }
            .margin(.bottom, .large)
            
            // Skills
            Section {
                Text("Skills")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Section {
                    ForEach(cv.skills) { skill in
                        Badge(skill.name)
                            .margin(.trailing, .small)
                    }
                }
            }
        }
        .padding(.vertical, .xLarge)
        .frame(maxWidth: .percent(80%))
        .horizontalAlignment(.leading)
    }
}
#endif
