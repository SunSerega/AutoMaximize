{$apptype windows}

{$reference PresentationFramework.dll}
{$reference PresentationCore.dll}
{$reference WindowsBase.dll}

{$ifdef DEBUG}

{ $define NoSaves}

{$endif DEBUG}

//TODO MergedStrings:
// - Use MergedStringLength

//TODO Missing features:
// - Save changes

uses System;
uses System.Windows;
uses System.Windows.Media;
uses System.Windows.Controls;

uses Misc;
uses TrayData;
uses MSList;

uses WinAPI;

uses PathUtils      in 'Utils\PathUtils';

uses Parsing        in 'Utils\Parsing';
uses ColoredStrings in 'Utils\ColoredStrings';
uses MergedStrings  in 'Utils\Patterns\MergedStrings';

type
  {$region Visual}
  
  {$region Utils}
  
  VisSelectableHead = class(Grid)
    private tb := new TextBlock;
    
    public property Text: string read tb.Text write tb.Text := value;
    
    public event Selected: procedure(keep_prev: boolean);
    public event Pushed: procedure(dir: integer);
    
    public procedure DisplaySelected(sel: boolean) :=
    self.Background := if sel then Brushes.LightGray else Brushes.White;
    
    public constructor;
    begin
      
      self.Children.Add(tb);
//      tb.FontFamily := new FontFamily('Cascadia Code');
      tb.FontFamily := new FontFamily('Consolas');
      
      var arrows := new StackPanel;
      self.Children.Add(arrows);
      arrows.Orientation := Orientation.Horizontal;
      
      var DisplayMouseIn := procedure(is_in: boolean)->
      begin
        arrows.Visibility := if is_in then
          System.Windows.Visibility.Visible else
          System.Windows.Visibility.Hidden;
      end;
      DisplayMouseIn(false);
      self.MouseEnter += (o,e)->DisplayMouseIn(true);
      self.MouseLeave += (o,e)->DisplayMouseIn(false);
      
      foreach var (ch,dir) in '<>'.ZipTuple(|-1,+1|) do
      begin
        var b := new Button;
        arrows.Children.Add(b);
        b.Content := ch;
        b.Click += (o,e)->TryInvoke(self.Pushed, dir);
      end;
      
      tb.MouseDown += (o,e)->
      begin
        if e.ChangedButton<>System.Windows.Input.MouseButton.Left then exit;
        var keep_prev := System.Windows.Input.Keyboard.Modifiers.HasFlag(System.Windows.Input.ModifierKeys.Control);
        self.DisplaySelected(true);
        TryInvoke(self.Selected, keep_prev);
      end;
      
    end;
    
  end;
  
  {$endregion Utils}
  
  {$region Name}
  
  VisWinName = sealed class(VisSelectableHead)
    
  end;
  
  {$endregion Name}
  
  {$region Class}
  
  VisWinClass = sealed class(StackPanel)
    private head := new VisSelectableHead;
    private opener := new TextBlock;
    private body := new StackPanel;
    private curr_sel: boolean;
    
    public event Selected: procedure(keep_prev: boolean);
    public event Pushed: procedure(dir: integer);
    
    public procedure DisplayDeselect;
    begin
      head.DisplaySelected(false);
      self.curr_sel := false;
    end;
    
    public procedure DisplayEmpty(is_empty: boolean) :=
    opener.Visibility := if is_empty then
      System.Windows.Visibility.Hidden else
      System.Windows.Visibility.Visible;
    
    public procedure AddName(n: VisWinName) :=
    body.Children.Add(n);
    public procedure RemName(n: VisWinName) :=
    body.Children.Remove(n);
    
    public constructor(s: string);
    begin
      
      var line0 := new DockPanel;
      self.Children.Add(line0);
      
      line0.Children.Add(opener);
      DisplayEmpty(true);
      DockPanel.SetDock(opener, Dock.Left);
      opener.Margin := new Thickness(0,0,8,0);
      // Monospace, so no size changes
      opener.FontFamily := new FontFamily('Consolas');
      
      line0.Children.Add(head);
      head.Text := s;
      
      var body_stride := new Border;
      self.Children.Add(body_stride);
      body_stride.BorderThickness := new Thickness(1,0,0,0);
      body_stride.BorderBrush := Brushes.Black;
      body_stride.Margin := new Thickness(3,0,0,0);
      
      body_stride.Child := body;
      body.Margin := new Thickness(11,0,0,0);
      
      var curr_open := false;
      var SetOpened := procedure(open: boolean)->
      begin
        curr_open := open;
        opener.Text := if open then '▼' else '►';
        body.Visibility := if open then
          System.Windows.Visibility.Visible else
          System.Windows.Visibility.Collapsed;
      end;
      opener.MouseUp += (o,e)->
      begin
        if self.curr_sel then exit;
        if e.ChangedButton<>System.Windows.Input.MouseButton.Left then exit;
        SetOpened(not curr_open);
      end;
      SetOpened(curr_open);
      
      head.Selected += keep_prev->
      begin
        SetOpened(false);
        self.curr_sel := true;
        TryInvoke(self.Selected, keep_prev);
      end;
      head.Pushed += dir->TryInvoke(self.Pushed, dir);
      
    end;
    private constructor := raise new InvalidOperationException;
    
  end;
  
  {$endregion Class}
  
  {$region Group}
  
  VisWinClassGroup = sealed class(Border)
    private body := new StackPanel;
    
    public constructor(name: string);
    begin
      
      self.BorderThickness := new Thickness(1,1,1,0);
      self.BorderBrush := Brushes.Black;
      
      var sw := new ScrollViewer;
      self.Child := sw;
      sw.VerticalScrollBarVisibility := ScrollBarVisibility.Auto;
      
      sw.Content := body;
      body.Margin := new Thickness(10);
      
    end;
    private constructor := raise new InvalidOperationException;
    
  end;
  
  {$endregion Group}
  
  {$region Window}
  
  //TODO Delete?
  AMWindow = sealed class(Window)
    
    public constructor;
    begin
      
    end;
    
  end;
  
  {$endregion Window}
  
  {$endregion Visual}
  
  {$region Logic}
  
  {$region Utils}
  
  AMEncoding = sealed class(System.Text.UTF8Encoding)
    public constructor := Create(true);
    public static Inst := new AMEncoding;
  end;
  
  SaveHelper = static class
    private static save_delay := 0;
    
    private static save_lock := new object;
    private static to_save := new Dictionary<string, sequence of string>;
    private static to_del := new HashSet<string>;
    
    {$region SaveDelay}
    
    private static procedure Save(fname: string; lines: sequence of string) :=
    if not FileExists(fname) or not ReadLines(fname, AMEncoding.Inst).SequenceEqual(lines) then
      // May be slow, but I don't expect big files
      System.IO.File.WriteAllLines(fname, lines, AMEncoding.Inst);
    
    public static procedure IncSaveDelay :=
      System.Threading.Interlocked.Increment(save_delay);
    
    public static procedure DecSaveDelay;
    begin
      var lvl := System.Threading.Interlocked.Decrement(save_delay);
      if lvl<0 then raise new System.InvalidOperationException;
      if lvl>0 then exit;
      
      lock save_lock do
      begin
        
        foreach var fname in to_save.Keys do
          Save(fname, to_save[fname]);
        foreach var fname in to_del do
          System.IO.File.Delete(fname);
        
        to_save.Clear;
        to_del.Clear;
      end;
      
    end;
    
    public static procedure DelaySaves(a: Action) :=
    try
      IncSaveDelay;
      a();
    finally
      DecSaveDelay;
    end;
    
    {$endregion SaveDelay}
    
    {$region Operations}
    
    public static procedure ChangeFile(fname: string; lines: sequence of string) :=
    lock save_lock do
    begin
      if save_delay=0 then
        raise new System.InvalidOperationException;
      fname := PathUtils.GetRelativePathRTA(fname);
      to_save[fname] := lines;
      to_del -= fname;
    end;
    
    public static procedure DeleteFile(fname: string) :=
    lock save_lock do
    begin
      if save_delay=0 then
        raise new System.InvalidOperationException;
      fname := PathUtils.GetRelativePathRTA(fname);
      to_save.Remove(fname);
      to_del += fname;
    end;
    
    {$endregion Operations}
    
  end;
  
  SymEscapeHelper = static class
    private const esc_sym = '%';
    private static escapables := System.IO.Path.GetInvalidFileNameChars.Append(esc_sym).ToHashSet;
    
    public static function Escape(s: string): string;
    begin
      var res := new StringBuilder(s.Length);
      foreach var ch in s do
        if ch in escapables then
        begin
          res += esc_sym;
          var code := ch.Code.ToString('X2');
          if code.Length<>2 then raise new System.NotImplementedException(code);
          res += code;
        end else
          res += ch;
      Result := res.ToString;
    end;
    public static function Escape(s: MergedString) := Escape(s.ToString(esc_sym));
    
    public static function UnEscape(s: string): string;
    begin
      var res := new StringBuilder(s.Length);
      var enmr := s.GetEnumerator;
      while enmr.MoveNext do
        if enmr.Current<>esc_sym then
          res += enmr.Current else
        begin
          if not enmr.MoveNext then raise new System.InvalidOperationException(s);
          var c_ch1 := enmr.Current;
          if not enmr.MoveNext then raise new System.InvalidOperationException(s);
          var c_ch2 := enmr.Current;
          var ch := char(System.Convert.ToInt16(c_ch1+c_ch2, 16));
          if ch not in escapables then raise new System.NotImplementedException(ch.Code.ToString);
          res += ch;
        end;
      Result := res.ToString;
    end;
    
  end;
  
  SelectionManager = static class
    private static curr := new Dictionary<object, Action>;
    
    public static procedure Limit<T>(keep: T->boolean) :=
    curr.Where(kvp->
    begin
      Result := not( (kvp.Key is T(var v)) and keep(v) );
      if Result then kvp.Value();
    end).Select(kvp->kvp.Key).ToList.ForEach(key->curr.Remove(key));
    
    public static procedure Clear := Limit&<object>(o->false);
    
    public static procedure Add<T>(o: T; rem: Action; keep: T->boolean) :=
    if IsSelected(o) then
    begin
      curr[o]();
      rem();
      curr.Remove(o);
    end else
    begin
      Limit&<T>(keep);
      curr.Add(o, rem);
    end;
    
    public static function Remove(o: object) := curr.Remove(o);
    
    public static function IsSelected(o: object) := curr.ContainsKey(o);
    public static function AllSelected := curr.Keys;
    
  end;
  
  WinCommon = static class
    
    static procedure InformOfConsumedOnInit(cont, del: object; cont_name, del_name: string) :=
    case MessageBox.Show($'{TypeName(del)}:"{del_name}" would be deleted, do so?', $'{TypeName(cont)}"{cont_name}"', MessageBoxButton.YesNo) of
      MessageBoxResult.Yes: ;
      else Halt(-1);
    end;
    
  end;
  
  WinClassGroup = sealed partial class
    private gr_l, gr_r: WinClassGroup;
    private constructor := raise new System.InvalidOperationException;
  end;
  WinClass = sealed partial class
    private gr: WinClassGroup;
    private constructor := raise new System.InvalidOperationException;
  end;
  WinName = sealed partial class
    private cl: WinClass;
    private constructor := raise new System.InvalidOperationException;
  end;
  
  {$endregion Utils}
  
  {$region Name}
  
  WinName = sealed partial class
    private name: MergedString;
    private vis := new VisWinName;
    
    private static procedure MoveGroup(names: sequence of WinName; old_cl: WinClass; dir: integer);
    
    public constructor(name: MergedString; name_s: string);
    begin
      self.name := name;
      self.vis.Text := name_s;
      
      vis.Selected += keep_prev->
      begin
        var w0 := self; //TODO #????
        SelectionManager.Add(self,
          ()->vis.DisplaySelected(false),
          w->keep_prev and (w.cl=w0.cl)
        );
      end;
      
      vis.Pushed += dir->
      begin
        var to_move := if SelectionManager.IsSelected(self) then
          SelectionManager.AllSelected.Cast&<WinName> else
          |self|;
        MoveGroup(to_move, self.cl, dir);
      end;
      
    end;
    public constructor(name_s: string) :=
    Create(MergedString.Parse(name_s, SymEscapeHelper.esc_sym), name_s);
    public constructor(name: MergedString) :=
    Create(name, name.ToString(SymEscapeHelper.esc_sym));
    
  end;
  
  {$endregion Name}
  
  {$region Class}
  
  WinClass = sealed partial class
    private cl_name: MergedString;
    private win_names := new List<WinName>;
    private ms_list := new MergedStringList;
    private vis: VisWinClass;
    
    private function MakeFileName: string;
    private procedure Resave;
    begin
      if gr=nil then exit;
      SaveHelper.ChangeFile(MakeFileName,
        win_names.Select(wn->
          wn.name.ToString(SymEscapeHelper.esc_sym)
        )
      );
    end;
    
    public procedure Add(wn: WinName; OnConsumed: WinName->());
    begin
      wn.cl := self;
      ms_list.Add(wn.name,
        nil,\(key,v)->
        begin
          if OnConsumed=nil then exit;
          OnConsumed(WinName(v[0]));
        end,
        wn, wn.vis
      );
      vis.DisplayEmpty(false);
      Resave;
    end;
    
    public procedure Remove(wn: WinName) := Remove(wn.name);
    public procedure Remove(wn: MergedString);
    begin
      if ms_list.Remove( wn, nil )<>1 then
        raise new System.InvalidOperationException;
      vis.DisplayEmpty(win_names.Count=0);
      Resave;
    end;
    
    public procedure Absorb(del_cl: WinClass);
    begin
      
      del_cl.vis.body.Children.Clear;
      foreach var wn in del_cl.win_names do
        self.Add( wn, nil );
      
    end;
    
    private static procedure MoveGroup(classes: sequence of WinClass; old_gr: WinClassGroup; dir: integer);
    
    public constructor(cl_name: MergedString; cl_name_s: string; update_visual: Action<Action>; names: sequence of WinName);
    begin
      self.cl_name := cl_name;
      self.vis := new VisWinClass(cl_name_s);
      
      vis.Selected += keep_prev->
      begin
        var c0 := self; //TODO #????
        SelectionManager.Add(self,
          vis.DisplayDeselect,
          c->keep_prev and (c.gr=c0.gr)
        );
      end;
      
      vis.Pushed += dir->
      begin
        var to_move := if SelectionManager.IsSelected(self) then
          SelectionManager.AllSelected.Cast&<WinClass> else
          |self|;
        MoveGroup(to_move, self.gr, dir);
      end;
      
      ms_list += win_names;
      ms_list += vis.body.Children;
      
      foreach var wn in names do
        update_visual(()->self.Add(wn,
          old_wn->WinCommon.InformOfConsumedOnInit(self,old_wn, cl_name_s,old_wn.vis.Text)
        ));
    end;
    public constructor(cl_name_s: string; update_visual: Action<Action>; names: sequence of WinName) :=
    Create(MergedString.Parse(cl_name_s, SymEscapeHelper.esc_sym), cl_name_s, update_visual, names);
    public constructor(cl_name: MergedString; update_visual: Action<Action>; names: sequence of WinName) :=
    Create(cl_name, cl_name.ToString(SymEscapeHelper.esc_sym), update_visual, names);
    private function NameFromLine(line: string) := new WinName(line);
    public constructor(fname: string; update_visual: Action<Action>) := Create(
      SymEscapeHelper.UnEscape(
        System.IO.Path.GetFileName(fname)
      ),
      update_visual,
      ReadLines(fname, AMEncoding.Inst)
      .Select(NameFromLine)
      {$ifdef NoSaves}
      .Take(0)
      {$endif NoSaves}
    );
    
  end;
  
  {$endregion Class}
  
  {$region Group}
  
  WinClassGroup = sealed partial class
    private path, name: string;
    private win_classes := new List<WinClass>;
    private ms_list := new MergedStringList;
    private vis: VisWinClassGroup;
    
    public function PredatorClasses(cl_name: MergedString) :=
    ms_list.DepValues(cl_name).Select(\(s,v)->WinClass(v[0]));
    
    public procedure Add(new_cl: WinClass; OnConsumed: WinClass->());
    begin
      new_cl.gr := self;
      if ms_list.Add(new_cl.cl_name,
        \(key, v)->
        begin
          TryInvoke(OnConsumed, new_cl);
          WinClass(v[0]).Absorb(new_cl);
        end,
        \(key, v)->
        begin
          var del_cl := WinClass(v[0]);
          TryInvoke(OnConsumed, del_cl);
          new_cl.Absorb(del_cl);
          SaveHelper.DeleteFile(del_cl.MakeFileName);
        end,
        new_cl, new_cl.vis
      ) then
        new_cl.Resave;
    end;
    
    public procedure Remove(cl_name: MergedString; on_del: WinClass->());
    begin
      if 1 <> ms_list.Remove(cl_name, \(key,v)->
      begin
        var del_cl := WinClass(v[0]);
        TryInvoke(on_del, del_cl);
        SaveHelper.DeleteFile(del_cl.MakeFileName);
      end) then
        raise new System.InvalidOperationException;
    end;
    
    private static All := new List<WinClassGroup>;
    public constructor(dir: string; update_visual: Action<Action>);
    begin
      self.path := dir;
      self.name := System.IO.Path.GetFileName(dir).Split(|' '|,2)[1];
      self.vis := new VisWinClassGroup(self.name);
      
      ms_list += win_classes;
      ms_list += vis.body.Children;
      
      foreach var fname in System.IO.Directory.CreateDirectory(dir).EnumerateFiles{$ifdef NoSaves}.Take(0){$endif} do
        update_visual(()->self.Add(
          new WinClass(fname.FullName, update_visual),
          old_wc->WinCommon.InformOfConsumedOnInit(self,old_wc, name,old_wc.vis.head.Text)
        ));
      
      All += self;
    end;
    
    public function NextInDir(dir: integer): WinClassGroup;
    begin
      case dir of
        -1: Result := self.gr_l;
        +1: Result := self.gr_r;
        else raise new System.InvalidOperationException;
      end;
    end;
    
  end;
  
  {$endregion Group}
  
  {$endregion Logic}
  
function WinClass.MakeFileName :=
$'{gr.path}\{SymEscapeHelper.Escape(cl_name)}';

{$region Group moving}

function LetChooseOne<T>(title: string; choises: IList<T>): integer?;
begin
  var res := default(integer?);
  var w := new Window;
  w.Title := title;
  w.SizeToContent := SizeToContent.WidthAndHeight;
  
  var sp := new StackPanel;
  w.Content := sp;
  
  foreach var ind in choises.Count.Times do
  begin
    var b := new Button;
    sp.Children.Add(b);
    b.Content := choises[ind];
    b.Click += (o,e)->
    begin
      res := ind;
      w.Close;
    end;
  end;
  
  w.KeyDown += (o,e)->
  case e.Key of
    System.Windows.Input.Key.Escape:
    begin
      e.Handled := true;
      w.Close;
    end;
  end;
  
  w.ShowDialog;
  Result := res;
end;

static procedure WinName.MoveGroup(names: sequence of WinName; old_cl: WinClass; dir: integer) :=
StartInSTA(()->
try
  var old_gr := old_cl.gr;
  var new_gr := old_gr.NextInDir(dir);
  if new_gr=nil then exit;
  
  var new_cls := new_gr.PredatorClasses(old_cl.cl_name).ToList;
  if new_cls.Count>1 then
  begin
    var ind := LetChooseOne($'Choose window class', new_cls.ConvertAll(cl->cl.cl_name.ToString(SymEscapeHelper.esc_sym)));
    if ind=nil then exit;
    var new_cl := new_cls[ind.Value];
    new_cls.Clear;
    new_cls += new_cl;
  end;
  
  old_cl.vis.Dispatcher.Invoke(()->SaveHelper.DelaySaves(()->
  begin
    foreach var wn in names do
      old_cl.Remove(wn);
    var new_cl: WinClass;
    if new_cls.Count=0 then
    begin
      new_cl := new WinClass(old_cl.cl_name, old_cl.vis.head.Text, a->a(), names);
      new_gr.Add( new_cl, del_cl->if del_cl=new_cl then raise new InvalidOperationException );
    end else
    begin
      new_cl := new_cls.Single;
      foreach var wn in names.ToArray do
        new_cl.Add( wn, del_wn->if wn=del_wn then SelectionManager.Remove(del_wn) );
    end;
    foreach var wn in names do
      wn.cl := new_cl;
  end));
  
except
  on e: Exception do MessageBox.Show(e.ToString);
end);

static procedure WinClass.MoveGroup(classes: sequence of WinClass; old_gr: WinClassGroup; dir: integer);
begin
  var new_gr := old_gr.NextInDir(dir);
  if new_gr=nil then exit;
  
  SaveHelper.DelaySaves(()->
    foreach var cl in classes.ToArray do
    begin
      old_gr.Remove( cl.cl_name, nil );
      new_gr.Add( cl, del_cl->if del_cl=cl then SelectionManager.Remove(del_cl) );
    end
  );
  
end;

{$endregion Group moving}

{$region Merging}

procedure AddCSPTo(cont: StackPanel; p: ColoredStringPart<string>; make_color: (string,integer)->Brush);
begin
  var text := p.GetSection;
  
  var last_ind := text.I1;
  var try_add_plain := procedure(i2: StringIndex)->
  begin
    if last_ind=i2 then exit;
    var tb := new TextBlock;
    cont.Children.Add(tb);
    tb.Text := text.WithI1(last_ind).WithI2(i2).ToString;
  end;
  
  //TODO #2783
  foreach var sub_p in p.SubParts.AsEnumerable index ind do
  begin
    try_add_plain(sub_p.TextRange.i1);
    
    var sp := new StackPanel;
    cont.Children.Add(sp);
    sp.Orientation := Orientation.Horizontal;
    AddCSPTo(sp, sub_p, make_color);
    sp.Background := make_color(sub_p.Key, ind) ?? Brushes.Transparent;
    if sp.Background <> Brushes.Transparent then
      sp.Margin := new Thickness(0,1,0,1);
    
    last_ind := sub_p.TextRange.i2;
  end;
  
  try_add_plain(text.I2);
end;

function LetChooseMerge(initial: sequence of MergedString; all: MergedStringList): ValueTuple<MergedString, HashSet<MergedString>, HashSet<MergedString>>;
begin
  var expected := initial.ToHashSet;
  
  {$region Visual}
  
  var w := new Window;
//  w.SizeToContent := SizeToContent.WidthAndHeight;
//  w.WindowStartupLocation := WindowStartupLocation.CenterScreen;
  w.WindowState := WindowState.Maximized;
  
  var w_body := new DockPanel;
  w.Content := w_body;
    
    var w_head := new StackPanel;
    w_body.Children.Add(w_head);
    DockPanel.SetDock(w_head, Dock.Top);
      
      var inp := new TextBox;
      w_head.Children.Add(inp);
      inp.Text := expected.Aggregate((s1,s2)->s1*s2).ToString(SymEscapeHelper.esc_sym);
      inp.Margin := new Thickness(5);
      inp.CaretIndex := inp.Text.Length;
      inp.Focus;
      
      var confirm_dp := new DockPanel;
      w_head.Children.Add(confirm_dp);
      confirm_dp.Margin := new Thickness(5,0,5,5);
        
        var confirm_slap := new Button;
        confirm_dp.Children.Add(confirm_slap);
        DockPanel.SetDock(confirm_slap, Dock.Right);
        confirm_slap.Content := '↑';
        
        var confirm_b := new Border;
        confirm_dp.Children.Add(confirm_b);
        confirm_b.BorderBrush := Brushes.Black;
        confirm_b.BorderThickness := new Thickness(1);
        confirm_b.Margin := new Thickness(0,0,5,0);
        confirm_b.Padding := new Thickness(2,0,2,0);
        
        var confirm_cont := new StackPanel;
        confirm_b.Child := confirm_cont;
        confirm_cont.Orientation := Orientation.Horizontal;
        
    var lists_g := new Grid;
    w_body.Children.Add(lists_g);
    begin
      var rd := new RowDefinition;
      rd.Height := GridLength.Auto;
      lists_g.RowDefinitions.Add(rd);
    end;
    lists_g.RowDefinitions.Add(new RowDefinition);
      
      var list_sp := |
        ('Expected',    Brushes.LightGreen),
        ('Missing',     Brushes.Pink),
        ('Unexpected',  Brushes.LightYellow),
        ('Other',       Brushes.LightBlue),
        ('Predators',   Brushes.Coral)
      |.ConvertAll((\(head_name,head_color), col_i)->
      begin
        
        var cd := new ColumnDefinition;
        cd.Width := new GridLength(1, GridUnitType.Star);
        lists_g.ColumnDefinitions.Add(cd);
        
        var head := new TextBlock;
        lists_g.Children.Add(head);
        Grid.SetRow(head, 0);
        Grid.SetColumn(head, col_i);
        head.Text := head_name;
        head.Background := head_color;
        
        var body := new ScrollViewer;
        lists_g.Children.Add(body);
        Grid.SetRow(body, 1);
        Grid.SetColumn(body, col_i);
        
        Result := new StackPanel;
        body.Content := Result;
        
      end);
      
  {$endregion Visual}
  
  {$region Logic}
  var res := default(MergedString);
  
  var last_ms := default(MergedString);
  var last_conf_text := '';
  {$region Update confirm}
  var confirm_wild_colors := |
    new SolidColorBrush(Color.FromRgb(255,117,141)),
    new SolidColorBrush(Color.FromRgb(255,185,255))
  |;
  var confirm_sym_colors := |
    Brushes.LightGreen,
    new SolidColorBrush(Color.FromRgb(190,190,250))
  |;
  var update_confirm := procedure->
  begin
    last_ms := MergedString.Parse(inp.Text, SymEscapeHelper.esc_sym);
    
    var to_display := last_ms.ToColoredString(SymEscapeHelper.esc_sym);
    last_conf_text := to_display.Text;
    
    confirm_slap.Background := if to_display.Text=inp.Text then
      Brushes.White else Brushes.Red;
    
    confirm_cont.Children.Clear;
    AddCSPTo(confirm_cont, to_display, (key,ind)->
    case key of
      'solid', 'chars':
        Result := Brushes.Transparent;
      
      'count':
        Result := Brushes.LightBlue;
      
      'wild':
        Result := confirm_wild_colors[ind mod confirm_wild_colors.Length];
      
      'sym':
        Result := confirm_sym_colors[ind mod confirm_sym_colors.Length];
      
      else MessageBox.Show(key, 'Unexpected colored string key');
    end);
    
  end;
  {$endregion Update confirm}
  
  {$region Update lists}
  
  var make_list_entry := function(s: MergedString; click: Action): ContentControl ->
  begin
    if click=nil then
      Result := new ContentControl else
    begin
      var res := new Button;
      res.Click += (o,e)->click();
      Result := res;
    end;
    Result.Content := s.ToString(SymEscapeHelper.esc_sym);
  end;
  
  var ms_list := list_sp.ConvertAll(sp->
  begin
    Result := new MergedStringList;
    Result += sp.Children;
  end);
  
  var remove_from_list := procedure(list_i: integer; s: MergedString)->
    if ms_list[list_i].Remove( s, nil ) <> 1 then
      raise new System.InvalidOperationException;
  
  var add_to_list: procedure(list_i: integer; s: MergedString); add_to_list := (list_i,s)->
  begin
    
    // 0. Expected
    // 1. Missing
    // 2. Unexpected
    // 3. Other
    // 4. Predators
    var on_click := default(Action);
    case list_i of
      0,3,4: ;
      1: on_click := ()->
      begin
        remove_from_list(1, s); // Missing
        add_to_list(3,s);        // Other
        expected.Remove(s);
      end;
      2: on_click := ()->
      begin
        remove_from_list(2, s); // Unexpected
        add_to_list(0, s);        // Expected
        expected.Add(s);
      end;
      else raise new System.InvalidOperationException;
    end;
    
    ms_list[list_i].Add(s,
      \(key,v)->raise new System.InvalidOperationException($'s="{s}" in key="{key}"'),
      \(key,v)->raise new System.InvalidOperationException($'key="{key}" in s="{s}"'),
      make_list_entry(s, on_click)
    );
  end;
  
  var last_consumed := new HashSet<MergedString>;
  var last_predators := new HashSet<MergedString>;
  foreach var s in expected do
    add_to_list(1,s);
  foreach var s in all.Keys do
    if s not in expected then
      add_to_list(3,s);
  
  var lists_next_update_id := 1;
  var lists_last_update_id := 0;
  var lists_update_lock := new object;
  var update_lists := procedure->
  begin
    var update_id := lists_next_update_id;
    lists_next_update_id += 1;
    
    System.Threading.Tasks.Task.Run(()->
    try
      var consumed := all.ConsumedBy(last_ms).ToHashSet;
      var predators := all.DepValues(last_ms).Select(\(key,v)->key).ToHashSet;
      
      var invoke := procedure(a: Action)->
      lists_g.Dispatcher.InvokeAsync(()->
      try
        a();
      except
        on e: Exception do
          MessageBox.Show(e.ToString);
      end, System.Windows.Threading.DispatcherPriority.Background);
      
      lock lists_update_lock do
      begin
        if update_id < lists_last_update_id then exit;
        lists_last_update_id := update_id;
        // 0. Expected
        // 1. Missing
        // 2. Unexpected
        // 3. Other
        // 4. Predators
        
        foreach var s in consumed do
        begin
          if s in last_consumed then continue;
          // add consumed
          
          invoke(()->
            if s in expected then
            begin
              remove_from_list(1, s); // Missing
              add_to_list(0,s);        // Expected
            end else
            begin
              remove_from_list(3, s); // Other
              add_to_list(2,s);        // Unexpected
            end
          );
          
        end;
        
        foreach var s in last_consumed do
        begin
          if s in consumed then continue;
          // remove consumed
          
          invoke(()->
            if s in expected then
            begin
              remove_from_list(0, s); // Expected
              add_to_list(1,s);        // Missing
            end else
            begin
              remove_from_list(2, s); // Unexpected
              add_to_list(3,s);        // Other
            end
          );
          
        end;
        
        foreach var s in predators do
        begin
          if s in last_predators then continue;
          // add predator
          invoke(()->add_to_list(4,s));
        end;
        
        foreach var s in last_predators do
        begin
          if s in predators then continue;
          // remove predator
          invoke(()->remove_from_list(4,s));
        end;
        
        last_consumed := consumed;
        last_predators := predators;
      end;
      
    except
      on e: Exception do
        MessageBox.Show(e.ToString);
    end);
    
  end;
  update_confirm += update_lists;
  {$endregion Update lists}
  
  inp.TextChanged += (o,e)->update_confirm();
  update_confirm;
  
  confirm_slap.Click += (o,e)->
    (inp.Text := last_conf_text);
  
  w.KeyDown += (o,e)->
  case e.Key of
    System.Windows.Input.Key.Escape:
    begin
      e.Handled := true;
      w.Close;
    end;
    System.Windows.Input.Key.Enter:
    if System.Windows.Input.Keyboard.Modifiers.HasFlag(System.Windows.Input.ModifierKeys.Control) then
    begin
      e.Handled := true;
      if ms_list[4].Keys.Any then // Predators
        case MessageBox.Show($'Consume the [Predators] column manually?', $'Some keys are blocking', MessageBoxButton.YesNo) of
          MessageBoxResult.Yes: ;
          else exit;
        end;
      if ms_list[1].Keys.Any then // Missing
        case MessageBox.Show($'Consume the [Missing] column manually?', $'Some keys were not consumed', MessageBoxButton.YesNoCancel) of
          
          MessageBoxResult.Yes: ;
          MessageBoxResult.No: expected := nil;
          
          else exit;
        end;
      res := last_ms;
      w.Close;
    end;
  end;
  
  {$endregion Logic}
  
  try
    w.ShowDialog;
    if expected<>nil then
    begin
      expected.ExceptWith(last_consumed);
      expected.ExceptWith(last_predators);
    end;
    Result := ValueTuple.Create(res, expected, last_predators);
  except
    on e: Exception do
      MessageBox.Show(e.ToString);
  end;
end;

{$endregion Merging}

begin
  try
    var w := new Window;
    w.WindowState := WindowState.Maximized;
    w.Title := 'Auto-Minimizer';
    w.Icon := new System.Windows.Media.Imaging.BitmapImage(new System.Uri('AM.bmp', System.UriKind.Relative));
    new TrayIcon(w);
    
    w.KeyDown += (o,e)->
    case e.Key of
      System.Windows.Input.Key.Escape:
      begin
        e.Handled := true;
        SelectionManager.Clear;
      end;
      System.Windows.Input.Key.Enter:
      begin
        e.Handled := true;
        var sel := SelectionManager.AllSelected.ToArray;
        var first := sel.FirstOrDefault;
        if first=nil then exit;
        
        var w := w;
        if first is WinName then
        begin
          var cl := WinName(first).cl;
          StartInSTA(()->
          begin
            var (res, missing, predators) := LetChooseMerge(
              sel.Select(o->
              begin
                var wn := WinName(o);
                if wn.cl<>cl then raise new System.InvalidOperationException;
                Result := wn.name;
              end),
              cl.ms_list
            );
            if res=nil then exit;
            w.Dispatcher.Invoke(()->SaveHelper.DelaySaves(()->
            begin
              foreach var s in predators do
                cl.Remove(s);
              cl.Add( new WinName(res), nil );
              if missing<>nil then foreach var s in missing do
                cl.Remove(s);
            end));
          end);
        end else
        if first is WinClass then
        begin
          var gr := WinClass(first).gr;
          var old_cls := sel.Select(o->
          begin
            Result := WinClass(o);
            if Result.gr<>gr then raise new System.InvalidOperationException;
          end).ToList;
          StartInSTA(()->
          begin
            var (res, missing, predators) := LetChooseMerge(
              old_cls.ConvertAll(cl->cl.cl_name),
              gr.ms_list
            );
            if res=nil then exit;
            var cl := new WinClass( res, nil, Seq&<WinName>() );
            var absorb := procedure(s: MergedString)->
              gr.Remove( s, cl.Absorb );
            w.Dispatcher.Invoke(()->SaveHelper.DelaySaves(()->
            begin
              foreach var s in predators do
                absorb(s);
              gr.Add( cl, nil );
              if missing<>nil then foreach var s in missing do
                absorb(s);
            end));
          end);
        end else
          raise new System.NotImplementedException(TypeName(first));
        
        SelectionManager.Clear;
      end;
    end;
    
    var disp := System.Windows.Threading.Dispatcher.CurrentDispatcher;
    var load_ops := new List<System.Windows.Threading.DispatcherOperation>;
    var update_visual := procedure(a: Action)->lock load_ops do load_ops.Add(disp.InvokeAsync(()->
    try
      a();
    except
      on e: Exception do
      begin
        MessageBox.Show(e.ToString);
        Halt;
      end;
    end, System.Windows.Threading.DispatcherPriority.Background));
    
    {$region Load}
    
    var g := new Grid;
    w.Content := g;
    
    begin
      var r1 := new RowDefinition;
      g.RowDefinitions.Add(r1);
      r1.Height := GridLength.Auto;
    end;
    
    begin
      var r2 := new RowDefinition;
      g.RowDefinitions.Add(r2);
      r2.Height := GridLength.Create(1, GridUnitType.Star);
    end;
    
    begin
      var prev_gr := default(WinClassGroup);
      SaveHelper.IncSaveDelay;
      foreach var gr_name in |'0 Touch','1 What','2 Dont'| do
      begin
        var dir := System.IO.Path.Combine('Classes', gr_name);
        if System.IO.Path.GetFileName(dir).StartsWith('.') then
          continue;
        g.ColumnDefinitions.Add(new ColumnDefinition);
        
        var gr := new WinClassGroup(dir, update_visual);
        if prev_gr<>nil then
        begin
          prev_gr.gr_r := gr;
          gr.gr_l := prev_gr;
        end;
        prev_gr := gr;
        
        begin
          var gr_name_tb := new TextBlock;
          g.Children.Add(gr_name_tb);
          Grid.SetRow(gr_name_tb, 0);
          Grid.SetColumn(gr_name_tb, g.ColumnDefinitions.Count-1);
          gr_name_tb.Text := gr.name;
          gr_name_tb.HorizontalAlignment := HorizontalAlignment.Center;
        end;
        
        begin
          var vis := gr.vis;
          g.Children.Add(vis);
          Grid.SetRow(vis, 1);
          Grid.SetColumn(vis, g.ColumnDefinitions.Count-1);
        end;
        
      end;
    end;
    
    {$endregion Load}
    
    {$ifdef NoSaves}
    begin
      var grs := WinClassGroup.All;
      var upd: Action<Action> := a->a();
//      grs[0].Add( new WinClass( 'a@[1..2*1bd..f]@[1..2*1be..g]@[*]@[*a]@[*]@[*a]@[*]@[*a]c',  upd, |new WinName('name1')|), nil );
//      grs[0].Add( new WinClass( 'a@[2..3*b]c',  upd, |new WinName('name2')|), nil );
//      grs[1].Add( new WinClass( 'abbc',         upd, |new WinName('name3')|), nil );
    end;
    {$endif NoSaves}
    
    System.Threading.Thread.Create(()->
    begin
      while true do
      begin
        lock load_ops do load_ops.RemoveAll(op->op.GetAwaiter.IsCompleted);
        if load_ops.Count=0 then break;
        Sleep(100);
      end;
      // Load complete
      SaveHelper.DecSaveDelay;
      foreach var fr in |500,1000,1500| do
        Console.Beep(fr, 300);
      
      while true do
      try
        Sleep(100);
        
        WinAPI.LongPollWindows(w->
        begin
          Result := false;
          
          if not w.CanMaximize then exit;
          
          var pl := w.GetPlacement;
          if pl=nil then exit;
          var w_st_max := false;
          case pl.Value.showCmd of
            SW_SHOWMINIMIZED: exit;
            SW_MAXIMIZE: w_st_max := true;
            SW_NORMAL: ;
            else raise new NotImplementedException(pl.Value.showCmd.ToString);
          end;
          
          var cl_s := w.GetClass;
          if cl_s=nil then exit;
          var cl_ms := MergedString.Literal(cl_s);
          
          var wn_s := w.GetName;
          var wn_ms := if wn_s=nil then nil else MergedString.Literal(wn_s);
          
          var cls := new List<WinClass>;
          foreach var gr in WinClassGroup.All do
            cls.AddRange( gr.PredatorClasses(cl_ms) );
          
          if (cls.Count>1) and (wn_ms<>nil) then
          begin
            var new_cls := cls.FindAll(cl->wn_ms in cl.ms_list);
            if new_cls.Count<>0 then
              cls := new_cls;
          end;
          
          if cls.Select(cl->cl.gr).Distinct.Skip(1).Any then
            cls.Clear;
          
          if cls.Count=0 then
            // No point adding more then 1
            cls.AddRange( WinClassGroup.All[1].PredatorClasses(cl_ms).Take(1) );
          
          if cls.Count=0 then
            cls += g.Dispatcher.Invoke(()->
            begin
              var cl := new WinClass( cl_ms, cl_s, update_visual, Seq&<WinName>() );
              Console.Beep;
              SaveHelper.DelaySaves(()->
                WinClassGroup.All[1].Add( cl, nil )
              );
              Result := cl;
            end);
          
          var cl := cls.First;
          
          if wn_ms<>nil then
            g.Dispatcher.Invoke(()->
              SaveHelper.DelaySaves(()->
                cl.Add( new WinName(wn_ms, wn_s), nil )
              )
            );
          
          Result := (cl.gr <> WinClassGroup.All[0]) or w_st_max or w.Maximize;
        end);
        
      except
        on e: Exception do
          MessageBox.Show(e.ToString);
      end;
      
    end).Start;
    
    var ec := Application.Create.Run;
    Halt(ec);
  except
    on e: Exception do
      MessageBox.Show(e.ToString);
  end;
end.