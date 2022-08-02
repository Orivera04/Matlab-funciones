function html = spehelp(blkname)
% SPEHELP Simulink Parameter Estimation on-line help function.
%   Points Web browser to the HTML help file corresponding to this
%   Simulink Parameter Estimation block.  The current block is queried for
%   its MaskType.

% Revised: Bora Eryilmaz
% Copyright 1995-2003 The MathWorks, Inc.
% $Revision: 1.1.6.5 $ $Date: 2004/04/11 00:44:01 $

error(nargchk(0,1,nargin));
d = docroot;

if isempty(d),
  % Help system not present:
  html = ['file:///' matlabroot '/toolbox/slestim/slestim/speherr.html'];
else
   if nargin < 1
      % Derive help file name from mask type:
      html_file = getblock_help_file(gcb);
   else
      % Derive help file name from blkname argument:
      html_file = getarg_help_file(blkname);
   end
   
   % Construct full path to help file.
   % Use 3 forward slashes for portability of HTML file paths:
   html = ['file:///' d '/toolbox/slestim/' html_file];
end

% --------------------------------------------------------------------------- %
function html_file = getarg_help_file(blkname)
html_file = help_name(blkname);

% --------------------------------------------------------------------------- %
function help_file = getblock_help_file(blk)
% Only masked SPE blocks call spehelp, so if
% we get here, we know we can get the MaskType string.
blkname = get_param(blk, 'MaskType');
help_file = help_name(blkname);

% --------------------------------------------------------------------------- %
function y = help_name(x)
% Returns proper help-file name, plus ".html" appended
% - only allow a-z, 0-9, and underscore
% - no longer truncates to 25 chars max
if isempty(x)
  x = 'default';
end
y = lower(x);
y(find(~isvalidchar(y))) = '';  % Remove invalid characters
y = [y '.html'];

% --------------------------------------------------------------------------- %
function y = isvalidchar(x)
y = isletter(x) | isdigit(x) | isunder(x);

% --------------------------------------------------------------------------- %
function y = isdigit(x)
y = (x >= '0' & x <= '9');

% --------------------------------------------------------------------------- %
function y = isunder(x)
y = (x == '_');
