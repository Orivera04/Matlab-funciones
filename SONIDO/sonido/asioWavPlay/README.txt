README for asioWavPlay

asioWavPlay is a MEX extension for Matlab. It plays multichannel
sound files using an ASIO driver.

Usage: asioWavPlay(wav filename [, deviceid])

The device ID parameter is optional. It defaults to 0 (the first ASIO device).
The library libsndfile.dll must reside in the same location as asioWavPlay.dll.

To build asioWavPlay, you will need:
 * PortAudio Portable Real-Time Audio Library (http://www.portaudio.com/)
 * libsndfile (http://www.mega-nerd.com/libsndfile/)
 * Steinberg ASIO2 SDK 

The provided asioWavPlay.dll has been built with:
 * PortAudio v18.1
 * libsndfile v1.0.13
 * ASIO 2.1 SDK 
 * Matlab v7.04

$Revision: 25.07.2007$ 
    - Initial release.

Copyright 2007 Pádraig Kitterick
Email: p.kitterick@psych.york.ac.uk
Department of Psychology
University of York, UK

*********************************************************************
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.
 
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
 
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*********************************************************************
