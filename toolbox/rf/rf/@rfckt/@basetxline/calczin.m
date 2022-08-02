function Z_in = calczin(h, freq, zterm)
%Z_IN = CALCZIN(H, FREQ, ZTERM) calculate the input impedance of a transmission line stub.

%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/20 23:19:32 $

error(nargchk(2,3,nargin));
% check frequency
freq = checkfrequency(h, freq);
if (isempty(freq))
    id = sprintf('rf:%s:calczin:Freq',strrep(class(h),'.',':'));
    error(id, ['Freq must be a vector whose elements are finite, real ',...
        'and positive.']);
end

% must call calckl first, calckl sets pv, loss and z0.
e_negkl = calckl(h, freq);
termination = get(h, 'Termination');
z0 = get(h, 'Z0');
mode = get(h, 'StubMode');

% check if StubMode is None
if strcmpi(mode, 'None')
    id = sprintf('rf:%s:calczin:StubMode',strrep(class(h),'.',':'));
    error(id, ['Input impedance can be calculated only ',...
        'when StubMode is set to ''Series'' or ''Shunt''.']);
end

% check zterm
if nargin > 2
    [row, col] = size(squeeze(zterm));
    if (~(row == 1) && ~(col == 1)) || ~isnumeric(zterm) || any(isnan(zterm))
        id = sprintf('rf:%s:calczin:ZTerm',strrep(class(h),'.',':'));
        error(id, 'ZTerm must be a vector whose elements are numeric.');
    end
    zterm = zterm(:);
    % Check terminating impedance
    if length(zterm) ~= length(freq) && length(zterm) ~= 1
        id = sprintf('rf:%s:calczin:ZTermFreq',strrep(class(h),'.',':'));
        error(id, 'Length of ZTerm must equal length of freq or 1.');
    end
elseif strcmpi(termination, 'Short')
    zterm = 0;
elseif strcmpi(termination, 'Open')
    zterm = inf;
else
    % if termination is empty
    id = sprintf('rf:%s:calczin:TerminationEmpty',strrep(class(h),'.',':'));
    warning(id, ['Termination of the transmission line stub is ',...
        'assumed to be open circuit ', sprintf('\n'), ...
        'in calculation of its input impedance when Termination ',...
        'is specified as ''None''.']);
    zterm = inf;
end
    
% Check z0
if length(z0) == 1
    z0 = z0*ones(size(freq));
elseif length(z0) ~= length(freq);
    id = sprintf('rf:%s:calczin:Z0Freq',strrep(class(h),'.',':'));
    error(id, 'Length of Z0 must equal length of freq or 1.');
end

e_kl = 1./e_negkl;
% Refer to page 75 of RF Circuit Design by Reinhold Ludwig
tempA = e_kl + e_negkl;
tempB = e_kl - e_negkl;

% Handle stub terminated with Inf impedance
if isinf(zterm)
    Z_in = tempA./tempB.*z0;
else
    Z_in = (zterm.*tempA + z0.*tempB)./(zterm.*tempB + z0.*tempA).*z0;
end
