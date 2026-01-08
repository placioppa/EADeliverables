VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "StakeholderMap"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Sub BuildStakeholderMap()
    Dim wb As Workbook
    Dim ws As Worksheet
    
    Set ws = ActiveSheet
    Set wb = ActiveWorkbook

    Dim tbl As Range
    Set tbl = ws.Range("Stakeholdermap_MainTable_Table")

    '---------------------------------------------------------
    ' 1. DRAW BACKGROUND QUADRANTS + AXIS
    '---------------------------------------------------------
    DrawStakeholderQuadrants wb, ws

    ' Positioning constants (adjust if needed)
    Dim originX As Single
    Dim originY As Single
    Dim quadWidth As Single
    Dim quadHeight As Single
    
    originX = wb.Names("_xOrigin_1").RefersToRange.Value
    originY = wb.Names("_yOrigin_1").RefersToRange.Value
    quadWidth = wb.Names("_quadWidth").RefersToRange.Value
    quadHeight = wb.Names("_quadHeight").RefersToRange.Value

    Dim existingShapes As Object
    Set existingShapes = GetShapeDictionary(ws)

    Dim r As Range
    For Each r In tbl.Rows

        Dim stakeholder As String
        stakeholder = r.Cells(1, 1).Value
        If Trim(stakeholder) = "" Then GoTo ContinueLoop

        Dim role As String: role = r.Cells(1, 2).Value
        Dim power As String: power = r.Cells(1, 4).Value           ' Low / Medium / High
        Dim disrupt As String: disrupt = r.Cells(1, 5).Value        ' YES / NO
        Dim understanding As String: understanding = r.Cells(1, 6).Value
        Dim commitment As String: commitment = r.Cells(1, 7).Value

        '---------------------------------------------------------
        ' 2. CALCULATE POWER SCORE
        '---------------------------------------------------------
        Dim powerScore As Double
        powerScore = ConvertLevelToScore(power)

        If UCase(disrupt) = "Y" Then
            powerScore = powerScore * 1.3
        End If

        If powerScore > 1 Then powerScore = 1

        '---------------------------------------------------------
        ' 3. CALCULATE INTEREST SCORE
        '---------------------------------------------------------
        Dim interestScore As Double
        interestScore = (ConvertLevelToScore(understanding) + _
                         ConvertLevelToScore(commitment)) / 2

        '---------------------------------------------------------
        ' 4. DETERMINE POSITION IN GRID
        '---------------------------------------------------------
        Dim xPos As Single, yPos As Single
        
        ' INTEREST ? X axis ? low = left, high = right
        xPos = originX + (interestScore * quadWidth) - 45
        
        ' POWER ? Y axis ? low = bottom, high = top
        yPos = originY + quadHeight - (powerScore * quadHeight)

        '---------------------------------------------------------
        ' 5. DRAW NODE (avoid duplicates)
        '---------------------------------------------------------
        Dim textLabel As String
        textLabel = stakeholder & vbCrLf & "(" & role & ")"

        Dim id As String
        id = CalculateID(stakeholder)

        If existingShapes.exists(id) Then GoTo ContinueLoop
        
        Dim s As Shape
        Set s = AddNode(msoShapeRoundedRectangle, _
                     id, textLabel, _
                     90, 45, xPos, yPos, _
                     False, msoShapeStylePreset1, ws)
        s.TextEffect.FontSize = 10.5

ContinueLoop:
    Next r

End Sub

Sub DrawStakeholderQuadrants(wb As Workbook, ws As Worksheet)

    Dim originX As Single
    Dim originY As Single
    Dim quadWidth As Single
    Dim quadHeight As Single
    
    originX = wb.Names("_xOrigin_1").RefersToRange.Value
    originY = wb.Names("_yOrigin_1").RefersToRange.Value
    quadWidth = wb.Names("_quadWidth").RefersToRange.Value
    quadHeight = wb.Names("_quadHeight").RefersToRange.Value

    Dim totalWidth As Single: totalWidth = quadWidth
    Dim totalHeight As Single: totalHeight = quadHeight

    ' Clear old quadrant shapes (optional)
    Dim shp As Shape
    For Each shp In ws.Shapes
        If Left(shp.name, 14) = "StakeholderBG_" Then shp.Delete
    Next shp

    ' Background
    ws.Shapes.AddShape(msoShapeRectangle, originX, originY, _
                       totalWidth, totalHeight).name = "StakeholderBG_All"

    With ws.Shapes("StakeholderBG_All")
        .Fill.ForeColor.RGB = RGB(240, 240, 240)
        .line.Visible = msoTrue
        .ZOrder (msoSendToBack)
    End With

    ' Vertical axis
    ws.Shapes.AddLine(originX + totalWidth / 2, originY, _
                      originX + totalWidth / 2, originY + totalHeight).name = "StakeholderBG_VAxis"

    ' Horizontal axis
    ws.Shapes.AddLine(originX, originY + totalHeight / 2, _
                      originX + totalWidth, originY + totalHeight / 2).name = "StakeholderBG_HAxis"

    ' Quadrant labels
    ' x: originX + full width (variable) - large of the label(120) - 5 (margin)
    ' y: originY + 5 (margin)
    AddQuadrantLabel ws, "Key Players", originX + totalWidth - 125, originY + 5, 0
    ' x: originX + full width (variable) - large of the label(120) - 5 (margin)
    ' y: originY  half of total height + 5 (margin)
    AddQuadrantLabel ws, "Keep Informed", originX + totalWidth - 125, originY + totalHeight * 0.5 + 5, 0
    ' x: originX + half of total width - large of the label(120) - 5 (margin)
    ' y: originY + 5 (margin)
    AddQuadrantLabel ws, "Keep Satisfied", originX + (totalWidth * 0.5) - 125, originY + 5, 0
    ' x: originX + half of total width - large of the label(120) - 5 (margin)
    ' y: originY  half of total height + 5 (margin)
    AddQuadrantLabel ws, "Minimal Effort", originX + (totalWidth * 0.5) - 125, originY + totalHeight * 0.5 + 5, 0
    
    'Axis label
    AddQuadrantLabel ws, "Level of Interest", originX + totalWidth - 120, originY + totalHeight + 5, 0
    AddQuadrantLabel ws, "Level of Power", originX - 75, originY + 90, -90

End Sub

Sub AddQuadrantLabel(ws As Worksheet, text As String, x As Single, y As Single, rotation As Single)
    Dim lbl As Shape
    Set lbl = ws.Shapes.AddTextbox(msoTextOrientationHorizontal, x, y, 120, 20)
    lbl.TextFrame2.TextRange.text = text
    lbl.TextFrame2.TextRange.Font.Size = 10
    lbl.TextFrame2.TextRange.Font.bold = True
    lbl.line.Visible = msoFalse
    lbl.rotation = rotation
End Sub

Function ConvertLevelToScore(level As String) As Double
    Select Case UCase(level)
        Case "LOW": ConvertLevelToScore = 0.2
        Case "MEDIUM": ConvertLevelToScore = 0.5
        Case "HIGH": ConvertLevelToScore = 0.9
        Case Else: ConvertLevelToScore = 0.5
    End Select
End Function


' Deletes all generated shapes from the worksheet after user confirmation.
Sub DeleteShapes()
    Dim response As VbMsgBoxResult
    
    ' Show confirmation dialog
    response = MsgBox("This action will delete all the generated shapes from " & Me.name & ". Are you sure?", vbYesNo + vbQuestion, "Confirm Action")
    
    If response = vbYes Then
        Call EraseShapes(Me)
    End If
End Sub

