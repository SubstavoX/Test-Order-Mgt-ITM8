/// <summary>
/// Test Order Management TO Permissions PROF (ID 6208500).
/// </summary>
permissionset 6208500 "TO Permissions PROF"
{
    Assignable = true;
    Caption = 'Test Order Management Permissions';
    Permissions =
        tabledata "TO Tracking No. Status PROF" = RIMD,
        tabledata "TO Setup PROF" = RIMD,
        tabledata "TO Test Order PROF" = RIMD,
        tabledata "TO Usage Decision PROF" = RIMD;
}