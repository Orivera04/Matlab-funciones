function ss=mmrnfield(s,oldname,newname)
%MMRNFIELD Rename Structure Fields. (MM)
% MMRNFIELD(S,OldName,NewName) returns the structure S with the
% field name denoted by the string OldName changed to NewName.
% Oldname must exist in S.
%
% If OldName and NewName are cell arrays of equal length, each
% field name in OldName is changed to the corresponding element
% in NewName.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 6/8/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin~=3
   error('Three Input Arguments Required.')
end
if ~isstruct(s)
   error('First Argument Must be a Structure.')
end
if ~(ischar(oldname)|iscellstr(oldname))&...
      ~(ischar(newname)|iscellstr(newname))
   error('Last Two Arguments Must be Strings or Cell Strings.')
end
if ischar(oldname)   % convert to cell
   oldname=cellstr(oldname);
end
if ischar(newname)   % convert to cell
   newname=cellstr(newname);
end
nold=length(oldname);
if nold~=length(newname)
   error('OldName and NewName Must Have the Same Length.')
end
fnames=fieldnames(s);      % get field names of structure
idx=zeros(nold,1);         % indices of oldname in fnames
for i=1:nold
   tmp=find(strcmp(fnames,oldname{i}));
   if isempty(tmp)
      error(sprintf('Structure Does Not Contain the Field Name  %s',oldname{i}))
   end
   idx(i)=tmp;
end
fnames(idx)=newname;       % change names of desired fields
c=struct2cell(s);          % convert structure to cell
ss=cell2struct(c,fnames,1);% rebuild structure with changed names
