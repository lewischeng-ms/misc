void get_next(char* T, int* next)
{
	int i = 0, j = -1;
	int length = strlen(T);
	next[0] = -1;
	
	while(i< length)
	{
		if(j==-1 || T[i]==T[j])
		{
			i++;
			j++;
			//优化后的get_next方法，可以防止出现形如"aaaaab"这种模式的计算退化
			if(T[i]!=T[j])
				next[i]=j;
			else
				next[i]=next[j];
		}
		else
			j=next[j];
	}
}

int KMP(char *S, char *T)
{
	int S_Length = strlen(S);
	int T_Length = strlen(T);
	
	//若模式长度大于字符串，则直接返回查询失败
	if( S_Length < T_Length)
	return 0;
	
	int i = 0, j = 0;
	int* next = new int[T_Length];
	get_next(T, next);
	
	while(i < S_Length && j < T_Length)
	{
		if(j == -1 || S[i] == T[j])
		{
			i++;
			j++;
		}
		else
			j=next[j];
	}
	
	if(j>=T_Length)
		return i-T_Length;
	else
		return 0;
}