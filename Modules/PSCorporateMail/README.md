# PSCorporateMail

> A PowerShell 5.1 enterprise notification framework for building branded, Outlook-safe HTML emails using reusable components instead of hand-written HTML.

---

# Overview

PSCorporateMail is a reusable PowerShell module designed to standardize email and notification generation across automation solutions.

Rather than manually concatenating HTML strings in every script, PSCorporateMail provides a component-based document model that separates:

- Content
- Presentation
- Rendering
- Delivery

This allows automation engineers to focus on business logic while the framework handles email structure, styling, and rendering.

Originally designed for enterprise automation scenarios including:

- ServiceNow Notifications
- Termination SafeGuard Reporting
- Active Directory Reporting
- Exchange Online Reporting
- Workday Reporting
- Jenkins Notifications
- IT Communications
- Executive Dashboards
- Compliance Reporting

---

# Why This Module Exists

Many automation solutions eventually end up generating HTML emails.

Typical automation scripts often contain:

```powershell
$html += '<table>'
$html += '<tr>'
$html += '<td>'
```

Over time this creates several problems:

- Duplicate HTML across projects
- Inconsistent branding
- Difficult maintenance
- Complex styling updates
- Poor readability
- Outlook rendering issues

PSCorporateMail solves this by introducing reusable email components.

Instead of writing HTML:

```powershell
$html += '<h1>Title</h1>'
```

You write:

```powershell
$Mail |
    Add-EmailHero `
        -Title 'Title'
```

---

# Design Goals

## Outlook First

Generated HTML must render correctly in:

- Outlook Desktop
- Outlook Web
- Exchange Online
- Mobile Email Clients

The framework intentionally avoids:

- CSS Grid
- Flexbox
- JavaScript
- Browser-specific layouts

and instead relies on proven Outlook-compatible email techniques.

---

## Component-Based Design

Every visual element is represented as a reusable component.

Examples:

- Hero
- Section
- Alert
- List
- Table
- Button
- Footer
- Image

---

## Separation of Concerns

The framework separates responsibilities into layers:

```text
Automation Script
        ↓
Email Document
        ↓
Components
        ↓
Renderers
        ↓
HTML
        ↓
Delivery
```

Each layer has a single responsibility.

---

# Example Usage

```powershell
$Mail = New-EmailDocument `
    -Template ServiceDesk `
    -Title 'Termination SafeGuard'

$Mail |
    Add-EmailHero `
        -Title '1 Account Requires Review' `
        -Severity Warning

$Mail |
    Add-EmailSection `
        -Title 'Summary' `
        -Body 'A terminated employee account remains enabled.'

$Mail |
    Add-EmailTable `
        -Data $Results

$Mail |
    Add-EmailButton `
        -Text 'Open ServiceNow' `
        -Url $SnowUrl

$html = Export-EmailHtml -Document $Mail
```

---

# Architecture

## Document Model

The framework is built around a document object model.

A document contains:

```text
Document
│
├── Metadata
│
└── Components
```

### Document Metadata

```powershell
Metadata = [PSCustomObject]@{
    Title
    Subtitle
    Template
    CreatedDate
    Version
}
```

### Components Collection

Documents store components using:

```powershell
[System.Collections.Generic.List[object]]
```

Benefits:

- Fast insertion
- Better scalability
- No array recreation
- Cleaner API

---

## Component Model

All components share a standardized contract.

```text
Component
│
├── Type
├── Id
│
├── Metadata
│
└── Properties
```

Example:

```powershell
[PSCustomObject]@{
    Type = 'Section'

    Id = [guid]::NewGuid

    Metadata = [PSCustomObject]@{
        CreatedDate = Get-Date
        Version     = '1.0.0'
    }

    Properties = [PSCustomObject]@{
        Title = 'Summary'
        Body  = 'This is a test.'
    }
}
```

---

# Architectural Standards

These decisions are considered foundational.

## Metadata Standard

All metadata objects use:

```powershell
[PSCustomObject]
```

Examples:

```powershell
Document.Metadata
Component.Metadata
```

---

## Property Standard

All component properties use:

```powershell
[PSCustomObject]
```

Examples:

```powershell
Component.Properties.Title
Component.Properties.Body
```

---

## Standard Component Contract

Every component must contain:

```text
Type
Id
Metadata
Properties
```

Renderers consume this contract exclusively.

Correct:

```powershell
$Component.Properties.Title
```

Incorrect:

```powershell
$Component.Title
```

---

# Public Commands

## Core Document Functions

| Function | Purpose | Status |
|----------|----------|----------|
| New-EmailDocument | Create an email document | ✅ |
| Export-EmailHtml | Render document to HTML | 🔲 |
| Send-EmailDocument | Deliver email | 🔲 |

---

## Component Commands

| Function | Purpose | Status |
|----------|----------|----------|
| Add-EmailHero | Hero/Header component | ✅ |
| Add-EmailSection | Content section | ✅ |
| Add-EmailButton | Call-to-action button | ✅ |
| Add-EmailAlert | Alert message | 🔲 |
| Add-EmailList | Bulleted list | 🔲 |
| Add-EmailTable | Data table | 🔲 |
| Add-EmailFooter | Footer block | 🔲 |
| Add-EmailImage | Image support | 🔲 |

---

# Internal Framework Helpers

These functions are private and not intended for direct consumer use.

## New-EmailComponent ✅

Creates standardized component objects.

Responsibilities:

- Generate IDs
- Apply metadata
- Apply standard structure
- Assign component type

---

## Add-DocumentComponent ✅

Adds components to documents.

Responsibilities:

- Validate document
- Validate component
- Add component to collection

---

## Test-EmailDocument ✅

Validates document integrity.

Responsibilities:

- Verify TypeName
- Verify Metadata
- Verify Components collection
- Verify document structure

---

# Theme Engine

Themes separate branding from content.

A theme controls:

- Primary Color
- Accent Color
- Fonts
- Hero Styling
- Button Styling
- Footer Styling
- Alert Styling

## Planned Themes

### ServiceDesk

```text
Corporate
Blue
Modern
```

### Automation

```text
Technical
Dark
System Notifications
```

### Compliance

```text
Governance
Audit
Professional
```

### Executive

```text
Minimal
Leadership Reporting
```

---

# Rendering Engine

Renderers convert components into Outlook-safe HTML.

Planned renderers:

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

## Renderer Rules

Renderers should consume only:

```powershell
Component.Type
Component.Metadata
Component.Properties
```

Renderers must never depend on component-specific root properties.

---

# Development Roadmap

## Version 0.1 (Current)

Completed:

- ✅ New-EmailDocument
- ✅ New-EmailComponent
- ✅ Add-DocumentComponent
- ✅ Test-EmailDocument
- ✅ Add-EmailHero
- ✅ Add-EmailSection
- ✅ Add-EmailButton

---

## Version 0.2

Goals:

- 🔲 Add-EmailAlert
- 🔲 Add-EmailList
- 🔲 Add-EmailTable
- 🔲 Add-EmailFooter

---

## Version 0.3

Goals:

- 🔲 Theme Engine
- 🔲 ServiceDesk Theme
- 🔲 Automation Theme
- 🔲 Compliance Theme
- 🔲 Executive Theme

---

## Version 0.4

Goals:

- 🔲 Component Renderers
- 🔲 HTML Generation

---

## Version 0.5

Goals:

- 🔲 Export-EmailHtml
- 🔲 Sample Templates

---

## Version 1.0

Goals:

- 🔲 Outlook-safe rendering
- 🔲 Documentation
- 🔲 Testing
- 🔲 Production-ready release

---

# MVP Definition

Version 1.0 is complete when:

- ✅ Documents can be created
- ✅ Components can be attached
- ✅ Themes can be selected
- ✅ Alerts can be rendered
- ✅ Lists can be rendered
- ✅ Tables can be rendered
- ✅ Buttons can be rendered
- ✅ Footers can be rendered
- ✅ HTML can be generated
- ✅ Outlook rendering is validated

Required commands:

```text
New-EmailDocument
Add-EmailHero
Add-EmailSection
Add-EmailAlert
Add-EmailList
Add-EmailTable
Add-EmailButton
Add-EmailFooter
Export-EmailHtml
```

---

# Enterprise Extensions (Post v1.0)

These features are intentionally deferred until the core framework is stable.

## Active Directory

- Add-EmailADUserSummary

## Exchange Online

- Add-EmailMailboxSummary

## ServiceNow

- Add-EmailTicketSummary

## Termination SafeGuard

- Add-EmailTerminationSummary

## Jenkins

- Add-EmailBuildSummary

---

# Future Enhancements

## Validation

- Validate Generic List type
- Validate component schemas
- Validate themes

---

## Component Metadata

- Automatic component ordering
- Correlation IDs
- Author tracking
- Render history

---

## Component Validation

Add ValidateSet support to:

```powershell
New-EmailComponent
```

---

## Additional Components

- Add-EmailInfoBox
- Add-EmailImage
- Add-EmailDivider
- Add-EmailSpacer
- Add-EmailColumns

---

## Testing

- Pester Coverage
- JSON Snapshot Testing
- HTML Snapshot Testing
- Outlook Rendering Validation

---

# Contributing Standards

All future components must follow the same pattern:

```text
Add-Email<Component>
        ↓
New-EmailComponent
        ↓
Add-DocumentComponent
        ↓
Document.Components
```

Rules:

- Components do not generate HTML.
- Components do not modify document metadata.
- Components store all data in `Properties`.
- Components use the standard component contract.
- Renderers consume components.
- Components never consume renderers.

---

# Module Structure

```text
PSCorporateMail
│
├── Functions
│   ├── Public
│   └── Private
│
├── Themes
├── Tests
├── Examples
├── Docs
│
├── PSCorporateMail.psd1
└── PSCorporateMail.psm1
```

---

# Immediate Next Steps

1. Build Add-EmailAlert
2. Build Add-EmailList
3. Build Add-EmailTable
4. Build Add-EmailFooter
5. Implement Theme Engine
6. Implement HTML Renderers
7. Implement Export-EmailHtml
8. Implement Send-EmailDocument
9. Build Pester Tests
10. Release Version 1.0

---

# Author

Created for enterprise automation and reporting scenarios using PowerShell 5.1.