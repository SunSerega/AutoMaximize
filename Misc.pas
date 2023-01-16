unit Misc;

procedure TryInvoke<T>(ev: T->(); v: T) :=
if ev<>nil then ev(v);

function StartInSTA(a: Action0): System.Threading.Thread;
begin
  Result := new System.Threading.Thread(a);
  Result.ApartmentState := System.Threading.ApartmentState.STA;
  Result.Start;
end;

end.