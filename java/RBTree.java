package ds;

import ds.RBNode.Color;

public class RBTree {
	public RBNode root = nil;
	public static final RBNode nil = new RBNode();

	static {
		nil.color = Color.Black;
	}
	
	public RBNode minimum(RBNode x) {
		if (x == nil)
			return nil;
		while (x.leftChild != nil)
			x = x.leftChild;
		return x;
	}
	
	public RBNode maximum(RBNode x) {
		if (x == nil)
			return nil;
		while (x.rightChild != nil) {
			x = x.rightChild;
		}
		return x;
	}
	
	public RBNode successor(RBNode x) {
		if (x == nil)
			return nil;
		if (x.rightChild != nil)
			return minimum(x.rightChild);
		// x has no right child, so look up above.
		RBNode y = x.parent;
		while (y != nil && x == y.rightChild) {
			x = y;
			y = y.parent;
		}
		return y;
	}
	
	public RBNode predecessor(RBNode x) {
		if (x == nil)
			return nil;
		if (x.leftChild != nil)
			return maximum(x.leftChild);
		// x has no left child, so look up above.
		RBNode y = x.parent;
		while (y != nil && x == y.leftChild) {
			x = y;
			y = y.parent;
		}
		return y;
	}
	
	public RBNode find(int data) {
		RBNode x = root;
		while (x != nil) {
			if (data == x.data)
				return x;
			else if (data < x.data)
				x = x.leftChild;
			else
				x = x.rightChild;
		}
		return nil;
	}
	
	public void insert(int data) throws RBTreeRotationException, RBTreeInvalidNodeException {
		RBNode z = new RBNode();
		z.data = data;
		insert(z);
	}
	
	public void insert(RBNode z) throws RBTreeRotationException, RBTreeInvalidNodeException {
		if (z == nil)
			throw new RBTreeInvalidNodeException("Try to insert a NIL node.");
		RBNode y = nil; // y is the parent node of x.
		RBNode x = root; // x is the iterative node.
		// Find the place to insert, must be at leaf node.
		while (x != nil) {
			y = x;
			if (z.data == x.data)
				return;
			else if (z.data < x.data)
				x = x.leftChild;
			else
				x = x.rightChild;
		}
		// Link z to y.
		z.parent = y;
		if (y == nil)
			root = z;
		else if (z.data < y.data)
			y.leftChild = z;
		else
			y.rightChild = z;
		z.leftChild = nil;
		z.rightChild = nil;
		z.color = Color.Red;
		// If the colors of y and z are both red, unbalanced situation occurs.
		insertFixup(z);
	}
	
	private void insertFixup(RBNode z) throws RBTreeRotationException {
		RBNode y; // y is z's uncle.
		while (z.parent.color == Color.Red) {
			if (z.parent == z.parent.parent.leftChild) {
				y = z.parent.parent.rightChild;
				if (y.color == Color.Red) { // Case 1
					z.parent.color = Color.Black;
					y.color = Color.Black;
					z.parent.parent.color = Color.Red;
					z = z.parent.parent;
				} else {
					if (z == z.parent.rightChild) { // Case 2
						z = z.parent;
						leftRotate(z);
					}
					// Case 3
					z.parent.color = Color.Black;
					z.parent.parent.color = Color.Red;
					rightRotate(z.parent.parent);
				}
			} else {
				y = z.parent.parent.leftChild;
				if (y.color == Color.Red) { // Case 1
					z.parent.color = Color.Black;
					y.color = Color.Black;
					z.parent.parent.color = Color.Red;
					z = z.parent.parent;
				} else {
					if (z == z.parent.leftChild) { // Case 2
						z = z.parent;
						rightRotate(z);
					}
					// Case 3
					z.parent.color = Color.Black;
					z.parent.parent.color = Color.Red;
					leftRotate(z.parent.parent);
				}
			}
		}
		root.color = Color.Black;
	}
	
	public RBNode remove(int data) throws RBTreeRotationException, RBTreeInvalidNodeException {
		RBNode z = find(data);
		return remove(z);
	}
	
	public RBNode remove(RBNode z) throws RBTreeRotationException, RBTreeInvalidNodeException {
		if (z == nil)
			throw new RBTreeInvalidNodeException("Try to remove a NIL node.");
		RBNode y; // y is the node to replace z.
		if (z.leftChild == nil || z.rightChild == nil)
			y = z; // z has NIL child, so no need to replace z.
		else
			y = successor(z); // Use the successor of z to replace z.
		RBNode x; // x is the non-NIL child of y.
		if (y.leftChild != nil)
			x = y.leftChild;
		else
			x = y.rightChild;
		// Because y is moved to replace z, so connect x to the parent node of y.
		x.parent = y.parent;
		if (y.parent == nil)
			root = x;
		else if (y == y.parent.leftChild)
			y.parent.leftChild = x;
		else
			y.parent.rightChild = x;
		// Replace z with y(just replace the data).
		if (y != z)
			z.data = y.data;
		// That the color of y is black may lead to unbalanced situation.
		if (y.color == Color.Black)
			removeFixup(x); // Fix up from the parent of x.
		return y;
	}
	
	private void removeFixup(RBNode x) throws RBTreeRotationException {
		RBNode w; // w is x's sibling.
		while (x != root && x.color == Color.Black) {
			if (x == x.parent.leftChild) {
				w = x.parent.rightChild;
				if (w.color == Color.Red) { // Case 1
					w.color = Color.Black;
					x.parent.color = Color.Red;
					leftRotate(x.parent);
					w = x.parent.rightChild;
				}
				if (w.leftChild.color == Color.Black && w.rightChild.color == Color.Black) { // Case 2
					w.color = Color.Red;
					x = x.parent;
				} else {
					if (w.rightChild.color == Color.Black) { // Case 3
						w.leftChild.color = Color.Black;
						w.color = Color.Red;
						rightRotate(w);
						w = x.parent.rightChild;
					}
					// Case 4
					w.color = x.parent.color;
					x.parent.color = Color.Black;
					w.rightChild.color = Color.Black;
					leftRotate(x.parent);
					x = root;
				}
			} else {
				w = x.parent.leftChild;
				if (w.color == Color.Red) { // Case 1
					w.color = Color.Black;
					x.parent.color = Color.Red;
					rightRotate(x.parent);
					w = x.parent.leftChild;
				}
				if (w.rightChild.color == Color.Black && w.leftChild.color == Color.Black) { // Case 2
					w.color = Color.Red;
					x = x.parent;
				} else {
					if (w.leftChild.color == Color.Black) { // Case 3
						w.rightChild.color = Color.Black;
						w.color = Color.Red;
						leftRotate(w);
						w = x.parent.leftChild;
					}
					// Case 4
					w.color = x.parent.color;
					x.parent.color = Color.Black;
					w.leftChild.color = Color.Black;
					rightRotate(x.parent);
					x = root;
				}
			}
		}
		x.color = Color.Black;
	}
	
	public void printSequence() {
		printSequenceAux(root);
	}
	
	private static void printSequenceAux(RBNode node) {
		if (node == nil)
			return;
		printSequenceAux(node.leftChild);
		System.out.println(node.data);
		printSequenceAux(node.rightChild);
	}
	
	public void printTree() {
		printTreeAux(root, 0);
	}
	
	private static void printTreeAux(RBNode node, int indent) {
		for (int i = 0; i < indent; ++i)
			System.out.print("\t");
		if (node == nil) {
			System.out.println("(NIL, Black)");
			return;
		}
		System.out.println("(" + node.data + ", " + node.color.toString() + ")");
		++indent;
		printTreeAux(node.leftChild, indent);
		printTreeAux(node.rightChild, indent);
	}
	
	private void leftRotate(RBNode x) throws RBTreeRotationException {
		RBNode y = x.rightChild;
		if (y == nil)
			throw new RBTreeRotationException("The node has no right child.", x);
		x.rightChild = y.leftChild;
		y.leftChild.parent = x;
		y.parent = x.parent;
		if (x.parent == nil)
			root = y;
		else if (x == x.parent.leftChild)
			x.parent.leftChild = y;
		else
			x.parent.rightChild = y;
		y.leftChild = x;
		x.parent = y;
	}
	
	private void rightRotate(RBNode y) throws RBTreeRotationException {
		RBNode x = y.leftChild;
		if (x == nil)
			throw new RBTreeRotationException("The node has no left child.", y);
		y.leftChild = x.rightChild;
		x.rightChild.parent = y;
		x.parent = y.parent;
		if (y.parent == nil)
			root = x;
		else if (y == y.parent.rightChild)
			y.parent.rightChild = x;
		else
			y.parent.leftChild = x;
		x.rightChild = y;
		y.parent = x;
	}
}
