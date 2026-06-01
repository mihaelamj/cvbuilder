let minimalDocumentJSON = """
{
  "cv": {
    "name": "Taylor Example",
    "title": "Senior iOS Developer",
    "summary": "Builds Swift applications and developer tools.",
    "contactInfo": {
      "email": "taylor@example.com",
      "phone": "+1 555 010 0101",
      "location": "Example City"
    }
  }
}
"""

let partialDocumentJSON = """
{
  "frontMatter": {
    "slug": "partial-cv"
  },
  "cv": {
    "name": "Jordan Example",
    "title": "Staff iOS Engineer",
    "summary": "Builds modular Swift platforms.",
    "contactInfo": {
      "email": "jordan@example.com",
      "phone": "+1 555 010 0102",
      "location": "Example City"
    },
    "experience": [
      {
        "company": {
          "name": "Example Systems"
        },
        "role": {
          "title": "iOS Engineer",
          "seniority": "Senior"
        },
        "period": {
          "start": { "month": 1, "year": 2024 },
          "end": { "month": 5, "year": 2026 }
        },
        "technicalFocus": {
          "areas": ["Architecture"]
        }
      }
    ],
    "education": [
      {
        "institution": "Example University",
        "degree": "BSc",
        "field": "Computer Science",
        "period": {
          "start": { "month": 9, "year": 2018 },
          "end": { "month": 6, "year": 2022 }
        }
      }
    ],
    "skills": [
      {
        "name": "Swift",
        "category": "language"
      }
    ]
  },
  "links": {
    "downloads": [
      {
        "label": "Markdown",
        "url": "/cv.md"
      }
    ]
  },
  "publicEvidence": [
    {
      "title": "Architecture Notes",
      "kind": "technicalWriting",
      "role": "Author",
      "summary": "Published notes about package boundaries.",
      "url": "https://example.com/notes",
      "technicalFocus": {
        "tags": ["architecture"]
      }
    }
  ],
  "rendering": {
    "mode": "earlyCareerTechnical"
  }
}
"""

let publicEvidenceHeavyDocumentJSON = """
{
  "cv": {
    "name": "Taylor Example",
    "title": "Senior iOS Developer",
    "summary": "Builds Swift applications and developer tools.",
    "contactInfo": {
      "email": "taylor@example.com",
      "phone": "+1 555 010 0101",
      "location": "Example City"
    }
  },
  "rendering": {
    "mode": "publicEvidenceHeavyTechnical"
  }
}
"""

let fullDocumentJSON = """
{
  "frontMatter": {
    "slug": "demo-cv",
    "title": "Demo CV"
  },
  "cv": {
    "id": "00000000-0000-0000-0000-000000000201",
    "name": "Alex Example",
    "title": "Senior Mobile Architect",
    "summary": "Builds Swift products and tooling.",
    "contactInfo": {
      "email": "alex@example.com",
      "phone": "+1 555 010 0103",
      "linkedIn": "https://example.com/linkedin",
      "github": "https://example.com/github",
      "website": "https://example.com",
      "location": "Example City"
    },
    "experience": [
      {
        "id": "00000000-0000-0000-0000-000000000202",
        "company": {
          "id": "00000000-0000-0000-0000-000000000203",
          "name": "Example Systems"
        },
        "role": {
          "id": "00000000-0000-0000-0000-000000000204",
          "title": "Mobile Architect",
          "seniority": "Senior"
        },
        "period": {
          "start": { "month": 9, "year": 2025 },
          "end": { "month": 5, "year": 2026 }
        },
        "projects": [
          {
            "id": "00000000-0000-0000-0000-000000000205",
            "project": {
              "id": "00000000-0000-0000-0000-000000000206",
              "name": "Contract Tooling",
              "company": {
                "id": "00000000-0000-0000-0000-000000000203",
                "name": "Example Systems"
              },
              "descriptions": [
                "Built a Swift package."
              ],
              "techs": [
                {
                  "id": "00000000-0000-0000-0000-000000000207",
                  "name": "Swift",
                  "category": "language"
                }
              ],
              "role": {
                "id": "00000000-0000-0000-0000-000000000204",
                "title": "Mobile Architect",
                "seniority": "Senior"
              },
              "period": {
                "start": { "month": 9, "year": 2025 },
                "end": { "month": 5, "year": 2026 }
              },
              "urls": [
                "https://example.com/tooling"
              ],
              "isCurrent": true,
              "technicalFocus": {
                "areas": ["API tooling"],
                "tags": ["swift"]
              }
            },
            "role": {
              "id": "00000000-0000-0000-0000-000000000204",
              "title": "Mobile Architect",
              "seniority": "Senior"
            },
            "period": {
              "start": { "month": 9, "year": 2025 },
              "end": { "month": 5, "year": 2026 }
            },
            "technicalFocus": {
              "areas": ["Package design"],
              "tags": ["spm"]
            }
          }
        ],
        "isCurrent": true,
        "technicalFocus": {
          "areas": ["Architecture"],
          "tags": ["modularity"]
        }
      }
    ],
    "education": [
      {
        "id": "00000000-0000-0000-0000-000000000208",
        "institution": "Example University",
        "degree": "MSc",
        "field": "Computer Science",
        "period": {
          "start": { "month": 9, "year": 2016 },
          "end": { "month": 6, "year": 2018 }
        }
      }
    ],
    "skills": [
      {
        "id": "00000000-0000-0000-0000-000000000209",
        "name": "OpenAPI",
        "category": "tool"
      }
    ]
  },
  "links": {
    "profiles": [
      {
        "label": "GitHub",
        "url": "https://example.com/github"
      }
    ],
    "downloads": [
      {
        "label": "PDF",
        "url": "/assets/demo-cv.pdf"
      }
    ],
    "companyURLs": {
      "Example Systems": "https://example.com/company"
    }
  },
  "publicEvidence": [
    {
      "id": "00000000-0000-0000-0000-000000000210",
      "title": "Contract Tooling",
      "kind": "openSource",
      "role": "Maintainer",
      "summary": "Maintains release notes for the package.",
      "url": "https://example.com/tooling",
      "technologies": ["Swift", "OpenAPI"],
      "date": "2026",
      "highlights": [
        "Kept releases documented."
      ],
      "technicalFocus": {
        "areas": ["Developer tooling"],
        "tags": ["contracts"]
      }
    }
  ],
  "rendering": {
    "mode": "experiencedTechnical",
    "recentCompanyCount": 3,
    "maxBulletsPerProject": 4,
    "nestProjectsUnderRoles": true,
    "compactGroupedSkills": true,
    "omitEmptySections": true
  }
}
"""

let projectCollectionsDocumentJSON = """
{
  "cv": {
    "name": "Casey Example",
    "title": "iOS Engineer",
    "summary": "Builds Swift features.",
    "contactInfo": {
      "email": "casey@example.com",
      "phone": "+1 555 010 0104",
      "location": "Example City"
    },
    "experience": [
      {
        "company": {
          "name": "Example Products"
        },
        "role": {
          "title": "iOS Engineer",
          "seniority": "Mid"
        },
        "period": {
          "start": { "month": 1, "year": 2023 },
          "end": { "month": 12, "year": 2023 }
        },
        "projects": [
          {
            "project": {
              "name": "Feature Delivery",
              "company": {
                "name": "Example Products"
              },
              "role": {
                "title": "iOS Engineer",
                "seniority": "Mid"
              },
              "period": {
                "start": { "month": 1, "year": 2023 },
                "end": { "month": 12, "year": 2023 }
              }
            },
            "role": {
              "title": "iOS Engineer",
              "seniority": "Mid"
            },
            "period": {
              "start": { "month": 1, "year": 2023 },
              "end": { "month": 12, "year": 2023 }
            }
          }
        ]
      }
    ]
  }
}
"""

let nullIDDocumentJSON = """
{
  "cv": {
    "id": null,
    "name": "Taylor Example",
    "title": "Senior iOS Developer",
    "summary": "Builds Swift applications and developer tools.",
    "contactInfo": {
      "email": "taylor@example.com",
      "phone": "+1 555 010 0101",
      "location": "Example City"
    }
  }
}
"""

let nullCollectionDocumentJSON = """
{
  "cv": {
    "name": "Taylor Example",
    "title": "Senior iOS Developer",
    "summary": "Builds Swift applications and developer tools.",
    "contactInfo": {
      "email": "taylor@example.com",
      "phone": "+1 555 010 0101",
      "location": "Example City"
    },
    "experience": null
  }
}
"""
