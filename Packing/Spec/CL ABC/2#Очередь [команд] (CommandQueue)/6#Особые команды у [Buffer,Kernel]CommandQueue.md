


����� ��������� ��� GPU (��������� � �������� ����� `BufferCommandQueue` � `KernelCommandQueue`)
������ ���� �������� ���������� ������ ������� ��� ���� ��� CPU.

��� ����� �������, ��������� ��������� `.NewQueue`:
```pas
var b: Buffer;
var q0: CommandQueueBase;
...
var q :=
  b.NewQueue.AddWriteValue(...) +
  q0 +
  HPQ(...) +
  b.NewQueue.AddWriteValue(...)
;
```
������ ����� ������� � ��������:
```pas
var b: Buffer;
var q0: CommandQueueBase;
...
var q := b.NewQueue
  .AddWriteValue(...)
  .AddQueue(q0)
  .AddProc(...)
  .AddWriteValue(...)
;
```
��� ������ �� ����� ����������� ����������, �� ��������� ������� ��� ����������� �����������


