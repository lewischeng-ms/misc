#include <stdio.h>
#include <stdbool.h>

void judge(char board[3][3]) {
	int r[3][2] = { 0 }; // 每一行上O或X的个数
	int c[3][2] = { 0 }; // 每一列上O或X的个数
	int d[2][2] = { 0 }; // 对角线上O或X的个数

	int i, j, n = 0;
	for (i = 0; i < 3; ++i) {
		for (j = 0; j < 3; ++j) {
			if (board[i][j] == '_') continue;
			n++;
			int t = board[i][j] == 'O';
			r[i][t]++;
			c[j][t]++;
			if (i == j) d[0][t]++;
			if (i + j == 3 - 1) d[1][t]++;
			if (r[i][t] >= 3 || c[j][t] >= 3 ||
				d[0][t] >= 3 || d[1][t] >= 3) {
				printf("Winner: %c\n", board[i][j]);
				return;
			}
		}
	}
	if (n == 3 * 3)
		printf("Draw\n");
	else
		printf("Not done yet\n");
}

int main() {
	char board[3][3] = {
		"XOO",
		"XXO",
		"OXO"
	};
	judge(board);
	return 0;
}