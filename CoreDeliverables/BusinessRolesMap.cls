Imports System.Collections.ObjectModel

VERSION 1.0 CLASS
BEGIN
MultiUse = -1  'True
End
Attribute VB_Name = "BusinessRolesMap"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Option Explicit On

' ========================================================================================
' BusinessRolesMap class manages the visualization and interaction of roles within each
' business unit, including drawing boxes, and grouping shapes.
' ========================================================================================

' Dictionary to store functional units found in the organization map
Dim FunctionalUnits As Scripting.Dictionary


' - Reads functional units from the source worksheet
' - Copies internal unit names and IDs to the active sheet
' - Populates the FunctionalUnits dictionary
Sub LoadBusinessUnits()
    Dim srcWB As Workbook
    Dim srcWS As Worksheet
    Dim destWS As Worksheet
    Dim lastRow As Long
    Dim i As Long, colIndex As Long, id As Long
    Dim unitName As String

    Dim buIdRow As Long, buNameRow As Long, om_buNameRow As Long
    Dim roleStartCol As Long

    ' Set references to workbooks and worksheets
    Set srcWB = ActiveWorkbook
    Set srcWS = GetWorksheetByCodeName(srcWB, "OrganizationMap")
    Set destWS = ActiveSheet
    Set FunctionalUnits = New Scripting.Dictionary
    
    buIdRow = Range("BusinessRolesMap_BUIdRow").Row
    buNameRow = Range("BusinessRolesMap_BUName_Row").Row
    om_buNameRow = srcWS.Range("OrganizationMap_BUName_Row").Row
    roleStartCol = Range("BusinessRolesMap_RoleStart_Col").Column

    ' Find last row in source data (column C)
    lastRow = srcWS.Cells(srcWS.Rows.Count, "C").End(xlUp).Row

    id = 1

    ' Loop through source rows to find internal units
    For i = om_buNameRow To lastRow
        If srcWS.Cells(i, "C").Value = "Internal" Then
            unitName = srcWS.Cells(i, "D").Value

            ' Copy functional unit name to destination sheet
            destWS.Cells(buNameRow, roleStartCol).Value = unitName

            ' Add a generic ID to the column
            destWS.Cells(buIdRow, roleStartCol).Value = "BU-" & id

            ' Store unit in dictionary
            FunctionalUnits.Add unitName, 1

            roleStartCol = roleStartCol + 2
            id = id + 1
        End If
    Next i
End Sub

' DrawBusinessRolesMap subroutine
' - Draws rectangles for each business unit and its roles
' - Groups shapes for each business unit
' - Avoids redrawing existing shapes
Sub DrawBusinessRolesMap()
    Dim i As Long, j As Long
    Dim centerX As Single, centerY As Single
    Dim key As Variant
    Dim wb As Workbook

    Set wb = ActiveWorkbook
    
    i = 0
    centerX = wb.Names("_xInitialPosition_2").RefersToRange.Value
    centerY = wb.Names("_yInitialPosition_2").RefersToRange.Value

    Dim data As Collection
    Dim roles As Collection
    Dim item As Variant
    Dim role As Variant
    Dim x As Single, y As Single, yR As Single
    Dim existingShapes As Scripting.Dictionary
    
    Set data = ExtractBUData()
    Set existingShapes = GetShapeDictionary(Me)
    
    ' Iterate over business units and draw shapes
    Dim id As String, name As String, style As MsoShapeStyleIndex
    Dim shapeNames As Collection
    Dim shp As Variant, shpIndex As Long, arrNames() As Variant

    For Each item In data
        Set shapeNames = New Collection
        shpIndex = 0

        name = item(0)
        Set roles = item(1)
        
        id = CalculateID(name)
        style = msoShapeStylePreset2

        ' Skip if shape already exists
        If existingShapes.exists(id) Then GoTo ContinueLoop

        x = centerX + (i * 140)
        y = centerY
        yR = centerY + 5

        ' Add main business unit rectangle
        Dim s As Shape
        Set s = AddNode(msoShapeRectangle, id, name, 120, 70 + (roles.Count * 25), x, y, False, style, Me)
        s.TextFrame.VerticalAlignment = xlVAlignTop
        shapeNames.Add s.name

        ' Add rectangles for each role under the business unit
        j = 1
        For Each role In item(1)
            name = role
            id = CalculateID(name)
            style = msoShapeStylePreset14

            Dim sR As Shape
            Set sR = AddNode(msoShapeRectangle, id, name, 100, 25, x + 10, yR + (j * 30), False, style, Me)
            sR.TextEffect.FontSize = 10.5
            shapeNames.Add sR.name

            j = j + 1
        Next role

        ' Group all shapes for this business unit
        ReDim arrNames(0 To shapeNames.Count - 1)
        For Each shp In shapeNames
            arrNames(shpIndex) = shp
            shpIndex = shpIndex + 1
        Next shp

        If UBound(arrNames) > 0 Then
            ActiveSheet.Shapes.Range(arrNames).Group
        End If

ContinueLoop:
        i = i + 1
    Next item
End Sub

' DeleteShapes subroutine
' - Prompts user for confirmation
' - Deletes all generated shapes and shape groups from the worksheet
Sub DeleteShapes()
    Dim response As VbMsgBoxResult

    ' Show confirmation dialog
    response = MsgBox("This action will delete all the generated shapes from " & Me.name & ". Are you sure?", vbYesNo + vbQuestion, "Confirm Action")

    If response = vbYes Then
        ' Delete grouped shapes and individual shapes
        Call EraseShapesGroups(Me)
        Call EraseShapes(Me)
    End If
End Sub

' ExtractBUData function
' - Reads business unit names and their roles from the worksheet
' - Returns a collection of arrays: each array contains the BU name and a collection of roles
Public Function ExtractBUData() As Collection
    Dim ws As Worksheet
    Dim col As Long
    Dim lastCol As Long
    Dim lastRow As Long
    Dim deptName As String
    Dim roles As Collection
    Dim result As New Collection
    Dim i As Long
    Dim buNameRow As Long, buIdRow As Long
    Dim roleStartRow As Long

    buNameRow = Range("BusinessRolesMap_BUName_Row").Row
    buIdRow = Range("BusinessRolesMap_BUIdRow").Row
    roleStartRow = buNameRow + 1

    ' Find last column with data in buIdRow (BU IDs)
    lastCol = Me.Cells(buIdRow, Me.Columns.Count).End(xlToLeft).Column

    ' Loop through each BU column (assumes B, D, F, H, ...)
    For col = 2 To lastCol Step 2
        deptName = Me.Cells(buNameRow, col).Value
        
        ' Initialize collection for roles
        Set roles = New Collection
        
        ' Find last row in this column
        lastRow = Me.Cells(Me.Rows.Count, col).End(xlUp).Row

        ' Collect roles starting from row 6
        For i = roleStartRow To lastRow
            If Me.Cells(i, col).Value <> "" Then
                roles.Add Me.Cells(i, col).Value
            End If
        Next i

        ' Add BU name and roles to result
        Dim buData As Variant
        buData = Array(deptName, roles)
        result.Add buData
    Next col
    
    Set ExtractBUData = result
End Function









