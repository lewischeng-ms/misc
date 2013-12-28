#include <iostream>
#include <vector>
#include <algorithm>
#include <climits>

using namespace std;

struct UndirectedGraphNode {
	bool visited;
	int label;
	UndirectedGraphNode *previous;
	int distance;
	int index;
	vector<UndirectedGraphNode *> neighbors;
	vector<int> weights;

	UndirectedGraphNode(int label) {
		this->visited = false;
		this->label = label;
		this->previous = NULL;
		this->distance = 0;
		this->index = 0;
	}
};

/* class UndirectedGraphNodeHeap {
public:
	void Add(UndirectedGraphNode *node) {
		auto i = Q_.begin();
		while (i != Q_.end()) {
			if ((*i)->distance >= node->distance)
				break;
			++i;
		}
		Q_.insert(i, node);
	}

	bool Empty() {
		return Q_.empty();
	}

	UndirectedGraphNode *RemoveMin() {
		UndirectedGraphNode *min = Q_[0];
		Q_.erase(Q_.begin());
		return min;
	}

	void Reorder(UndirectedGraphNode *node) {
		auto i = Q_.begin();
		while (*i != node)
			++i;
		if (i == Q_.begin())
			return;
		UndirectedGraphNode *u = *i;
		while (i > Q_.begin() && (*(i - 1))->distance > u->distance) {
			*i = *(i - 1);
			--i;
		}
		*i = u;
	}
private:
	vector<UndirectedGraphNode *> Q_;
}; */

class UndirectedGraphNodeHeap {
public:
	void Add(UndirectedGraphNode *node) {
		int index = Q_.size();
		node->index = index;
		Q_.push_back(node);
		SiftUp(node->index);
	}

	bool Empty() {
		return Q_.empty();
	}

	UndirectedGraphNode *RemoveMin() {
		int n = Q_.size();
		UndirectedGraphNode *u = Q_[0];
		Q_[0]->index = 0;
		
		Q_[0] = Q_[n - 1];
		Q_.resize(n - 1);

		SiftDown(0);
		return u;
	}

	void Reorder(UndirectedGraphNode *node) {
		SiftUp(node->index);
	}
private:
	int Left(int begin) {
		return begin * 2 + 1;
	}

	int Right(int begin) {
		return begin * 2 + 2;
	}

	bool HashLeft(int begin) {
		int n = Q_.size();
		return Left(begin) < n;
	}

	bool HasRight(int begin) {
		int n = Q_.size();
		return Right(begin) < n;
	}

	void SiftDown(int begin) {
		int i = begin;
		while (HashLeft(i)) {
			int swap = i;

			if (Q_[i]->distance > Q_[Left(i)]->distance)
				swap = Left(i);

			if (HasRight(i) && Q_[swap]->distance > Q_[Right(i)]->distance)
				swap = Right(i);

			if (swap == i)
				return;

			std::swap(Q_[i], Q_[swap]);
			Q_[i]->index = i;
			Q_[swap]->index = swap;

			i = swap;
		}
	}

	int Parent(int begin) {
		return (begin - 1) / 2;
	}

	bool HasParent(int begin) {
		return Parent(begin) >= 0;
	}

	void SiftUp(int begin) {
		int i = begin;
		while (HasParent(i)) {
			int swap = i;

			if (Q_[i]->distance < Q_[Parent(i)]->distance)
				swap = Parent(i);

			if (swap == i)
				return;

			std::swap(Q_[i], Q_[swap]);
			Q_[i]->index = i;
			Q_[swap]->index = swap;

			i = swap;
		}
	}

	vector<UndirectedGraphNode *> Q_;
};

class UndirectedGraph {
public:
	UndirectedGraph() {

	}

	~UndirectedGraph() {
		for (auto i = nodes_.begin(); i != nodes_.end(); ++i)
			delete *i;
	}

	UndirectedGraphNode *AddNode(int label) {
		UndirectedGraphNode *node = new UndirectedGraphNode(label);
		nodes_.push_back(node);
		return node;
	}

	void AddEdge(UndirectedGraphNode* u, UndirectedGraphNode* v, int weight) {
		u->neighbors.push_back(v);
		u->weights.push_back(weight);
		v->neighbors.push_back(u);
		v->weights.push_back(weight);
	}

	void DFS() {
		if (nodes_.empty())
			return;
		for (auto i = nodes_.begin(); i != nodes_.end(); ++i)
			(*i)->visited = false;
		DFSHelper(nodes_[0]);
	}

	void ShortestPath(UndirectedGraphNode *start) {
		int n = nodes_.size();

		for (auto i = nodes_.begin(); i != nodes_.end(); ++i) {
			(*i)->distance = INT_MAX;
			(*i)->previous = NULL;
		}

		for (int i = 0; i < start->neighbors.size(); ++i) {
			start->neighbors[i]->distance = start->weights[i];
			start->neighbors[i]->previous = start;
		}

		start->distance = 0;

		UndirectedGraphNodeHeap Q;
		for (auto i = nodes_.begin(); i != nodes_.end(); ++i)
			if (*i != start)
				Q.Add(*i);

		while (!Q.Empty()) {
			auto u = Q.RemoveMin();
			if (u->distance == INT_MAX)
				return; // Cannot reach any node any more!

			for (int i = 0; i < u->neighbors.size(); ++i) {
				auto v = u->neighbors[i];
				if (u->distance + /* u->v */u->weights[i] < v->distance) {
					v->distance = u->distance + u->weights[i];
					v->previous = u;
					Q.Reorder(v);
				}
			}
		}
	}

	vector<UndirectedGraphNode *> BuildPath(UndirectedGraphNode *pnode) {
		vector<UndirectedGraphNode *> path;
		while (pnode != NULL) {
			path.push_back(pnode);
			pnode = pnode->previous;
		}
		reverse(path.begin(), path.end());
		return path;
	}
private:
	void DFSHelper(UndirectedGraphNode *start) {
		if (start->visited)
			return;
		start->visited = true;
		for (int i = 0; i < start->neighbors.size(); ++i) {
			cout << start->label << " => "
				 << start->neighbors[i]->label << " ["
				 << start->weights[i] << "]\n";
			DFSHelper(start->neighbors[i]);
		}
	}
	vector<UndirectedGraphNode *> nodes_;
};

int main() {
	// UndirectedGraph g from:
	// http://en.wikipedia.org/wiki/File:Dijkstra_Animation.gif
	UndirectedGraph g;
	
	auto v1 = g.AddNode(1);
	auto v2 = g.AddNode(2);
	auto v3 = g.AddNode(3);
	auto v4 = g.AddNode(4);
	auto v5 = g.AddNode(5);
	auto v6 = g.AddNode(6);

	g.AddEdge(v1, v2, 7);
	g.AddEdge(v1, v6, 14);
	g.AddEdge(v1, v3, 9);
	g.AddEdge(v2, v4, 15);
	g.AddEdge(v3, v4, 11);
	g.AddEdge(v3, v6, 2);
	g.AddEdge(v4, v5, 6);
	g.AddEdge(v5, v6, 9);

	cout << "DFS:\n";
	g.DFS();

	g.ShortestPath(v1);
	auto path = g.BuildPath(v5);
	if (path.size() > 0) {
		cout << "Path: ";
		for (int i = 0; i < path.size(); ++i) {
			if (i < path.size() - 1)
				cout << path[i]->label << " => ";
			else
				cout << path[i]->label << endl;
		}
	}

	return 0;
}
