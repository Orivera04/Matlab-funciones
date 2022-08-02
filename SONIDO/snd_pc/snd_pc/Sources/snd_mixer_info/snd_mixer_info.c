 /* SND_MIXER_INFO.DLL Print information about an audio mixer device.    */
 /*     SND_MIXER_INFO.DLL(MIXER_ID) prints information about mixer with */
 /*     the ID MIXER_ID in the Matlab command window.                    */
 /*     If only one audio device is installed MIXER_ID should be set 0.  */
 /*     If MIXER_ID is bigger than actuall number of audio mixer devices */
 /*     the function likly to cause a segmentation fault.                */
 /*                                                                      */
 /*     SND_MIXER_INFO   same as above, default MIXER_ID is zero.        */
 /*                                                                      */
 /*     MIXER_NAME = SND_MIXER_INFO(MIXER_ID) returns the device name of */
 /*     the mixer device with the ID MIXER_ID in the string MIXERNAME    */
 /*     without printing the other information. That might be useful to  */
 /*     determine the audio device in use.                               */
 /*                                                                      */
 /*     Use SND_CONTROL.DLL to change control values of the sound mixer  */
 /*                                                                      */
 /*     See also SND_CONTROL and the Microsoft Multimedia API.           */
 /*                                                                      */
 /* Bugs: The function relies on the number of controls per source       */
 /*       returned by the driver. If that number is higher than the      */
 /*       actuall number of controls the function is likly to cause a    */
 /*       segmentation fault (e.g.GINA soundcard's driver ver. 4.0       */
 /*       and below). In that case the expected number of controls       */
 /*       (Examine the function's output before the crash) must be set   */
 /*       manually in the C-code. Recompilation will be necessary.       */
 /*                                                                      */
 /* SND_MIXER_INFO is part of the SND_PC toolbox (by Torsten Marquardt)  */
 /* and works with Windows 95/98/NT and Matlab 5.x only.                 */

#include "c:\develop\matlab5.3\extern\include\mat.h" /* Must include mat.h before mex.h */
#include "c:\develop\matlab5.3\extern\include\mex.h" /* because mat.h #includes stdio.h */
#include <windows.h>
#include <mmsystem.h>
#include <stdio.h>
#include <string.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
	
	UINT				mixer_ID,i,j,k,l,connections;
	HMIXEROBJ			hmx;
	MIXERCAPS			mxcaps;
	MIXERLINE			mxl;
	MIXERLINECONTROLS	mxlc;
	MIXERCONTROL		pamxctrl[15];
	MIXERCONTROLDETAILS	mxcd;
	MIXERCONTROLDETAILS_LISTTEXT	padetailstext[30];
	MIXERCONTROLDETAILS_SIGNED		padetailssigned[30];												

	if (nrhs > 1)
		mexErrMsgTxt("Too many input parameter!");

	if (nrhs > 0){
		mixer_ID = (UINT)mxGetScalar(prhs[0]);
	}
	else{
		mixer_ID = 0;		
	}

	if ((mixer_ID + 1) > mixerGetNumDevs()){
		mexErrMsgTxt("MIXER_ID too high. Remenber: MIXER_IDs start with 0!");
	}

	if (mixerOpen((LPHMIXER)&hmx,mixer_ID,0,0,0))
		mexPrintf("error opening mixer !!!!");

	if (nlhs == 1){
		if (mixerGetDevCaps((UINT)hmx, &mxcaps, sizeof(mxcaps)))
			mexPrintf("!!!! error getting info !!!!");
		plhs[0]=mxCreateString(mxcaps.szPname);	
		return;
	}
	else
		mexPrintf("There are %d  active mixer devices in the system. \n \n", mixerGetNumDevs());

	if (mixerGetDevCaps((UINT)hmx, &mxcaps, sizeof(mxcaps)))
		mexPrintf("!!!! error getting info !!!!");
	mexPrintf("cDestinations is: %ld\n",mxcaps.cDestinations);
	mexPrintf(strcat(mxcaps.szPname,"\n\n"));
	mexPrintf("Driver Version: is: %d.%d \n", (char)(mxcaps.cDestinations >> 8),\
		(char)mxcaps.cDestinations);

	/*prepare MIXERLINE structure */
	mxl.cbStruct = sizeof(mxl);
	mxlc.cbStruct = sizeof(mxlc);
	for (i=0; i < mxcaps.cDestinations; i++){
		mxl.dwDestination = i;
		if (mixerGetLineInfo(hmx, &mxl,MIXER_GETLINEINFOF_DESTINATION))
			mexPrintf("!!!! error getting info !!!!");
		mexPrintf("\n================================\nDestination %ld:  ",i);
		mexPrintf(strcat(mxl.szName,"  ("));
		mexPrintf(strcat(mxl.szShortName,")\n"));
		mexPrintf("  dwLineID is: %ld\n",mxl.dwLineID);
		mexPrintf("  cChannels is: %ld\n",mxl.cChannels);
		mexPrintf("  cConnections is: %ld\n",mxl.cConnections);
		mexPrintf("  cControls is: %ld\n    ",mxl.cControls);

		mxlc.dwLineID = mxl.dwLineID;
		mxlc.cControls = mxl.cControls;
		mxlc.cbmxctrl = sizeof(pamxctrl[0]);
		mxlc.pamxctrl = pamxctrl;	
		if (mixerGetLineControls(hmx,&mxlc,MIXER_GETLINECONTROLSF_ALL))
			mexPrintf("!!!! error getting info !!!!");
		for (j=0; j < mxl.cControls; j++){
			mexPrintf("\n\n - Control %ld:  ",j);
			mexPrintf(strcat(mxlc.pamxctrl[j].szName,"\n    "));
			mexPrintf("dwControlID is: %ld\n    ",mxlc.pamxctrl[j].dwControlID);
			mexPrintf("cMultipleItems is: %ld\n    ",mxlc.pamxctrl[j].cMultipleItems);
			mexPrintf("lMninmum is: %ld\n    ",mxlc.pamxctrl[j].Bounds.lMinimum);
			mexPrintf("lMaximum is: %ld\n    ",mxlc.pamxctrl[j].Bounds.lMaximum);
			mexPrintf("cSteps is: %ld\n    ",mxlc.pamxctrl[j].Metrics.cSteps);
			mexPrintf("fdwControl is: %ld\n       ",mxlc.pamxctrl[j].fdwControl);

			mxcd.cbStruct = sizeof(mxcd);
			mxcd.dwControlID = mxlc.pamxctrl[j].dwControlID;
			mxcd.cChannels = mxl.cChannels;
			mxcd.cMultipleItems = mxlc.pamxctrl[j].cMultipleItems;
			mxcd.cbDetails = sizeof(padetailssigned[0]);
			mxcd.paDetails = padetailssigned;
			if (mixerGetControlDetails(hmx,&mxcd,\
					MIXER_GETCONTROLDETAILSF_VALUE)) {
				mxcd.cChannels = 1;
				if (mixerGetControlDetails(hmx,&mxcd,\
					MIXER_GETCONTROLDETAILSF_VALUE))
					mexPrintf("!!!! error getting info !!!!");
				}
			if (mxlc.pamxctrl[j].cMultipleItems > 0){
				mxcd.cbStruct = sizeof(mxcd);
				mxcd.dwControlID = mxlc.pamxctrl[j].dwControlID;
				mxcd.cChannels = mxl.cChannels;
				mxcd.cMultipleItems = mxlc.pamxctrl[j].cMultipleItems;
				mxcd.cbDetails = sizeof(padetailstext[0]);
				mxcd.paDetails = padetailstext;
				if (mixerGetControlDetails(hmx,&mxcd, \
					MIXER_GETCONTROLDETAILSF_LISTTEXT))
					mexPrintf("!!!! error getting info !!!!");
				for (k=0; k < mxlc.pamxctrl[j].cMultipleItems; k++){ 
					mexPrintf(strcat(padetailstext[k].szName,": "));
					mexPrintf("l:%ld ",(LONG)padetailssigned[k].lValue);
					mexPrintf("r:%ld \n       ",(LONG)padetailssigned[k + \
						mxlc.pamxctrl[j].cMultipleItems].lValue);
				}
			}
			else {
				mexPrintf("l:%ld ",(LONG)padetailssigned[0].lValue);
				mexPrintf("r:%ld \n       ",(LONG)padetailssigned[1].lValue);
			}
		}
		connections = mxl.cConnections;
		for (l=0; l < connections; l++){
			mxl.cbStruct = sizeof(mxl);
			mxlc.cbStruct = sizeof(mxlc);
			mxl.dwSource = l;
			if (mixerGetLineInfo(hmx, &mxl,MIXER_GETLINEINFOF_SOURCE))
				mexPrintf("!!!! error getting info !!!!");
			mexPrintf("\n-----------------------------\nSource %ld:  ",l);
			mexPrintf(strcat(mxl.szName,"  ("));
			mexPrintf(strcat(mxl.szShortName,")\n"));
			mexPrintf("  dwLineID is: %ld\n",mxl.dwLineID);
			mexPrintf("  cChannels is: %ld\n",mxl.cChannels);
			mexPrintf("  cControls is: %ld\n",mxl.cControls);
			mexPrintf("  dwDeviceID is: %ld\n",mxl.Target.dwDeviceID);
			mexPrintf(strcat(mxl.Target.szPname,"\n    "));

			mxlc.dwLineID = mxl.dwLineID;
			mxlc.cControls = mxl.cControls;
			mxlc.cbmxctrl = sizeof(pamxctrl[0]);
			mxlc.pamxctrl = pamxctrl;	
			if (mixerGetLineControls(hmx,&mxlc,MIXER_GETLINECONTROLSF_ALL))
				mexPrintf("!!!! error getting info !!!!");
			for (j=0; j < mxl.cControls; j++){
				mexPrintf("\n - Control %ld:  ",j);
				mexPrintf(strcat(mxlc.pamxctrl[j].szName,"\n    "));
				mexPrintf("dwControlID is: %ld\n    ",mxlc.pamxctrl[j].dwControlID);
				mexPrintf("cMultipleItems is: %ld\n    ",mxlc.pamxctrl[j].cMultipleItems);
				mexPrintf("lMninmum is: %ld\n    ",mxlc.pamxctrl[j].Bounds.lMinimum);
				mexPrintf("lMaximum is: %ld\n    ",mxlc.pamxctrl[j].Bounds.lMaximum);
				mexPrintf("cSteps is: %ld\n    ",mxlc.pamxctrl[j].Metrics.cSteps);
				mexPrintf("fdwControl is: %ld\n       ",mxlc.pamxctrl[j].fdwControl);

				mxcd.cbStruct = sizeof(mxcd);
				mxcd.dwControlID = mxlc.pamxctrl[j].dwControlID;
				mxcd.cChannels = mxl.cChannels;
				mxcd.cMultipleItems = mxlc.pamxctrl[j].cMultipleItems;
				mxcd.cbDetails = sizeof(padetailssigned[0]);
				mxcd.paDetails = padetailssigned;
				if (mixerGetControlDetails(hmx,&mxcd,\
						MIXER_GETCONTROLDETAILSF_VALUE)) {
					mxcd.cChannels = 1;
					if (mixerGetControlDetails(hmx,&mxcd,\
						MIXER_GETCONTROLDETAILSF_VALUE))
						mexPrintf("!!!! error getting info !!!!");
				}
				if (mxlc.pamxctrl[j].cMultipleItems > 0){
					mxcd.cbStruct = sizeof(mxcd);
					mxcd.dwControlID = mxlc.pamxctrl[j].dwControlID;
					mxcd.cChannels = mxl.cChannels;
					mxcd.cMultipleItems = mxlc.pamxctrl[j].cMultipleItems;
					mxcd.cbDetails = sizeof(padetailstext[0]);
					mxcd.paDetails = padetailstext;
					if (mixerGetControlDetails(hmx,&mxcd, \
						MIXER_GETCONTROLDETAILSF_LISTTEXT))
						mexPrintf("!!!! error getting info !!!!");
					for (k=0; k < mxlc.pamxctrl[j].cMultipleItems; k++){ 
						mexPrintf(strcat(padetailstext[k].szName,": "));
						mexPrintf("l:%ld ",(LONG)padetailssigned[k].lValue);
						mexPrintf("r:%ld \n       ",(LONG)padetailssigned[k + \
							mxlc.pamxctrl[j].cMultipleItems].lValue);
					}
				}
				else {
					mexPrintf("l:%ld ",(LONG)padetailssigned[0].lValue);
					mexPrintf("r:%ld \n       ",(LONG)padetailssigned[1].lValue);
				}
			}
		}
	}
	mixerClose((HMIXER)hmx);
    return;
}

