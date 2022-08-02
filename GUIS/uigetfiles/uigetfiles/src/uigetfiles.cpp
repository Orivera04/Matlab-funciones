//
//	MEX based Multiple File Get File
//
//	Calls the Windows Common Dialog resource to select multiple files.
//  Intended to emulate the uigetfile matlab function
//
//	18 Aug 1998		1.00	Original version
//  
//
//	Usage :  [ filenames, pathname ] = uigetfiles( 'filterSpec', 'dialogTitle', 'startPath' )
//
//  Inputs:
//
//      'filterSpec'    The initial default extension (type of file). For example '*.m' will
//                      display all MATLAB M-files.
//
//      'dialogTitle'   A string containing the title for the dialog box.
//
//      'startPath'     A string containing the path location from which to start browsing.
//                      If not specified, default start path is the current working directory.
//
//  Outputs:
//
//      filenames       A cell array of strings of the selected file names without the path.
//                      If the user selects the cancel button or an error occurs, this parameter
//                      is set to an empty cell matrix.
//
//      pathname        A string containing the path of all selected files. Due to limitations
//                      of the WIN32 API, all selected files must reside in a single directory.
//                      If the user selects the cancel button or an error occurs, this parameter
//                      is set to zero.
//
//      The optional input arguments X and Y are not supported.
//
// Version 1.0 initial release
// Copyright 2001 (All rights reserved) David J. Warren,
// Dept of Bioengineering, University of Utah, 
// 2480 Merrill Engineering Bldg, Salt Lake City, UT, 84112
// John Moran Laboratories, Center for Neural Interfaces, 801-581-3817
//
// Version 1.1 bug fix by Greg Aloe
// The MathWorks, Inc
// 3 Apple Hill Drive, Natick, MA, 01760
// aloe@mathworks.com
//
// Previously, MATLAB would report the same PWD before and after calling UIGETFILES; 
// however, dir listings (LS, DIR) would incorrectly report files in the last dir 
// accessed by UIGETFILES' GUI. Now, UIGETFILES returns to the original dir correctly.
// Transferred source maintenance to Greg Aloe.
//
// Version 2.0 modifications by Greg Aloe and John R. Haines
// John R. Haines
// Technology Service Corporation
// 5825 Delmonico Drive, Suite 350, Colorado Springs, CO 80919
// 719-884-0224 ext. 352
// Added specification of a STARTPATH.  Default STARTPATH is now the MATLAB PWD.
// Revised help file.
//
// Version 2.1 enhancement by Greg Aloe
// STARTPATH now accepts path names the same way MATLAB does.  That is, you can pass
// path separators as either "/" or "\", or any combination thereof (e.g., "//\/\\\/").


#include <windows.h>
#include <commctrl.h>
#include <math.h>
#include <string.h>
#include "mex.h"
#include <direct.h>

/* Input Arguments */
#define	FILTER  		InputArray[0]
#define	TITLE   		InputArray[1]
#define STARTPATH		InputArray[2]
#define NINPUT          3

/* Output Arguments */
#define	FILENAMES		OutputArray[0]
#define	PATHNAME		OutputArray[1]
#define NOUTPUT         2

void mexFunction(int NOutput,       mxArray *OutputArray[],
                 int NInput,  const mxArray *InputArray[] )
{
    char status[ 512 ];
    int i, j;
	
	//
    // Check for proper number of output arguments 
	//
	if( NOutput != NOUTPUT )
    {
        if( NOutput >= 1 )
        {
    	    FILENAMES = mxCreateCellMatrix( 0, 0 );
            if( NOutput >= 2 )
            {
                PATHNAME = mxCreateDoubleMatrix( 1, 1, mxREAL );
                double * pr = (double *) mxGetPr( PATHNAME );
                *pr = 0.0;
            }
        }
        sprintf( status, "UIGetFiles requires %d output arguments.", NOUTPUT );
		mexWarnMsgTxt( status );
        return;
    }

	//
    // Check for proper number of input arguments
	//
    if( (NInput > NINPUT) || (NInput < 2) )
    {
        FILENAMES = mxCreateCellMatrix( 0, 0 );
        PATHNAME = mxCreateDoubleMatrix( 1, 1, mxREAL );
        double * pr = (double *) mxGetPr( PATHNAME );
        *pr = 0.0;
		sprintf( status, "UIGetFiles requires 2 or 3 input arguments." );
        mexWarnMsgTxt( status );
        return;
    }

	//
	//	Pointers to input arguments
	//
	unsigned filterspecleng = mxGetM( FILTER ) * mxGetN( FILTER ) * sizeof(mxChar) + 1;
	char * filterspec = (char *) mxCalloc( filterspecleng, sizeof( char ) );
	if( mxGetString( FILTER, filterspec, filterspecleng ) != 0 ) 
    {
        FILENAMES = mxCreateCellMatrix( 0, 0 );
        PATHNAME = mxCreateDoubleMatrix( 1, 1, mxREAL );
        double * pr = (double *) mxGetPr( PATHNAME );
        *pr = 0.0;
		mexWarnMsgTxt( "Unable to interpret filter specification." );
        return;
    }

	//
	// Check if title is a valid string
	//
    unsigned titleleng = mxGetM( TITLE ) * mxGetN( TITLE ) * sizeof(mxChar) + 1;
	char * title = (char *) mxCalloc( titleleng, sizeof( char ) );
	if( mxGetString( TITLE, title, titleleng ) != 0 ) 
    {
        FILENAMES = mxCreateCellMatrix( 0, 0 );
        PATHNAME = mxCreateDoubleMatrix( 1, 1, mxREAL );
        double * pr = (double *) mxGetPr( PATHNAME );
        *pr = 0.0;
		mexWarnMsgTxt( "Unable to interpret title specification." );
        return;
    }

	//
	// Remember the current working directory
	//
	char * curdir = (char *) mxCalloc( _MAX_PATH, sizeof( char ) );
      _getcwd( curdir, _MAX_PATH );

	//
	// Allocate memory for startpath
	//
	char * startpath = (char *) mxCalloc( _MAX_PATH, sizeof( char ) );

	//
	// If startpath is not specified, use the current working directory
	//
	if( NInput == 2 )
	{
		startpath = curdir;
	}

	//
	// If startpath is specified, use it
	//
	else
	{
		// Check if startpath is a valid string
		if( mxGetString( STARTPATH, startpath, _MAX_PATH ) != 0 ) 
	    {
			FILENAMES = mxCreateCellMatrix( 0, 0 );
			PATHNAME = mxCreateDoubleMatrix( 1, 1, mxREAL );
			double * pr = (double *) mxGetPr( PATHNAME );
			*pr = 0.0;
			mexWarnMsgTxt( "Unable to interpret start path specification." );
			return;
		}
	}
	
	//
	// Modify the startpath string so that it meets Windows API needs, because
	// the user may be using "/" instead of "\" since MATLAB allows this!
	//
	char * pathVarBeingChanged = (char *) mxCalloc( _MAX_PATH, sizeof( char ) );
	strcpy(pathVarBeingChanged,startpath);
	char * pdest = strchr(pathVarBeingChanged,'/'); // Pointer to character occurence returned by strchr()
	while (pdest != NULL)
	{
		strncpy(pdest,"\\",1);
		pdest = strchr(pathVarBeingChanged,'/');
	}
	startpath = pathVarBeingChanged;

	//
	// Check to make sure startpath exists
	//
	if (_chdir(startpath))
	{
		FILENAMES = mxCreateCellMatrix( 0, 0 );
		PATHNAME = mxCreateDoubleMatrix( 1, 1, mxREAL );
		double * pr = (double *) mxGetPr( PATHNAME );
		*pr = 0.0;
		mexWarnMsgTxt( "Unable to locate specified start directory; directory may not exist." );
		_chdir(curdir);
		return;
	}

	//
	// If we have made it this far, then reset the startpath to the CWD.
	// We need to do this, because there are ways that _chdir() accepts paths 
	// where the OPENFILENAME structure or GetOpenFileName() does not.
	//
	_getcwd( startpath, _MAX_PATH );

	//
    // Extract extension pointer
	//
    char * extension = strchr( filterspec, '.' );
    char allfiles[] = "*";
    if( extension != NULL )
    {
        extension++;
    }
    else
    {
        extension = allfiles;
    }

	//
	// Local variables
	//
    char * lpstrFilter = (char *) mxCalloc( (3 * _MAX_EXT + 32), sizeof( char ) );
    memset( lpstrFilter, 0, (3 * _MAX_EXT + 32) );
    strcpy( lpstrFilter, extension );
    strcat( lpstrFilter, "-file *." );
    strcat( lpstrFilter, extension );
    strcat( lpstrFilter, "|*." );
    strcat( lpstrFilter, extension );
    strcat( lpstrFilter, "|All files *.*|*.*||" );
    for( i=0; i<(3 * _MAX_EXT + 32); i++ )
    {
        if( lpstrFilter[i] == '|' ) lpstrFilter[i] = '\0';
    }

	//
    // Structure for open file common dialog
	//
    OPENFILENAME ofn;
    memset( &ofn, 0, sizeof( OPENFILENAME ) );
    ofn.lStructSize = sizeof( OPENFILENAME );
    ofn.hwndOwner = NULL;
    ofn.hInstance = 0;
    ofn.lpstrFilter = lpstrFilter;
    ofn.lpstrCustomFilter = NULL;
    ofn.nMaxCustFilter = 0;
    ofn.nFilterIndex = 1;
    ofn.lpstrFile = (char *) mxCalloc( 100*_MAX_PATH, sizeof( char ) );
    memset( ofn.lpstrFile, 0, 100*_MAX_PATH );
    ofn.nMaxFile = 100*_MAX_PATH;
    ofn.lpstrFileTitle = NULL;
    ofn.nMaxFileTitle = 0;
    ofn.lpstrInitialDir = startpath;
    ofn.lpstrTitle = title;
    ofn.Flags = OFN_ALLOWMULTISELECT | OFN_EXPLORER | OFN_FILEMUSTEXIST | OFN_LONGNAMES | OFN_PATHMUSTEXIST;
    ofn.lpstrDefExt = filterspec;

	//
    // Call WIN API Open File Dialog
	//
    if( !GetOpenFileName( &ofn ) )
    {
        FILENAMES = mxCreateCellMatrix( 0, 0 );
        PATHNAME = mxCreateDoubleMatrix( 1, 1, mxREAL );
        double * pr = (double *) mxGetPr( PATHNAME );
        *pr = 0.0;
		
		// Return to the current directory
		_chdir(curdir);

        return;
    }

	//
    // Find out how many items are returned
	//
    for( i=1, j=0; i<100*_MAX_PATH; i++ )
    {
        if( (ofn.lpstrFile[i-1] != '\0') && (ofn.lpstrFile[i] == '\0') ) j++;
        if( (ofn.lpstrFile[i-1] == '\0') && (ofn.lpstrFile[i] == '\0') ) break;
    }

    if( j == 1 )
    {  
        // Hack to handle single file name returned
        char pathname[ _MAX_PATH ], filename[ _MAX_PATH ];
        char drive[ _MAX_DRIVE ], dir[ _MAX_DIR ], fname[ _MAX_FNAME ], ext[ _MAX_EXT ];
        _splitpath( ofn.lpstrFile, drive, dir, fname, ext );
        _makepath( pathname, drive, dir, NULL, NULL );
        _makepath( filename, NULL, NULL, fname, ext );

        //	Finally, we can create output arguments
	    FILENAMES = mxCreateCellMatrix( 1, 1 );
        PATHNAME = mxCreateString( pathname );

        // Copy one and only file
        mxSetCell( FILENAMES, 0, mxCreateString( filename ) );
    }
    else
    {   
        // Add backslash to pathname
        char * pathname = (char *) mxCalloc( _MAX_PATH + 2, sizeof( char ) );
        memset( pathname, 0, (_MAX_PATH + 2)*sizeof( char ) );
        strcpy( pathname, ofn.lpstrFile );
        strcat( pathname, "\\" );
        
        //	Finally, we can create output arguments
        FILENAMES = mxCreateCellMatrix( 1, j-1 );
        PATHNAME = mxCreateString( pathname );
        
        // Get rid of first item in list, pathname
        char * pc = ofn.lpstrFile;
        while( *pc != NULL )
        {
            pc++;
        }
        pc++;
        
        // Add string arrays as cells
        for( i=0; i<(j-1); i++ )
        {
            mxSetCell( FILENAMES, i, mxCreateString( pc ) );
            // Find next item
            while( *pc != NULL )
            {
                pc++;
            }
            pc++;
        }
    }

	//
	// Return to the current directory
	//
	_chdir(curdir);

    return;

}
