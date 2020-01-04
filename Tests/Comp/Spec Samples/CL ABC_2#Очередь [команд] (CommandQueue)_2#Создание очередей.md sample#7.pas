uses OpenCLABC;

begin
  
  var q1 := HFQ( ()->1 );
  var q2 := HFQ( ()->2 );
  
  // ������� 2, �� ���� ������ ��������� ��������� �������
  // ��� ������� �� �� �������� ������������������
  Context.Default.SyncInvoke( q1+q2 ).Println;
  // ������ ������ ���, ��� ����� ���������� ���� ���������/���������� ��������
  
  // � ����� ������ ���� ������������ CombineSyncQueue � CombineAsyncQueue
  // � ������ �� ����������, ������ �������� ������� - ������� ��������������
  Context.Default.SyncInvoke(
    CombineSyncQueue(
      results->results.JoinIntoString, // ������� ��������������
      q1, q2
    )
  ).Println;
  // ������ ������� ������ "1 2". ��� �� �� �����, ��� ����� "Arr(1,2).JoinIntoString"
  
end.