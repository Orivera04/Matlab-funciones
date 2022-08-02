function c=mmclass(arg)
%MMCLASS MATLAB Object Class Existence. (MM)
% MMCLASS returns a cell array of strings containing the
% names of MATLAB object classes available with this license.
% 
% MMCLASS('ClassName') returns logical True (1) if the class
% having the name 'ClassName' exists with this license.
% Otherwise logical False (0) is returned.
%
% MMCLASS searches the MATLABPATH for class directories.
% Classes not on the MATLABPATH are ignored.
%
% See also CLASS, ISA, METHODS, ISOBJECT

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 2/24/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

persistent clist  % save data for future calls

if isempty(clist)
   clist=cell(0);
   cstar=[filesep '@*'];
   dlist=[pathsep matlabpath];
   sidx=findstr(pathsep,dlist)+1;      % path segment starting indices
   eidx=[sidx(2:end)-2 length(dlist)]; % path segment ending indices
   
   for i=1:length(sidx)-1   % look at each path segment
      cdir=dir([dlist(sidx(i):eidx(i)) cstar]); % dir @* on segment
      clist=[clist {cdir.name}];                % add results to list
   end
   clist=char(clist);         % convert to string array
   clist(:,1)=[];             % eliminate initial '@'
   clist=unique(clist,'rows');% alphabetize and make unique
   clist=cellstr(clist);      % back to a cell array
end
if nargin==0
   c=clist;
elseif ischar(arg)
   c=~isempty(strmatch(arg,clist));
else
   error('Character String Argument Expected.')
end