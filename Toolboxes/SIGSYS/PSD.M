function [Pxx, Pxxc, f] = psd(P1, P2, P3, P4, P5, P6, P7)
% PSD	Power Spectral Density estimate
%	Pxx = PSD(X,NFFT,Fs,WINDOW) estimates the Power Spectral Density of 
%	signal vector X using Welch's averaged periodogram method.  X is 
%	divided into overlapping sections, each of which is detrended, then
%	windowed by the WINDOW parameter, then zero-padded to length NFFT.  
%	The magnitude squared of the length NFFT DFTs of the sections are 
%	averaged to form Pxx.  Pxx is length NFFT/2+1 for NFFT even, (NFFT+1)/2
%	for NFFT odd, or NFFT if the signal X is complex.  If you specify a 
%	scalar for WINDOW, a Hanning window of that length is used.  Fs is the 
%	sampling frequency which doesn't effect the spectrum estimate but is 
%	used for scaling of plots.
%
%	[Pxx,F] = PSD(X,NFFT,Fs,WINDOW,NOVERLAP) returns a vector of frequen-
%	cies the same size as Pxx at which the PSD is estimated, and overlaps
%	the sections of X by NOVERLAP samples.
%
%	[Pxx, Pxxc, F] = PSD(X,NFFT,Fs,WINDOW,NOVERLAP,P) where P is a scalar
%	between 0 and 1, returns the P*100% confidence interval for Pxx.
%
%	PSD(X,...,DFLAG), where DFLAG can be 'linear', 'mean' or 'none', 
%	specifies a detrending mode for the prewindowed sections of X.
%	DFLAG can take the place of any parameter in the parameter list
%	(besides X) as long as it is last, e.g. PSD(X,'none');
%	
%	PSD with no output arguments plots the PSD in the current figure window,
%	with confidence intervals if you provide the P parameter.
%
%	The default values for the parameters are NFFT = 256 (or LENGTH(X),
%	whichever is smaller), NOVERLAP = 0, WINDOW = HANNING(NFFT), Fs = 2, 
%	P = .95, and DFLAG = 'linear'.  You can obtain a default parameter by 
%	leaving it off or inserting an empty matrix [], e.g. PSD(X,[],10000).

% 	Author(s): T. Krauss, 3-26-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%       $Revision: 1.12 $  $Date: 1994/01/25 17:59:38 $

error(nargchk(1,7,nargin))
[msg,x,y,nfft,Fs,window,noverlap,p,dflag]=eval(optargs('psdchk',nargin,''));
error(msg)

% compute PSD
x = x(:);		% Make sure x is a column vector
window = window(:);
n = length(x);		% Number of data points
nwind = length(window); % length of window
if n < nwind    % zero-pad x if it has length less than the window length
    x(nwind)=0;  n=nwind;
end
k = fix((n-noverlap)/(nwind-noverlap));	% Number of windows
					% (k = fix(n/nwind) for noverlap=0)

if 0
    disp(sprintf('   x        = (length %g)',length(x)))
    disp(sprintf('   y        = (length %g)',length(y)))
    disp(sprintf('   nfft     = %g',nfft))
    disp(sprintf('   Fs       = %g',Fs))
    disp(sprintf('   window   = (length %g)',length(window)))
    disp(sprintf('   noverlap = %g',noverlap))
    if ~isempty(p)
        disp(sprintf('   p        = %g',p))
    else
        disp('   p        = undefined')
    end
    disp(sprintf('   dflag    = ''%s''',dflag))
    disp('   --------')
    disp(sprintf('   k        = %g',k))
end

index = 1:nwind;
KMU = k*norm(window)^2;	% Normalizing scale factor ==> asymptotically unbiased
% KMU = k*sum(window)^2;% alt. Nrmlzng scale factor ==> peaks are about right

Spec = zeros(nfft,1); Spec2 = zeros(nfft,1);
for i=1:k
    if strcmp(dflag,'linear')
        xw = window.*detrend(x(index));
    elseif strcmp(dflag,'none')
        xw = window.*(x(index));
    else
        xw = window.*detrend(x(index),0);
    end
    index = index + (nwind - noverlap);
    Xx = abs(fft(xw,nfft)).^2;
    Spec = Spec + Xx;
    Spec2 = Spec2 + abs(Xx).^2;
end

% Select first half
if ~any(any(imag(x)~=0)),   % if x is not complex
    if rem(nfft,2),    % nfft odd
        select = (1:(nfft+1)/2)';
    else
        select = (1:nfft/2+1)';
    end
    Spec = Spec(select);
    Spec2 = Spec2(select);
%    Spec = 4*Spec(select);     % double the signal content - essentially
% folding over the negative frequencies onto the positive and adding.
%    Spec2 = 16*Spec2(select);
else
    select = (1:nfft)';
end
Spec = Spec*(1/KMU);
freq_vector = (select - 1)*Fs/nfft;

% find confidence interval if needed
if (nargout == 3)|((nargout == 0)&~isempty(p)),
    if isempty(p),
        p = .95;    % default
    end
    confid = zeros(size(Spec));
    if k > 1
        c = (k.*Spec2-abs(Spec).^2)./(k-1);
        c = max(c,zeros(size(Spec)));
        confid = sqrt(c);
    end
    ff = sqrt(2)*erfinv(p);  % Equal-tails.
    confid = (ff.*confid)*(1/KMU);

    % compute variance using Welch's equation (6.112 in Rabiner and Gold)
    % (assumes underlying Gaussian process)
    % D = nwind - noverlap;
    % wcorr = xcorr(window,window);
    % rho = (wcorr((nwind+D):D:length(wcorr))/wcorr(nwind)).^2
    % var = abs(Spec).^2/k*( 1 +  (k-(1:length(rho)))*rho(:)*(2/k) );

    % if exist('chi2inv')==2   % Statistics Tlbx?
    %     % Confidence interval from Kay, p. 76, eqn 4.16:
    %     alfa = 1 - p;
    %     confid = 2*k*Spec*(1./chi2inv([1-alfa/2 alfa/2],2*k));
    %     % (first column is lower edge of conf int., 2nd col is upper edge)
    % end

    if noverlap > 0
        disp('Warning: confidence intervals inaccurate for NOVERLAP > 0.')
    end
end

% set up output parameters
if (nargout == 3),
   Pxx = Spec;
   Pxxc = confid;
   f = freq_vector;
elseif (nargout == 2),
   Pxx = Spec;
   Pxxc = freq_vector;
elseif (nargout == 1),
   Pxx = Spec;
elseif (nargout == 0),
   if ~isempty(p),
       P = [Spec max(Spec-confid,0) Spec+confid];
   else
       P = Spec;
   end
   newplot;
   plot(freq_vector,10*log10(abs(P))), grid
   xlabel('Frequency'), ylabel('Power Spectrum Magnitude (dB)');
end
