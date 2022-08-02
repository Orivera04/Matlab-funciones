function c=mmcellstr(arg,sep)
%MMCELLSTR Create Cell Array of Strings. (MM)
% MMCELLSTR(S) converts the character array S into a cell
% array of strings. S may have any of the following forms:
%
% S = A row vector string containing new line characters or
%     vertical separators '|'. In this case the cells contain
%     the corresponding strings appearing between separators.
%     If new lines are found in S, '|' characters are ignored.
%     Initial and final separators are optional.
%     Example: S='one|two|three'     S='|one|two|three'
%     S=sprintf('one\ntwo\nthree\n') S=sprintf('\none\ntwo\nthree\n')
%     all return {'one' 'two' 'three'}
% S = A standard 2D string array such as that created by CHAR.
%     In this case each cell contains the corresponding deblanked row.
%     This is the same function as CELLSTR, but is approximately
%     three times faster.
%
% MMCELLSTR(S,SEP) alternatively uses the single character SEP as
% the separating character about which to create cells.

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 6/5/99, 12/11/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<1 | ~ischar(arg)
   error('One String Input Argument Required.')
end
if ndims(arg)~=2
   error('Input Must be 2D.')
end
rows=size(arg,1);
if rows>1 % string array input
   c=cell(rows,1);
   n=mmfindrc(arg~=0&~isspace(arg),1);
   for i=1:rows
      c{i}=arg(i,1:n(i));
   end
else % row vector input
   if nargin==2 % SEP supplied
      if ~ischar(sep) | length(sep)>1
         error('SEP Must be a Single Character.')
      end
   else % find SEP
      sep=sprintf('\n'); % look for new lines first
      isep=find(sep==arg);
      if isempty(isep)
         sep='|';
         isep=find(sep==arg);
         if isempty(isep) % no separators, early exit
            c{1}=deblank(arg);
            return
         end
      end
   end
   if arg(1)~=sep % begin with a SEP
      arg=[sep arg];
   end
   if arg(end)~=sep % end with a SEP
      arg=[arg sep];
   end
   isep=find(sep==arg);
   n=length(isep)-1;
   c=cell(n,1);
   for i=1:n
      c{i}=arg(isep(i)+1:isep(i+1)-1);
   end
end