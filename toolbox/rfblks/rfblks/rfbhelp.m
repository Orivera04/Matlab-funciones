function html = rfbhelp(fileStr)
% RFBHELP  Get URL for RF Blockset online help.
%
%   RFBHELP returns the URL of the HTML help file corresponding to
%   the current RF Blockset block.  To do this, the function
%   queries the current block for its MaskType.
%
%   RFBHELP(fname) returns the URL for online help when the
%   string fname is a filename without the .html
%   extension. 
%
%   Typical usage:
%      set_param(gcb,'MaskHelp','helpview(rfbhelp);');

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $  $Date: 2004/04/12 23:40:10 $

error(nargchk(0,1,nargin));
d = docroot;

if nargin < 1
  % Derive help file name from mask type:
  html_file = getblock_help_file(gcb);
else
  % Derive help file name from fileStr argument:
  html_file = help_name(fileStr);
end
html = fullfile(d,'toolbox', 'rfblks', html_file);
html=strrep(html,'\','/'); % To be safe, replace any backslashes
   
if isempty(d),
   error(['Help system is unavailable.  Try using the ',...
           'Web-based documentation set at http://www.mathworks.com']);
end
return

% --------------------------------------------------------
function help_file = getblock_help_file(blk)

% Version 1.0 libraries:
s = rfblksliblist;
libsvcur = s.rfblks10;

linkStatus = lower(get_param(blk,'LinkStatus'));

switch linkStatus
case 'resolved'
   rblock = get_param(blk,'ReferenceBlock');
   sys = get_param(rblock,'Parent');
case 'none'
   sys = get_param(blk,'Parent');
otherwise
   error('Unknown link status reported.');
end

% Only masked RF Blockset blocks call rfbhelp, so if
% we get here, we know we can get the MaskType string.
fileStr = get_param(blk,'MaskType');
help_file = help_name(fileStr);
return

% ---------------------------------------------------------
function y = help_name(x)
% Returns proper help-file name
%
% Invoke same naming convention as used with the
% auto-generated help conversions for the blockset
% online manuals.
%
% - only allow a-z, 0-9, and underscore
% - truncate to 25 chars max, plus ".html"

if isempty(x), x='default'; end
y = lower(x);
y(find(~isvalidchar(y))) = '';  % Remove invalid characters
y = [y '.html'];

return


% ---------------------------------------------------------
function y = isvalidchar(x)
y = isletter(x) | isdigit(x) | isunder(x);
return


% ---------------------------------------------------------
function y = isdigit(x)
y = (x>='0' & x<='9');
return


% ---------------------------------------------------------
function y = isunder(x)
y = (x=='_');
return


% [EOF] rfbhelp.m
