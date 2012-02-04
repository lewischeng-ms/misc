struct treenode_t {
	struct treenode_t* left;
	struct treenode_t* right;
};

void euler_tour(struct treenode_t* root)
{
	if (!root->left && !root->right)
	{
		// visit external node.
		// print number.
	}
	else
	{
		// left-side visiting.
		// print (.
		if (root->left) euler_tour(root->left);
		// bottom-side visiting.
		// print operator.
		if (root->right) euler_tour(root->right);
		// right-side visiting.
		// print ).
	}
}