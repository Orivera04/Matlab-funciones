 /* SND_CONTROL.DLL returns and sets controls of audio mixers device     */
 /*     CONTROL_VALUE = SND_CONTROL(CONTROL_ID) returns the value of the */
 /*     CONTROL_VALUE of the audio mixer control with ID CONTROL_ID.     */
 /*                                                                      */
 /*     CONTROL_VALUE = SND_CONTROL(CONTROL_ID, VALUE) sets the value of */
 /*     the audio mixer control with ID CONTROL_ID to CONTROL_VALUE      */
 /*     reads it again and returns it in CONTROL_VALUE to check of the   */
 /*     success. CONTROL_VALUE and VALUE may be vectors of lentgh up to  */
 /*     (mxcd.cChannels * mxcd.cMultipleItems) to set/read all values    */
 /*     of the contol.                                                   */
 /*     Use SND_MIXER_INFO.DLL to get informations about mixer parameter */
 /*     and CONTROL_ID.                                                  */
 /*                                                                      */
 /*     See also SND_MIXER_INFO and Microsoft Multimedia API.            */
 /*                                                                      */
 /*     SND_CONTROL is part of the SND_PC toolbox (by Torsten Marquardt) */
 /*     and works with Windows 95/98 and Matlab 5.x only.                */

#include "c:\develop\matlab5.3\extern\include\mat.h" /* Must include mat.h before mex.h */
#include "c:\develop\matlab5.3\extern\include\mex.h" /* because mat.h #includes stdio.h */
#include <windows.h>
#include <mmsystem.h>
#include <stdio.h>
#include <string.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
	
	DWORD							i;
	UINT							mixer_ID;
	double							*set_values, *get_values;
	HMIXEROBJ						hmx;
	MIXERLINECONTROLS				mxlc;
	MIXERCONTROL					pamxctrl[15];
	MIXERCONTROLDETAILS				mxcd;
	MIXERCONTROLDETAILS_SIGNED		padetailssigned[30];
	
	if (nrhs <1 || nrhs > 3)
		mexErrMsgTxt("Wrong number of input parameter! \
		(Min. 1, max. 2, Second may be a vector)");

	if (nrhs > 2)
		mixer_ID = (long)mxGetScalar(prhs[2]);
	else
		mixer_ID = 0;

	if ((mixer_ID + 1) > mixerGetNumDevs()){
		mexPrintf("There are %d  active mixer devices in the system. \n \n", mixerGetNumDevs());
		mexErrMsgTxt("MIXER_ID too high. Remenber: MIXER_IDs start with 0!");
	}

	if (mixerOpen((LPHMIXER)&hmx,mixer_ID,0,0,0))
		mexPrintf("error opening mixer !!!!");

	mxlc.cbStruct = sizeof(mxlc);
	mxlc.cbmxctrl = sizeof(pamxctrl[0]);
	mxlc.pamxctrl = pamxctrl;	
	mxlc.dwControlID = (DWORD)*mxGetPr(prhs[0]);
	if (mixerGetLineControls(hmx,&mxlc,MIXER_GETLINECONTROLSF_ONEBYID))
			mexPrintf("!!!! error getting info1 !!!!");

	mxcd.cbStruct = sizeof(mxcd);
	mxcd.cbDetails = sizeof(padetailssigned[0]);
	mxcd.paDetails = padetailssigned;
	mxcd.dwControlID = (DWORD)*mxGetPr(prhs[0]);
	mxcd.cChannels = 2;
	mxcd.cMultipleItems = mxlc.pamxctrl[0].cMultipleItems;

	if (mixerGetControlDetails(hmx,&mxcd,\
		MIXER_GETCONTROLDETAILSF_VALUE)) {
		mxcd.cChannels = 1;
		if (mixerGetControlDetails(hmx,&mxcd,\
			MIXER_GETCONTROLDETAILSF_VALUE))
			mexPrintf("!!!! error getting info2 !!!!");
	}

	if (nrhs > 1){
		set_values = mxGetPr(prhs[1]);
		for (i=0; i < (DWORD)mxGetN(prhs[1]); i++)
			padetailssigned[i].lValue = (long)set_values[i];
		if (mixerSetControlDetails(hmx,&mxcd,\
			MIXER_SETCONTROLDETAILSF_VALUE)) 
			mexPrintf("!!!! error setting info3 !!!!");
	}
	/* getting return values */
	if (mixerGetControlDetails(hmx,&mxcd,\
		MIXER_GETCONTROLDETAILSF_VALUE))
		mexPrintf("!!!! error getting info 4!!!!");

	if (mxcd.cMultipleItems){
		plhs[0]=mxCreateDoubleMatrix(1, mxcd.cChannels * \
			mxcd.cMultipleItems, mxREAL);	
		get_values = mxGetPr(plhs[0]);
		for (i=0; i < mxcd.cChannels * mxcd.cMultipleItems; i++)
		get_values[i] =(double)(long)padetailssigned[i].lValue;
	}
	else {
		plhs[0]=mxCreateDoubleMatrix(1, mxcd.cChannels, mxREAL);	
		get_values = mxGetPr(plhs[0]);
		for (i=0; i < mxcd.cChannels; i++)
		get_values[i] =(double)(long)padetailssigned[i].lValue;
	}

	mixerClose((HMIXER)hmx);
    return;
}

