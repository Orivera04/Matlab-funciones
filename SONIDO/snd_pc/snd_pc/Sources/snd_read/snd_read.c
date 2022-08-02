 /* SND_READ.DLL:  read  audio data from an audio file (".wav")          */
 /*    [Y FORMAT] = SND_READ(WAVEFILE, START, END, BUFFERLENGTH)         */
 /*    accumulates the audio data contained in the audio file (".wav")   */
 /*    specified by the string WAVEFILE and located beetween the sample  */
 /*    positions START and END (incl). The data in Buffer of length      */
 /*    BUFFERLENGTH is devided by the number of averages, resulting in a */
 /*    data range of [-1,+1]. The result is returned in the the matrix Y */
 /*    of length BUFFERLENGTH. Each row of Y represents an audio channel */
 /*    (opposed to Matlabs WAVEREAD (column wise)!).                     */
 /*    The format information of the audio file will be stored in the    */
 /*    4 element vector FORMAT [1 nChannels SampleRate nBitsPerSample].  */
 /*    8, 16, 24 and 32 bits per sample are supported.                   */
 /*                                                                      */
 /*    [Y FORMAT] = SND_READ(WAVEFILE, START, END) reads the samples     */
 /*    between the sample positions specified in START and END (incl.).  */
 /*                                                                      */
 /*    [Y FORMAT] = SND_READ(WAVEFILE, START) reads the samples from     */
 /*    sample positions START (inclusive) to the end of the file.        */
 /*                                                                      */
 /*    [Y FORMAT] = SND_READ(WAVEFILE) reads the whole file into Y.      */
 /*                                                                      */
 /*    [SIZE] = SND_READ(WAVEFILE) returns the total number of sampels   */
 /*    contained in all channels of the audio file WAVEFILE.             */
 /*                                                                      */
 /*    See also SND_MULTI, WAVREAD, WAVWRITE, AUREAD, AUWRITE.           */
 /*                                                                      */
 /*    SND_READ is part of the SND_PC toolbox (by Torsten Marquardt)     */
 /*    and works with Windows 95/98 and Matlab 5.x only.                 */

#include "c:\develop\matlab5.3\extern\include\mat.h"   /* Must include mat.h before mex.h */
#include "c:\develop\matlab5.3\extern\include\mex.h"   /* because mat.h #includes stdio.h */
#include <windows.h>
#include <mmsystem.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

long  average(char *pData, double *buffer, double *format, long avgLength)
{
	long		i, tmp[1];

	switch((long)format[3]){
		case 8:
			for(i=0; i<format[1]*avgLength; i++)
				buffer[i] += (((double)((unsigned char*)pData)[i])- 128)/128;
			break;
		case 16:
			for(i=0; i<format[1]*avgLength; i++)
				buffer[i] += ((double)((short*)pData)[i])/32768;
			break;
		case 24:
			tmp[0] = 0; 
			for(i=0; i<format[1]*avgLength; i++){
				((char*)tmp)[1] = pData[3*i];
				((char*)tmp)[2] = pData[3*i+1];
				((char*)tmp)[3] = pData[3*i+2];
				buffer[i] += ((double)(*tmp))/ 2147483648;
			}
			break;
		case 32:
			for(i=0; i<format[1]*avgLength; i++)
				buffer[i] += ((double)((long*)pData)[i])/2147483648;
			break;
		default:			
			mexPrintf("Only support for 8, 16, 24 oder 32 bit per sample!");
			return 1;
	}
	return 0;
}

void snd_read(long start, long end, long avgLength, char* waveFile, \
			  double* size, double* format, mxArray** plhs)
{
    HMMIO			hmmio;              // file handle for open file 
    MMCKINFO		mmckinfoParent;     // parent chunk information 
    MMCKINFO		mmckinfoSubchunk;   // subchunk information structure 
    DWORD			dwDataSize;         // size of "DATA" chunk 
    WAVEFORMATEX	*pFormat;           // address of "FMT" chunk
	HPSTR			pData;				// temporary data storage
	double			*buffer;			// average buffer and return data
	WORD			nBlockAlign;
	long			i, n;
 
    // Open the file for reading with buffered I/O by using the default internal buffer 
    if(!(hmmio = mmioOpen(waveFile, NULL, 
        MMIO_READ | MMIO_ALLOCBUF))){ 
        mexErrMsgTxt("Failed to open file! Include suffix (.wav)\n"); 
        return; 
    } 
	if (mmioSetBuffer(hmmio, NULL, 65536L, 0)){ 
		mexPrintf("File I/O buffer cannot be allocated!");
        mmioClose(hmmio, 0); 
        return; 
	}
    // Locate a "RIFF" chunk with a "WAVE" form type to make sure the file is a waveform-audio file. 
    mmckinfoParent.fccType = mmioFOURCC('W', 'A', 'V', 'E'); 
    if (mmioDescend(hmmio, (LPMMCKINFO) &mmckinfoParent, NULL, 
        MMIO_FINDRIFF)){ 
        mexPrintf("This is not a waveform-audio file!\n"); 
        mmioClose(hmmio, 0); 
        return; 
    } 
    // Find the "FMT" chunk (form type "FMT"); it must be a subchunk of the "RIFF" chunk. 
    mmckinfoSubchunk.ckid = mmioFOURCC('f', 'm', 't', ' '); 
    if (mmioDescend(hmmio, &mmckinfoSubchunk, &mmckinfoParent, 
        MMIO_FINDCHUNK)){ 
        mexPrintf("Waveform-audio file has no FMT chunk.!\n"); 
        mmioClose(hmmio, 0); 
        return; 
    } 
    // Allocate and lock memory for FMT" chunk. 
    if(!(pFormat = (WAVEFORMATEX*)malloc(mmckinfoSubchunk.cksize))){ 
        mexPrintf("Could not allocate meory for pFormat!\n"); 
        mmioClose(hmmio, 0); 
        return;
	}
    // Read the "FMT" chunk. 
    if (mmioRead(hmmio, (HPSTR) pFormat, mmckinfoSubchunk.cksize) != (long)mmckinfoSubchunk.cksize){ 
        mexPrintf("Failed to read format chunk!\n"); 
        mmioClose(hmmio, 0);
		free(pFormat);
        return; 
    }
    // Ascend out of the "FMT" subchunk. 
    mmioAscend(hmmio, &mmckinfoSubchunk, 0); 

    // Find the data subchunk. 
    mmckinfoSubchunk.ckid = mmioFOURCC('d', 'a', 't', 'a'); 
    if (mmioDescend(hmmio, &mmckinfoSubchunk, &mmckinfoParent, 
        MMIO_FINDCHUNK)){ 
        mexPrintf("Waveform-audio file has no data chunk.\n"); 
        mmioClose(hmmio, 0); 
		free(pFormat);
        return; 
    } 
    // Get the size of the data subchunk. 
    dwDataSize = mmckinfoSubchunk.cksize; 
    if (dwDataSize == 0L){ 
        mexPrintf("The data chunk contains no data!\n"); 
        mmioClose(hmmio, 0); 
		free(pFormat);
        return; 
    }
	// if only size is asked for set $size and return
	if (size){	// address is already assigned
		*size = (double)(dwDataSize/(long)(ceil((double)pFormat->wBitsPerSample/8)));
        mmioClose(hmmio, 0); 
		free(pFormat);
        return; 
    }
	else{ // memory for format is only allocated if nlhs==2
		format[0] =	(double)(pFormat->wFormatTag);
		format[1] = (double)(pFormat->nChannels);
		format[2] = (double)(pFormat->nSamplesPerSec);
		format[3] = (double)(pFormat->wBitsPerSample);
		nBlockAlign = pFormat->nBlockAlign;
		free(pFormat);
		if (format[0] != WAVE_FORMAT_PCM){
			mexPrintf("The file is not in WAVE_FORMAT_PCM!\n");
			mmioClose(hmmio, 0);
			return; 
		}
	}
	if (!end){
		end = dwDataSize/(long)(ceil(format[3]/8))/(long)format[1];
	}
	if (!avgLength){
		avgLength = end - start;
	}
    // Create Matrix of zeros for the waveform-audio data.
	plhs[0] = mxCreateDoubleMatrix((long)format[1], avgLength, mxREAL);
	buffer = mxGetPr(plhs[0]);
	for(i=0; i<format[1]*avgLength; i++)
		buffer[i] = 0;
	// allocate memory for temporary data storage
    if(!(pData = (HPSTR)malloc(avgLength*nBlockAlign))){ 
        mexPrintf("Could not allocate memory for pData!\n"); 
        mmioClose(hmmio, 0); 
        return;
	}
	// Seek to position start
	mmioSeek(hmmio, start*nBlockAlign, SEEK_CUR);
	for (i=0; i<(end-start)/avgLength; i++) {
		// Read the waveform-audio data subchunk. 
		if(mmioRead(hmmio, (HPSTR) pData, avgLength*nBlockAlign) != avgLength*nBlockAlign){ 
			mexPrintf("Failed to read data chunk in loop %d.\n", i); 
			free(pData);
			mmioClose(hmmio, 0); 
			return; 
		}
		// average into buffer
		if(average(pData, buffer, format, avgLength)){
			mexPrintf("Failed to average data in loop %d.\n", i); 
			free(pData);
			mmioClose(hmmio, 0); 
			return;
		}
	}
	for(n=0; n<avgLength; n++){
		buffer[n] = buffer[n]/i;
	}
    // Close the file. 
	free(pData);
    mmioClose(hmmio, 0); 
	return;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){

	double 		*format, *size;
	long		start, end, avgLength;
	char		waveFile[128];

	size = 0; start = end = avgLength = 0;
  /* get parameter */
    if ((nrhs > 4)||(nrhs < 1)||(nlhs > 2)) 
		mexErrMsgTxt("Error using snd_read.dll: wrong number of parameters!");
	if ((mxGetN(prhs[0])>127)||(mxGetM(prhs[0])>1))
		mexErrMsgTxt("waveFile is invalid!\n");
	if (mxGetString(prhs[0], waveFile, mxGetN(prhs[0])+1))
		mexErrMsgTxt("waveFile is invalid!\n");
    if (nrhs > 1)
		start = (long)mxGetScalar(prhs[1]) - 1;
    if (nrhs > 2)
		end = (long)mxGetScalar(prhs[2]);
	if ((end <= start)&&(end!=0))
		mexErrMsgTxt("Parameter END must be bigger than START!\n");
    if (nrhs > 3)
		avgLength = (long)mxGetScalar(prhs[3]);
    if (nlhs < 2){
		plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
		if (!(size = mxGetPr(plhs[0]))){
			mexErrMsgTxt("Could not create format matrix!\n");
		}
	}
	else{
		plhs[1] = mxCreateDoubleMatrix(1, 4, mxREAL);
		format	= mxGetPr(plhs[1]);
	}
	snd_read(start, end, avgLength, waveFile, size, format, plhs);
	return;
}

		




