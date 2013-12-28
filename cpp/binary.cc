#include <vector>
#include <iostream>
#include <string>
#include <algorithm>
#include <cstdlib>
using namespace std;

void error(string msg) {
	cout << msg << endl;
	exit(1);
}

bool findX(vector<int> &src, int l, int h, int x) {
	vector<int>::iterator end = src.begin() + h + 1;
	return find(src.begin() + l, end, x) != end;
}

void helper(vector<int> &preorder, vector<int> &inorder, int lp, int hp, int li, int hi) {
	if (lp > hp || li > hi) return;

	// 先序的第一个元素是根
	int rootVal = preorder[lp];

	// 根在中序中的位置ri, 所以：
	// 左子树在inorder中的位置[li, ri - 1]
	// 右子树在inorder中的位置[ri + 1, hi]
	int ri;
	for (ri = li; ri <= hi; ++ri)
		if (inorder[ri] == rootVal)
			break;
	if (ri > hi) error("Root not found in inorder"); // Error!

	// 在先序中找到左子树的左边界llp
	int llp = lp + 1;
	// 在先序中找到左子树的右边界lrp
	int lrp = hp;
	while (llp <= lrp) {
		if (findX(inorder, li, ri - 1, preorder[lrp]))
			break;
		--lrp;
	}
	if (llp <= lrp)
		helper(preorder, inorder, llp, lrp, li, ri - 1);

	// 在先序中找到右子树的右边界rrp
	int rrp = hp;
	// 在先序中找到右子树的左边界rlp
	int rlp = lrp + 1;
	if (rlp <= rrp)
		helper(preorder, inorder, rlp, rrp, ri + 1, hi);

	cout << rootVal << " ";
}

void printPostorder(vector<int> &preorder, vector<int> &inorder) {
    if (preorder.size() < 1 || inorder.size() < 1)
    	return;
    helper(preorder, inorder, 0, preorder.size() - 1, 0, inorder.size() - 1);
    cout << endl;
}

int main() {
	int pre[] = { 7, 10, 4, 3, 1, 2, 8, 11 };
	int in[] = { 4, 10, 3, 1, 7, 11, 8, 2 };
	vector<int> preorder(pre, pre + 8);
	vector<int> inorder(in, in + 8);
	printPostorder(preorder, inorder);
	return 0;
}