#include "csapp.h"

void echo(int fd);

void sigchld_handler(int sig) {
	while (waitpid(-1, 0, WNOHANG) > 0)
		;
	return;
}

int main(int argc, char *argv[]) {
	if (argc != 2) {
		fprintf(stderr, "usage: %s <port>\n", argv[0]);
		exit(0);
	}

	int port = atoi(argv[1]);

	Signal(SIGCHLD, sigchld_handler);

	socklen_t clientlen = sizeof(struct sockaddr_in);
	int listenfd = Open_listenfd(port);
	while (1) {
		struct sockaddr_in clientaddr;
		int connfd = Accept(listenfd, (SA *)&clientaddr, &clientlen);

		if (Fork() == 0) {
			Close(listenfd); /* Child closes its listening socket */
			echo(connfd); /* Child services client */
			Close(connfd); /* Child closes connection with client */
			exit(0);
		}

		Close(connfd); /* Parent closes connected socket (important!) */
	}

	exit(0);
}

void echo(int fd) {
	rio_t rio;
	Rio_readinitb(&rio, fd);

	size_t n;
	char buf[MAXLINE];
	while ((n = Rio_readlineb(&rio, buf, MAXLINE)) != 0) {
		printf("server received %d bytes\n", n);
		Rio_writen(fd, buf, n);
	}
}