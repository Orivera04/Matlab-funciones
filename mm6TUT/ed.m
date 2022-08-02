function ed(varargin)
%ED Shortcut for Edit. (MM)
% ED filename or ED('filename') is a shortcut for EDIT filename
% ED filename1 filename2 ... opens all specified files.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 6/14/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==0
   disp('String Input Argument Expected.')
end
for i=1:nargin
   arg=varargin{i};
   if ischar(arg)
      arg(end+1:end+2)='.m';
      if exist(arg,'file')
         edit(arg)
      else
         disp(['Can''t find file ' arg])
      end
   end
end
