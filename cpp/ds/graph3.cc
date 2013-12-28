#include <vector>
#include <queue>
#include <algorithm>
#include <cstdio>

using namespace std;

/* Representation of Directed Graphs: Adjacency Matrix
 * Analysis:
 *  - Storage:			O(V^2)
 *  - Add vertex:		O(V^2)
 *	- Add Edge:			O(1)
 *  - Remove vertex:	O(V^2)
 *  - Remove edge:		O(1)
 *  - Test adjacency:	O(1)
 * Advantage:
 *  - Cache efficient
 *  - Test adjacency efficiently
 * Disadvantage:
 *  - Space inefficient
 *  - Find neighbours inefficiently
 */

struct Graph {
	int *vec_values;
	int **matrix;
	int num_vertices;

	Graph() : vec_values(NULL), matrix(NULL), num_vertices(0) {}
};

/* O(V^2) */
int AddVertex(Graph &graph, int value) {
	int index = graph.num_vertices;

	int *new_vec_values = new int[graph.num_vertices + 1];
	for (int i = 0; i < graph.num_vertices; ++i)
		new_vec_values[i] = graph.vec_values[i];
	new_vec_values[index] = value;
	delete[] graph.vec_values;
	graph.vec_values = new_vec_values;

	int **new_matrix = new int*[graph.num_vertices + 1];
	for (int i = 0; i < graph.num_vertices + 1; ++i) {
		new_matrix[i] = new int[graph.num_vertices + 1];
		for (int j = 0; j < graph.num_vertices + 1; ++j) {
			if (i == graph.num_vertices || j == graph.num_vertices) {
				new_matrix[i][j] = 0;
			} else {
				new_matrix[i][j] = graph.matrix[i][j];
			}
		}
		if (i < graph.num_vertices)
			delete[] graph.matrix[i];
	}
	delete[] graph.matrix;
	graph.matrix = new_matrix;

	graph.num_vertices++;

	return index;
}

/* O(1) */
void AddEdge(Graph &graph, int from, int to) {
	graph.matrix[from][to] = 1;
}

/* O(V^2) */
void RemoveVertex(Graph &graph, int vertex) {
	for (int i = vertex + 1; i < graph.num_vertices; ++i)
		graph.vec_values[i - 1] = graph.vec_values[i];

	// The right block moves left
	for (int i = 0; i < vertex - 1; ++i)
		for (int j = vertex + 1; j < graph.num_vertices; ++j)
			graph.matrix[i][j - 1] = graph.matrix[i][j];
	
	// The bottom block moves up
	for (int i = vertex + 1; i < graph.num_vertices; ++i)
		for (int j = 0; j < vertex - 1; ++j)
			graph.matrix[i - 1][j] = graph.matrix[i][j];

	// The bottom right block moves up along diagnol
	for (int i = vertex + 1; i < graph.num_vertices; ++i)
		for (int j = vertex + 1; j < graph.num_vertices; ++j)
			graph.matrix[i - 1][j - 1] = graph.matrix[i][j];

	--graph.num_vertices;
}

/* O(1) */
void RemoveEdge(Graph &graph, int from, int to) {
	graph.matrix[from][to] = 0;
}

/* O(1) */
bool IsAdjacent(Graph &graph, int u, int v) {
	return graph.matrix[u][v] || graph.matrix[v][u];
}

/* O(V) */
int GetVertexFromValue(Graph &graph, int value) {
	for (int i = 0; i < graph.num_vertices; ++i)
		if (graph.vec_values[i] == value)
			return i;
	return -1;
}

static void DFSHelper(Graph &graph, int vertex, vector<bool> &visited) {
	if (visited[vertex])
		return;
	printf("%d ", graph.vec_values[vertex]);
	visited[vertex] = true;
	for (int i = 0; i < graph.num_vertices; ++i)
		if (graph.matrix[vertex][i])
			DFSHelper(graph, i, visited);
}

void DFS(Graph &graph) {
	vector<bool> visited(graph.num_vertices);
	for (int i = 0; i < graph.num_vertices; ++i)
		DFSHelper(graph, i, visited);
}

static void BFSHelper(Graph &graph, int vertex, vector<bool> &visited) {
	if (visited[vertex])
		return;

	queue<int> q;
	q.push(vertex);
	while (!q.empty()) {
		int v = q.front();
		q.pop();
		if (!visited[v]) {
			visited[v] = true;
			printf("%d ", graph.vec_values[v]);
			for (int i = 0; i < graph.num_vertices; ++i)
				if (graph.matrix[v][i])
					q.push(i);
		}
	}
}

void BFS(Graph &graph) {
	vector<bool> visited(graph.num_vertices);
	for (int i = 0; i < graph.num_vertices; ++i)
		BFSHelper(graph, i, visited);
}

int main() {
	Graph graph;
	int v1 = AddVertex(graph, 1);
	int v2 = AddVertex(graph, 2);
	int v3 = AddVertex(graph, 3);
	int v4 = AddVertex(graph, 4);
	int v5 = AddVertex(graph, 5);
	int v6 = AddVertex(graph, 6);

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
	v5 = GetVertexFromValue(graph, 5);
	RemoveVertex(graph, v5);

	printf("BFS: ");
	BFS(graph);
	printf("\n");

	v3 = GetVertexFromValue(graph, 3);
	v4 = GetVertexFromValue(graph, 4);
	v6 = GetVertexFromValue(graph, 6);
	printf("Is vertices 4 and 3 adjacent? %d\n", IsAdjacent(graph, v4, v3));
	printf("Is vertices 3 and 6 adjacent? %d\n", IsAdjacent(graph, v3, v6));

	return 0;
}
