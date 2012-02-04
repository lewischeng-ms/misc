#include <windows.h>
#include <stdio.h>
#include <stdlib.h>

// IsInsideVPC's exception filter
DWORD __forceinline IsInsideVPC_exceptionFilter(LPEXCEPTION_POINTERS ep)
{
	PCONTEXT ctx = ep->ContextRecord;
	
	ctx->Ebx = -1; // Not running VPC
	ctx->Eip += 4; // skip past the "call VPC" opcodes

	// we can safely resume execution since we skipped faulty instruction
	return EXCEPTION_CONTINUE_EXECUTION;
}

// high level language friendly version of IsInsideVPC()
bool IsInsideVPC()
{
	bool rc = true;
	
	__try
	{
		__asm
		{
			push ebx
			mov ebx, 0	// Flag
			mov eax, 1	// VPC function number

			// Call VPC
			__emit 0Fh
			__emit 3Fh
			__emit 07h
			__emit 0Bh

			test ebx, ebx
			setz [rc]
			pop ebx
		}
	}
	// The except block shouldn't get triggered if VPC is running!!
	__except(IsInsideVPC_exceptionFilter(GetExceptionInformation()))
	{
		rc = false;
	}
	
	return rc;
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

int main(int argc, char* argv[])
{
	printf("Inside Virtual PC? %d.\n", IsInsideVPC());
	printf("Inside VMWare? %d.\n", IsInsideVMWare());

	system("PAUSE");
	return 0;
}