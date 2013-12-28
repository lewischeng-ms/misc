#include <cstdio>
#include <cstdlib>
#include <queue>
#include <stack>

using namespace std;

typedef struct node_tag {
	int tag;
	int value;
	struct node_tag *left;
	struct node_tag *right;
} node_type, *node_pointer;

typedef void (*node_handler)(node_pointer pnode);

void dfs(node_pointer root, node_handler func) {
	if (root != NULL) {
		func(root);
		dfs(root->left, func);
		dfs(root->right, func);
	}
}

void bfs(node_pointer root, node_handler func) {
	queue<node_pointer> q;

	if (root == NULL)
		return;

	q.push(root);
	while (!q.empty()) {
		node_pointer pnode = q.front();
		q.pop();

		func(pnode);

		if (pnode->left)
			q.push(pnode->left);

		if (pnode->right)
			q.push(pnode->right);
	}
}

void preorder(node_pointer root, node_handler func) {
	if (!root)
		return;
	func(root);
	preorder(root->left, func);
	preorder(root->right, func);
}

void preorder1(node_pointer root, node_handler func) {
	stack<node_pointer> s;

	if (!root)
		return;

	s.push(root);
	while (!s.empty()) {
		node_pointer pnode = s.top();
		s.pop();
		func(pnode);
		if (pnode->right)
			s.push(pnode->right);
		if (pnode->left)
			s.push(pnode->left);
	}
}

void inorder(node_pointer root, node_handler func) {
	if (!root)
		return;
	
	inorder(root->left, func);
	func(root);
	inorder(root->right, func);
}

void inorder1(node_pointer root, node_handler func) {
	stack<node_pointer> s;

	if (!root) return;

	node_pointer pnode = root;
	while (pnode || !s.empty()) {
		while (pnode) {
			s.push(pnode);
			pnode = pnode->left;
		}
		pnode = s.top();
		s.pop();
		func(pnode);
		pnode = pnode->right;
	}
}

void postorder(node_pointer root, node_handler func) {
	if (!root)
		return;
	
	postorder(root->left, func);
	postorder(root->right, func);
	func(root);
}

void postorder1(node_pointer root, node_handler func) {
	stack<node_pointer> s;

	if (!root) return;

	s.push(root);
	while (!s.empty()) {
		node_pointer pnode = s.top();
		if (pnode->tag == 0) {
			pnode->tag = 1;
			if (pnode->left)
				s.push(pnode->left);
		} else if (pnode->tag == 1) {
			pnode->tag = 2;
			if (pnode->right)
				s.push(pnode->right);
		} else {
			func(pnode);
			s.pop();
		}
	}
}

void print_node(node_pointer pnode) {
	printf("%d ", pnode->value);
}

int main() {
	/*
				____0____
				|		|
			____1____   2____
			|		| 		|
			3		4 	____5____
						|		|
						6		7
	*/
	node_type nodes[8] = {
		{ 0, 0, &nodes[1], &nodes[2] },
		{ 0, 1, &nodes[3], &nodes[4] },
		{ 0, 2, NULL, &nodes[5] },
		{ 0, 3, NULL, NULL },
		{ 0, 4, NULL, NULL },
		{ 0, 5, &nodes[6], &nodes[7] },
		{ 0, 6, NULL, NULL },
		{ 0, 7, NULL, NULL }
	};

	printf("dfs:\n");
	dfs(nodes, print_node);
	printf("\n");

	printf("bfs:\n");
	bfs(nodes, print_node);
	printf("\n");

	printf("preorder (recursive):\n");
	preorder(nodes, print_node);
	printf("\n");

	printf("preorder (iterative):\n");
	preorder1(nodes, print_node);
	printf("\n");

	printf("inorder (recursive):\n");
	inorder(nodes, print_node);
	printf("\n");

	printf("inorder (iterative):\n");
	inorder1(nodes, print_node);
	printf("\n");

	printf("postorder (recursive):\n");
	postorder(nodes, print_node);
	printf("\n");

	printf("postorder (iterative):\n");
	postorder1(nodes, print_node);
	printf("\n");
	return 0;
}