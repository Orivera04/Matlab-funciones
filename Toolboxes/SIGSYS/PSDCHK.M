function [msg,x,y,nfft,Fs,window,noverlap,p,dflag] = ...
                               psdchk(P1,P2,P3,P4,P5,P6,P7,P8)
%PSDCHK Helper function for PSD, CSD, COHERE, TFE and SPECGRAM
%	assumes that there are between 1 and 8 arguments on input

%	Author(s): T. Krauss, 10-28-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%       $Revision: 1.2 $  $Date: 1994/01/25 17:59:39 $

if 0,   % forces the interpreter to pass parameters by value, not reference
    P1=P1; P2=P2; P3=P3; P4=P4; P5=P5; P6=P6; P7=P7; P8=P8;
end

msg = [];
if (nargin>1),
    % 0ne signal or 2 present?
    if (all(size(P1)==size(P2))&~isstr(P2)) | (max(size(P2))>1 & ~isstr(P2))
        onesig = 0;      % two signals, x and y, present
        x = P1; y = P2;
        for k = 3:nargin,    % shift parameters one left
            eval(['P' num2str(k-1) ' = P' num2str(k) ';']);
        end
    else 
        onesig = 1;      % only one signal, x, present
        x = P1; y = []; 
    end
else  % nargin == 1
    onesig = 1;      % only one signal, x, present
    x = P1; y = []; 
end

% now x and y are defined; let's get the rest

if nargin == (1 + (1-onesig)),
    nfft = min(length(x),256);
    window = hanning(nfft);
    noverlap = 0;
    Fs = 2;
    p = [];
    dflag = 'linear';
elseif nargin == (2 + (1-onesig)),
    if isempty(P2),   dflag = 'linear'; nfft = min(length(x),256); 
    elseif isstr(P2), dflag = P2;       nfft = min(length(x),256); 
    else              dflag = 'linear'; nfft = P2;   end
    Fs = 2;
    window = hanning(nfft);
    noverlap = 0;
    p = [];
elseif nargin == (3 + (1-onesig)),
    if isempty(P2), nfft = min(length(x),256); else nfft=P2;     end
    if isempty(P3),   dflag = 'linear'; Fs = 2;
    elseif isstr(P3), dflag = P3;       Fs = 2;
    else              dflag = 'linear'; Fs = P3; end
    window = hanning(nfft);
    noverlap = 0;
    p = [];
elseif nargin == (4 + (1-onesig)),
    if isempty(P2), nfft = min(length(x),256); else nfft=P2;     end
    if isempty(P3), Fs = 2;     else    Fs = P3; end
    if isstr(P4)
        dflag = P4;
        window = hanning(nfft);
    else
        dflag = 'linear';
        window = P4;
        if length(window) == 1, window = hanning(window); end
        if isempty(window), window = hanning(nfft); end
    end
    noverlap = 0;
    p = [];
elseif nargin == (5 + (1-onesig)),
    if isempty(P2), nfft = min(length(x),256); else nfft=P2;     end
    if isempty(P3), Fs = 2;     else    Fs = P3; end
    window = P4;
    if length(window) == 1, window = hanning(window); end
    if isempty(window), window = hanning(nfft); end
    if isstr(P5)
        dflag = P5;
        noverlap = 0;
    else
        dflag = 'linear';
        if isempty(P5), noverlap = 0; else noverlap = P5; end
    end
    p = [];
elseif nargin == (6 + (1-onesig)),
    if isempty(P2), nfft = min(length(x),256); else nfft=P2;     end
    if isempty(P3), Fs = 2;     else    Fs = P3; end
    window = P4;
    if length(window) == 1, window = hanning(window); end
    if isempty(window), window = hanning(nfft); end
    if isempty(P5), noverlap = 0; else noverlap = P5; end
    if isstr(P6)
        dflag = P6;
        p = [];
    else
        dflag = 'linear';
        if isempty(P6), p = .95;    else    p = P6; end
    end
elseif nargin == (7 + (1-onesig)),
    if isempty(P2), nfft = min(length(x),256); else nfft=P2;     end
    if isempty(P3), Fs = 2;     else    Fs = P3; end
    window = P4;
    if length(window) == 1, window = hanning(window); end
    if isempty(window), window = hanning(nfft); end
    if isempty(P5), noverlap = 0; else noverlap = P5; end
    if isempty(P6), p = .95;    else    p = P6; end
    if isstr(P7)
        dflag = P7;
    else
        msg = 'DFLAG parameter must be a string.'; return
    end
end

% NOW do error checking
if (nfft<length(window)), 
    msg = 'Requires window''s length to be no greater than the FFT length.';
end
if (noverlap >= length(window)),
    msg = 'Requires NOVERLAP to be strictly less than the window length.';
end
if (nfft ~= abs(round(nfft)))|(noverlap ~= abs(round(noverlap))),
    msg = 'Requires positive integer values for NFFT and NOVERLAP.';
end
if ~isempty(p),
    if (prod(size(p))>1)|(p(1,1)>1)|(p(1,1)<0),
        msg = 'Requires confidence parameter to be a scalar between 0 and 1.';
    end
end
if min(size(x))~=1,
    msg = 'Requires vector (either row or column) input.';
end
if (min(size(y))~=1)&(~isempty(y)),
    msg = 'Requires vector (either row or column) input.';
end
if (length(x)~=length(y))&(~isempty(y)),
    msg = 'Requires X and Y be the same length.';
end

dflag = lower(dflag);
if strcmp(dflag,'l')|strcmp(dflag,'li')|strcmp(dflag,'lin')| ...
   strcmp(dflag,'line')|strcmp(dflag,'linea')|strcmp(dflag,'linear')
      dflag = 'linear';
elseif strcmp(dflag,'m')|strcmp(dflag,'me')|strcmp(dflag,'mea')| ...
   strcmp(dflag,'mean')
      dflag = 'mean';
elseif strcmp(dflag,'n')|strcmp(dflag,'no')|strcmp(dflag,'non')| ...
   strcmp(dflag,'none')
      dflag = 'none';
else
    msg = 'DFLAG must be ''linear'', ''mean'', or ''none''.';
end
