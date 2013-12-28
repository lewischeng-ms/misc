#include <stdio.h>

int main() {
	double brick3 = 652960 + 244860 + 397500; // 三块砖
	double subsidy = 327000; // 补偿
	double bonus = 384060; // 奖励
	double cash = brick3 + subsidy + bonus;
	double avg_cash = cash / 4;

	double sib1 = 510000; // 大妈妈
	double sib2 = 920000; // 二妈妈
	double sibTtl = sib1 + sib2;

	double sib1_sub = subsidy * sib1 / sibTtl;
	double sib2_sub = subsidy * sib2 / sibTtl;

	printf("总价：%f\n", cash);
	printf("每人应分到：%f\n", cash / 4);
	printf("补偿（大妈妈）：%f\n", sib1_sub);
	printf("补偿（二妈妈）：%f\n", sib2_sub);
	printf("大妈妈应付：%f\n", sib1-avg_cash+sib1_sub);
	printf("二妈妈应付：%f\n", sib2-avg_cash+sib2_sub);

	return 0;
}