uses OpenCLABC;

begin
  
  // ����� ����� �������� ������ ����� ��������� �� �����:
//  var code_text := ReadAllText('0.cl');
  
  // �� ����� �������� .cl ���� ������ .exe � ��������� ������:
  {$resource '0.cl'}
  var code_text := System.IO.StreamReader.Create( GetResourceStream('0.cl') ).ReadToEnd;
  // ��� �� ����� ������� .cl ���� ������ � .exe
  
  var code := new ProgramCode(code_text);
  
  var A := new Buffer( 10 * sizeof(integer) ); // ����� �� 10 ����� ���� "integer"
  
  // 'TEST' - ��� ������������-������ �� .cl �����. ������� �����!
  var kernel := code['TEST'];
  
  kernel.Exec1(10, // ���������� 10 �������
    
    A.NewQueue.AddFillValue(1) // ��������� ���� ����� ����������, ����� ����� �����������
    as CommandQueue<Buffer> //ToDo ����� ������ �� �� issue ����������� #1981, ����� �������� �������� ������. ����� �������� - ����� ����� ������
    
  );
  
  A.GetArray1&<integer>.Println; // ������ ���� ����� ��� ���������� ������ � ���������� ���� "integer" � ����� �������
  
end.