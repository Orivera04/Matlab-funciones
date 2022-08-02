function [yo,fo,to] = specgram(P1,P2,P3,P4,P5)
%SPECGRAM Calculate spectrogram from signal.
%	B = SPECGRAM(A,NFFT,Fs,WINDOW,NOVERLAP) calculates the spectrogram for 
%	the signal in vector A.  SPECGRAM splits the signal into overlapping 
%	segments, windows each with the WINDOW vector and forms the columns of
%	B with their zero-padded, length NFFT discrete Fourier transforms.  Thus
%	each column of B contains an estimate of the short-term, time-localized
%	frequency content of the signal A.  Time increases linearly across the 
%	columns of B, from left to right.  Frequency increases linearly down 
%	the rows, starting at 0.  If A is a length NX complex signal, B is a 
%	complex matrix with NFFT rows and 
%	     k = fix((NX-NOVERLAP)/(length(WINDOW)-NOVERLAP)) 
%	columns.  If A is real, B still has k columns but the higher frequency
%	components are truncated (because they are redundant); in that case,
%	SPECGRAM returns B with NFFT/2+1 rows for NFFT even and (NFFT+1)/2 rows 
%	for NFFT odd.  If you specify a scalar for WINDOW, SPECGRAM uses a 
%	Hanning window of that length.  WINDOW must have length smaller than
%	or equal to NFFT and greater than NOVERLAP.  NOVERLAP is the number of
%	samples the sections of A overlap.  Fs is the sampling frequency
%	which does not effect the spectrogram but is used for scaling plots.
%
%	[B,F,T] = SPECGRAM(A,NFFT,Fs,WINDOW,NOVERLAP) returns a column of 
%	frequencies F and one of times T at which the spectrogram is computed.
%	F has length equal to the number of rows of B, T has length k. If you 
%	leave Fs unspecified, SPECGRAM assumes a default of 2 Hz.
%
%	B = SPECGRAM(A) produces the spectrogram of the signal A using default
%	settings; the defaults are NFFT = minimum of 256 and the length of A, a
%	Hanning window of length NFFT, and NOVERLAP = length(WINDOW)/2.  You 
%	can tell SPECGRAM to use the default for any parameter by leaving it 
%	off or using [] for that parameter, e.g. SPECGRAM(A,[],1000)
%
%	SPECGRAM with no output arguments plots the absolute value of the 
%	spectrogram in the current figure, using IMAGESC(T,F,20*log10(ABS(B))),
%	AXIS XY, COLORMAP(JET) so the low frequency content of the first 
%	portion of the signal is displayed in the lower left corner of the axes.
%
%	See also PSD

%       Author(s): L. Shure, 1-1-91
%		   T. Krauss, 4-2-93, updated
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%       $Revision: 1.21 $  $Date: 1994/01/25 17:59:57 $

error(nargchk(1,5,nargin))
[msg,x,y,nfft,Fs,window,noverlap,p,dflag]=eval(optargs('psdchk',nargin,''));
error(msg)
    
if nargin >= 5
    if isempty(P5)
        noverlap = length(window)/2;
    end
else
    noverlap = length(window)/2;
end

x = x(:); % make a column vector for ease later
nx = length(x);
nwind = length(window);
if nx < nfft    % zero-pad x if it has length less than the window length
    x(nfft)=0;  nx=nfft;
end

% figure out number of columns for offsetting the signal
% this may truncate the last portion of the signal since we'd
% rather not append zeros unnecessarily - also makes the fancy
% indexing that follows more difficult.
ncol = fix((nx-noverlap)/(nwind-noverlap));
y = zeros(nfft,ncol);

% now stuff x into columns of y with the proper offset
% should be able to do this with fancy indexing!
colindex = 1 + (0:(ncol-1))*(nwind-noverlap);
rowindex = (1:nfft)';
x(nfft+colindex(ncol)-1) = 0;   % zero-pad x
y(:) = x(rowindex(:,ones(1,ncol))+colindex(ones(nfft,1),:)-1);
%y = x(rowindex(:,ones(1,ncol))+colindex(ones(nfft,1),:)-1);

% Apply the window to the array of offset signal segments.
y = window(:,ones(1,ncol)).*y(1:nwind,:);

% now fft y which does the columns
y = fft(y,nfft);
if ~any(any(imag(x)))    % x purely real
	if rem(nfft,2),    % nfft odd
		select = [1:(nfft+1)/2];
	else
		select = [1:nfft/2+1];
	end
	y = y(select,:);
else
	select = 1:nfft;
end
f = (select - 1)'*Fs/nfft;
t = (colindex-1)'/Fs;

% take abs, and use image to display results
if nargout == 0
        newplot;
        if length(t)==1
	    imagesc([0 1/f(2)],f,20*log10(abs(y)+eps));axis xy; colormap(jet)
        else
	    imagesc(t,f,20*log10(abs(y)+eps));axis xy; colormap(jet)
        end
	xlabel('Time')
	ylabel('Frequency')
elseif nargout == 1,
	yo = y;
elseif nargout == 2,
	yo = y;
	fo = f;
elseif nargout == 3,
	yo = y;
	fo = f;
	to = t;
end

