# PSCorporateMail Framework

## Vision

Build a reusable PowerShell 5.1 enterprise notification framework that allows automation developers to create branded, standardized HTML emails without writing HTML directly.

The goal is to write automation code like this:

```powershell
$Mail = New-EmailDocument `
    -Template ServiceDesk `
    -Title "Termination SafeGuard"

$Mail |
    Add-EmailHero `
        -Title "1 Account Requires Review" `
        -Severity Warning

$Mail |
    Add-EmailSection `
        -Title "Summary" `
        -Body "A terminated employee account remains enabled."

$Mail |
    Add-EmailTable -Data $Results

$Mail |
    Add-EmailButton `
        -Text "Open ServiceNow" `
        -Url $SnowUrl

$html = Export-EmailHtml -Document $Mail
```

The automation script should never need to manipulate HTML directly.

---

# Design Principles

## Reusable Components

Every visual element should be a standardized component.

Examples:

- Hero
- Section
- Alert
- List
- Table
- Button
- Footer
- Image

## Separation of Concerns

Automation scripts define content.

Component builders create document objects.

Renderers define appearance.

Themes define branding.

## Outlook First

All generated HTML must be compatible with:

- Outlook Desktop
- Outlook Web
- Exchange Online
- Mobile Email Clients

Avoid:

- Flexbox
- CSS Grid
- Advanced CSS
- JavaScript

Prefer:

- Tables
- Inline CSS
- Email-safe HTML

## Extensible

Future business-specific components can be added without changing existing scripts.

Examples:

- ServiceNow Summary
- AD User Summary
- Exchange Summary
- Workday Summary
- Jenkins Build Summary

---

# Current Object Model

## Document Structure

```powershell
Document
│
├── Metadata (PSCustomObject)
│   ├── Title
│   ├── Subtitle
│   ├── Template
│   ├── CreatedDate
│   └── Version
│
└── Components (List[object])
```

Example:

```powershell
[PSCustomObject]@{
    Metadata = [PSCustomObject]@{
        Title       = $Title
        Subtitle    = $Subtitle
        Template    = $Template
        CreatedDate = Get-Date
        Version     = '1.0.0'
    }

    Components = [System.Collections.Generic.List[object]]::new()
}
```

---

## Component Structure

Every component shares the same schema.

```powershell
Component
│
├── Type
├── Id
│
├── Metadata
│   ├── CreatedDate
│   ├── Version
│   └── Order
│
└── Properties
```

Example:

```powershell
[PSCustomObject]@{
    Type = 'Section'

    Id = :NewGuid().Guid

    Metadata = [PSCustomObject]@{
        CreatedDate = Get-Date
        Version     = '1.0.0'
        Order       = 1
    }

    Properties = [PSCustomObject]@{
        Title = 'Summary'
        Body  = 'This is a test.'
    }
}
```

---

# Phase 1: Core Framework

## Objective

Build a document object model for email content.

### ✅ New-EmailDocument

Creates the root email object.

Example:

```powershell
$Mail = New-EmailDocument `
    -Title "Monthly Update" `
    -Template ServiceDesk
```

### ✅ New-EmailComponent

Private helper used by all public components.

Responsibilities:

- Create component IDs
- Apply metadata
- Apply standard structure
- Register component type

### ✅ Add-DocumentComponent

Private helper used by all public components.

Responsibilities:

- Validate documents
- Validate components
- Add components to the document
- Maintain component ordering

### ✅ Test-EmailDocument

Private validation helper.

Responsibilities:

- Validate document schema
- Validate metadata
- Validate components collection

---

# Phase 2: Component Architecture

## ✅ Add-EmailHero

### Purpose

Creates a large header/banner section.

### Example

```powershell
$Mail |
    Add-EmailHero `
        -Title "Termination SafeGuard" `
        -Subtitle "Daily Compliance Review" `
        -Severity Warning
```

### Stored Properties

```powershell
Properties = @{
    Title
    Subtitle
    Severity
}
```

### Usage

- Daily reports
- IT newsletters
- Escalation alerts
- Executive summaries

---

## ✅ Add-EmailSection

### Purpose

Creates a standard content block.

### Example

```powershell
$Mail |
    Add-EmailSection `
        -Title "Why It Matters" `
        -Body "Disabled accounts reduce risk."
```

### Stored Properties

```powershell
Properties = @{
    Title
    Body
}
```

### Usage

General narrative content.

---

## ✅ Add-EmailButton

### Purpose

Creates call-to-action buttons.

### Example

```powershell
$Mail |
    Add-EmailButton `
        -Text "Open Ticket" `
        -Url $TicketUrl
```

### Stored Properties

```powershell
Properties = @{
    Text
    Url
}
```

### Usage

- ServiceNow
- SharePoint
- Internal portals
- Dashboards

---

## 🔲 Add-EmailAlert

### Purpose

Displays alert-style content.

### Example

```powershell
$Mail |
    Add-EmailAlert `
        -Severity Critical `
        -Message "MID Server Offline"
```

### Stored Properties

```powershell
Properties = @{
    Severity
    Message
}
```

### Severity Levels

```text
Info
Success
Warning
Critical
```

### Usage

- Automation failures
- Monitoring
- Compliance notifications

---

## 🔲 Add-EmailList

### Purpose

Creates bulleted or numbered lists.

### Stored Properties

```powershell
Properties = @{
    Title
    Items
}
```

---

## 🔲 Add-EmailTable

### Purpose

Automatically renders PowerShell objects into HTML tables.

### Stored Properties

```powershell
Properties = @{
    Data
}
```

### Features

- Automatic column generation
- Optional column selection
- Row highlighting
- Empty result handling

---

## 🔲 Add-EmailFooter

### Purpose

Creates standardized footer content.

### Stored Properties

```powershell
Properties = @{
    Department
    SupportEmail
    AdditionalText
}
```

---

## 🔲 Add-EmailImage

### Purpose

Display images or screenshots.

### Stored Properties

```powershell
Properties = @{
    Path
    Url
    AltText
}
```

---

# Phase 3: Theme Engine

## Objective

Keep branding separate from content.

### Usage

```powershell
New-EmailDocument `
    -Template ServiceDesk
```

Template determines:

- Colors
- Fonts
- Header styling
- Footer styling
- Alert styling

---

## Theme: ServiceDesk

```text
Modern
Corporate
Blue
```

```text
Primary: #0078D4
Accent:  #005A9E
```

---

## Theme: Automation

```text
Technical
Dark
System Notifications
```

```text
Primary: #003A70
Accent:  #0078D4
```

---

## Theme: Compliance

```text
Audit
Governance
Professional
```

```text
Primary: #107C10
Accent:  #5E9732
```

---

## Theme: Executive

```text
Minimal
Leadership Reports
Premium
```

```text
Primary: #323130
Accent:  #605E5C
```

---

# Phase 4: Rendering Engine

## Objective

Convert email objects into Outlook-safe HTML.

Public functions should never generate HTML directly.

Instead:

```text
Document
    ↓
Component Objects
    ↓
Renderers
    ↓
HTML
```

---

## Rendering Functions

```text
ConvertTo-DocumentHtml
ConvertTo-HeroHtml
ConvertTo-SectionHtml
ConvertTo-AlertHtml
ConvertTo-ListHtml
ConvertTo-TableHtml
ConvertTo-ButtonHtml
ConvertTo-ImageHtml
ConvertTo-FooterHtml
```

### Renderer Pattern

```powershell
foreach ($Component in $Document.Components) {

    switch ($Component.Type) {

        'Hero' {

            $Title = $Component.Properties.Title
        }

        'Section' {

            $Body = $Component.Properties.Body
        }

        'Button' {

            $Text = $Component.Properties.Text
            $Url  = $Component.Properties.Url
        }
    }
}
```

---

## 🔲 Export-EmailHtml

Combines:

- Theme
- Components
- Layout
- CSS

Into final HTML.

Example:

```powershell
$html = Export-EmailHtml -Document $Mail
```

---

# Phase 5: Sending Engine

## 🔲 Send-EmailDocument

### Objective

Abstract email delivery.

```powershell
Send-EmailDocument `
    -Document $Mail `
    -To $Recipients `
    -Subject $Subject
```

### Future Support

```text
SMTP
Microsoft Graph
Exchange Online
Shared Mailboxes
Distribution Lists
```

---

# Phase 6: Enterprise Reporting Components

## 🔲 Add-EmailADUserSummary

### Features

- Total users
- Disabled accounts
- New users
- Summary table

---

## 🔲 Add-EmailTerminationSummary

### Features

- Total findings
- High-risk users
- Exception table
- Recommended actions

---

## 🔲 Add-EmailMailboxSummary

### Features

- Mailbox statistics
- Shared mailbox details
- Licensing information

---

## 🔲 Add-EmailTicketSummary

### Features

- Open tickets
- New tickets
- Escalations
- SLA breaches

---

## 🔲 Add-EmailBuildSummary

### Features

- Build status
- Commit information
- Release notes
- Deployment results

---

# Module Structure

```text
PSCorporateMail
│
├── Functions
│   │
│   ├── Public
│   │   ├── New-EmailDocument.ps1
│   │   ├── Add-EmailHero.ps1
│   │   ├── Add-EmailSection.ps1
│   │   ├── Add-EmailButton.ps1
│   │   ├── Add-EmailAlert.ps1
│   │   ├── Add-EmailList.ps1
│   │   ├── Add-EmailTable.ps1
│   │   ├── Add-EmailFooter.ps1
│   │   ├── Add-EmailImage.ps1
│   │   ├── Export-EmailHtml.ps1
│   │   └── Send-EmailDocument.ps1
│   │
│   └── Private
│       ├── New-EmailComponent.ps1
│       ├── Add-DocumentComponent.ps1
│       ├── Test-EmailDocument.ps1
│       ├── ConvertTo-DocumentHtml.ps1
│       ├── ConvertTo-HeroHtml.ps1
│       ├── ConvertTo-SectionHtml.ps1
│       ├── ConvertTo-AlertHtml.ps1
│       ├── ConvertTo-ListHtml.ps1
│       ├── ConvertTo-TableHtml.ps1
│       ├── ConvertTo-ButtonHtml.ps1
│       ├── ConvertTo-ImageHtml.ps1
│       ├── ConvertTo-FooterHtml.ps1
│       ├── Get-Theme.ps1
│       └── Get-InlineStyles.ps1
│
├── Themes
├── Tests
├── Examples
├── Docs
├── PSCorporateMail.psd1
└── PSCorporateMail.psm1
```

---

# Initial MVP Scope

Version 1.0 should include:

### Completed

- ✅ New-EmailDocument
- ✅ New-EmailComponent
- ✅ Add-DocumentComponent
- ✅ Add-EmailHero
- ✅ Add-EmailSection
- ✅ Add-EmailButton
- ✅ Test-EmailDocument

### Remaining

- 🔲 Add-EmailAlert
- 🔲 Add-EmailList
- 🔲 Add-EmailTable
- 🔲 Add-EmailFooter
- 🔲 Export-EmailHtml

Theme support:

- ServiceDesk
- Automation

---

# Recommended Next Steps

## Phase 2 Completion

1. Build `Add-EmailAlert`
2. Build `Add-EmailList`
3. Build `Add-EmailTable`
4. Build `Add-EmailFooter`

## Phase 3

5. Build Theme Engine
6. Create ServiceDesk Theme
7. Create Automation Theme

## Phase 4

8. Build `ConvertTo-HeroHtml`
9. Build `ConvertTo-SectionHtml`
10. Build `ConvertTo-ButtonHtml`
11. Build `ConvertTo-AlertHtml`
12. Build `ConvertTo-DocumentHtml`
13. Build `Export-EmailHtml`

## Phase 5

14. Build `Send-EmailDocument`

---

# Long-Term Goal

Create a PowerShell 5.1 enterprise notification framework that allows any automation to generate professional, branded, Outlook-safe HTML communications using reusable components instead of custom HTML.

Target use cases:

- ServiceNow Notifications
- Termination SafeGuard Reports
- Active Directory Reporting
- Exchange Online Reporting
- Workday Reporting
- Jenkins Pipelines
- IT Newsletters
- Executive Dashboards
- Compliance Reporting