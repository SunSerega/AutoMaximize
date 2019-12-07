


����� ��������� ��� GPU (��������� � �������� ����� `BufferCommandQueue` � `KernelCommandQueue`)
������ ���� �������� ���������� ������ ������� ��� ���� ��� CPU.

��� ����� �������, ��������� ��������� `.NewQueue`:
```
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
```
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


