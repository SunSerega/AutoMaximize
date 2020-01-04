uses OpenCLABC;

begin
  
  var q1 := HPQ(()->
  begin
    // lock ��������� ����� ��� ������������ ���������� ��� ������ �� �������� ������������ ����� ������������. ����� ������� ����
    lock output do Writeln('������� 1 ������ �����������');
    Sleep(500);
    lock output do Writeln('������� 1 ��������� �����������');
  end);
  var q2 := HPQ(()->
  begin
    lock output do Writeln('������� 2 ������ �����������');
    Sleep(500);
    lock output do Writeln('������� 2 ��������� �����������');
  end);
  
  Writeln('���������������� ����������:');
  Context.Default.SyncInvoke( q1 + q2 );
  
  Writeln;
  Writeln('������������ ����������:');
  Context.Default.SyncInvoke( q1 * q2 );
  
end.