unit WinAPI;

interface

uses System;

type
  WinAPIWindowShowState = (
    SW_HIDE = 0,            // Hides the window and activates another window.
    SW_NORMAL = 1,          // Activates and displays a window. If the window is minimized or maximized, the system restores it to its original size and position. An application should specify this flag when displaying the window for the first time.
    SW_SHOWMINIMIZED = 2,   // Activates the window and displays it as a minimized window.
    SW_MAXIMIZE = 3,        // Activates the window and displays it as a maximized window.
    SW_SHOWNOACTIVATE = 4,  // Displays a window in its most recent size and position. This value is similar to SW_SHOWNORMAL, except that the window is not activated.
    SW_SHOW = 5,            // Activates the window and displays it in its current size and position.
    SW_MINIMIZE = 6,        // Minimizes the specified window and activates the next top-level window in the Z order.
    SW_SHOWMINNOACTIVE = 7, // Displays the window as a minimized window. This value is similar to SW_SHOWMINIMIZED, except the window is not activated.
    SW_SHOWNA = 8,          // Displays the window in its current size and position. This value is similar to SW_SHOW, except that the window is not activated.
    SW_RESTORE = 9,         // Activates and displays the window. If the window is minimized or maximized, the system restores it to its original size and position. An application should specify this flag when restoring a minimized window.
    SW_SHOWDEFAULT = 10,    // Sets the show state based on the SW_ value specified in the STARTUPINFO structure passed to the CreateProcess function by the program that started the application.
    SW_FORCEMINIMIZE = 11   // Minimizes a window, even if the thread that owns the window is not responding. This flag should only be used when minimizing windows from a different thread.
  );
  
  WinAPIWindowPlacement = record
    length: UInt32 := sizeof(WinAPIWindowPlacement);
    flags: UInt32;
    showCmd: WinAPIWindowShowState;
    ptMinPosition, ptMaxPosition: record
      X, Y: Int32;
    end;
    rcNormalPosition, rcDevice: record
      X1,Y1: Int32;
      X2,Y2: Int32;
    end;
  end;
  
  WinAPIWindow = record
    private hnd: IntPtr;
    
    public function GetClass: string;
    
    public function GetName: string;
    
    public function IsAlive: boolean;
    
    public function GetPlacement: WinAPIWindowPlacement?;
    
    public function Maximize: boolean;
    
  end;
  
procedure LongPollWindows(new_win: Action<WinAPIWindow>);

implementation

uses System.Runtime.InteropServices;

{$region Win info}

type
  StringGetHelper = static class
    
    private [ThreadStatic] static curr_buff: record
      ptr: IntPtr;
      max_len: integer;
    end;
    
    private static function GetCharBuff(len: integer): IntPtr;
    begin
      var res := curr_buff;
      
      Result := res.ptr;
      if (Result<>IntPtr.Zero) and (res.max_len>=len) then exit;
      
      Result := Marshal.AllocHGlobal(len);
      Marshal.FreeHGlobal(res.ptr);
      res.ptr := Result;
      res.max_len := len;
      
      curr_buff := res;
    end;
    
    public static function GetString(win: WinAPIWindow; len: integer; f: function(win: WinAPIWindow; buff: IntPtr; max_len: integer): integer): string;
    begin
      var buff := GetCharBuff(len);
      Result := if f(win, buff, len)=0 then
        nil else Marshal.PtrToStringAnsi(buff);
    end;
    
  end;

function GetClassName(hnd: WinAPIWindow; buff: IntPtr; max_len: integer): integer;
external 'user32.dll';
function WinAPIWindow.GetClass :=
StringGetHelper.GetString(self, 256, GetClassName);

function GetWindowTextLength(hnd: WinAPIWindow): integer;
external 'user32.dll';
function GetWindowText(hnd: WinAPIWindow; buff: IntPtr; max_len: integer): integer;
external 'user32.dll';

function WinAPIWindow.GetName :=
StringGetHelper.GetString(self, GetWindowTextLength(self)+1, GetWindowText);

function IsWindow(win: WinAPIWindow): boolean;
external 'user32.dll';
function WinAPIWindow.IsAlive := IsWindow(self);

{$endregion Win info}

{$region LongPollWindows}

function EnumWindows(on_win: function(hnd: WinAPIWindow; data: IntPtr): boolean; data: IntPtr): boolean;
external 'user32.dll';
function IsWindowVisible(win: WinAPIWindow): boolean;
external 'user32.dll';

var last_windows := new HashSet<WinAPIWindow>;
procedure LongPollWindows(new_win: Action<WinAPIWindow>);
begin
  var curr_windows := new HashSet<WinAPIWindow>(last_windows.Count);
  
  if not EnumWindows((win,data)->
  begin
    Result := true;
    if not IsWindowVisible(win) then exit;
    if win not in last_windows then
      new_win(win);
    if not curr_windows.Add(win) then
      raise new System.InvalidOperationException;
  end, IntPtr.Zero) then
    raise new System.ComponentModel.Win32Exception;
  
  last_windows := curr_windows;
end;

{$endregion LongPollWindows}

{$region Maximize}

function PostMessage(win: WinAPIWindow; msg: UInt32; w_param: UIntPtr; l_param: IntPtr): boolean;
external 'user32.dll';

function GetWindowPlacement(win: WinAPIWindow; var pl: WinAPIWindowPlacement): boolean;
external 'user32.dll';

function WinAPIWindow.GetPlacement: WinAPIWindowPlacement?;
begin
  var res: WinAPIWindowPlacement;
  if GetWindowPlacement(self, res) then
    Result := res else
    Result := nil;
end;

function WinAPIWindow.Maximize: boolean;
const WM_SYSCOMMAND = $0112;
const SC_MAXIMIZE   = $F030;
begin
  Result := false;
  
  if not PostMessage(self, WM_SYSCOMMAND, new UIntPtr(SC_MAXIMIZE), IntPtr.Zero) then
    exit;
//    new System.ComponentModel.Win32Exception;
  
  Result := GetPlacement.GetValueOrDefault.showCmd=WinAPIWindowShowState.SW_MAXIMIZE;
end;

{$endregion Maximize}

end.