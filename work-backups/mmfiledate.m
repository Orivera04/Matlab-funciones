function varargout=mmfiledate(varargin)
%MMFILEDATE Get File Modification Date. (MM)
% MMFILEDATE File1 File2 ... displays the file modification dates for
% the listed files. Blank lines are displayed for files that do not exist.
%
% MMFILEDATE('File1','File2',...) returns the file modification dates
% for the listed files in a corresponding cell array of strings. An empty
% cell is returned for listed files that are not in the current directory
% or on the MATLABPATH. If only one input argument is given the output is
% returned as a string array.
%
% [D1,D2,...]=MMFILEDATE('File1','File2',...) returns string array results
% in the corresponding output arguments.

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 6/4/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==0
   error('At least one input argument is required.')
end
switch nargout
case 0 % no output arguments, so just display the results
   loose=strcmp(get(0,'FormatSpacing'),'loose');
   if loose, disp(''), end
   for i=1:nargin
      disp(local_getdate(varargin{i}))
   end
   if loose, disp(''),end
case 1 % 1 output argument
   if nargin==1        % return string array for one input
      d=local_getdate(varargin{1});
   else                % return a cell array for multiple input arguments
      d=cell(1,nargin);
      for i=1:nargin
         d{i}=local_getdate(varargin{i});
      end
   end
   varargout{1}=d;
otherwise % multiple outputs, deal inputs to outputs
   if nargin~=nargout
      error('Number of Outputs Must Match Number of Inputs.')
   end
   for i=1:nargin
      varargout{i}=local_getdate(varargin{i});
   end
end
%-----------------------------------------------------------------
function d=local_getdate(arg)
p=which(arg); % see if file exists
if isempty(p)| strcmp(p,'built-in') | strcmp(p,'variable')
   d='';
else % file exists
   s=dir(p);
   d=s.date;
end