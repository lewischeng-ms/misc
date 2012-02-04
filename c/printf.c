#define haha_list char *
#define haha_start(ap, fmt) ap = (haha_list)&fmt + sizeof(haha_list)
#define haha_arg(ap, type) *((type *)((ap += sizeof(type)) - sizeof(type)))
#define haha_end(ap) ap = (haha_list)0

void haha(const char * fmt, ...)
{
	haha_list args;
	haha_start(args, fmt);
	int a = haha_arg(args, int);
	double b = haha_arg(args, double);
	char * s = haha_arg(args, char *);
	printf("a = %d, b = %lf, s = %s\n", a, b, s);
	haha_end(args);
}

int main(int argc, char* argv[])
{
	haha(0, 5, 8.0, "haha");
	getchar();
	return 0;
}

