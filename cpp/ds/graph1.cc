#include <vector>
#include <queue>
#include <algorithm>
#include <cstdio>

using namespace std;

/* Representation of Directed Graphs: Objects and pointers
 * Analysis:
 *  - Storage:			O(V+E)
 *  - Add vertex:		O(1)
 *  - Add Edge:			O(1)
 *  - Remove vertex:	O(E)
 *  - Remove edge:		O(E)
 *  - Test adjacency:	O(E)
 * Advantage:
 *  - Space efficient
 *  - Find neighbours efficiently
 * Disadvantage:
 *  - Cache inefficient
 *  - Test adjacency inefficiently
 */

struct Edge;

struct Vertex {
	int value;
	bool visited;
	vector<Edge *> edges;
};

struct Edge {
	int weight;
	Vertex *from;
	Vertex *to;
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
Edge *AddEdge(Graph &graph, Vertex *from, Vertex *to) {
	Edge *edge = new Edge;
	edge->from = from;
	edge->to = to;

	from->edges.push_back(edge);
	to->edges.push_back(edge);

	return edge;
}

static void FindEdgeAndEraseByFrom(vector<Edge *> &edges, Vertex *from) {
	auto i = edges.begin();
	for (; i != edges.end(); ++i)
		if ((*i)->from == from)
			break;
	if (i != edges.end())
		edges.erase(i);
}

static void FindEdgeAndEraseByTo(vector<Edge *> &edges, Vertex *to) {
	auto i = edges.begin();
	for (; i != edges.end(); ++i)
		if ((*i)->to == to)
			break;
	if (i != edges.end())
		edges.erase(i);
}

/* O(E) */
void RemoveVertex(Graph &graph, Vertex *vertex) {
	auto &edges = vertex->edges;
	auto i = edges.begin();
	while (i != edges.end()) {
		Vertex *from = (*i)->from;
		Vertex *to = (*i)->to;
		if (from == vertex) {
			FindEdgeAndEraseByFrom(to->edges, vertex);
			delete *i;
			i = edges.erase(i);
		} else if (to == vertex) {
			FindEdgeAndEraseByTo(from->edges, vertex);
			delete *i;
			i = edges.erase(i);
		} else {
			++i;
		}
	}

	auto j = find(graph.vertices.begin(), graph.vertices.end(), vertex);
	graph.vertices.erase(j);
	delete vertex;
}

/* O(E) */
void RemoveEdge(Graph &graph, Edge *edge) {
	Vertex *from = edge->from;
	Vertex *to = edge->to;
	FindEdgeAndEraseByTo(from->edges, to);
	FindEdgeAndEraseByFrom(to->edges, from);
	delete edge;
}

/* O(E) */
bool IsAdjacent(Graph &graph, Vertex *u, Vertex *v) {
	auto &edges = u->edges;
	for (auto i = edges.begin(); i != edges.end(); ++i) {
		Vertex *from = (*i)->from;
		Vertex *to = (*i)->to;
		if (from == u && to == v || from == v && to == u)
			return true;
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
	for (auto i = vertex->edges.begin(); i != vertex->edges.end(); ++i)
		if ((*i)->from == vertex)
			DFSHelper((*i)->to);
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
			for (auto i = v->edges.begin(); i != v->edges.end(); ++i)
				if ((*i)->from == v)
					q.push((*i)->to);
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

	Edge *e15 = AddEdge(graph, v1, v5);
	Edge *e12 = AddEdge(graph, v1, v2);
	Edge *e25 = AddEdge(graph, v2, v5);
	Edge *e23 = AddEdge(graph, v2, v3);
	Edge *e34 = AddEdge(graph, v3, v4);
	Edge *e54 = AddEdge(graph, v5, v4);
	Edge *e46 = AddEdge(graph, v4, v6);

	printf("DFS: ");
	DFS(graph);
	printf("\n");

	printf("BFS: ");
	BFS(graph);
	printf("\n");

	printf("Remove edges: 1->5, 1->2\n");
	RemoveEdge(graph, e12);
	RemoveEdge(graph, e15);

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
