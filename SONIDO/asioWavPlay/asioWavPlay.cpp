/*======================================================================
 * asioWavPlay
 * asioWavPlay is a MEX extension for Matlab. It plays multichannel
 * sound files using an ASIO driver.
 *
 * Usage: asioWavPlay(wav filename [, deviceid])
 *
 * The device ID parameter is optional. It defaults to 0 (the first
 * ASIO device).
 *
 * Samples are read from the file as needed, so playback start time
 * is not dependant on the length of the file. Memory usage is also
 * low because the whole file doesn't need to be loaded into memory.
 *
 * Copyright 2007 Padraig Kitterick
 * Email: p.kitterick@psych.york.ac.uk 
 * Department of Psychology
 * University of York, UK
 *
 ***********************************************************************
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *  
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *  
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ***********************************************************************
 *   
 * $Revision: 25.07.2007$ 
 *     - Initial release.
 *	
 *====================================================================*/

#include <time.h>
#include "sndfile.h"
#include "portaudio.h"
#include "mex.h"

typedef struct 
{
  SNDFILE *sndFile;
  SF_INFO sfInfo;
}
WavData;

/*
Callback function for audio output
*/

int Callback(void *inputBuffer, void *outputBuffer,
               unsigned long framesPerBuffer,
               PaTimestamp outTime, void *userData)
{
  // we passed a data structure into the callback
  // so we have something to work with
  WavData *data = (WavData *)userData;

  float *out = (float *)outputBuffer;
  float *in = (float *)inputBuffer;
  int i,read_count;

  for (i=0; i<framesPerBuffer; i++) {
	  // read in the audio information from the file
	  read_count = sf_read_float(data->sndFile, out, data->sfInfo.channels);

	  // Increment the buffer pointer by the total number of output channels
	  out += data->sfInfo.channels;

	  // If there is no more audio data then exit...
	  if (read_count == 0)
	  {
		  return 1;
	  }
  }
  return 0;
}

/*
mexFunction
*/
void
mexFunction( int nlhs, mxArray *plhs[],
             int nrhs, const mxArray *prhs[] )
{
	char *input_buf;
	int buflen, status;
	int deviceid = 0;

	// Do some parameter length checks
    if (nrhs < 1)
	{
		// Tell the user what parameters are missing
		mexErrMsgTxt("Please specify a wav filename, and optionally a device number.\nSyntax: asioWavPlay(filename [, deviceid])");
	}
    else if (nrhs > 2)
	{
		// Tell the user what parameters are missing
		mexErrMsgTxt("Too many input arguments.\n\nPlease specify a wav filename, and optionally a device number.\nSyntax: asioWavPlay(filename [, deviceid])");
	}

	if (nlhs > 0) 
    {
        mexErrMsgTxt("Too many output arguments");
    }    

  // The filename parameter must be a string.
  if (mxIsChar(prhs[0]) != 1)
    mexErrMsgTxt("Parameter 1 (wav filename) must be a string.");
    
  // Get the length of the input string.
  buflen = (mxGetM(prhs[0]) * mxGetN(prhs[0])) + 1;

  // Allocate memory for input string.
  input_buf = (char *) mxCalloc(buflen, sizeof(char));

  // Copy the string data from prhs[0] into a C string input_buf.
  status = mxGetString(prhs[0], input_buf, buflen);
  if (status != 0) 
    mexWarnMsgTxt("Not enough space. String is truncated.");

  // Optional Device ID argument
  if (nrhs > 1) {
	// The input must be an integer specifying the device ID to use.
    int mrows, ncols;
    mrows = mxGetM(prhs[1]);
    ncols = mxGetN(prhs[1]);
    
    if (!mxIsDouble(prhs[1]) || mxIsComplex(prhs[1]) || 
        !(mrows == 1 && ncols == 1)) 
    {
        mexErrMsgTxt("Parameter 2 (device ID) must be an integer.");
    }
     deviceid = mxGetScalar(prhs[1]);
  }

  WavData *data = (WavData *)malloc(sizeof(WavData));
  PortAudioStream *stream;
  PaError error;

  // initialize our data structure
  data->sfInfo.format = 0;
  // try to open the file 
  data->sndFile = sf_open(input_buf, SFM_READ, &data->sfInfo);

  if (!data->sndFile)
  {
	mexPrintf("Error opening file: %s\n", input_buf);
    return;
  }

  // start portaudio
  Pa_Initialize();
  
  // device id now specified. Defaults to first device
	error = Pa_OpenStream(
    &stream,
    paNoDevice,     // Input device
    0,				      // No input channels
    paFloat32,      // input sample format
    NULL,           // input driver info
    deviceid,       // output device
    data->sfInfo.channels, // output channels
    paFloat32,      // 32 bit floating point output 
    NULL,           // output driver info
    data->sfInfo.samplerate,     // stream sample rate
    256,            // frames per buffer
    0,              // number of buffers, if zero then use default minimum 
    paNoFlag,       // stream flag
    Callback,       // callback function
    data);          // user data


  // if we can't open it, then bail out
  if (error)
  {
	mexPrintf( "An error occured while opening the audio stream\n" );
	mexPrintf( "Error number: %d\n", error );
	mexPrintf( "Error message: %s\n", Pa_GetErrorText( error ) );
    Pa_Terminate();
    return;
  }

  // when we start the stream, the callback starts getting called
	error = Pa_StartStream( stream );
	if( error != paNoError ) 
	{
		mexPrintf( "An error occured while using the audio stream\n" );
		mexPrintf( "Error number: %d\n", error );
		mexPrintf( "Error message: %s\n", Pa_GetErrorText( error ) );
	}

	// sleep while stream's active
	while( Pa_StreamActive(stream) )
		Pa_Sleep( 50 );

	// the stream is inactive (no more audio to play) so flush the buffers and stop the stream
    error = Pa_StopStream( stream );
	if( error != paNoError ) 
	{
		mexPrintf( "An error occured while stopping the audio stream\n" );
		mexPrintf( "Error number: %d\n", error );
		mexPrintf( "Error message: %s\n", Pa_GetErrorText( error ) );
	}

	// now we close the stream
	error = Pa_CloseStream( stream );
	if( error != paNoError )
	{
		mexPrintf( "An error occured while closing the audio stream\n" );
		mexPrintf( "Error number: %d\n", error );
		mexPrintf( "Error message: %s\n", Pa_GetErrorText( error ) );
	}

	// finally we terminate portaudio and close the wav file
	Pa_Terminate();
	sf_close(data->sndFile);
  return;
}
