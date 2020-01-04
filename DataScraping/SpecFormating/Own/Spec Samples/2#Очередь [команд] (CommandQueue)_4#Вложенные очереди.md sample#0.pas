uses OpenCLABC;

begin
  var b := new Buffer(10*sizeof(integer));
  // ������� ���� ����� ��������, ����� �� ���� ������
  b.FillValue(0);
  
  var q := b.NewQueue
    
    // ������ �������� AddWriteValue - ������ �� ������ ������
    // �� ����� ��� integer, � ������ ����� �������� � CommandQueue<integer>
    // ����� �������, � �������� ����������� ��������, � �� ������� ��������
    // ������� 3 ������ ���� ����� ��������� � 3 ������� ���������
    .AddWriteValue(5, HFQ(()-> Random(0,9)*sizeof(integer) ))
    
  as CommandQueue<Buffer>;
  
  Context.Default.SyncInvoke(q);
  Context.Default.SyncInvoke(q);
  Context.Default.SyncInvoke(q);
  
  b.GetArray1&<integer>.Println;
  
end.