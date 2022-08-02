%% HDL Video Filter
% This demonstration illustrates how to generate HDL code for an ITU-R
% BT.601 luma filter with 8-bit input data and 10-bit output data.  This
% filter is a low-pass filter with a -3 dB point of 3.2 MHz with a 13.5
% MHz sampling frequency and a specified range for both passband ripple
% and stopband attenuation shown in the ITU specification.  The filter
% coefficients were designed using the Filter Design Toolbox. This
% example focuses on quantization effects and generating HDL code for
% the filter.

% Copyright 2004 The MathWorks, Inc. 
% $Revision: 1.1.6.1 $  $Date: 2004/04/08 20:51:31 $

%% Set up the coefficients
% Assign the previously designed filter coefficients to variable b. This
% is a halfband filter and, therefore, every other coefficient is zero
% with the exception of the coefficient at the filter midpoint, which is
% exactly one-half. 
%
% Check that double-precision filter design meets the ITU-R BT.601
% template for passband ripple and stopband attenuation using freqz and
% plot the passband. The red lines show the allowed variation in the
% specification.


b = [0.00303332064210658,  0,...
    -0.00807786494715095,  0,...
     0.0157597395206364,   0,...
    -0.028508691397868,    0,...
     0.0504985344927114,   0,...
    -0.0977926818362618,   0,...
     0.315448742029959,...
     0.5,...
     0.315448742029959,    0,...
    -0.0977926818362618,   0,...
     0.0504985344927114,   0,...
    -0.028508691397868,    0,...
     0.0157597395206364,   0,...
    -0.00807786494715095,  0,...
     0.00303332064210658];

f = 0:100:2.75e6;
H = freqz(b,1,f,13.5e6);
plot(f,20*log10(abs(H)));
title('HDL Video Filter Double-Precision Passband');
axis([0 2.75e6 -.8 .8]);
passbandrange = {[2.75e6;  1e6;   0;  1e6; 2.75e6],...
                 [  -0.5; -0.5;   0;  0.5;    0.5]};
line(passbandrange{:}, 'Color', 'red');


%% Plot the stopband
% The red line shows a "not to exceed" limit on the stopband.

f = 4e6:100:6.75e6;
H = freqz(b,1,f,13.5e6);
plot(f,20*log10(abs(H)));
title('HDL Video Filter Double-Precision Stopband');
axis([4e6 6.75e6 -70 -35]);
stopbandrange = {[4e6;   6.25e6;  6.75e6],...
                 [-40;      -55;     -55]};
line(stopbandrange{:}, 'Color', 'red');

%% Create the quantized filter
% Create a quantized version of the filter and see what quantizer
% settings are needed.  Experiment with the coefficient word length to
% get the desired response for 8-bit input data and 10-bit output data.

Hd = dfilt.dffir(b);
Hd.Arithmetic = 'fixed';
Hd.CastBeforeSum = false;
Hd.InputWordLength = 8;
Hd.InputFracLength = 7;
Hd.OutputWordLength = 10;
Hd.OutputMode = 'SpecifyPrecision';
Hd.OutputFracLength = 9;
Hd.AccumWordLength = 24;
%Try 10-bit coefficients
Hd.CoeffWordLength = 10;

%% Plot the quantized filter response
% Now examine the passband and stopband response of the quantized filter
% relative to the specification.  Plot and check the quantized passband
% first.
%
% The quantized design meets the passband specifications except at DC,
% where it misses the specification by about 0.035 dB.

f = 0:100:2.75e6;
H = freqz(Hd.Numerator,1,f,13.5e6);
plot(f,20*log10(abs(H)));
title('HDL Video Filter Quantized Passband');
axis([0 2.75e6 -.8 .8]);
line(passbandrange{:}, 'Color', 'red');

%% Plot the quantized stopband
% The red lines again show a "not to exceed" limit on the stopband.
%
% The stopband limit is violated, which indicates a problem with the
% quantization settings.

f = 4e6:100:6.75e6;
H = freqz(Hd.Numerator,1,f,13.5e6);
plot(f,20*log10(abs(H)));
title('HDL Video Filter Quantized Stopband');
axis([4e6 6.75e6 -70 -35]);
line(stopbandrange{:}, 'Color', 'red');

%% Change the coefficient quantizer settings
% Adding more bits to the coefficient word length enables the filter to
% meet the specification.  Increment the word length by one and replot
% the stopband.
%
% This just misses the specification at the end of the stopband.  This
% small deviation from the specification might be acceptable if you know
% that some other part of your system applies a lowpass filter to this
% signal.

Hd.CoeffWordLength = 11;
f = 4e6:100:6.75e6;
H = freqz(Hd.Numerator,1,f,13.5e6);
plot(f,20*log10(abs(H)));
title('HDL Video Filter Quantized Stopband');
axis([4e6 6.75e6 -70 -35]);
line(stopbandrange{:}, 'Color', 'red');

%% Set the final coefficient quantizer word length
% Add one more bit to the coefficient quantizer word length and replot
% the stopband.  This should meet the specification.

Hd.CoeffWordLength = 12;
f = 4e6:100:6.75e6;
H = freqz(Hd.Numerator,1,f,13.5e6);
plot(f,20*log10(abs(H)));
title('HDL Video Filter Final Quantized Stopband');
axis([4e6 6.75e6 -70 -35]);
line(stopbandrange{:}, 'Color', 'red');

%% Perform a final check on the passband response
% Recheck the passband to be sure the changes have improved the problems
% in the response near DC. The response now passes the specification.

f = 0:100:2.75e6;
H = freqz(Hd.Numerator,1,f,13.5e6);
plot(f,20*log10(abs(H)));
title('HDL Video Filter Final Quantized Passband');
axis([0 2.75e6 -.8 .8]);
line(passbandrange{:}, 'Color', 'red');

%% Generate HDL code from the quantized filter
% Starting from the correctly quantized filter, generate VHDL or Verilog
% code.  You also have the option of generating a VHDL, Verilog, or
% ModelSim .do file test bench to verify that the HDL design matches the
% MATLAB filter.
%
% Create a temporary work directory.  After generating the HDL
% (selecting VHDL in this case), open the generated VHDL file in the
% editor.  
%
% To generate Verilog instead, change the value of the property
% 'TargetLanguage', from 'VHDL' to 'Verilog'.
%
% The warnings indicate that by selecting another filter structure, such
% as symmetric FIR, or by setting 'OptimizeForHDL' to 'on' the resulting
% HDL code might produce smaller area or run at a higher clock rate.

workingdir = tempname;
generatehdl(Hd,'Name', 'hdlvideofilt', 'TargetLanguage', 'VHDL',...
            'TargetDirectory', workingdir);
edit(fullfile(workingdir, 'hdlvideofilt.vhd'));

%% Generate HDL test bench from the quantized filter
% Generate a VHDL test bench to make sure that it matches the response
% in MATLAB exactly.  Select the default input stimulus, which for FIR
% is impulse, step, ramp, chirp, and noise inputs. After generating the
% test bench code, open the test bench file in the editor.
%
% To generate a Verilog test bench instead, change the second argument
% from 'VHDL' to 'Verilog'.

generatetb(Hd, 'VHDL', 'TestBenchName', 'hdlvideofilt_tb',...
           'TargetDirectory', workingdir);
edit(fullfile(workingdir, 'hdlvideofilt_tb.vhd'));

%% Plot the test bench stimulus
% Plot the default test bench stimulus used by generatetb, using the
% generatetbstimulus function. With no output variable, the function
% plots the stimulus.

generatetbstimulus(Hd);

%% Conclusion
% You designed a double precision filter to meet the ITU-R BT.601 luma
% filter specification and then created a quantized filter that also met
% the specification. You generated VHDL code and a VHDL test bench that
% functionally verified the filter.
%
% You can use a VHDL simulator, such as ModelSim, to verify these
% results.  You can also experiment with Verilog.  You can use many
% optimizations to get smaller and faster HDL results by removing the
% constraint that the generated HDL be exactly true to MATLAB. When you
% use these optimizations, the HDL test bench can check the filter
% response to be within a specified error margin of the MATLAB response.
