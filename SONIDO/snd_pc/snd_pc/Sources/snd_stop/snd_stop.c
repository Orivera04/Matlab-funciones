 /* SND_STOP.DLL Stop sound output and free resources. (See SND_MULTI)   */
 /*     SND_STOP(RESOURCES) stops sound output and free resources        */
 /*     specified by RESOURCES.                                          */
 /*     The sound output has been started previously with:               */
 /*                                                                      */
 /*     RESOURCES = SND_MULTI([1 0 ...                                   */
 /*                                                                      */
 /*     (If NCH_IN=0 in the SND_MULTI call the control returns           */
 /*     immediately to Matlab after output started.                      */
 /*                                                                      */
 /*     See also SND_MULTI                                               */
 /*                                                                      */
 /*     SND_STOP is part of the SND_PC toolbox (by Torsten Marquardt)    */
 /*     and works with Windows 95/98 and Matlab 5.x only.                */


#include "c:\develop\matlab5.3\extern\include\mat.h"   
#include "c:\develop\matlab5.3\extern\include\mex.h"  
#include <windows.h>
#include <mmsystem.h>
#include <stdio.h>
#include <string.h>
  
void printOutError(UINT mmrError, char *pstr)
{
    if (mmrError != 0){
    	char ErrText[MAXERRORLENGTH];

    	waveOutGetErrorText(mmrError, ErrText, MAXERRORLENGTH);
    	mexPrintf(pstr);
		mexPrintf(": ");
    	mexPrintf(ErrText);
    	mexPrintf("\n");
    }
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
	
	HWAVEOUT	hWaveOut;
	HGLOBAL		bufferOut, dataOut;
	LPWAVEHDR 	lpwh;
	UINT		rtn;
	double 		*format;
	long		n,m;

  /* get format of wave data */
    if (nrhs!=1) mexErrMsgTxt
		("Error using snd_stop.dll: wrong number of parameters!");
  	if (mxGetN(prhs[0])!=4) 
		mexErrMsgTxt("Error using snd_stop.dll: wrong parameter!");
	m = mxGetM(prhs[0]);
  	format = mxGetPr(prhs[0]);
	/* close output resources */

	for (n=0; n < m; n++){
  		hWaveOut = (HWAVEOUT)(long)format[4*n];
  		lpwh= (LPWAVEHDR)(long)format[4*n+1];
  		bufferOut = (HGLOBAL)(long)format[4*n+2];
  		dataOut= (HGLOBAL)(long)format[4*n+3];

  		rtn = waveOutReset(hWaveOut);
		printOutError(rtn,"waveOutReset");
		rtn = waveOutUnprepareHeader(hWaveOut,(LPWAVEHDR) lpwh, sizeof(WAVEHDR));
		printOutError(rtn,"waveOutUnprepareHeader");
		rtn = waveOutClose(hWaveOut);
		printOutError(rtn,"waveOutClose");
		GlobalUnlock(bufferOut);
		GlobalFree(bufferOut);	
		GlobalUnlock(dataOut);
		GlobalFree(dataOut);
	}
    return;
}

