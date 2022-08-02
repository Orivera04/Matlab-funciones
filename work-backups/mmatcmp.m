function tf=mmatcmp(a,b)
%MMATCMP True if MAT File Contents are Equal. (MM)
% MMATCMP('File1','File2') returns logical TRUE (1) if the contents of
% the two MAT files are equal. They are equal if they contain both the
% same variables and those variables contain the same values.
% Otherwise logical False (0) is returned.
%
% Because the function ISEQUAL returns 0 when any of its input arguments
% contain NaN's, this function returns 0 when either file contains NaN's.
% As a result, two MAT files may be equal but MMATCMP will return False
% if they contain NaN's in the same locations. By definition NaN's are 
% never equal.

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 6/14/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

% Note tf=isequal(load(a),load(b)); works but uses lots of memory 
% if a and b contain large variables. So avoid loading all that data...

tf=logical(0);
if nargin~=2 | ~ischar(a) | ~ischar(b)
   error('Two String Input Arguments are Required.')
end
if length(a)<4 | ~strcmp(lower(a(end-3:end)),'.mat')
   a=[a '.mat'];
end
if length(b)<4 | ~strcmp(lower(b(end-3:end)),'.mat')
   b=[b '.mat'];
end
if exist(a,'file')~=2
   error('Can''t Find First File')
end
if exist(b,'file')~=2
   error('Can''t Find Second File')
end
sa=whos('-file',a); % grab info on what's in the files
lsa=length(sa);
sb=whos('-file',b);
lsb=length(sb);

if lsa==lsb % same # of variables in each file, so check each one
   anames=char(sa.name); % poke names in a into a string array
   [anames,idx]=sortrows(anames);
   sa=sa(idx);
   bnames=char(sb.name); % poke names in b into a string array
   [bnames,idx]=sortrows(bnames);
   sb=sb(idx); % indices and names now line up in a and b
   if ~isequal(anames,bnames) % names not equal
      return
   elseif ~isequal(char(sa.class),char(sb.class)) % classes not equal
      return
   elseif ~isequal(cat(1,sa.size),cat(1,sb.size)) % sizes not equal
      return
   elseif ~isequal(cat(1,sa.bytes),cat(1,sb.bytes)) % bytes not equal
      return
   else % contents of each variable in each file
      for i=1:lsa % load individually to save memory
         if ~isequal(load(a,anames(i)),load(b,anames(i)))
            return % contents of like named variables not equal
         end
      end
   end
   tf=logical(1); % passed all tests, return True
end