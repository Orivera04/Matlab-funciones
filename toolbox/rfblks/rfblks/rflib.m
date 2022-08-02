function rflib(varargin)
% RFLIB Open The RF Blockset
%
%  RFLIB opens the latest version of the RF Blockset.
% 
%  RFLIB(N) opens version number N of the RF Blockset, 
%  where N may currently be 1.0.
%  RFLIB N also opens version N.
%
%  The RF Blockset has the following tree structure:
%
%    RFLIBV1            Main Library
%      RFMATHMODELS1      RF Mathematical Sub-library
%      RFPHYSMODELS1      RF Physical Models Sub-library
%        RFLADDERFILTERS1   Sub-library of RF Laddder Filters
%        RFTXLINES1         Sub-library of RF Transmission Lines
%        RFBLACKBOX1        Sub-library of RF Black Box Elements
%        RFAMPLIFIERS1      Sub-library of RF Amplifiers
%        RFMIXERS1          Sub-library of RF Mixers
%        RFPORTS1           Sub-library of RF Input/Output Ports

%       Copyright 2003-2004 The MathWorks, Inc.
%       $Revision: 1.1.6.6 $  $Date: 2004/04/12 23:40:12 $


error(nargchk(0,1,nargin));

if (nargin == 0)
   v = '1';
else
   v = varargin{1};    
end;

if ischar(v)
	vs = v;
elseif isnumeric(v)
   vs = num2str(double(v));
else
   error('The RF Blockset version number must be a string or numeric value.');
end;

switch vs
case {'1' '1.0'}
	vs = '1';    
otherwise
    error(['Unknown version of the RF Blockset.']);
end;

% Attempt to open library:
model = ['rflibv' vs];
try
   open_system(model);
catch
   error(['Could not find RF Blockset version ' vs ' (' model '.mdl).']);
end

% [EOF]
