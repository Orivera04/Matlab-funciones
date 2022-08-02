function [num, den, z, p] = butter(n, Wn, ftype, anaflag)
%BUTTER	Butterworth digital and analog filter design.
%	[B,A] = BUTTER(N,Wn) designs an N'th order lowpass digital
%	Butterworth filter and returns the filter coefficients in length
%	N+1 vectors B and A.  The cut-off frequency Wn must be
%	0.0 < Wn < 1.0, with 1.0 corresponding to half the sample rate.
%
%	If Wn is a two-element vector, Wn = [W1 W2], BUTTER returns an 
%	order 2N bandpass filter with passband  W1 < W < W2.
%	[B,A] = BUTTER(N,Wn,'high') designs a highpass filter.
%	[B,A] = BUTTER(N,Wn,'stop') is a bandstop filter if Wn = [W1 W2].
%	
%	When used with three left-hand arguments, as in
%	[Z,P,K] = BUTTER(...), the zeros and poles are returned in
%	length N column vectors Z and P, and the gain in scalar K. 
%
%	When used with four left-hand arguments, as in
%	[A,B,C,D] = BUTTER(...), state-space matrices are returned.
%
%	BUTTER(N,Wn,'s'), BUTTER(N,Wn,'high','s') and BUTTER(N,Wn,'stop','s')
%	design analog Butterworth filters.  In this case, Wn can be bigger
%	than 1.0.
%
%	See also BUTTORD, BESSELF, CHEBY1, CHEBY2, ELLIP, FREQZ and FILTER.

%	Author(s): J.N. Little, 1-14-87
%		   J.N. Little, 1-14-88, revised
%		   L. Shure, 4-29-88, revised
%		   T. Krauss, 3-24-93, revised
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.8 $  $Date: 1994/01/25 17:58:43 $

%	References:
%	  [1] T. W. Parks and C. S. Burrus, Digital Filter Design,
%	      John Wiley & Sons, 1987, chapter 7, section 7.3.3.

btype = 1;
if (nargin == 3),
	if strcmp(ftype,'s'),
		analog = 1;
	elseif strcmp(ftype,'z')
		analog = 0;
        else    % band-stop or high-pass
		btype = 3;  analog = 0;
	end
elseif (nargin == 4)
	if strcmp(anaflag,'s'),
		analog = 1;
	elseif strcmp(anaflag,'z')
		analog = 0;
        else
		error('last input argument should be ''s'' or ''z''.');
	end
	btype = 3;  % band-stop or high-pass
else
	analog = 0;
end
if max(size(Wn)) == 2
	btype = btype + 1;
end

% step 1: get analog, pre-warped frequencies
if ~analog,
	fs = 2;
	u = 2*fs*tan(pi*Wn/fs);
else
	u = Wn;
end

% step 2: convert to low-pass prototype estimate
if btype == 1	% lowpass
	Wn = u;
elseif btype == 2	% bandpass
	Bw = u(2) - u(1);
	Wn = sqrt(u(1)*u(2));	% center frequency
elseif btype == 3	% highpass
	Wn = u;
elseif btype == 4	% bandstop
	Bw = u(2) - u(1);
	Wn = sqrt(u(1)*u(2));	% center frequency
end

% step 3: Get N-th order Butterworth analog lowpass prototype
[z,p,k] = buttap(n);

% Transform to state-space
[a,b,c,d] = zp2ss(z,p,k);

% step 4: Transform to lowpass, bandpass, highpass, or bandstop of desired Wn
if btype == 1		% Lowpass
	[a,b,c,d] = lp2lp(a,b,c,d,Wn);

elseif btype == 2	% Bandpass
	[a,b,c,d] = lp2bp(a,b,c,d,Wn,Bw);

elseif btype == 3	% Highpass
	[a,b,c,d] = lp2hp(a,b,c,d,Wn);

elseif btype == 4	% Bandstop
	[a,b,c,d] = lp2bs(a,b,c,d,Wn,Bw);
end

% step 5: Use Bilinear transformation to find discrete equivalent:
if ~analog,
	[a,b,c,d] = bilinear(a,b,c,d,fs);
end

if nargout == 4
	num = a;
	den = b;
	z = c;
	p = d;
else	% nargout <= 3
% Transform to zero-pole-gain and polynomial forms:
	if nargout == 3
		[z,p,k] = ss2zp(a,b,c,d,1);
		num = z;
		den = p;
		z = k;
	else % nargout <= 2
		den = poly(a);
		num = poly(a-b*c)+(d-1)*den;
	end
end

