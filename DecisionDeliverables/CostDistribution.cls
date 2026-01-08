VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CostDistribution"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
' Triggered when the worksheet is activated
' Refreshes the Power query datasources and Pivot table
Private Sub Worksheet_Activate()
    ThisWorkbook.Queries("CapexByCapabilityQuery").Refresh
    ThisWorkbook.Queries("OpexByCapabilityQuery").Refresh
    ThisWorkbook.Queries("CapexByBUQuery").Refresh
    ThisWorkbook.Queries("CapexByBUQuery").Refresh

    'Optional delay to ensure query completes
    Application.CalculateUntilAsyncQueriesDone

    Me.PivotTables("CapDistributionCPX").RefreshTable
    Me.PivotTables("CapDistributionOPX").RefreshTable
    Me.PivotTables("BUDistributionCPX").RefreshTable
    Me.PivotTables("BUDistributionOPX").RefreshTable
End Sub
