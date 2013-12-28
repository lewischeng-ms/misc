#include <assert.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void error(const char *msg) {
	fprintf(stderr, msg);
	exit(1);
}

static const char *parse_proto(const char *url, char *proto) {
	const char *p = url;
	if (!isalpha(*p))
		return p;
	int len = 0;
	while (isalpha(*p))
		proto[len++] = *p++;
	proto[len] = 0;
	if (*p != ':')
		return url;
	++p;
	if (*p != '/' || *(p + 1) != '/')
		error("invalid characters after protocol");
	return p + 2;
}

static const char *parse_hostname(const char *str, char *hostname) {
	const char *p = str;
	int len = 0;
	while (isalpha(*p) || *p == '.')
		hostname[len++] = *p++;
	hostname[len] = 0;
	return p;
}

static const char *parse_resource_path(const char *str, char *path) {
	const char *p = str;
	int len = 0;
	while (*p != '?' && *p != 0)
		path[len++] = *p++;
	path[len] = 0;
	return p;
}

static const char *parse_query_options(const char *str, char *options) {
	const char *p = str;
	int len = 0;
	while (*p != 0)
		options[len++] = *p++;
	options[len] = 0;
	return p;
}

void parse_url(const char *url, char *proto, char *hostname, char *path, char *options) {
	assert(url != NULL);

	const char *p = parse_proto(url, proto);
	p = parse_hostname(p, hostname);
	p = parse_resource_path(p, path);
	if (*p == '?')
		p = parse_query_options(p + 1, options);
	assert(!*p);
}

int main() {
	const char *url = "http://a.com/b/c?d=e&&f=g";
	char proto[16];
	char hostname[128];
	char path[128];
	char options[128];
	parse_url(url, proto, hostname, path, options);
	printf("Protocol: %s\n", proto);
	printf("Hostname: %s\n", hostname);
	printf("Resource Path: %s\n", path);
	printf("Query Options: %s\n", options);
	return 0;
}