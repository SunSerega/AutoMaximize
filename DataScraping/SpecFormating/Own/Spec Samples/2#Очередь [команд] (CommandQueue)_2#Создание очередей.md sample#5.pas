var cq := q as IConstQueue;
if cq=nil then
  Writeln('������� �� �����������') else
  Writeln($'������� ���� ������� �� �������� ({cq.GetConstVal})');