uses OpenCLABC;

/// ����� ���� � �������� �������
procedure OtpObject(o: object) :=
Writeln( $'{o?.GetType}[{_ObjectToString(o)}]' );
// "o?.GetType" ��� �������� ����� "o=nil ? nil : o.GetType",
// �� ����, ���� ��� ��� �������, ��� nil ���� ��� ������ nil
// _ObjectToString ��� �������, ������� ���������� Writeln ��� �������������� ��������

begin
  var b0 := new Buffer(1);
  
  // ��� - �����, ������ ��� ������� ������� �� ������
  OtpObject(  Context.Default.SyncInvoke( b0.NewQueue as CommandQueue<Buffer>   )  );
  
  // ��� - Int32 (�� ���� integer), ������ ��� ��� ��� �� ��������� ��� ��������� (5)
  OtpObject(  Context.Default.SyncInvoke( HFQ( ()->5                          ) )  );
  
  // ��� - string, �� ��� �� �������
  OtpObject(  Context.Default.SyncInvoke( HFQ( ()->'abc'                      ) )  );
  
  // ��� �����������, ������ ��� HPQ ���������� nil
  OtpObject(  Context.Default.SyncInvoke( HPQ( ()->Writeln('����������� HPQ') ) )  );
  
end.