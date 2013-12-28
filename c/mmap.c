#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>

int main() {
	int fd = open("hello", O_RDWR);
	if (fd < 0) {
		perror("open hello");
		return 1;
	}
	char *p = mmap(NULL, 6, PROT_WRITE, MAP_PRIVATE, fd, 0);
	if (p == MAP_FAILED) {
		perror("mmap");
		return 1;
	}
	close(fd);
	p[0] = 'k';
	munmap(p, 6);
	return 0;
}