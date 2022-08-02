function inputdata = generatetbstimulus(filterobj, varargin)
%GENERATETBSTIMULUS Generates and returns HDL Test Bench Stimulus
%   GENERATETBSTIMULUS(Hd) automatically generates the filter
%   input stimulus based on the settings for the current filter.
%   The stimulus consists of any or all of impulse, step, ramp,
%   chirp, noise, or user-defined stimulus.  Note that the results
%   are quantized using the input quantizer settings of Hd. If the
%   arithmetic property of the filter Hd is set to 'double', then
%   double-precision stimulus is return. If the arithmetic property
%   is set to 'fixed', then the stimulus is return as a fixed-point
%   object.
%
%   GENERATETBSTIMULUS(Hd, PARAMETER1, VALUE1, PARAMETER2, VALUE2, ...) 
%   generates the test bench with parameter/value pairs. Valid 
%   properties and values for GENERATETBSTIMULUS are listed in 
%   the Filter Design HDL Coder documentation section "Property
%   Reference."
%
%   Y = GENERATETBSTIMULUS(Hd,...) returns the stimulus to MATLAB
%   variable Y. 
%
%   GENERATETBSTIMULUS(Hd,...) with no output argument plots the 
%   stimulus in the current figure window.
%
%   EXAMPLE:
%   % Setup filter
%   h = firceqrip(30,0.4,[0.05 0.03]);
%   Hb = dfilt.dffir(h);
%   Hb.arithmetic = 'fixed';
%   Hb.castbeforesum = false;
%
%   % Generate or plot stimulus
%   % Generate Ramp and Chirp stimulus and return in the variable y.
%   y = generatetbstimulus(Hq, 'TestBenchStimulus',{'ramp','chirp'});
%
%   % Generate Noise stimulus and plot in the current figure window
%   generatetbstimulus(Hq, 'TestBenchStimulus','noise');
%
%   See also GENERATEHDL, GENERATETB.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/01 16:19:59 $ 

% M-file help for generatetbstimulus method.

% [EOF]

