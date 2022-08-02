function html = asbhelp(fileStr)
% ASBHELP Aerospace Blockset on-line help function.
%   Points Web browser to the HTML help file corresponding to this
%   Aerospace Blockset block.  The current block is queried for its MaskType.
%
%   Typical usage:
%      set_param(gcb,'MaskHelp','web(asbhelp);');

% Copyright 1990-2003 The MathWorks, Inc.
% $Revision: 1.2.2.6 $ $Date: 2004/04/06 01:03:56 $

if ~isempty(nargchk(0,1,nargin))
   error('aeroblks:asbhelp:invalidnumberinputs','Too many inputs');
end

d = docroot;

if isempty(d),
   % Help system not present:
   html = ['file:///' matlabroot '/toolbox/aeroblks/aeroblks/asbherr.html'];
else
   if nargin < 1
      % Derive help file name from mask type:
      html_file = getblock_help_file(gcb);
   else
      % Derive help file name from fileStr argument:
      html_file = getarg_help_file(fileStr);
   end
   
   % Construct full path to help file.
   % Use 3 forward slashes for portability of HTML file paths:
   html = ['file:///' d '/toolbox/aeroblks/' html_file];
end
return

% --------------------------------------------------------
function html_file = getarg_help_file(fileStr)

html_file = help_name(fileStr);
return


% --------------------------------------------------------
function help_file = getblock_help_file(blk)

% Version 1.1 libraries:
s = aeroliblist;
libsv2 = s.aero11;

refBlock = get_param(blk,'ReferenceBlock'); 
if ~isempty(refBlock) 
   sys = get_param(refBlock,'Parent'); 
else 
   sys = get_param(blk,'Parent');
end 

if isempty(strmatch(sys,libsv2,'exact'))
   % Not a version 1.1 block, no online help is available.
   fileStr = 'noaerospaceblocksethelp';
   
else
   % Version 1.1  block, online help is available:
   
   % Only masked Aerospace Blockset blocks call asbhelp, so if
   % we get here, we know we can get the MaskType string.
   fileStr = get_param(blk,'MaskType');
end

help_file = help_name(fileStr);

return

% ---------------------------------------------------------
function y = help_name(x)
% Returns proper help-file name
%
% Invoke same naming convention as used with the
% auto-generated help conversions for the blockset
% on-line manuals.
%
% - only allow a-z, 0-9, and underscore
% - truncate to 25 chars max, plus ".html"

if isempty(x), x='default'; end
y = lower(x);
y = y(isvalidchar(y));  % Remove invalid characters
if length(y)>40, y=y(1:40); end
y = [y '.html'];

return


% ---------------------------------------------------------
function y = isvalidchar(x)
y = isletter(x) | isdigit(x) | isunder(x) | isperiod(x);
return


% ---------------------------------------------------------
function y = isdigit(x)
y = (x>='0' & x<='9');
return


% ---------------------------------------------------------
function y = isunder(x)
y = (x=='_');
return

% ---------------------------------------------------------
function y = isperiod(x)
y = (x=='.');
return


% [EOF] asbhelp.m


