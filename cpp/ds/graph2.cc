#include <vector>
#include <queue>
#include <algorithm>
#include <cstdio>

using namespace std;

/* Representation of Directed Graphs: Adjacency List
 * Analysis:
 *  - Storage:			O(V+E)
 *  - Add vertex:		O(1)
 *	- Add Edge:			O(1)
 *  - Remove vertex:	O(E)
 *  - Remove edge:		O(E)
 *  - Test adjacency:	O(V)
 * Advantage:
 *  - Space efficient
 *  - Find neighbours efficiently
 * Disadvantage:
 *  - Cache inefficient
 *  - Test adjacency inefficiently
 */

struct Vertex {
	int value;
	bool visited;
	vector<Vertex *> neighbours; // starts from this vertex
};

struct Graph {
	vector<Vertex *> vertices;
};

/* O(1) */
Vertex *AddVertex(Graph &graph, int value) {
	Vertex *vertex = new Vertex;
	vertex->value = value;
	vertex->visited = false;
	graph.vertices.push_back(vertex);
	return vertex;
}

/* O(1) */
void AddEdge(Graph &graph, Vertex *from, Vertex *to) {
	from->neighbours.push_back(to);
}

/* O(E) */
void RemoveVertex(Graph &graph, Vertex *vertex) {
	auto i = graph.vertices.begin(); 
	while (i != graph.vertices.end()) {
		if (*i == vertex) {
			i = graph.vertices.erase(i);
		} else {
			auto &neighbours = (*i)->neighbours;
			auto j = neighbours.begin();
			while (j != neighbours.end()) {
				if (*j == vertex) {
					neighbours.erase(j);
					break;
				}
				++j;
			}
			++i;
		}
	}

	delete vertex;
}

/* O(E) */
void RemoveEdge(Graph &graph, Vertex *from, Vertex *to) {
	auto i = from->neighbours.begin();
	while (i != from->neighbours.end()) {
		if (*i == to) {
			from->neighbours.erase(i);
			return;
		}
		++i;
	}
}

/* O(V) */
bool IsAdjacent(Graph &graph, Vertex *u, Vertex *v) {
	auto i = u->neighbours.begin();
	while (i != u->neighbours.end()) {
		if (*i == v)
			return true;
		++i;
	}
	i = v->neighbours.begin();
	while (i != v->neighbours.end()) {
		if (*i == u)
			return true;
		++i;
	}
	return false;
}

void ClearVisitStatus(Graph &graph) {
	for (auto i = graph.vertices.begin(); i != graph.vertices.end(); ++i)
		(*i)->visited = false;
}

static void DFSHelper(Vertex *vertex) {
	if (vertex->visited)
		return;
	printf("%d ", vertex->value);
	vertex->visited = true;
	for (auto i = vertex->neighbours.begin(); i != vertex->neighbours.end(); ++i)
		DFSHelper(*i);
}

void DFS(Graph &graph) {
	ClearVisitStatus(graph);
	for (auto i = graph.vertices.begin(); i != graph.vertices.end(); ++i)
		DFSHelper(*i);
}

static void BFSHelper(Vertex *vertex) {
	if (vertex->visited)
		return;

	queue<Vertex *> q;
	q.push(vertex);
	while (!q.empty()) {
		Vertex *v = q.front();
		q.pop();
		if (!v->visited) {
			v->visited = true;
			printf("%d ", v->value);
			for (auto i = v->neighbours.begin(); i != v->neighbours.end(); ++i)
				q.push(*i);
		}
	}
}

void BFS(Graph &graph) {
	ClearVisitStatus(graph);
	for (auto i = graph.vertices.begin(); i != graph.vertices.end(); ++i)
		BFSHelper(*i);
}

int main() {
	Graph graph;
	Vertex *v1 = AddVertex(graph, 1);
	Vertex *v2 = AddVertex(graph, 2);
	Vertex *v3 = AddVertex(graph, 3);
	Vertex *v4 = AddVertex(graph, 4);
	Vertex *v5 = AddVertex(graph, 5);
	Vertex *v6 = AddVertex(graph, 6);

	AddEdge(graph, v1, v5);
	AddEdge(graph, v1, v2);
	AddEdge(graph, v2, v5);
	AddEdge(graph, v2, v3);
	AddEdge(graph, v3, v4);
	AddEdge(graph, v5, v4);
	AddEdge(graph, v4, v6);

	printf("DFS: ");
	DFS(graph);
	printf("\n");

	printf("BFS: ");
	BFS(graph);
	printf("\n");

	printf("Remove edges: 1->5, 1->2\n");
	RemoveEdge(graph, v1, v2);
	RemoveEdge(graph, v1, v5);

	printf("DFS: ");
	DFS(graph);
	printf("\n");

	printf("Remove vertex: 2, 5\n");
	RemoveVertex(graph, v2);
	RemoveVertex(graph, v5);

	printf("BFS: ");
	BFS(graph);
	printf("\n");

	printf("Is vertices 4 and 3 adjacent? %d\n", IsAdjacent(graph, v4, v3));
	printf("Is vertices 3 and 6 adjacent? %d\n", IsAdjacent(graph, v3, v6));

	return 0;
}
