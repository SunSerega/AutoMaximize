{$apptype windows}

{$reference PresentationFramework.dll}
{$reference PresentationCore.dll}
{$reference WindowsBase.dll}

uses System;
uses System.Windows;
uses System.Windows.Media;
uses System.Windows.Controls;

uses WinAPI;

var enc := new System.Text.UTF8Encoding(true);
procedure AppendLine(log, line: string);
begin
  System.IO.File.AppendAllLines(log, |line|, enc);
//  Writeln((log,line));
end;

type
  WinClassGroup = class;
  WinClass = sealed class
    name := default(string);
    gr: WinClassGroup;
    win_names := new HashSet<string>;
    visual := new TreeViewItem;
    arrow_l := new Button;
    arrow_r := new Button;
    
    static All := new Dictionary<string, WinClass>;
    
    function GetLogName: string;
    procedure RegisterArrowClicks;
    
    constructor(name: string; gr: WinClassGroup);
    begin
      self.name := name;
      self.gr := gr;
      
      var head := new DockPanel;
      
      head.Children.Add(arrow_l);
      DockPanel.SetDock(arrow_l, Dock.Left);
      arrow_l.Content := '<';
      arrow_l.Padding := new Thickness(0);
      arrow_l.Margin := new Thickness(0,0,2,0);
      
      head.Children.Add(arrow_r);
      DockPanel.SetDock(arrow_r, Dock.Left);
      arrow_r.Content := '>';
      arrow_r.Padding := new Thickness(0);
      arrow_r.Margin := new Thickness(0,0,5,0);
      
      var head_tb := new TextBlock;
      head.Children.Add(head_tb);
      head_tb.Text := name;
      
      visual.Header := head;
      
      RegisterArrowClicks;
      All.Add(name, self);
    end;
    
    procedure AddWinName(win_name: string; save: boolean := true);
    begin
      if string.IsNullOrWhiteSpace(win_name) then exit;
      if not win_names.Add(win_name) then exit;
      if save then AppendLine(GetLogName, win_name);
      visual.Items.Add(new TextBlock(new System.Windows.Documents.Run(win_name)));
    end;
    
  end;
  
  WinClassGroup = sealed class
    dir_name := default(string);
    name := default(string);
    classes := new HashSet<WinClass>;
    visual := new TreeView;
    
    static All := new List<WinClassGroup>;
    
    constructor(name: string);
    begin
      self.dir_name := name;
      var spl := name.Split(|' '|, 2);
      if (spl.Length=2) and spl[0].All(char.IsDigit) then
        name := spl[1];
      self.name := name;
      All.Add(self);
    end;
    
    procedure InsertClassVisual(c: WinClass) :=
    visual.Items.Insert(self.classes.Count(c0->c0.name<c.name), c.visual);
    
    function AddClass(win_class: string): WinClass;
    begin
      Result := new WinClass(win_class, self);
      InsertClassVisual(Result);
      if not classes.Add(Result) then raise new System.InvalidOperationException;
    end;
    
    procedure RemoveClass(c: WinClass);
    begin
      if not classes.Remove(c) then
        raise new System.InvalidOperationException;
      visual.Items.Remove(c.visual);
    end;
    
    procedure MoveClass(c: WinClass);
    begin
      c.gr.RemoveClass(c);
      var log_fname := c.GetLogName;
      InsertClassVisual(c);
      if not classes.Add(c) then raise new System.InvalidOperationException;
      c.gr := self;
      System.IO.File.Move(log_fname, c.GetLogName);
    end;
    
  end;
  
const
  ClassesDir = 'Classes';
  
function WinClass.GetLogName := $'{ClassesDir}/{gr.dir_name}/{self.name}';

procedure WinClass.RegisterArrowClicks;
begin
  var i := WinClassGroup.All.IndexOf(self.gr);
  arrow_l.Click += (o,e)->
  begin
    if i=0 then exit;
    i -= 1;
    WinClassGroup.All[i].MoveClass(self);
  end;
  arrow_r.Click += (o,e)->
  begin
    if i=WinClassGroup.All.Count-1 then exit;
    i += 1;
    WinClassGroup.All[i].MoveClass(self);
  end;
end;

const
  GN_Touch  = 'Touch';
  GN_What   = 'What';
  GN_Dont   = 'Dont';

function DefaultGroupName(cname: string): string;
begin
  
  if cname.StartsWith('HwndWrapper[') then
    Result := GN_Dont else
  
  Result := GN_What;
end;

type
  ReopenWindowCommand = sealed class(System.Windows.Input.ICommand)
    private w: Window;
    private icon: UIElement;
    
    public constructor(w: Window; icon: UIElement);
    begin
      self.w := w;
      self.icon := icon;
    end;
    private constructor := raise new System.InvalidOperationException;
    
    public procedure add_CanExecuteChanged(hnd: EventHandler) := exit;
    public procedure remove_CanExecuteChanged(hnd: EventHandler) := exit;
    public function CanExecute(parameter: System.Object) := true;
    public procedure Execute(parameter: System.Object);
    begin
      w.Show;
      icon.Visibility := Visibility.Hidden;
    end;
    
  end;
  
begin
  var StartMinimized := 'StartMinimized' in CommandLineArgs;
  
  foreach var gname in |GN_Touch, GN_What, GN_Dont| index i do
  begin
    var full_gname := $'{i} {gname}';
    var gr := new WinClassGroup(full_gname);
    
    var dir := $'{ClassesDir}\{full_gname}';
    System.IO.Directory.CreateDirectory(dir);
    foreach var fname in EnumerateFiles(dir) do
    begin
      var c := gr.AddClass(System.IO.Path.GetFileName(fname));
      foreach var win_name in ReadLines(fname, enc) do
        c.AddWinName(win_name, false);
    end;
    
  end;
  
  var un_max := new HashSet<WinAPIWindow>;
  var TryMaximize := function(w: WinAPIWindow): boolean->
  begin
    Result := w.Maximize;
    if Result then exit;
    AppendLine('err.log', $'{DateTime.Now}: [{(w.GetClass()??string.Empty).PadRight(50)}] "{(w.GetName()??string.Empty).PadRight(100)}" | Failed to maximize');
  end;
  
  var w := new Window;
  w.WindowState := WindowState.Maximized;
  w.Title := 'Auto-Minimizer';
  
  begin
    {$reference Hardcodet.NotifyIcon.Wpf.dll}
    var tray_icon := new Hardcodet.Wpf.TaskbarNotification.TaskbarIcon;
//    tray_icon.ToolTipText := w.Title;
    tray_icon.Visibility := Visibility.Hidden;
    
    tray_icon.ContextMenu := new ContextMenu;
    begin
      var mi := new MenuItem;
      tray_icon.ContextMenu.Items.Add(mi);
      mi.Header := 'Stop';
      mi.Click += (o,e)->
      begin
        tray_icon.Dispose;
        Application.Current.Shutdown();
      end;
    end;
    
    w.Closing += (o,e)->
    if System.Windows.Input.Keyboard.Modifiers.HasFlag(System.Windows.Input.ModifierKeys.Control) then
      Application.Current.Shutdown else
    begin
      w.Hide;
      tray_icon.Visibility := Visibility.Visible;
      e.Cancel := true;
    end;
    if StartMinimized then
      tray_icon.Visibility := Visibility.Visible else
      w.Show;
    
    var reopen_command := new ReopenWindowCommand(w, tray_icon);
    tray_icon.LeftClickCommand := reopen_command;
    tray_icon.DoubleClickCommand := reopen_command;
  end;
  
  var g := new Grid;
  w.Content := g;
  
  loop 2 do g.RowDefinitions.Add(new RowDefinition);
  g.RowDefinitions[0].Height := GridLength.Auto;
  
  foreach var gr in WinClassGroup.All index i do
  begin
    
    var cd := new ColumnDefinition;
    cd.Width := new GridLength(1, GridUnitType.Star);
    g.ColumnDefinitions.Add(cd);
    
    var title := new TextBlock;
    g.Children.Add(title);
    title.Text := gr.name;
    title.HorizontalAlignment := HorizontalAlignment.Center;
    Grid.SetColumn(title, i);
    
    g.Children.Add(gr.visual);
    Grid.SetRow(gr.visual, 1);
    Grid.SetColumn(gr.visual, i);
    
  end;
  
  System.Threading.Thread.Create(()->
  while true do
  begin
    un_max.RemoveWhere(w->not w.IsAlive);
    un_max.RemoveWhere(TryMaximize);
    
    LongPollWindows(w->
    begin
//      $'{DateTime.Now}: [{(w.GetClass()??string.Empty).PadRight(50)}] "{(w.GetName()??string.Empty).PadRight(100)}"'.Println;
      
      if w.GetPlacement.GetValueOrDefault.showCmd<>WinAPIWindowShowState.SW_NORMAL then exit;
      
      var cname := w.GetClass;
      if cname=nil then exit;
      
      g.Dispatcher.Invoke(()->
      begin
        
        var c: WinClass;
        if not WinClass.All.TryGetValue(cname, c) then
        begin
          var gname := DefaultGroupName(cname);
          var gr := WinClassGroup.All.Single(gr->gr.name=gname);
          c := gr.AddClass(cname);
          System.IO.File.Create(c.GetLogName).Close;
          Console.Beep;
        end;
        
        if c.gr.name=GN_Touch then
        begin
          w.Maximize;
          un_max += w;
        end;
        
        c.AddWinName(w.GetName);
      end);
      
    end);
    
    Sleep(100);
  end).Start;
  
  var ec := Application.Create.Run;
  Halt(ec);
end.