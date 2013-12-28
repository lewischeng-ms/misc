#include "csapp.h"

int main(int argc, char *argv[]) {
	if (argc != 3) {
		fprintf(stderr, "usage: %s <host> <port>\n", argv[0]);
		exit(0);
	}

	char *host = argv[1];
	int port = atoi(argv[2]);

	int fd = Open_clientfd(host, port);

	rio_t rio;
	Rio_readinitb(&rio, fd);

	char buf[MAXLINE];
	while (Fgets(buf, MAXLINE, stdin) != NULL) {
		Rio_writen(fd, buf, strlen(buf));
		Rio_readlineb(&rio, buf, MAXLINE);
		Fputs(buf, stdout);
	}

	Close(fd);
	exit(0);
}