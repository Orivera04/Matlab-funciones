%FILTDEM2 Demonstration of filter design techniques.
%	This Expo demo adapted from ...
%	FILTDEMO Demonstration of filter design techniques.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Demo initialization ====================
if ~exist('SlideShowGUIFlag'), figNumber=0; end;

% normalized frequencies and desired frequency response
f = [0 .4 .4 .6 .6  1];
H = [0  0  1  1  0  0];
fs = 1000; % assumed sampling rate
fhz = f*fs/2;
  
if ssinit(figNumber), 
    % Now we are ready to plot.

    plot(fhz,H), title('Desired Frequency Response')
    xlabel('Frequency (Hz)'), ylabel('Magnitude')

    str = str2mat( ...
      ' Press the "Start" button to see a demonstration of bandpass', ...
      ' filter design using the YULEWALK, BUTTER and CHEBY1', ...
      ' functions.', ...
      ' ', ...
      ' >> f = [0 .4 .4 .6 .6  1];', ...
      ' >> H = [0  0  1  1  0  0];', ...
      ' >> fs = 1000; % assumed sampling rate', ...
      ' >> fhz = f*fs/2;', ...
      ' >> plot(fhz,H), title(''Desired Frequency Response'')', ...
      ' >> xlabel(''Frequency (Hz)''), ylabel(''Magnitude'')' ...
    );
    ssdisp(figNumber,str);                                          

    if figNumber, return; end
end

% Beginning of the demo ==================

str = str2mat( ...
  ' The YULEWALK function allows you to specify a piecewise', ...
  ' shape for the desired frequency response magnitude.', ...
  ' YULEWALK then finds an infinite-impulse response filter', ...
  ' of the desired order that fits the frequency response in a', ...
  ' least-squares sense.' ...
);
ssdisp(figNumber,str); 

if sspause(figNumber), return; end;


str = str2mat( ...                                                             
  ' We start by specifying the desired frequency response', ...
  ' point-wise, with 1.0 corresponding to half the sample rate.', ...
  ' ', ...
  ' >> f = [0 .4 .4 .6 .6  1];', ...
  ' >> H = [0  0  1  1  0  0];' ...
);
ssdisp(figNumber,str);                                               

if sspause(figNumber), return; end;


str = str2mat( ...                                                             
  ' Next we plot the desired frequency response to make sure', ...
  ' it is what we want (we''ll unnormalize the frequency axis).', ...
  ' ', ...
  ' >> fs = 1000; % assumed sampling rate', ...
  ' >> fhz = f*fs/2;', ...
  ' >> plot(fhz,H)', ...
  ' >> title(''Desired Frequency Response'')', ...
  ' >> xlabel(''Frequency (Hz)'')', ...
  ' >> ylabel(''Magnitude'')' ...
);
ssdisp(figNumber,str);                                               

if sspause(figNumber), return; end;


N = 8;		% Order of the filter (number of poles and zeros).
[Bh,Ah] = yulewalk(N,f,H);	% Working, please wait.....

str = str2mat( ...
  ' Now we use YULEWALK to compute the coefficients of an 8th', ...
  ' order filter that will approximate our desired response.', ...
  ' ', ...
  ' >> N = 8;', ...
  ' >> [Bh,Ah] = yulewalk(N,f,H);' ...
);
ssdisp(figNumber,str);                                               

if sspause(figNumber), return; end;


n = 256;
hh = freqz(Bh,Ah,n);	% compute complex frequency response
hy  = abs(hh);    	% compute magnitude
ff  = fs/(2*n) * (0:n-1);
plot(fhz,H,ff,hy), title('Actual vs. Desired Frequency Response')
xlabel('Frequency (Hz)'), ylabel('Magnitude')

str = str2mat( ...
  ' Now we can plot the frequency response magnitude and', ...
  ' compare it to the desired response.', ...
  ' ', ...
  ' >> n = 256;', ...
  ' >> hh = freqz(Bh,Ah,n);', ...
  ' >> hy  = abs(hh);', ...
  ' >> ff  = fs/(2*n) * (0:n-1);', ...
  ' >> plot(fhz,H,ff,hy)', ...
  ' >> title(''Actual vs. Desired Frequency Response'')', ...
  ' >> xlabel(''Frequency (Hz)''), ylabel(''Magnitude'')' ...
);
ssdisp(figNumber,str);                                               

if sspause(figNumber), return; end;


% filter order, passband specification and allowable ripple in dB
N = 4; passband = [.4 .6]; ripple = .1;

[Bb,Ab] = butter(N, passband);
[Bc,Ac] = cheby1(N, ripple, passband);
h = [abs(hh) abs(freqz(Bb,Ab,n)) abs(freqz(Bc,Ac,n))];

plot(ff,h)
title('YuleWalk, Butterworth and Chebyshev filters')
xlabel('Frequency (Hz)'), ylabel('Magnitude'),

str = str2mat( ...
  ' Now let''s design Butterworth and Chebyshev bandpass filters', ...
  ' with the same passband (defined between 0.0 and 1.0).', ...
  ' Here we compare all three frequency responses.', ...
  ' ', ...
  ' >> N = 4; passband = [.4 .6]; ripple = .1;', ...
  ' >> [Bb,Ab] = butter(N, passband);', ...
  ' >> [Bc,Ac] = cheby1(N, ripple, passband);', ...
  ' >> h = [abs(hh) abs(freqz(Bb,Ab,n)) abs(freqz(Bc,Ac,n))];', ...
  ' >> plot(ff,h)', ...
  ' >> title(''YuleWalk, Butterworth and Chebyshev filters'')' ...
);
ssdisp(figNumber,str);                                           

if sspause(figNumber), return; end;


plot(ff(2:n),20*log10(h(2:n,:)))
title('YuleWalk, Butterworth and Chebyshev filters')
xlabel('Frequency (Hz)')
ylabel('Magnitude in dB')

str = str2mat( ...
  ' Finally, we look at the frequency response on a logarithmic', ...
  ' decibel (dB) scale.', ...
  ' ', ...
  ' >> plot(ff(2:n),20*log10(h(2:n,:)))', ...
  ' >> title(''YuleWalk, Butterworth and Chebyshev filters'')', ...
  ' >> xlabel(''Frequency (Hz)'')', ...
  ' >> ylabel(''Magnitude in dB'')' ...
);
ssdisp(figNumber,str);                                           

% End of the demo ========================
