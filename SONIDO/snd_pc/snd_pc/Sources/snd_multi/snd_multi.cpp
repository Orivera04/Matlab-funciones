// Nonloop Version: this version does not make use of the drivers loop feature.
//                  Instead it uses the MM_WOM_DONE message to loop the sound
//                  output
// It has now 2 different output buffers, bufferOut[] and bufferOut2[],
// to be compatible with other sound cards than GINA (with Gina you can put the 
// same buffer in the queue multiple times.
//
// There are 3 link warnings but nevertheless the Mexfile works:
// LINK : warning LNK4089: all references to "ADVAPI32.dll" discarded by /OPT:REF
// LINK : warning LNK4089: all references to "SHELL32.dll" discarded by /OPT:REF
// LINK : warning LNK4089: all references to "comdlg32.dll" discarded by /OPT:REF

 /* SND_MULTI.DLL: Record and/or play sound via multiple audio devices        */
 /*                                                                           */
 /*      Y = SND_MULTI([1 NCH_IN FS NBITS],X,NLOOPS)                          */
 /*      plays the matrix X via audio output devices assuming each row of X   */
 /*      represents data for one audio output channel (max. 64). Every two    */
 /*      rows will be played on one stereo output device. If the number of    */
 /*      rows is odd the last row will be played on both outputs of the last  */
 /*      device (mono mode). The audio data in X are expected to be in the    */
 /*      range [-1,+1]. Data outside this range will be clipped. Towards the  */
 /*      LSB the data will be truncated to the specified bits per sample      */
 /*      (NBITS). The data in X will be played in a NLOOP times loop. Ensure  */
 /*      the matrix is of sufficient length. The sound driver might have      */
 /*      difficulties to loop blocks which are too short. This is system      */
 /*      dependend. (A block of one second should be looped glitch free.)     */
 /*      Synchronously samples from audio input devices are recorded into     */
 /*      matrix Y, each row representing one recording channel. The full      */
 /*      dynamic range is [-1,+1].                                            */
 /*      The format vector [1 NCH_IN FS NBITS] normally  starts with a one    */
 /*      indicating that the audio data are in PCM format (WAVE_FORMAT_PCM).  */
 /*      NCH_IN determines the number of recording channels (up to 16).       */
 /*      (The number of output channels depends on the number of rows in X!)  */
 /*      FS is the sampling frequency. NBITS is the number of bits per sample */
 /*      Both are valid for input and output (NBIT may be 8 16 24 or 32 if    */
 /*      supported by the audio devices in use).                              */
 /*      SND_MULTI opens a small window. Closing the window causes premature  */
 /*      termination of SND_MUTLI (except if NCH_IN is zero. See below!)      */
 /*                                                                           */
 /*      Y = SND_MULTI([1 NCH_IN FS NBITS],X)                                 */
 /*      Same as above, but no looping (assumes NLOOPS = 1).                  */
 /*                                                                           */
 /*      SND_MULTI([1 NCH_IN FS NBITS],X,NLOOPS)                              */
 /*      will do sound output only.                                           */
 /*                                                                           */
 /*      Y = SND_MULTI([1 NCH_IN FS NBITS],ones(0,10000),NLOOPS)              */
 /*      If X has no rows (e.g. create by "ones(0,10000)") there will be no   */
 /*      sound output, but the length of X and the number of loops (NLOOPS)   */
 /*      still determines the number of samples to record.                    */
 /*                                                                           */
 /*      RTN = SND_MULTI([1 NCH_IN FS NBITS],X,NLOOPS,WAVEFILE)               */
 /*      Recorded data are stored in a file specified by WAVEFILE. RTN is 0   */
 /*      if all data are recorded (NO premature termination). Otherwise RTN   */
 /*      contains the total number of sampeles recorded.                      */
 /*      The maximum number of recording channels (NCH_IN) is two!            */
 /*                                                                           */
 /*      RESOURCES = SND_MULTI([1 0 FS NBITS],X,NLOOPS)                       */
 /*      Setting NCH_IN = 0 will force the function to return the control to  */
 /*      Matlab after starting sound output. The left hand parameter          */
 /*      RESOURCES will contain the handles to the resources opened.          */
 /*      There is no small window opened to terminate sound output premature. */
 /*      Use SND_STOP(RESOURCES) to stop sound output and free the resources. */
 /*                                                                           */
 /*      SND_MULTI is written for soundcards by Echo. The driver of those     */
 /*      soundcard starts all audio channels sample synchronously if all      */
 /*      devices are first set in pause mode and than started.                */
 /*      On other multichannel audio devices or multipe audio devices the     */
 /*      sample synchron start is not guaranteed! (Multichannel soundcards    */
 /*      are usually regarded as several stereo devices.                      */
 /*                                                                           */
 /*      BUGS: 1. The file open routine seems to cause the Explorer windows   */
 /*               to uptdate what might cause interruption                    */
 /*               => close the Windows Explorer                               */
 /*            2. If stopping the recording to file premature by closing the  */
 /*               window the current buffer is not flushed to the file.       */
 /*            3. specific to Echo driver vers. 4.x: The driver sets wrongly  */
 /*               the number of channels for all virtual stereo device to the */
 /*               number specified last. That leads to mis-interpretation of  */
 /*               the provided sound data in X (e.g. playing pairs of         */
 /*               channels interleaved as mono channel)                       */
 /*               => specify even number of channels only. Fill the unused    */
 /*               row in X with zeros / discard the unused recorded channel.  */
 /*                                                                           */
 /*                                                                           */
 /*      See also SND_STOP, SND_READ                                          */
 /*                                                                           */
 /* SND_MULTI.DLL is part of the Matlab SND_PC toolbox (by Torsten Marquardt) */
 /* and works with Windows 95/98 and Matlab 5.x only.                         */


// use the manipulated mat.h, mex.h etc. provided in the toolbox sources!
// TRUE and FALSE have to be converted to 1 and 0 in these files!
#include "D:\HOME\grobi\MULTIMEDIA\snd_PC\Sources\mat.h"
#include "D:\HOME\grobi\MULTIMEDIA\snd_PC\Sources\mex.h"   
#include <afxwin.h>
#include <mmsystem.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#define	 MAX_BUFFER_IN 8  //!! determines also the number of maximum recording devices
#define  BUFFER_LENGTH_IN 8192

long			done, loop_counter, nChannelsIn, nChannelsOut; 
long			bufferLengthIn, bufferLengthOut, nBuffersIn;
HMMIO			hMmio;
HWAVEIN			hWaveIn[MAX_BUFFER_IN];
WAVEFORMATEX 	FormatStereo, FormatMono;
HWND			hWnd;

void printOutError(UINT mmrError, char *pstr)
{
    if (mmrError != 0){
    	char ErrText[MAXERRORLENGTH];

    	waveOutGetErrorText(mmrError, ErrText, MAXERRORLENGTH);
    	mexPrintf("%s: %s \n", pstr, ErrText);
    }
}

void printInError(UINT mmrError, char *pstr)
{
    if (mmrError != 0){
		char ErrText[MAXERRORLENGTH];

		waveInGetErrorText(mmrError, ErrText, MAXERRORLENGTH);
    	mexPrintf("%s: %s \n", pstr, ErrText);
    }
}


long FAR PASCAL WndProc(HWND hWnd, UINT message, UINT wParam, LONG lParam) 
{
	UINT			rtn;
	HDC				hdc;
	PAINTSTRUCT		ps;
	RECT			rect;
	HPEN			hpen, hpenOld;
	LPWAVEHDR		lpwhIn;

	switch(message) {
		case MM_WIM_DATA :
			if (nBuffersIn == 1){ // recording into Matlab matrix (one buffer)
				DestroyWindow(hWnd);
			}
			else {
				lpwhIn = (LPWAVEHDR) lParam;
				mmioWrite(hMmio, lpwhIn->lpData, lpwhIn->dwBytesRecorded);
				
				if (!done){
					rtn = waveInUnprepareHeader((HWAVEIN)wParam,lpwhIn, sizeof(WAVEHDR));
					// printInError(rtn, "waveInUnprepareHeader");
					lpwhIn->dwBytesRecorded = 0;
					lpwhIn->dwFlags = 0;
					rtn = waveInPrepareHeader((HWAVEIN)wParam, lpwhIn, sizeof(WAVEHDR));
					// printInError(rtn, "WinProc: waveInPrepareHeader");
					rtn = waveInAddBuffer((HWAVEIN)wParam, lpwhIn, sizeof(WAVEHDR));
					// printInError(rtn, "WinProc: waveInAddBuffer");
				}
				else{
					DestroyWindow(hWnd);
				}
			}
			break;
			
		case MM_WOM_DONE :
			if(loop_counter > 1){
				((LPWAVEHDR) lParam)->dwFlags = 0L; 
				rtn = waveOutWrite((HWAVEOUT) wParam, (LPWAVEHDR) lParam, sizeof(WAVEHDR));
				//printOutError(rtn,"waveOutWrite");
				loop_counter -= 1;
				break;
			}
			if(!hWaveIn[0]){ // if no recording break message loop, otherwise the MM_WIM_DATA does it
				DestroyWindow(hWnd);
			}
			else{
				if(hMmio){ // if there is a file input there is only one device: hWaveIn[0]
					done = 1;
				}
				rtn = waveInReset(hWaveIn[0]); // causes a MM_WIM_DATA message to write the last buffer to file
				printInError(rtn, "waveInReset");
			}
			break;

		case WM_PAINT :
			hdc = BeginPaint(hWnd, &ps);
			GetClientRect(hWnd, &rect);
			GetClientRect(hWnd, &rect);
			hpen = CreatePen(PS_SOLID, 6, RGB(255, 0, 0));
			hpenOld = (HPEN)SelectObject(hdc, hpen);
			Rectangle(hdc, rect.left + 10, rect.top + 10, 
				rect.right - 10, rect.bottom - 10);
			DrawText(hdc, "Close window to stop!", -1, &rect,
			   DT_SINGLELINE | DT_CENTER | DT_VCENTER);
			SelectObject(hdc, hpenOld);
			DeleteObject(hpen);	
			EndPaint(hWnd, &ps);
			break;

		case WM_DESTROY :
			PostQuitMessage(0);
			return 0;
        }
	return DefWindowProc(hWnd, message, wParam, lParam);
}


HWND open_win()
{
	static char szAppName[] = "snd_win";
	HWND        hWnd;
	WNDCLASS    wndclass;
	HINSTANCE	hInstance;

	hInstance = AfxGetInstanceHandle();

	wndclass.style = CS_HREDRAW | CS_VREDRAW;
		wndclass.lpfnWndProc   = WndProc;
		wndclass.cbClsExtra    = 0;
		wndclass.cbWndExtra    = 0;
		wndclass.hInstance     = hInstance;
		wndclass.hIcon         = LoadIcon(NULL,IDI_APPLICATION);
 		wndclass.hCursor       = LoadCursor(NULL,IDC_ARROW);
		wndclass.hbrBackground = (HBRUSH)GetStockObject(WHITE_BRUSH);
		wndclass.lpszMenuName  = NULL;
		wndclass.lpszClassName = szAppName;
		RegisterClass(&wndclass);

	hWnd = CreateWindow(szAppName,// window class name
		"snd_win Window",       //window caption
		WS_OVERLAPPEDWINDOW,	// window style
		CW_USEDEFAULT,			// initial x position
		CW_USEDEFAULT,			// initial y position
		300,					// initial x size
		150,					// initial y size
		NULL,	// parent window handle
		NULL,					// window menu handle
		hInstance,				// program instance handle
		NULL);					// creation parameters
	if (!hWnd)
		return (hWnd);

	ShowWindow(hWnd,SW_SHOWNORMAL);
	UpdateWindow(hWnd);
	return (hWnd);
}


long  buffer2sndIn(LPWAVEHDR *lpwhIn, double *sndIn)
{
	long			i, n, tmp[1];

	n=0;
	switch((int)FormatStereo.wBitsPerSample){
		case 8:
			for(i=0; i<bufferLengthIn; i++){
				for(n=0; n < (long)(nChannelsIn/2); n++){
					sndIn[nChannelsIn*i+2*n] = (((double)((unsigned char*)\
						lpwhIn[n]->lpData)[2*i])- 128)/128;
					sndIn[nChannelsIn*i+2*n+1] = (((double)((unsigned char*)\
						lpwhIn[n]->lpData)[2*i+1])- 128)/128;
				}
				if (nChannelsIn%2){  // if single channel (mono) 
					sndIn[nChannelsIn*i+n] = (((double)((unsigned char*)\
						lpwhIn[n]->lpData)[i])- 128)/128;
				}
			}
			break;
		case 16:
			for(i=0; i<bufferLengthIn; i++){
				for(n=0; n < (long)(nChannelsIn/2); n++){
					sndIn[nChannelsIn*i+2*n] = ((double)((short*)\
						lpwhIn[n]->lpData)[2*i])/32768;
					sndIn[nChannelsIn*i+2*n+1] = ((double)((short*)\
						lpwhIn[n]->lpData)[2*i+1])/32768;
				}
				if (nChannelsIn%2) { // if single channel (mono) 
					sndIn[nChannelsIn*i+n] = ((double)((short*)\
						lpwhIn[n]->lpData)[i])/32768;
				}
			}
			break;
		case 24:
			tmp[0] = 0; 
			for(i=0; i<bufferLengthIn; i++){
				for(n=0; n < (long)(nChannelsIn/2); n++){
					((char*)tmp)[1] = lpwhIn[n]->lpData[6*i];
					((char*)tmp)[2] = lpwhIn[n]->lpData[6*i+1];
					((char*)tmp)[3] = lpwhIn[n]->lpData[6*i+2];
					sndIn[nChannelsIn*i+2*n] = ((double)(*tmp))/ 2147483648;
	
					((char*)tmp)[1] = lpwhIn[n]->lpData[6*i+3];
					((char*)tmp)[2] = lpwhIn[n]->lpData[6*i+4];
					((char*)tmp)[3] = lpwhIn[n]->lpData[6*i+5];
					sndIn[nChannelsIn*i+2*n+1] = ((double)(*tmp))/ 2147483648;
				}  
				if (nChannelsIn%2){  // if single channel (mono) 
					((char*)tmp)[1] = lpwhIn[n]->lpData[3*i];
					((char*)tmp)[2] = lpwhIn[n]->lpData[3*i+1];
					((char*)tmp)[3] = lpwhIn[n]->lpData[3*i+2];
					sndIn[nChannelsIn*i+n] = ((double)(*tmp))/ 2147483648;
				}
			}
			break;
		case 32:
			for(i=0; i<bufferLengthIn; i++){
				for(n=0; n < (long)(nChannelsIn/2); n++){
					sndIn[nChannelsIn*i+2*n] = ((double)((long*)\
						lpwhIn[n]->lpData)[2*i])/2147483648;
					sndIn[nChannelsIn*i+2*n+1] = ((double)((long*)\
						lpwhIn[n]->lpData)[2*i+1])/2147483648;
				}
				if (nChannelsIn%2){  // if single channel (mono) 
					sndIn[nChannelsIn*i+n] = ((double)((long*)\
						lpwhIn[n]->lpData)[i])/2147483648;
				}
			}
			break;
		default:			
			MessageBox(hWnd, "Only support for 8, 16, 24 oder 32 bit per sample!",\
				"snd_multi.dll", MB_ICONEXCLAMATION);
			return 1;
	}
	return 0;
}


long  sndOut2buffer(LPWAVEHDR *lpwh, double *sndOut)
{
	long			i, n, tmp[1];

	/* fill output buffer */
	switch((int)FormatStereo.wBitsPerSample){
		case 8:
			for  (i=0; i < bufferLengthOut; i++){
				for (n=0; n < (long)nChannelsOut/2; n++){
					lpwh[n]->lpData[2*i] = (char)(sndOut[nChannelsOut*i+2*n]*127+128);
					lpwh[n]->lpData[2*i+1] = (char)(sndOut[nChannelsOut*i+2*n+1]*127+128);
				}
				if (nChannelsOut%2){  /* last device prepared as single channel (mono) */
					lpwh[n]->lpData[i] = (char)(sndOut[nChannelsOut*i+2*n]*127+128);
				}
			}
			break;
		case 16:
			for  (i=0; i < bufferLengthOut; i++){
				for (n=0; n < (long)nChannelsOut/2; n++){
					((short*)lpwh[n]->lpData)[2*i] = (short)\
						(sndOut[nChannelsOut*i+2*n]*32767);
					((short*)lpwh[n]->lpData)[2*i+1] = (short)\
						(sndOut[nChannelsOut*i+2*n+1]*32767);
				}
				if (nChannelsOut%2){  /* last device prepared as single channel (mono) */
					((short*)lpwh[n]->lpData)[i] = (short)\
					(sndOut[nChannelsOut*i+2*n]*32767);
				}
			}
		break;
		case 24:
			for  (i=0; i < bufferLengthOut; i++){
				for (n=0; n < (long)nChannelsOut/2; n++){
					*tmp = (long)(sndOut[nChannelsOut*i+2*n]*2147483647);
					lpwh[n]->lpData[6*i]   = ((char*)tmp)[1];
					lpwh[n]->lpData[6*i+1] = ((char*)tmp)[2];
					lpwh[n]->lpData[6*i+2] = ((char*)tmp)[3];

					*tmp = (long)(sndOut[nChannelsOut*i+2*n+1]*2147483647);
					lpwh[n]->lpData[6*i+3] = ((char*)tmp)[1];
					lpwh[n]->lpData[6*i+4] = ((char*)tmp)[2];
					lpwh[n]->lpData[6*i+5] = ((char*)tmp)[3];
				}
				if (nChannelsOut%2){ /* last device prepared as single channel (mono) */
					*tmp = (long)(sndOut[nChannelsOut*i+2*n]*2147483647);
					lpwh[n]->lpData[3*i]   = ((char*)tmp)[1];
					lpwh[n]->lpData[3*i+1] = ((char*)tmp)[2];
					lpwh[n]->lpData[3*i+2] = ((char*)tmp)[3];
				}
			}
			break;
		case 32:
			for  (i=0; i < bufferLengthOut; i++){
				for (n=0; n < (long)nChannelsOut/2; n++){
					((long*)lpwh[n]->lpData)[2*i] = (long)\
						(sndOut[nChannelsOut*i+2*n]*2147483647);
					((long*)lpwh[n]->lpData)[2*i+1] = (long)\
						(sndOut[nChannelsOut*i+2*n+1]*2147483647);
				}
				if (nChannelsOut%2){  /* last device prepared as single channel (mono) */
					((long*)lpwh[n]->lpData)[i] = (long)(sndOut[nChannelsOut*i+2*n]\
					*2147483647);
				}
			}
			break;
		default:			
			MessageBox(hWnd, "Only support for 8, 16, 24 oder 32 bit per sample!",\
				"snd_multi.dll", MB_ICONEXCLAMATION);
			return 1;
	}
	return 0;
}


void fillFormats(double *format)
{
	FormatMono.wFormatTag = FormatStereo.wFormatTag = WAVE_FORMAT_PCM;
	FormatStereo.nChannels = 2;
	FormatMono.nChannels = 1;
	FormatMono.nSamplesPerSec = FormatStereo.nSamplesPerSec = (int)format[2];
	FormatMono.wBitsPerSample = FormatStereo.wBitsPerSample = (int)format[3];
	FormatStereo.nBlockAlign = (int)format[3]/4;
	FormatMono.nBlockAlign = (int)format[3]/8;
	FormatStereo.nAvgBytesPerSec = (int)format[2] * FormatStereo.nBlockAlign;
	FormatMono.nAvgBytesPerSec = (int)format[2] * FormatMono.nBlockAlign;
	return;
}


long initIn(HGLOBAL *dataIn, HGLOBAL *bufferIn, LPWAVEHDR *lpwhIn, HWAVEIN *hWaveIn,\
			HWND hWnd)
{
	long			i, n, nBuffersTotal;
	BOOL			errAlloc = FALSE;
	MMRESULT		rtn;
	char			ErrText[MAXERRORLENGTH];


	// open input devices, allocate memory and prepare input buffer 
	nBuffersTotal = 0; i = 0; rtn = 0;; // init
	for (n=0; n < (long)(nChannelsIn/2); n++){	  // the stereos
		if (rtn = waveInOpen(&hWaveIn[n],(UINT)WAVE_MAPPER,(LPWAVEFORMATEX)\
				&FormatStereo,(DWORD)hWnd,0,CALLBACK_WINDOW))
			break;
		for (i=0; i<nBuffersIn; i++){
			if(!(bufferIn[nBuffersIn*n+i] = GlobalAlloc(GMEM_MOVEABLE|GMEM_SHARE,(long)\
				sizeof(WAVEHDR))) || \
			   !(dataIn[nBuffersIn*n+i] = GlobalAlloc(GMEM_MOVEABLE|GMEM_SHARE,(long)\
				(FormatStereo.nBlockAlign * bufferLengthIn))))
			{
				errAlloc = TRUE;
				break;
			}
			nBuffersTotal++;
			lpwhIn[nBuffersIn*n+i] = (LPWAVEHDR)GlobalLock(bufferIn[nBuffersIn*n+i]);
			lpwhIn[nBuffersIn*n+i]->lpData= (LPSTR)GlobalLock(dataIn[nBuffersIn*n+i]);
			lpwhIn[nBuffersIn*n+i]->dwBufferLength = (long)(FormatStereo.nBlockAlign*\
				bufferLengthIn);
			lpwhIn[nBuffersIn*n+i]->dwBytesRecorded = 0L;
			lpwhIn[nBuffersIn*n+i]->dwUser = 0L;
			lpwhIn[nBuffersIn*n+i]->dwFlags = 0L;
			lpwhIn[nBuffersIn*n+i]->dwLoops = 0L;
		}
		if (rtn || errAlloc){ // if error
			break; // break outer loop
		}
	}
	// if last is a mono channel and no error so far: prepare last as mono channel
	if (nChannelsIn%2 && !(rtn || errAlloc)){ // if: last is a mono channel and no error so far
		if (!(rtn = waveInOpen(&hWaveIn[n],(UINT)WAVE_MAPPER,(LPWAVEFORMATEX)\
				&FormatMono,(DWORD)hWnd,0,CALLBACK_WINDOW)))
		{
			for (i=0; i<nBuffersIn; i++){
				if ((bufferIn[nBuffersIn*n+i] = GlobalAlloc(GMEM_MOVEABLE|GMEM_SHARE,(long)\
					sizeof(WAVEHDR))) && \
					(dataIn[nBuffersIn*n+i] = GlobalAlloc(GMEM_MOVEABLE|GMEM_SHARE,(long)\
					(FormatMono.nBlockAlign * bufferLengthIn))))
				{
					nBuffersTotal++;
					lpwhIn[nBuffersIn*n+i] = (LPWAVEHDR)GlobalLock(bufferIn[nBuffersIn*n+i]);
					lpwhIn[nBuffersIn*n+i]->lpData= (LPSTR)GlobalLock(dataIn[nBuffersIn*n+i]);
					lpwhIn[nBuffersIn*n+i]->dwBufferLength = (long)(FormatMono.nBlockAlign*\
						bufferLengthIn);
					lpwhIn[nBuffersIn*n+i]->dwBytesRecorded = 0L;
					lpwhIn[nBuffersIn*n+i]->dwUser = 0L;
					lpwhIn[nBuffersIn*n+i]->dwFlags = 0L;
					lpwhIn[nBuffersIn*n+i]->dwLoops = 0L;
				}
				else{
					errAlloc = 1;
					break;
				}
			}
		}
	}
	if (rtn || errAlloc){ // Could not open all devices or allocate all memory
		if (rtn){	
    		waveInGetErrorText(rtn, ErrText, MAXERRORLENGTH);
			MessageBox(hWnd, ErrText, "waveInOpen", MB_ICONEXCLAMATION);
			mexPrintf(strcat(ErrText, "(waveInOpen)\n"));
		}
		else{	
			MessageBox(hWnd, "Out of memory!","snd_multi.dll", MB_ICONEXCLAMATION);
			mexPrintf("Out of memory! (snd_multi.dll)\n");
		}
	}
	else
		nBuffersTotal = -1;	// success: all  required buffers opened
	return nBuffersTotal;  // success: -1  ; failure:  number of buffers actually opened
}


long initOut(HGLOBAL *dataOut, HGLOBAL *bufferOut, LPWAVEHDR *lpwhOut, HWAVEOUT *hWaveOut,\
		 double *sndOut, HGLOBAL *bufferOut2, LPWAVEHDR *lpwhOut2, long nLoops)
{
	long			n, nDevices;
	BOOL			errAlloc = FALSE;
	MMRESULT		rtn;
	char			ErrText[MAXERRORLENGTH];

	// open output devices, allocate memory and prepare output buffer
	nDevices = 0; rtn = 0; //init
	for (n=0; n < (long)(nChannelsOut/2); n++){	  // the stereos
		if (hWnd){
			rtn = waveOutOpen(&hWaveOut[n],(UINT)WAVE_MAPPER,(LPWAVEFORMATEX)\
					&FormatStereo,(DWORD)hWnd,0,CALLBACK_WINDOW);
		}
		else{
			rtn=waveOutOpen(&hWaveOut[n],(UINT)WAVE_MAPPER,(LPWAVEFORMATEX)&FormatStereo,\
				(DWORD)NULL,0,0);
		}
		if (rtn)
			break;
		nDevices++;

		if( !(bufferOut[n] = GlobalAlloc(GMEM_MOVEABLE|GMEM_SHARE,(long)\
			sizeof(WAVEHDR))) || \
			!(dataOut[n] = GlobalAlloc(GMEM_MOVEABLE|GMEM_SHARE,(long)\
			(FormatStereo.nBlockAlign * bufferLengthOut))))
		{
			errAlloc = TRUE;
			break;
		}
		lpwhOut[n] = (LPWAVEHDR)GlobalLock(bufferOut[n]);
		lpwhOut[n]->lpData = (LPSTR)GlobalLock(dataOut[n]);
		lpwhOut[n]->dwBufferLength = (long)(FormatStereo.nBlockAlign*bufferLengthOut);
		lpwhOut[n]->dwBytesRecorded = 0L;
		lpwhOut[n]->dwUser = 0L;
		lpwhOut[n]->dwFlags = 0L;
		lpwhOut[n]->dwLoops = 0L;
		if (nLoops < 0){
			lpwhOut[n]->dwFlags = WHDR_BEGINLOOP|WHDR_ENDLOOP;
			lpwhOut[n]->dwLoops = -nLoops; // negative nLoops: control back to Matlab
		}
		if (nLoops > 1){
			if( !(bufferOut2[n] = GlobalAlloc(GMEM_MOVEABLE|GMEM_SHARE,(long)\
				sizeof(WAVEHDR))) )
			{
				errAlloc = TRUE;
				break;
			}
			lpwhOut2[n] = (LPWAVEHDR)GlobalLock(bufferOut2[n]);
			lpwhOut2[n]->lpData = (LPSTR)GlobalLock(dataOut[n]);
			lpwhOut2[n]->dwBufferLength = (long)(FormatStereo.nBlockAlign*bufferLengthOut);
			lpwhOut2[n]->dwBytesRecorded = 0L;
			lpwhOut2[n]->dwUser = 0L;
			lpwhOut2[n]->dwFlags = 0L;
			lpwhOut2[n]->dwLoops = 0L;
		}
	}

	if (nChannelsOut%2 && !(rtn || errAlloc)){ // if: last is a mono channel and no error so far
		if (hWnd){
			rtn = waveOutOpen(&hWaveOut[n],(UINT)WAVE_MAPPER,(LPWAVEFORMATEX)\
					&FormatMono,(DWORD)hWnd,0,CALLBACK_WINDOW);
		}
		else{
			rtn=waveOutOpen(&hWaveOut[n],(UINT)WAVE_MAPPER,(LPWAVEFORMATEX)&FormatMono,\
				(DWORD)NULL,0,0);
		}
		if (!rtn){
			nDevices++;
			if (!(bufferOut[n] = GlobalAlloc(GMEM_MOVEABLE|GMEM_SHARE,(long)\
				sizeof(WAVEHDR))) || \
				!(dataOut[n] = GlobalAlloc(GMEM_MOVEABLE|GMEM_SHARE,(long)\
				(FormatMono.nBlockAlign * bufferLengthOut))))
			{
				errAlloc = TRUE; 
			}
			else{
				lpwhOut[n] = (LPWAVEHDR)GlobalLock(bufferOut[n]);
				lpwhOut[n]->lpData = (LPSTR)GlobalLock(dataOut[n]);
				lpwhOut[n]->dwBufferLength = (long)(FormatMono.nBlockAlign*bufferLengthOut);
				lpwhOut[n]->dwBytesRecorded = 0L;
				lpwhOut[n]->dwUser = 0L;
				lpwhOut[n]->dwFlags = 0L;
				lpwhOut[n]->dwLoops = 0L;
				if (nLoops < 0){
					lpwhOut[n]->dwFlags = WHDR_BEGINLOOP|WHDR_ENDLOOP;
					lpwhOut[n]->dwLoops = -nLoops; // negative nLoops: control back to Matlab
				}

				if (nLoops > 1){
					if( !(bufferOut2[n] = GlobalAlloc(GMEM_MOVEABLE|GMEM_SHARE,(long)\
						sizeof(WAVEHDR))) )
					{
						errAlloc = TRUE;
					}
					else{
						lpwhOut2[n] = (LPWAVEHDR)GlobalLock(bufferOut2[n]);
						lpwhOut2[n]->lpData = (LPSTR)GlobalLock(dataOut[n]);
						lpwhOut2[n]->dwBufferLength = (long)(FormatMono.nBlockAlign*bufferLengthOut);
						lpwhOut2[n]->dwBytesRecorded = 0L;
						lpwhOut2[n]->dwUser = 0L;
						lpwhOut2[n]->dwFlags = 0L;
						lpwhOut2[n]->dwLoops = 0L;
					}
				}
			}
		}
	}

	if (rtn || errAlloc){// Could not open all devices or allocate all memory
		if (rtn){
    		waveOutGetErrorText(rtn, ErrText, MAXERRORLENGTH);
			MessageBox(hWnd, ErrText, "waveOutOpen", MB_ICONEXCLAMATION);
			mexPrintf(strcat(ErrText, "(waveOutOpen)\n"));
		}
		else{	
			MessageBox(hWnd, "Out of memory!","snd_multi.dll", MB_ICONEXCLAMATION);
			mexPrintf("Out of memory! (snd_multi.dll)\n");
		}
	}
	else {// if no error - fill output buffer
		if(!sndOut2buffer(lpwhOut, sndOut))
			nDevices = -1;  // success: all required devices opened
	}
	return nDevices;  // success: -1  ;failure:  number of devices actually opened
}



void snd_multi(long task, double *sndIn, double *sndOut, char *waveFile, long nLoops)
{
	MMRESULT		rtn;
	MSG				msg;
	long 			rtnInit, error, n, m, i;
	MMCKINFO		mmckinfoRiff, mmckinfoFmt, mmckinfoData; 

	// output
	long			nDevicesOut;
	HGLOBAL			dataOut[32], bufferOut[32], bufferOut2[32];
	HWAVEOUT		hWaveOut[32];
	LPWAVEHDR 		lpwhOut[32], lpwhOut2[32];

	// input
	long			nDevicesIn;
	HGLOBAL			dataIn[MAX_BUFFER_IN], bufferIn[MAX_BUFFER_IN];
	LPWAVEHDR 		lpwhIn[MAX_BUFFER_IN];

	hWnd = 0; // init
	nDevicesIn = (long)(ceil((float)nChannelsIn/2));
	nDevicesOut = (long)(ceil((float)nChannelsOut/2));

	if (nChannelsIn > 0){// open window if required (not when return to matlab after starting)
		hWnd = open_win();
		if (!hWnd){
			mexErrMsgTxt("snd_multi.dll: Couldn't open window.");
		}
	}
	switch (task){ 
		case 3:	// recording to file: open file	and create chunks
			if (!(hMmio = mmioOpen(waveFile, NULL, MMIO_CREATE | MMIO_WRITE| MMIO_ALLOCBUF))){
				MessageBox(hWnd, "Could not open file!","snd_multi.dll", MB_ICONEXCLAMATION);
				error = 6;
				break;
			}
			error =5;
			if (mmioSetBuffer(hMmio, NULL, 524288L, 0)){ 
				MessageBox(hWnd, " File I/O buffer cannot be allocated!",\
					"snd_multi.dll", MB_ICONEXCLAMATION);
				break;
			}
			mmckinfoRiff.fccType = mmioFOURCC('W', 'A', 'V', 'E');
			mmckinfoRiff.cksize = 0L;
			if(mmioCreateChunk(hMmio, &mmckinfoRiff, MMIO_CREATERIFF)){
				MessageBox(hWnd, "Could not create RIFF chunk!","snd_multi.dll", MB_ICONEXCLAMATION);
				break;
			}
			mmckinfoFmt.ckid = mmioFOURCC('f', 'm', 't', ' ');
			mmckinfoFmt.cksize = 16;
			if(mmioCreateChunk(hMmio, &mmckinfoFmt, 0L)){
				MessageBox(hWnd, "Could not create FMT_ chunk!","snd_multi.dll", MB_ICONEXCLAMATION);
				break;
			}
			switch (nChannelsIn){
				case 1 : // mono	 	
					rtnInit = mmioWrite(hMmio, (char*)&FormatMono, sizeof(WAVEFORMATEX)-2);
					break;
				case 2 : // stereo
					rtnInit = mmioWrite(hMmio, (char*)&FormatStereo, sizeof(WAVEFORMATEX)-2);
					break;
				default:
					MessageBox(hWnd, "Recording to file: Only up to 2 recording channels supported!",\
						"snd_multi.dll", MB_ICONEXCLAMATION);
			} // end switch (nChannelsIn)
			if (rtnInit != sizeof(WAVEFORMATEX)-2){
				MessageBox(hWnd, "Could not write FMT_ chunk!","snd_multi.dll",\
					MB_ICONEXCLAMATION);
				break;
			}
			mmckinfoData.ckid = mmioFOURCC('d', 'a', 't', 'a');
			mmckinfoData.cksize = 0L;
			if(mmioCreateChunk(hMmio, &mmckinfoData,0L)){
				MessageBox(hWnd, "Could not create DATA chunk!","snd_multi.dll", MB_ICONEXCLAMATION);
				break;
			}
		case 2:	 // init and prepair wave input
			if (0 <= (rtnInit = initIn(dataIn, bufferIn, lpwhIn, hWaveIn, hWnd))){
				error = 4;
				break;
			}
			rtn = 0;
			for (n=0; n < nDevicesIn; n++){	 // prepair
				for (i=0; i < nBuffersIn; i++){	 // prepair
					if (rtn = waveInPrepareHeader(hWaveIn[n], lpwhIn[nBuffersIn*n+i],\
						sizeof(WAVEHDR)))
					{
						printInError(rtn, "waveInPrepareHeader");
						break;
					}
					else{
						if (rtn = waveInAddBuffer(hWaveIn[n], lpwhIn[nBuffersIn*n+i],\
							sizeof(WAVEHDR)))
						{
							printInError(rtn, "waveInAddBuffer");
							i++; // instead of the "end of for loop n++" (because of break!)
							break;
						}
					}
				}
				if (rtn){
					n++;
					break; // break outer loop, too 
				}
			}
			if (rtn){ 
				error = 3;
				break; // break switch(task)
			}
		case 1:	 // init and prepair wave output and set in pause mode
			if (nChannelsIn == 0){ // only start playing and return the resource handles to matlab 
				nLoops = -nLoops; // negative nLoops indicates: control back to Matlab
			}
			if (0 <= (rtnInit = initOut(dataOut, bufferOut, lpwhOut, hWaveOut,\
				sndOut, bufferOut2, lpwhOut2, nLoops))){
				error = 2;
				break;
			}
			rtn =0;
			for (n=0; n < nDevicesOut; n++){ 
				if (rtn = waveOutPrepareHeader(hWaveOut[n], lpwhOut[n], sizeof(WAVEHDR))){
					printOutError(rtn,"waveOutPrepareHeader1");
					break;
				}
	 			if (rtn=waveOutPause(hWaveOut[n])){
					printOutError(rtn, "waveOutPause");
					break;
				}
				if (rtn=waveOutWrite(hWaveOut[n], lpwhOut[n], sizeof(WAVEHDR))){
					printOutError(rtn, "waveOutWrite");
					break;
				}
				if (nLoops > 1){
					if (rtn = waveOutPrepareHeader(hWaveOut[n], lpwhOut2[n], sizeof(WAVEHDR))){
						printOutError(rtn,"waveOutPrepareHeader2");
						break;
					}
					if (rtn=waveOutWrite(hWaveOut[n], lpwhOut2[n], sizeof(WAVEHDR))){
						printOutError(rtn, "waveOutWrite");
						break;
						}
				}
			}

			if (rtn) {
				error = 1;
				break;	// break switch (task)
			}

			error = 0; // successful so far, full set of resources has to be freed	later

			if (task > 1) {  //start recording
				for (n=0; n < nDevicesIn; n++){
					if (rtn = waveInStart(hWaveIn[n])){
						printInError(rtn, "waveInStart");
						break;
					}
				}
			}
			for (n=0; n < nDevicesOut; n++){  // start  playing sound 
				if (rtn=waveOutRestart(hWaveOut[n])){
					printOutError(rtn, "waveOutRestart");
					break;
				}
			}
	} // end switch (task)

	if (error == 0){
		if (nChannelsIn == 0){// only start playing and return the resource handles to matlab 
			for (n=0; n < nDevicesOut; n++){
				sndIn[4*n] = (double)(long)hWaveOut[n];
				sndIn[4*n+1] = (double)(long)lpwhOut[n];		    
				sndIn[4*n+2] = (double)(long)bufferOut[n];
				sndIn[4*n+3] = (double)(long)dataOut[n];
			}
			return;
		}
	}
	else{ // destroy Window
		DestroyWindow(hWnd);
	}
	if (hWnd != 0){// only if window is open	
		while(GetMessage(&msg, NULL, 0, 0)) { // message_loop			
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
	}


	// free resources
	switch (error){  
		case 0:	// everything went fine
		case 1:	// reset output, unprepare output header
			if (error == 1){ // error during 
				m = n+1;
			mexPrintf("Error 1: prepare output\n");
			}
			else
				m = nDevicesOut;
			for (n=0; n < m; n++){
  				rtn = waveOutReset(hWaveOut[n]);
				printOutError(rtn,"waveOutReset");
				rtn = waveOutUnprepareHeader(hWaveOut[n],lpwhOut[n], sizeof(WAVEHDR));
				printOutError(rtn,"waveOutUnprepareHeader");
				if (nLoops > 1){
					rtn = waveOutUnprepareHeader(hWaveOut[n],lpwhOut2[n], sizeof(WAVEHDR));
					printOutError(rtn,"waveOutUnprepareHeader");
				}
			}
		case 2:	 // free output resources
			if (error == 2){ // if error initOut() 
				m = rtnInit; // rtnInit from initOut(): no. of actual of opened output devices
				mexPrintf("Error 2: init output\n");
			}
			else
				m = nDevicesOut;
			for(n=0; n < m; n++){	 
				rtn = waveOutClose(hWaveOut[n]);
				printOutError(rtn, "waveOutClose");
				GlobalUnlock(bufferOut[n]);
				GlobalFree(bufferOut[n]);	
				GlobalUnlock(dataOut[n]);
				GlobalFree(dataOut[n]);
				if (nLoops > 1){
					GlobalUnlock(bufferOut2[n]);
					GlobalFree(bufferOut2[n]);	
				}
			}
		if (task >1){ // only if recording was requested
			case 3:	  // reset input, unprepare input header
				if (error == 3){ // if error prepare input headers
					m = n;	 // no. of actually prepared input headers in total
					mexPrintf("Error 3: prepare input\n");
				}
				else{
					m = nDevicesIn;
				}
				if ((error == 0)&&(task == 2)) { // put recorded data into Matlab matrix
					buffer2sndIn(lpwhIn, sndIn);
				}
				for (n=0; n < m; n++){
					rtn = waveInReset(hWaveIn[n]);
					printInError(rtn, "waveInReset");
					for (i=0; i < nBuffersIn; i++){
						rtn = waveInUnprepareHeader(hWaveIn[n],lpwhIn[n*nBuffersIn+i],\
							sizeof(WAVEHDR));
						printInError(rtn, "waveInUnprepareHeader");
					}
				}		
			case 4:	  // free input resources
				if (error == 4){  // if error initIn()
					m = rtnInit;  //rtnInit from initIn(): no. of actually opened buffers
					mexPrintf("Error 4: Init input\n");
				}
				else
					m = nBuffersIn*nDevicesIn; //no. opened buffers over all
				for(n=0; n < (m+nBuffersIn-1)/nBuffersIn; n++){
					rtn = waveInClose(hWaveIn[n]);
					printInError(rtn, "waveInClose");
				}
				for(n=0; n < m; n++){
					GlobalUnlock(bufferIn[n]);
					GlobalFree(bufferIn[n]);	
					GlobalUnlock(dataIn[n]);
					GlobalFree(dataIn[n]);
				}
			case 5:	// close file if opened
				if (error == 5){ 
					mexPrintf("Error 5: Init RIFF file\n");
				}
				if (hMmio){
					if (rtn = mmioAscend(hMmio,(LPMMCKINFO) &mmckinfoData, 0L)){
						mexPrintf("\nsnd_multi.dll: Could not ascend DATA chunk! rtn: %d\n",rtn);
					}
					if (rtn = mmioAscend(hMmio, (LPMMCKINFO) &mmckinfoRiff, 0L)){
						mexPrintf("\nsnd_multi.dll: Could not ascend RIFF chunk! rtn: %d\n",rtn);
					}
					// return 1 if recoprding prematurely stopped 
					rtn = mmioSeek(hMmio, 0, SEEK_CUR);
					if(rtn < 0){
						mexPrintf("\nsnd_multi.dll: Could not seek in the wave file! rtn: %d\n",rtn);
					}
					if((long)rtn  >= nLoops*bufferLengthOut* \
							nChannelsIn*FormatMono.wBitsPerSample/8+44) {
						sndIn[0] = 0L; // all data recorded
					}
					else{   // recording prematurely termitated
						sndIn[0] = (rtn-32)/FormatMono.wBitsPerSample*8;
					}
					if (rtn = mmioClose(hMmio,0)){
						mexPrintf("\nsnd_multi.dll: Could not close the wave file! rtn: %d\n",rtn);
					}
				}
		} // end if(task>1)
	} // end switch(error)
	return;
}



void mexFunction(int nlhs, mxArray *plhs[], int nrhs,const mxArray *prhs[])
{
	double			*format, *sndIn, *sndOut;
	long			task, nLoops;
	char			waveFile[128];

	// get parameter and check them 
	if ((nrhs < 2)||(nrhs >4))
		mexErrMsgTxt("Wrong number of input arguments!\n");
	sndOut = mxGetPr(prhs[1]); // get snd data
	format = mxGetPr(prhs[0]); // get format of snd data
	if (nlhs > 1)
		mexErrMsgTxt("Wrong number of output arguments!\n");
	if (mxGetN(prhs[0])!=4) 
		mexErrMsgTxt("Error 1st argument: Format vector must contain 4 parameters\n");
	if (nrhs > 2){
		if ((mxGetN(prhs[2]) != 1) || (mxGetN(prhs[2]) != 1)){
			mexErrMsgTxt("Error 3rd argument: NLOOPS shoud be a scalar!\n");
		}
		nLoops = (long)mxGetScalar(prhs[2]);
	}
	else{
		nLoops = 1;
	}
	if (nLoops < 1){
		mexErrMsgTxt("Error 3rd argument: NLOOPS shoud be greater zero!\n");
	}
	if ((bufferLengthOut = mxGetN(prhs[1])) < 40) 
		mexErrMsgTxt(strcat("Error 2nd argument: ",\
		"length of Y must be bigger than 40, or the driver will be too slow!\n"));
	if ((nChannelsOut = mxGetM(prhs[1])) > 64)
		mexErrMsgTxt(strcat("Error 2nd argument: ",\
			"Y has too many rows. Only up to 2x32 output channels suported!\n"));
	if ((nChannelsOut == 0)&&(nrhs > 3))
		mexErrMsgTxt(strcat("Error 2nd argument: ",\
		"Sorry, no suppression of output (by zero rows of Y) while recording to file!\n"));
	if ((nChannelsOut == 0)&&(nlhs == 0))
		mexErrMsgTxt(\
		"Sorry, nothing to do! (Y is empty and no recording parameters)\n");
	if ((nChannelsIn = (long)format[1]) > 16)
		mexErrMsgTxt(strcat("Error 1st argument, 2nd column (NCH_IN): ",\
		"Only max. 8x2 recording channels suported (to Matlab matrix) !($nChannelsIn)\n"));
	if ((nChannelsIn > 2)&&(nrhs > 3))
		mexErrMsgTxt(strcat("Error 1st argument, 2nd column (NCH_IN): ",\
		"Only max. 2 recording channels supported (when recording to file) !\n"));
	if ((nChannelsIn == 0)&&(nlhs == 0))
		mexErrMsgTxt(strcat("NCH_IN == 0 means start play and return to Matlab. \n",\
		"But you need to provide lhs parameter to get resources handles for snd_stop.dll!\n"));
	if ((nChannelsIn == 0)&&(nrhs > 3))
		mexErrMsgTxt(strcat("NCH_IN == 0 means start play and return to Matlab. \n",\
			"You don't need to specify a file name for recording (3rd argument)!\n"));
	if (nrhs>3){	// get name of file in which to record
		if ((mxGetN(prhs[3])>127)||(mxGetM(prhs[3])>1))
			mexErrMsgTxt("Error 4th argument: WAVEFILE is invalid!\n");
		if (mxGetString(prhs[3], waveFile, mxGetN(prhs[3])+1))
			mexErrMsgTxt("Error 4th argument: WAVEFILE is invalid!\n");
	}

	// init
	done = 0; hMmio = 0; hWaveIn[0] = 0; 	
	bufferLengthIn = BUFFER_LENGTH_IN; 
	nBuffersIn = MAX_BUFFER_IN;
	loop_counter = nLoops*(long)(ceil((float)nChannelsOut/2));
	fillFormats(format); // prepare PCMWAVEFORMAT structures 

	// What is to do?
	if (nrhs > 3){ 
		task = 3;  // if file name is given: record into file, not into Matlab matrix
		plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
		sndIn = mxGetPr(plhs[0]);
	}
	else{
		if (nlhs > 0){ // record into Matlab Matrix or start playing and return to Matlab, see next 
			if (nChannelsIn == 0){// only start playing and return  the resource handles to matlab
				plhs[0] = mxCreateDoubleMatrix((long)(ceil((float)nChannelsOut/2)), 4, mxREAL);
				sndIn = mxGetPr(plhs[0]);
				task = 1; // no recording
			}
			else{
				nBuffersIn = 1;	 // (nBuffersIn == 1) is indicator for matrix recording in WinProc() 
				bufferLengthIn = nLoops * bufferLengthOut;
				plhs[0] = mxCreateDoubleMatrix(nChannelsIn, bufferLengthIn, mxREAL);
				sndIn = mxGetPr(plhs[0]);
				task = 2;  // recording into Matlab matrix
			}
		}
		else  // no recording, playing only, return to Matlab afterwards
			task = 1;
	}
	snd_multi(task, sndIn, sndOut, waveFile, nLoops);
	return;
}

