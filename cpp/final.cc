typedef vector<vector<int> > Mat;

vector<vector<bool> > visited;

void dfs(const Mat& org, int i, int j, Mat &conn) {
	int m = org.size();
	int n = org[0].size();
	if (i >= m || j >= n)
		return;
	if (org[i][j] == 0 || visited[i][j])
		return;
	conn[i][j] = org[i][j];
	visited[i][j] = true;
	dfs(org, i + 1, j, conn); // 访问右边
	dfs(org.i, j + 1, conn); // 访问下边
	// 因为是由上至下、由左至右遍历的，所以左边和上边不用考虑。
}

void final(const Mat& org, vector<Mat>& res) {
	int m = org.size();
	if (m < 1) return;
	int n = org[0].size();
	if (n < 1) return;
	visited.clear();
	visited.resize(m, vector<bool>(n));
	for (int i = 0; i < m; ++i) {
		for (int j = 0; j < n; ++j) {
			if (org[i][j] == 0 || visited[i][j])
				continue;
			Mat conn(m, vector<int>(n));
			dfs(org, i, j, conn);
			res.push_back(conn);
		}
	}
}
