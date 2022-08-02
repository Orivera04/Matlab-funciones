function aerolib(v)
%AEROLIB Open Aerospace Blockset library.
%  AEROLIB opens the latest version of Aerospace Blockset.
%
%  AEROLIB(V) opens major version number V of the Aerospace Blockset, 
%  where V may currently be 1.
%  AEROLIB V will also open version V.
%
%  Other information available for the Aerospace Blockset:
%    help aeroblks   - to view the Contents file
%    info aeroblks   - to view the Readme file
%
%    help aerodemos - Summary of Aerospace Blockset demonstrations and examples

% Copyright 1990-2003 The MathWorks, Inc.
% $Revision: 1.4.2.3 $  $Date: 2004/04/06 01:03:55 $

if ~isempty(nargchk(0,1,nargin))
   error('aeroblks:aerolib:invalidnumberinputs','Too many inputs');
end

% Default is current version of Aerospace Blockset:
if nargin == 0,
   vs = '1';
else
   % Argument could be a number or a string, due to command/fcn duality:
   if ischar(v),
      vs = v;
   else
      % Ignore any minor version numbers (fractions) specified
      vs = num2str(floor(v));
   end   
end

% Attempt to open library:
if strcmp(vs,'0')
   model = 'aerospace';
else
   model = ['aerolibv' vs];
end
try
   open_system(model);
catch
   error('aeroblks:aerolib:invalidmodelname',['Could not find Aerospace Blockset version ' vs ' (' model '.mdl).']);
end

% end of aerolib.m
