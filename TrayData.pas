unit TrayData;

{$reference PresentationFramework.dll}
{$reference PresentationCore.dll}
{$reference WindowsBase.dll}
uses System.Windows;

{$reference Hardcodet.NotifyIcon.Wpf.dll}
uses Hardcodet.Wpf.TaskbarNotification;

type
  DummyCommand = sealed class(System.Windows.Input.ICommand)
    private a: Action0;
    
    public constructor(a: Action0) := self.a := a;
    private constructor := raise new System.InvalidOperationException;
    
    public procedure add_CanExecuteChanged(hnd: System.EventHandler) := exit;
    public procedure remove_CanExecuteChanged(hnd: System.EventHandler) := exit;
    public function CanExecute(parameter: object) := true;
    public procedure Execute(parameter: object) := a();
    
  end;
  
  TrayIcon = sealed class(TaskbarIcon)
    
    public constructor(w: Window);
    begin
      self.ToolTipText := w.Title;
      
      // self.IconSource tries to reload icon with Application.GetResourceStream
      begin
        
        var enc := new System.Windows.Media.Imaging.BmpBitmapEncoder;
        enc.Frames.Add(System.Windows.Media.Imaging.BitmapFrame.Create(System.Windows.Media.Imaging.BitmapSource(w.Icon)));
        
        var m := new System.IO.MemoryStream;
        enc.Save(m);
//        m.Flush;
        
        {$reference System.Drawing.dll}
        var bmp := new System.Drawing.Bitmap(m);
        bmp.MakeTransparent;
        self.Icon := System.Drawing.Icon.FromHandle(bmp.GetHicon);
      end;
      
      var show_win := procedure->
      begin
        w.Show;
        self.Visibility := System.Windows.Visibility.Hidden;
      end;
      var show_ico := procedure->
      begin
        w.Hide;
        self.Visibility := System.Windows.Visibility.Visible;
      end;
      
      begin
        var mi := new System.Windows.Controls.MenuItem;
        mi.Header := 'Stop';
        mi.Click += (o,e)->
        begin
          self.Dispose;
          Application.Current.Shutdown;
        end;
        
        self.ContextMenu := new System.Windows.Controls.ContextMenu;
        self.ContextMenu.Items.Add(mi);
      end;
      
      if 'StartMinimized' in CommandLineArgs then
        show_ico else
        show_win;
      
      w.Closing += (o,e)->
      if not System.Windows.Input.Keyboard.Modifiers.HasFlag(System.Windows.Input.ModifierKeys.Control) then
      begin
        show_ico;
        e.Cancel := true;
      end;
      
      self.NoLeftClickDelay := true;
      self.LeftClickCommand := new DummyCommand(show_win);
    end;
    private constructor := raise new System.InvalidOperationException;
    
  end;
  
end.