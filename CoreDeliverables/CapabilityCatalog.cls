Imports System.Collections.ObjectModel

VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CapabilityCatalog"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True

' ========================================================================================
' CapabilityCatalog class manages multiple selection in dropdown cells within a specified
' range, storing selections in a dictionary and handling worksheet activation and changes.
' ========================================================================================

' Dictionary to store cell values for multiple selections in dropdowns
Dim cellValues As Scripting.Dictionary
' Range containing the cells with dropdowns for relationships
Dim relRange As Range

' Worksheet_Activate event handler
' - Initializes the cellValues dictionary
' - Defines the relRange for dropdowns using a named range
' - Enables worksheet events
Private Sub Worksheet_Activate()
    Dim wb As Workbook
    Set wb = ActiveWorkbook
    
    Set cellValues = New Scripting.Dictionary
    Call DefineRanges(wb)
    Application.EnableEvents = True
End Sub

' DefineRanges function
' - Sets the relRange using the named range "CapabilityCatalog_BUOwner_Column" from the workbook
Function DefineRanges(ByVal wb As Workbook)
    Set relRange = Range("CapabilityCatalog_BUOwner_Column")
End Function

' Worksheet_Change event handler
' - Handles changes in worksheet cells
' - Manages multiple selections in dropdown cells within relRange
' - Updates cellValues to store selections and avoids duplicates
Private Sub Worksheet_Change(ByVal Target As Range)
    On Error GoTo ErrorHandler

    Dim newVal As String
    Dim oldVal As String
    Dim separator As String
    Dim exists As Boolean
    Dim wb As Workbook
    Set wb = ActiveWorkbook
    
    separator = ", " ' Separator between selections
    exists = False

    ' Ensure relRange is defined
    If relRange Is Nothing Then
        Call DefineRanges(wb)
    End If

    ' Ensure cellValues dictionary is initialized
    If cellValues Is Nothing Then
        Set cellValues = New Scripting.Dictionary
    End If

    ' Check if the changed cell is within the relRange
    If Not Intersect(Target, relRange) Is Nothing Then
        Application.EnableEvents = False

        If Target.text <> "" Then
            newVal = Target.Value
            key = "R" & CStr(Target.Row) & "C" & CStr(Target.Column)

            ' Retrieve previous value if exists
            If cellValues.exists(key) Then
                oldVal = cellValues(key)
                exists = True
            End If

            ' Append new selection if not a duplicate
            If Target.Offset(0, 0).Value <> "" Then
                If oldVal <> "" And InStr(1, oldVal, newVal) = 0 Then
                    Target.Value = oldVal & separator & newVal
                End If
            End If

            ' Update or add the value in the dictionary
            If exists Then
                cellValues(key) = Target.Value
            Else
                cellValues.Add key, Target.Value
            End If
        Else
            cellValues.RemoveAll
        End If

        Application.EnableEvents = True
    End If

CleanExit:
    Application.EnableEvents = True
    Exit Sub

ErrorHandler:
    ' Display error message and resume clean exit
    MsgBox "Error " & Err.Number & ": " & Err.Description, vbCritical, "Worksheet_Change Error"
    Resume CleanExit

End Sub

' Copy the capabilities to memory clipboard (used in the Operational deliverables file)
Sub CopyCapabilities()
    Dim response As VbMsgBoxResult
    Dim wb As Workbook
    Dim capRange As Range
    
    Set wb = ActiveWorkbook
    
    ' Ensure ranges for capabilities are defined
    Set capRange = Range("CapabilityCatalog_CapabilityName_Column")
    
    ' Count valid units (non-empty names)
    Dim capCount As Long
    Dim validCap As Collection
    Set validCap = New Collection

    Dim i As Long
    For i = 1 To capRange.Rows.Count
        If Trim(capRange.Cells(i, 2).Value) <> "" Then
            validCap.Add capRange.Cells(i, 1).Value   ' store fu name
        End If
    Next i


    ' Build a newline-separated string (for pasting into rows)
    If validCap.Count > 0 Then
        ReDim buf(1 To validCap.Count)
        For i = 1 To validCap.Count
            buf(i) = CStr(validCap(i))
        Next i
        textToCopy = Join(buf, vbCrLf)
    Else
        textToCopy = ""
    End If

    ' Copy to clipboard

    If CopyTextToClipboard(textToCopy) Then
        MsgBox "Units copied to clipboard." & vbCrLf &
               "Paste into a worksheet to get one per row.", vbInformation, "Message"
    Else
        MsgBox "Could not access the clipboard. As a fallback, values will be written to the active sheet.", vbExclamation, "Clipboard Error"
    End If

End Sub