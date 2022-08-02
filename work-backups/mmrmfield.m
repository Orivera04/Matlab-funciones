function [ss,r]=mmrmfield(s,fdel)
%MMRMFIELD Remove Structure Fields (MM)
% MMRMFIELD(S,FName) removes the field identified by the string
% FName from the structure S.
% If FName is a string array or cell array of strings, all
% specified fields are removed.
%
% [S,R]=MMRMFIELD(S,FName) returns S with fields removed in the
% structure S and the removed fields in the structure R.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 6/6/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin~=2
   error('Two Input Arguments Required.')
end
if ~isstruct(s)
   error('First Argument Must be a Structure.')
end
if ~ischar(fdel)&~iscellstr(fdel)
   error('Second Argument Must be a String Array or Cell Array of Strings.')
end
if ischar(fdel)         % convert to cells if char array
   fdel=cellstr(fdel);
end
fnames=fieldnames(s);   % get field names of structure
nf=prod(size(fdel));    % number of fields
idx=zeros(nf,1);        % preallocate
for i=1:nf
   tmp=find(strcmp(fnames,fdel(i)));
   if isempty(tmp)
      error(sprintf('A Field Named  %s  Does Not Exist in S.',fdel{i}))
   end
   idx(i)=tmp(1);       % get index of fieldname to delete
end
c=struct2cell(s);              % convert structure to cells
args=repmat({':'},1,ndims(s)); % generate :,:,... for indexing

if nargout==2  % return removed fields
   r=cell2struct(c(idx,args{:}),fnames(idx),1);
end
c(idx,args{:})=[];          % throw out fields to delete
fnames(idx)=[];             % throw out field names to delete
ss=cell2struct(c,fnames,1); % build new structure from remains