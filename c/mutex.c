#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

int counter;
pthread_mutex_t counter_mutex = PTHREAD_MUTEX_INITIALIZER;

void *doit(void *);

int main() {
	pthread_t tid[2];

	pthread_create(&tid[0], NULL, doit, &tid[0]);
	pthread_create(&tid[1], NULL, doit, &tid[1]);

	pthread_join(tid[0], NULL);
	pthread_join(tid[1], NULL);

	printf("Counter = %d\n", counter);

	return 0;
}

void *doit(void *vptr) {
	pthread_t tid = *(pthread_t *)vptr;

	int i;
	for (i = 0; i < 5000; ++i) {
		pthread_mutex_lock(&counter_mutex);
		++counter;
		pthread_mutex_unlock(&counter_mutex);
	}

	return NULL;

}