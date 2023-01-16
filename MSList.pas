unit MSList;

interface

uses MergedStrings  in 'Utils\Patterns\MergedStrings';

uses Misc;

type
  MergedStringList = sealed class
    private l := new List<MergedString>;
    
    private deps := new List<System.Collections.IList>;
    public static procedure operator+=(l: MergedStringList; dep: System.Collections.IList) := l.deps += dep;
    
    public function Keys := l.AsEnumerable;
    private function MakeParallelAndNumerated := l.AsParallel.Select((key,ind)->System.ValueTuple.Create(ind,key));
    
    private function IndsConsumedBy(s: MergedString) := MakeParallelAndNumerated.Where(\(ind,key)->key in s);
    public function ConsumedBy(s: MergedString) := IndsConsumedBy(s).Select(\(ind,key)->key);
    
    private function IndsConsuming(s: MergedString) := MakeParallelAndNumerated.Where(\(ind,key)->s in key);
    private function DepValue(ind: integer; key: MergedString): System.ValueTuple<MergedString, array of object>;
    begin
      Result.Item1 := key;
      Result.Item2 := new object[deps.Count];
      for var i := 0 to Result.Item2.Length-1 do
        Result.Item2[i] := deps[i][ind];
    end;
    public function DepValues(s: MergedString) := IndsConsuming(s).Select(\(ind,key)->DepValue(ind,key));
    
    public function Contains(s: MergedString) := IndsConsuming(s).Any;
    public static function operator in(s: MergedString; l: MergedStringList) := l.Contains(s);
    
    private function FindInsertInd(s: MergedString): integer;
    begin
      var b1 := 0;
      var b2 := l.Count;
      
      while b2>b1 do
      begin
        var m := (b1+b2) div 2;
        
        if MergedString.Compare(s, l[m]) >= 0 then
          b1 := m+1 else
          b2 := m;
        
      end;
      
      Result := b2;
    end;
    
    public function Add(s: MergedString; ConsumedBeforeAdd, ConsumedByAdd: System.ValueTuple<MergedString,array of object>->(); params vs: array of Object): boolean;
    begin
      if deps.Count<>vs.Length then raise new System.InvalidOperationException($'{deps.Count}<>{vs.Length}');
      
      Result := false;
      begin
        var (ind,key) := IndsConsuming(s).FirstOrDefault;
        if key<>nil then
        begin
          TryInvoke(ConsumedBeforeAdd, DepValue(ind,key));
          exit;
        end;
      end;
      Result := true;
      
      var consumed := new boolean[l.Count];
      foreach var (ind, key) in IndsConsumedBy(s) do
      begin
        TryInvoke(ConsumedByAdd, DepValue(ind, key));
        consumed[ind] := true;
      end;
      
      for var ind := l.Count-1 downto 0 do
      begin
        if not consumed[ind] then continue;
        l.RemoveAt(ind);
        foreach var dep in deps do
          dep.RemoveAt(ind);
      end;
      
      var ind := FindInsertInd(s);
      l.Insert(ind, s);
      for var i := 0 to deps.Count-1 do
        deps[i].Insert(ind, vs[i]);
      
    end;
    
    public function Remove(s: MergedString; on_rem: System.ValueTuple<MergedString,array of object>->()): integer;
    begin
      foreach var (ind,key) in IndsConsumedBy(s).ToArray do
      begin
        ind -= Result;
        var v := DepValue(ind,key);
        l.RemoveAt(ind);
        foreach var dep in deps do
          dep.RemoveAt(ind);
        TryInvoke(on_rem, v);
        Result += 1;
      end;
    end;
    
  end;
  
//  MergedStringDict<TValue> = record
//    private l := new MergedStringList;
//    
//    public constructor := l += new List<TValue>;
//    
//    public function KeysConsumedBy(s: MergedString) := l.ConsumedBy(s);
//    public function ValuesConsuming(s: MergedString) := l.DepValues(s).Select(\(k,v)->TValue(v[0]));
//    
//    public function ContainsKey(s: MergedString) := s in l;
//    public static function operator in(s: MergedString; d: MergedStringDict<TValue>) := d.ContainsKey(s);
//    
//    public function Add(s: MergedString; v: TValue) := l.Add(s, v);
//    public function Remove(s: MergedString) := l.Remove(s);
//    
//  end;
  
implementation



end.