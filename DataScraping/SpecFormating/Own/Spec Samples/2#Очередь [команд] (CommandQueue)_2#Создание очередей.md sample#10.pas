uses OpenCLABC;

begin
  
  var b := new Buffer( 3*sizeof(integer) );
  var A := new integer[3];
  
  // ��� � ���������
  
  var Q_BuffWrite :=
    ( b.NewQueue.AddWriteValue(1, 0*sizeof(integer) ) as CommandQueue<Buffer> ) *
    ( b.NewQueue.AddWriteValue(5, 1*sizeof(integer) ) as CommandQueue<Buffer> ) *
    ( b.NewQueue.AddWriteValue(7, 2*sizeof(integer) ) as CommandQueue<Buffer> )
  ;
  
  var Q_BuffRead := b.NewQueue.AddReadArray(A) as CommandQueue<Buffer>;
  
  var Q_Otp := HPQ(()->
  begin
    A.Println;
  end);
  
  Context.Default.SyncInvoke(
    Q_BuffWrite +
    Q_BuffRead +
    Q_Otp
  );
  
  // ���� �� ��� ��� ���, �� ��� ����� ��������
  // ������ - ������ ����� .Write*** � .Read*** �� ����� ������ �� �������
  // ����� ������ ������, �� ����������� ���������
  
  // ������ Q_BuffWrite
  System.Threading.Tasks.Parallel.Invoke(
    ()->b.WriteValue(1, 0*sizeof(integer) ),
    ()->b.WriteValue(5, 1*sizeof(integer) ),
    ()->b.WriteValue(7, 2*sizeof(integer) )
  );
  
  // ������ Q_BuffRead
  b.ReadArray(A);
  
  // ������ Q_Otp
  A.Println;
  
end.