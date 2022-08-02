/*
 * File: trans2dos.cpp
 *
 * Abstract:
 *   Translate input win32 long file path name into traditional DOS 8.3 
 *   format filename.
 *
 * $Revision: 1.1.4.1 $
 * $Date: 2004/05/01 14:36:42 $
 *
 * Copyright 2002 The MathWorks, Inc.
 */

#include <iostream>
using namespace std;
#include <windows.h>


void usage(void)
{
    cout << " Usage: trans2dos long_path_name" << endl;
}

int main(int argc, char *argv[])
{
    DWORD result = 0;
    const bufferSize = 1000;
    char ShortPathBuffer[bufferSize];
    LPVOID lpMsgBuf;
	
	if (argc != 2)
    {
	usage();
	return 1;
    }
	
	result = GetShortPathName(argv[1], ShortPathBuffer, bufferSize);
	if (result > 0)
	{
		cout << ShortPathBuffer;
		return 0;
	} else {
                /* Error handling*/
                FormatMessage( 
                    FORMAT_MESSAGE_ALLOCATE_BUFFER | 
                    FORMAT_MESSAGE_FROM_SYSTEM | 
                    FORMAT_MESSAGE_IGNORE_INSERTS,
                    NULL,
                    GetLastError(),
                    MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
                    (LPTSTR) &lpMsgBuf,
                    0,
                    NULL 
                );
                /* Display the error string. */
                cout << argv[0] << ": error in call to Kernel32.lib(GetShortPathName())\n" << (LPCTSTR)lpMsgBuf;
                /* Free the buffer. */
                LocalFree( lpMsgBuf );

		return 1;
	}
}
