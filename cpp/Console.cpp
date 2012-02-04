// Console.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"
#include <Windows.h>
#include <dwmapi.h>

void DrawString(int x, int y, LPCWSTR str)
{
	COORD pos = { x, y };
	SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), pos);
	fputws(str, stdout);
}

int _tmain(int argc, _TCHAR* argv[])
{
	LPCWSTR title = L"Hello Console Window!";
	// 设置标题
	SetConsoleTitle(title);

	// 设置行列数
	system("mode con cols=80 lines=40");

	// 查找本窗口句柄并设置窗口样式
	HWND hwnd = FindWindow(L"ConsoleWindowClass", title);
	SetWindowLong(hwnd, GWL_STYLE, WS_CAPTION | WS_VISIBLE | WS_SYSMENU);
		
	// 开启玻璃效果
	MARGINS m = { -1 };
	DwmExtendFrameIntoClientArea(hwnd, &m);

	RECT rect;
	GetWindowRect(hwnd, &rect);
	// 置于屏幕中央且置顶
	rect.left = (GetSystemMetrics(SM_CXSCREEN) - rect.right + rect.left) / 2;
	rect.top = (GetSystemMetrics(SM_CYSCREEN) - rect.bottom + rect.top) / 2;
	SetWindowPos(hwnd, HWND_TOPMOST, rect.left, rect.top, rect.right, rect.bottom, SWP_SHOWWINDOW);

	DrawString(5, 5, L"Hahahaaha");
	return 0;
}

