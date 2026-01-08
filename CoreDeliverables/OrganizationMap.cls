VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "OrganizationMap"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
' ========================================================================================
' OrganizationMap class manages the visualization and interaction of organizational units
' and their relationships within an Excel worksheet, including drawing nodes, connectors,
' and handling multiple selections in dropdown cells.
' ========================================================================================

' Stores cell values for multiple selections in dropdowns
Dim cellValues As Scripting.Dictionary
' Range containing business unit data
Dim unitRange As Range
' Range containing relationships between units (connected to)
Dim relRange As Range


' Triggered when the worksheet is activated
' Initializes the cellValues dictionary and defines ranges for units and relationships.
Private Sub Worksheet_Activate()
    Dim wb As Workbook
    Set wb = ActiveWorkbook
    
    Set cellValues = New Scripting.Dictionary
    Call DefineRanges(wb)
    Application.EnableEvents = True
End Sub


' Handles changes in worksheet cells.
' Manages multiple selections in dropdown cells and updates cellValues accordingly.
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
    
    ' Ensure ranges are defined
    If unitRange Is Nothing Then
        Call DefineRanges(wb)
    End If
    
    ' Ensure cellValues dictionary is initialized
    If cellValues Is Nothing Then
        Set cellValues = New Scripting.Dictionary
    End If

    ' Check if the changed cell is within the relationship range
    If Not Intersect(Target, relRange) Is Nothing And Target.text <> "" Then
        Application.EnableEvents = False

        newVal = Target.Value
        key = "R" & CStr(Target.Row) & "C" & CStr(Target.Column)

        ' Retrieve previous value if exists
        If cellValues.exists(key) Then
            oldVal = cellValues(key)
            exists = True
        End If

        ' Append new selection if not a duplicate
        If Target.Offset(0, 0).Value <> "" Then
            ' Avoid duplicates
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

        Application.EnableEvents = True
    End If

CleanExit:
    Application.EnableEvents = True
    Exit Sub

ErrorHandler:
    MsgBox "Error " & Err.Number & ": " & Err.Description, vbCritical, "Worksheet_Change Error"
    Resume CleanExit

End Sub


' Draws the business unit map diagram on the worksheet.
' Creates nodes for each unit, draws connectors for relationships, and links internal units to the main organization node.
Sub DrawBusinessUnitMap()
    Dim ws As Worksheet, wb As Workbook
    Set ws = ActiveSheet
    Set wb = ActiveWorkbook
    
    ' Ensure ranges for units and relationships are defined
    If unitRange Is Nothing Then
        Call DefineRanges(wb)
    End If
    
    ' Count valid units (non-empty names)
    Dim unitCount As Long
    Dim validUnits As Collection
    Set validUnits = New Collection

    Dim i As Long
    For i = 1 To unitRange.Rows.Count
        If Trim(unitRange.Cells(i, 2).Value) <> "" Then
            validUnits.Add i   ' store row index
        End If
    Next i
    
    unitCount = validUnits.Count
    
    ' Get existing shapes to avoid redrawing
    Dim existingShapes As Scripting.Dictionary
    Set existingShapes = GetShapeDictionary(Me)
        
    ' Define diagram's initial position and main node properties
    Dim centerX As Single, centerY As Single, radius As Single
    centerX = wb.Names("_xInitialPosition_1").RefersToRange.Value
    centerY = wb.Names("_yInitialPosition_1").RefersToRange.Value
    radius = 200
    
    ' Add MAIN NODE (Organization) if not exists
    Dim mainNode As Shape
    Dim mainW As Single, mainH As Single, mainName As String
    
    mainW = 120    ' width
    mainH = 50     ' height
    mainName = wb.Names("_Organization").RefersToRange.Value
    
    If Not existingShapes.exists("MAIN_ORG") Then
        Set mainNode = AddNode(msoShapeRoundedRectangle, "MAIN_ORG", mainName, mainW, mainH, centerX, centerY, True, msoShapeStylePreset10, Me)
        existingShapes.Add "MAIN_ORG", mainNode
    End If
        
    
    ' Draw each business unit as a node
    For i = 1 To unitCount
        Dim id As String, name As String, uType As String, style As MsoShapeStyleIndex
        name = unitRange.Cells(i, 2).Value
        id = CalculateID(name)
        style = msoShapeStylePreset9

        If existingShapes.exists(id) Then GoTo ContinueLoop

        ' Compute angle for this node
        Dim theta As Double
        theta = (i - 1) * 2 * Application.WorksheetFunction.Pi() / unitCount

        Dim x As Single, y As Single
        x = centerX + radius * Cos(theta)
        y = centerY + radius * Sin(theta)
        
        
        uType = unitRange.Cells(validUnits(i), 1).Value
        If LCase(Trim(uType)) <> "internal" Then
            style = msoShapeStylePreset8
        End If

        ' Add shape for the unit
        Dim s As Shape
        Set s = AddNode(msoShapeOval, id, name, 100, 60, x, y, False, style, Me)
        s.TextEffect.FontSize = 10.5
        ' Store in dictionary
        existingShapes.Add id, s
ContinueLoop:
    Next i
    

    ' Create connectors between units based on relationships
    Dim validRels As Collection
    Set validRels = New Collection
    
    For i = 1 To relRange.Rows.Count
        If Trim(relRange.Cells(i, 1).Value) <> "" Then
            validRels.Add i   ' store row index
        End If
    Next i
    

    Dim r As Long
    Dim connectionName As String, reversedConnection As String
    
    For r = 1 To validRels.Count
        Dim fromID As String, toID As String
        Dim connections() As String
        fromID = CalculateID(unitRange.Cells(r, 2).Value)
        ' Split by comma
        connections = Split(relRange.Cells(r, 1).Value, ",")
        
        For i = LBound(connections) To UBound(connections)
            toID = CalculateID(Trim(connections(i))) ' Trim removes extra spaces
            connectionName = fromID & "@" & toID
            reversedConnection = toID & "@" & fromID
            
            ' Avoid duplicate and two-way connections
            If existingShapes.exists(connectionName) Or existingShapes.exists(reversedConnection) Then GoTo ContinueConnectionsLoop
        
            If existingShapes.exists(fromID) And existingShapes.exists(toID) Then
                Dim conn As Shape
                Set conn = ws.Shapes.AddConnector(msoConnectorCurve, 0, 0, 100, 100)
                conn.ConnectorFormat.BeginConnect existingShapes(fromID), 1
                conn.ConnectorFormat.EndConnect existingShapes(toID), 1
                conn.RerouteConnections
                conn.name = connectionName
               
                existingShapes.Add connectionName, conn
            End If
            
ContinueConnectionsLoop:
        Next i
    Next r

    
    ' Connect MAIN NODE to all INTERNAL units
    Dim unitType As String, mainToBuConnectionName As String
    For i = 1 To unitCount
        ' B column = Type of Unit
        unitType = unitRange.Cells(validUnits(i), 1).Value
        
        If LCase(Trim(unitType)) = "internal" Then
            Dim extID As String
            extID = CalculateID(unitRange.Cells(validUnits(i), 2).Value)
            mainToBuConnectionName = "MAIN_ORG@" & extID
            
            
            If Not existingShapes.exists(mainToBuConnectionName) Then
                Dim connMain As Shape
                Set connMain = ws.Shapes.AddConnector(msoConnectorCurve, 0, 0, 100, 100)
                connMain.name = mainToBuConnectionName
                
                If mainNode Is Nothing Then
                    Set mainNode = existingShapes("MAIN_ORG")
                End If
                
                connMain.ConnectorFormat.BeginConnect mainNode, 1
                connMain.ConnectorFormat.EndConnect existingShapes(extID), 1
                connMain.RerouteConnections
                connMain.Line.ForeColor.RGB = RGB(233, 113, 50)
                
                existingShapes.Add mainToBuConnectionName, connMain
            End If
        End If
    Next i
    
    ' Bring main node to front
    If Not mainNode Is Nothing Then
        mainNode.ZOrder (msoBringToFront)
    End If
End Sub

' Deletes all generated shapes from the worksheet after user confirmation.
Sub DeleteShapes()
    Dim response As VbMsgBoxResult
    
    ' Show confirmation dialog
    response = MsgBox("This action will delete all the generated shapes from " & Me.name & ". Are you sure?", vbYesNo + vbQuestion, "Confirm Action")
    
    If response = vbYes Then
        Call EraseShapes(Me)
    End If
End Sub

' Copy the business units to memory clipboard (used in the Operational deliverables file)
Sub CopyBusinessUnits()
    Dim response As VbMsgBoxResult
    Dim wb As Workbook
    Set wb = ActiveWorkbook
    
        ' Ensure ranges for units and relationships are defined
    If unitRange Is Nothing Then
        Call DefineRanges(wb)
    End If

    ' Count valid units (non-empty names)
    Dim unitCount As Long
    Dim validUnits As Collection
    Set validUnits = New Collection

    Dim i As Long
    For i = 1 To unitRange.Rows.Count
        If Trim(unitRange.Cells(i, 2).Value) <> "" And LCase(Trim(unitRange.Cells(i, 1).Value)) = "internal" Then
            validUnits.Add unitRange.Cells(i, 2).Value   ' store fu name
        End If
    Next i


    ' Build a newline-separated string (for pasting into rows)
    If validUnits.Count > 0 Then
        ReDim buf(1 To validUnits.Count)
        For i = 1 To validUnits.Count
            buf(i) = CStr(validUnits(i))
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

' Defines the ranges for business units and relationships using named ranges in the workbook.
Function DefineRanges(ByVal wb As Workbook)
    Set unitRange = Range("OrganizationMap_BUType_Column")
    Set relRange = Range("OrganizationMap_ConnectedTo_Column")
End Function


