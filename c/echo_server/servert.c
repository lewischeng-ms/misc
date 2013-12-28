#include "csapp.h"

void echo(int fd);
void *thread(void *vargp);

int main(int argc, char *argv[]) {
	if (argc != 2) {
		fprintf(stderr, "usage: %s <port>\n", argv[0]);
		exit(0);
	}

	int port = atoi(argv[1]);

	int listenfd = Open_listenfd(port);
	while (1) {
		struct sockaddr_in clientaddr;
		socklen_t clientlen = sizeof(struct sockaddr_in);
		int *connfdp = Malloc(sizeof(int));
		*connfdp = Accept(listenfd, (SA *)&clientaddr, &clientlen);

		pthread_t tid;
		Pthread_create(&tid, NULL, thread, connfdp);
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

void *thread(void *vargp) {
	int connfd = *(int *)vargp;
	Pthread_detach(pthread_self());
	Free(vargp);
	echo(connfd);
	Close(connfd);
	return NULL;
}
