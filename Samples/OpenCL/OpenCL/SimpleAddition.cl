


// ��� ������������ ������� �������� �� "SimpleAddition.pas" 10 ��� �����������
__kernel void TEST(__global int* message)
{
	int gid = get_global_id(0); // ����� �������� ������ TEST
	
	message[gid] += gid;
}


