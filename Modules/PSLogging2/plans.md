# Implementation Plan: PSLogging2 Evolution (v3.0 Roadmap)

## 1. Bug Fixes & Stability (Priority: High - Patch 1.x.x)
*   **Thread Safety:** Implement `[System.Runtime.EnterExclusiveLock]` or a Semaphore mechanism to ensure that concurrent PowerShell jobs writing to the same log file do not cause "File in Use" errors.
*   **Exception Silencing:** Ensure that a failure in the logging subsystem (e.g., Disk Full, Permissions issue) does not crash the primary script execution unless explicitly requested via a `-Strict` parameter.
*   **Path Normalization:** Fix issues where relative paths or network shares (UNC paths) are not correctly resolved before attempting to initialize file handles.
*   **Encoding Standardization:** Force UTF-8 encoding for all file outputs to ensure special characters in log messages do not cause "Mojibake" or script crashes.

## 2. Core Feature Enhancements (Priority: Medium - v2.x)
*   **Structured Logging:** Add a `-Json` switch. Instead of plain text, output logs as JSON objects to allow for easier ingestion by tools like Splunk, ELK Stack, or Azure Monitor.
*   **Log Rotation (Rolling Files):** Implement automatic rotation logic based on file size (e.g., `maxSizeMB`) or date-based naming (e.g., `log_2023-10-27.txt`).
*   **Severity Levels:** Formally implement standard severity levels: `DEBUG`, `INFO`, `WARN`, `ERROR`, and `CRITICAL`.
*   **Contextual Metadata:** Automatically inject metadata into every log entry, including:
    *   Timestamp (ISO 8601 format)
    *   Script Name / Module Name
    *   Line Number (where the call originated)
    *   Machine Name/User Identity

## 3. Integration & Extensibility (Priority: Long-term - v3.x)
*   **Multi-Sink Support:** Allow one "Log" command to output to multiple destinations simultaneously (e.g., write to a local file AND the Windows Event Log).
*   **Event Log Provider:** Add an option to automatically create and write to a custom Windows Event Log.
*   **Webhook/API Sink:** Add a native hook for sending critical errors to a Webhook (e.g., Discord, Slack, or Teams).
*   **Configuration Files:** Implement `.json` or `.xml` configuration files so users don't have to pass long parameter strings every time they call the function.

## 4. Technical Debt & DX (Developer Experience)
*   **Performance Optimization:** Move heavy string manipulation and file IO to background threads where possible for high-frequency logging loops.
*   **Compatibility Layer:** Maintain full backward compatibility with current parameters while marking older methods as `[Obsolete()]`.
*   **Type Hinting:** Implement strongly typed objects (`PSCustomObject`) for all internal configuration objects to improve IntelliSense in VS Code and PowerShell ISE.

## Implementation Roadmap Phases:
- **Phase 1 (Stabilization):** Fix concurrency issues and enforce UTF-8 encoding.
- **Phase 2 (Standardization):** Add Severity levels and ISO 8601 timestamps.
- **Phase 3 (Advanced Features):** Implement JSON output and Log Rotation.
- **Phase 4 (Ecosystem Integration):** Add Windows Event Log and Webhook support.**
