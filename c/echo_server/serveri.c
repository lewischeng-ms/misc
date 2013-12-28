#include "csapp.h"

void echo(int fd);

int main(int argc, char *argv[]) {
	if (argc != 2) {
		fprintf(stderr, "usage: %s <port>\n", argv[0]);
		exit(0);
	}

	int port = atoi(argv[1]);

	int listenfd = Open_listenfd(port);
	while (1) {
		struct sockaddr_in clientaddr;
		int clientlen = sizeof(clientaddr);
		int connfd = Accept(listenfd, (SA *)&clientaddr, &clientlen);

		struct hostent *hp = Gethostbyaddr((const char *)&clientaddr.sin_addr.s_addr,
										   sizeof(clientaddr.sin_addr.s_addr), AF_INET);
		char *haddrp = inet_ntoa(clientaddr.sin_addr);
		printf("server connected to %s (%s)\n", hp->h_name, haddrp);

		echo(connfd);
		Close(connfd);
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