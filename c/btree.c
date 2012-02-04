#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MIN_CHILD_COUNT 10
#define MAX_CHILD_COUNT (MIN_CHILD_COUNT << 1)
#define MIN_ITEM_COUNT (MIN_CHILD_COUNT - 1)
#define MAX_ITEM_COUNT (MAX_CHILD_COUNT - 1)

struct Pair
{
	int key;
	void * value;
};

struct BNode
{
	struct BNode * parent;
	struct Pair items[MAX_ITEM_COUNT + 1];
	struct BNode * childs[MAX_CHILD_COUNT + 1];
	int item_count;
	int child_count;
};

int count = 0;

bool insert(struct BNode * root, struct Pair * item);
bool check_tree(struct BNode * root, int * max, int * min);
void print_tree(struct BNode * root, int indent);
void test1();

int main()
{
	printf("B-Tree: t = %d, node size = %d bytes.\n", MIN_CHILD_COUNT, sizeof(struct BNode));
	test1();
	return 0;
}

void test1()
{
	// Create the root node.
	struct BNode * root = (struct BNode *)malloc(sizeof(struct BNode));
	root->parent = NULL;
	root->item_count = 0;
	root->child_count = 0;

	// Insertions.
	count = 0;
	struct Pair temp;
	temp.value = NULL;
	temp.key = (int)clock();
	int n = 100000000;
	int i;

	printf("Beginning insertion of %d items with randomized key...\n", n);
	clock_t st = clock();
	for (i = 0; i < n; ++i)
	{
		temp.key = (int)(((__int64)314159269 * temp.key + 453806245) % 0x80000000);

		// Ensure distinction.
		if (!insert(root, &temp))
			--i;
	}
	clock_t en = clock();
	printf("Insertion complete, time elapsed: %lfs.\n", (en - st) / 1000.0);

	// Check if the tree has violated the rule for B_Tree.
	int max, min;
	if (check_tree(root, &max, &min))
		printf("Check complete: OK, total items: %d.\n", count);
	else
		printf("Check complete: Error.\n");
}

static bool search_key(struct BNode * root, int key, struct BNode ** pparent)
{
	int i; // index for keys.
	int j; // index for childs.

	struct BNode * parent;

	while (root != NULL)
	{
		// Start searching from the first child of the new node.
		j = 0;

		for (i = 0; i < root->item_count; ++i)
		{
			if (key < root->items[i].key)
			{ // key < keys[i].
				break;
			}
			else if (key == root->items[i].key)
			{ // key = keys[i].
				// Found.
				return true;
			}
			else
			{ // key > keys[i].
				++j;
			}
		}

		// Turn to the child.
		parent = root;
		if (j < root->child_count)
			root = root->childs[j];
		else
			root = NULL;
	}

	*pparent = parent;
	
	// Not found.
	return false;
}

static void insert_unchecked(struct BNode * node, struct Pair * item, struct BNode * child)
{
	// Find the place to insert.
	int i = node->item_count;
	while (i > 0 && item->key < node->items[i - 1].key)
	{
		node->items[i] = node->items[i - 1];
		node->childs[i + 1] = node->childs[i];
		--i;
	}

	// Do insertion.
	node->items[i] = *item;
	node->childs[i + 1] = child;

	++node->item_count;
	if (child != NULL)
		++node->child_count;
}

static struct BNode * create_new_node_from(struct BNode * source, int start, int end)
{
	struct BNode * dest = (struct BNode *)malloc(sizeof(struct BNode));
	dest->child_count = 0;
	dest->item_count = end - start;

	// The first child is an exception and should copy it alone.
	if (start < source->child_count)
	{
		dest->childs[0] = source->childs[start];
		dest->childs[0]->parent = dest;
		++dest->child_count;
	}

	int i, j, k;
	for (i = start, j = 1, k = i + 1; i < end; ++i, ++j, ++k)
	{
		dest->items[j - 1] = source->items[i];
		if (k < source->child_count)
		{
			dest->childs[j] = source->childs[k];
			dest->childs[j]->parent = dest;
			++dest->child_count;
		}
	}

	return dest;
}

static void split_node(struct BNode * node, struct BNode * root)
{
	// Acquire the middle item.
	int mid = MIN_CHILD_COUNT - 1;
	struct Pair mid_item = node->items[mid];

	int i, j;

	// Create right.
	struct BNode * right = create_new_node_from(node, mid + 1, node->item_count);

	if (node == root)
	{
		// if node is root, then the structure shall be:
		//                 root
		//              left   right

		// Create left.
		struct BNode * left = create_new_node_from(node, 0, mid);
		left->parent = node;
		right->parent = node;

		// Reset node.
		node->items[0] = mid_item;
		node->childs[0] = left;
		node->childs[1] = right;
		node->item_count = 1;
		node->child_count = 2;
	}
	else
	{
		// if node isn't root, then the structure shall be:
		//                 parent
		//              node   right

		// Node itself is now the 'left'.
		node->item_count = mid;
		node->child_count = node->child_count - right->child_count;

		// insert the mid_item and right to the parent of the node (splitting
		// is possible).
		struct BNode * parent = node->parent;
		right->parent = parent;

		// Insert the middle item to node's parent.
		insert_unchecked(parent, &mid_item, right);
		if (parent->item_count > MAX_ITEM_COUNT)
			split_node(parent, root);
	}
}

bool insert(struct BNode * root, struct Pair * item)
{
	// Find if key of the item exists in the tree and get the node where
	// the item will be inserted.
	struct BNode * node = NULL;
	if (search_key(root, item->key, &node))
		return false;

	// If the item is not found in the tree, then search must be reach
	// the bottom of the tree.
	// So the node should be the leaf node where the insertion
	// will take place.

	insert_unchecked(node, item, NULL);
	if (node->item_count > MAX_ITEM_COUNT)
		split_node(node, root);

	return true;
}

void print_tree(struct BNode * root, int indent)
{
	// Print indent.
	int i;
	for (i = 0; i < indent; ++i)
		printf("    ");

	// Print all keys of the node.
	printf("(");
	for (i = 0; i < root->item_count; ++i)
	{
		if (i == root->item_count - 1)
			printf("%d)\n", root->items[i]);
		else
			printf("%d, ", root->items[i]);
	}

	// Print childs.
	for (i = 0; i < root->child_count; ++i)
		print_tree(root->childs[i], indent + 1);
}

bool check_tree(struct BNode * root, int * max, int * min)
{
	int imax;
	int imin;

	*max = root->items[0].key;
	*min = root->items[0].key;

	int i;
	for (i = 0; i < root->item_count; ++i)
	{
		++count;

		// Check the order of keys in the node.
		if (i > 0 && root->items[i].key <= root->items[i - 1].key)
			return false;

		// Keep track of min and max value of keys in the node.
		if (root->items[i].key < *min)
			*min = root->items[i].key;
		if (root->items[i].key > *max)
			*max = root->items[i].key;

		// The min value in the child[i] should > key[i - 1].
		// The max value in the child[i] should < key[i].
		if (i < root->child_count)
		{
			if (!check_tree(root->childs[i], &imax, &imin))
				return false;
			if (i > 0 && imin <= root->items[i - 1].key)
				return false;
			if (imax >= root->items[i].key)
				return false;
		}
	}

	// The last child is an exception.
	if (root->item_count < root->child_count)
	{
		if (!check_tree(root->childs[root->item_count], &imax, &imin))
			return false;
		if (imin <= root->items[root->item_count - 1].key)
			return false;
	}

	return true;
}