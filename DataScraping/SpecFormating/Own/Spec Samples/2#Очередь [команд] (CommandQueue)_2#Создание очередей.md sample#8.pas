type t1 = class ... end;
type t2 = class(t1) ... end;
...
var Q1: CommandQueue<integer> := 5;
var Q2: CommandQueueBase := Q1;
var Q3: CommandQueue<t1> := (new t2) as t1;
var Q4: CommandQueue<t1> := new t1;
var Q5: CommandQueue<t2> := new t2;

// �����, ������ ��� � object ����� ������������� ��
Context.Default.SyncInvoke( Q1.Cast&<object> );

// ������, �������������� �� integer � byte - �������� ���������� ������������� ������
Context.Default.SyncInvoke( Q1.Cast&<byte> );

// �����, Q2 � ��� ����� ��� CommandQueue<integer>, � ������ ��� Cast ����� (Q2 as CommandQueue<integer>)
Context.Default.SyncInvoke( Q2.Cast&<integer> );

// �����, ������ ��� Q3 ���������� t2
Context.Default.SyncInvoke( Q3.Cast&<t2> );

// ������, Q4 ���������� �� t2 � t1, ������� � t2 ������������� �� ���������
Context.Default.SyncInvoke( Q4.Cast&<t2> );

// �����, ������ ��� t2 ��������� �� t1
Context.Default.SyncInvoke( Q5.Cast&<t1> );