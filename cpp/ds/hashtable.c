#include <assert.h>
#include <stdlib.h>
#include <stdio.h>

#define MIN_BUCKET_COUNT 7

struct bucket_node {
	int value;
	struct bucket_node *next;
};

typedef struct bucket_node *bucket;

struct hashtable {
	int bucket_count;
	bucket *buckets;
};

void hashtable_init(struct hashtable *ht, int bc) {
	assert(ht != NULL);

	if (bc < MIN_BUCKET_COUNT)
		bc = MIN_BUCKET_COUNT;

	ht->bucket_count = bc;
	ht->buckets = calloc(bc, sizeof(bucket));

	int i;
	for (i = 0; i < bc; ++i)
		ht->buckets[i] = NULL;
}

void hashtable_insert(struct hashtable *ht, int x) {
	assert(ht != NULL);

	if (hashtable_find(ht, x))
		return;

	assert(ht->bucket_count != 0);
	int index = x % ht->bucket_count;
	bucket pnode = malloc(sizeof(struct bucket_node));
	assert(pnode != NULL);
	pnode->value = x;
	if (ht->buckets[index] == NULL) {
		pnode->next = NULL;
		ht->buckets[index] = pnode;
	} else {
		pnode->next = ht->buckets[index];
		ht->buckets[index] = pnode;
	}
}

typedef int (*bucket_node_handler)(bucket *ppnode);
void hashtable_traverse(struct hashtable *ht, bucket_node_handler f) {
	assert(ht != NULL);
	assert(f != NULL);

	int i;
	for (i = 0; i < ht->bucket_count; ++i) {
		bucket *ppnode = &ht->buckets[i];
		while (*ppnode) {
			int cont = f(ppnode);
			ppnode = &((*ppnode)->next);
			if (!cont)
				return;
		}
	}
}

static int value_to_find;
static bucket *ppnode_to_find;
static int remove_helper(bucket *ppnode) {
	if ((*ppnode)->value == value_to_find) {
		ppnode_to_find = ppnode;
		return 0;
	}
	return 1;
}

void hashtable_remove(struct hashtable *ht, int x) {
	assert(ht != NULL);

	value_to_find = x;
	ppnode_to_find = NULL;
	hashtable_traverse(ht, remove_helper);
	if (ppnode_to_find) {
		bucket node_to_free = *ppnode_to_find;
		*ppnode_to_find = node_to_free->next;
		free(node_to_free);
	}
}


static int found;
static int find_helper(bucket *ppnode) {
	if ((*ppnode)->value == value_to_find) {
		found = 1;
		return 0;
	}
	return 1;
}

int hashtable_find(struct hashtable *ht, int x) {
	assert(ht != NULL);

	value_to_find = x;
	found = 0;
	hashtable_traverse(ht, find_helper);
	return found;
}

void hashtable_destroy(struct hashtable *ht) {
	assert(ht != NULL);

	int i;
	for (i = 0; i < ht->bucket_count; ++i) {
		bucket p = ht->buckets[i];
		while (p) {
			bucket next = p->next;
			free(p);
			p = next;
		}
	}
	if (ht->bucket_count > 0)
		free(ht->buckets);
	ht->buckets = NULL;
	ht->bucket_count = 0;
}

static struct hashtable *target_ht;
static int resize_helper(bucket *ppnode) {
	hashtable_insert(target_ht, (*ppnode)->value);
	return 1;
}

void hashtable_resize(struct hashtable *ht, int newsize) {
	assert(ht != NULL);

	if (newsize == ht->bucket_count)
		return;

	struct hashtable newht;
	hashtable_init(&newht, newsize);
	target_ht = &newht;
	hashtable_traverse(ht, resize_helper);
	hashtable_destroy(ht);
	*ht = newht;
}

static int print_helper(bucket *ppnode) {
	printf("%d ", (*ppnode)->value);
	return 1;
}

int main() {
	struct hashtable ht;
	hashtable_init(&ht, 7);
	int i;
	for (i = 0; i < 100; ++i)
		hashtable_insert(&ht, i);
	printf("is 20 in? %d\n", hashtable_find(&ht, 20));
	hashtable_remove(&ht, 20);
	hashtable_remove(&ht, 0);
	printf("is 20 in again? %d\n", hashtable_find(&ht, 20));
	hashtable_traverse(&ht, print_helper);
	printf("\nAfter Resize:\n");
	hashtable_resize(&ht, 13);
	hashtable_traverse(&ht, print_helper);
	printf("\n");
	hashtable_destroy(&ht);
	return 0;
}