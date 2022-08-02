function k=mmfindstr(s1,s2)
%MMFINDSTR Find First String in Second String. (MM)
% MMFINDSTR(S1,S2) returns starting indices of nonoverlapping
% occurances of S2 in S1.
%
% This is different from FINDSTR In MATLAB in two ways.
% For example:
% S1 = 'How much woood would a wooodchuck chuck?';
% FINDSTR(S1,'oo')   returns [11 12 25 26]   % includes overlaps
% MMFINDSTR(S1,'oo') returns [11 25]         % nonoverlapping only
%
% FINDSTR('oo',S1)   returns [11 12 25 26]   % commutative
% MMFINDSTR('oo',S1) returns []              % not commutative

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 1/23/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin~=2 |~ischar(s1) | ~ischar(s2)
   error('Two String Inputs Required.')
end
s1=s1(:)'; s1len=length(s1);
s2=s2(:)'; s2len=length(s2);

if s2len>s1len | s2len==0
   k=[];
elseif s1len==s2len & isequal(s1,s2)
   k=1;
elseif s2len==1
   k=findstr(s1,s2);
else
   k=findstr(s1,s2);
   i=1;
   while i<length(k) % throw out overlapping finds
      k(k>k(i) & k<(k(i)+s2len))=[];
      i=i+1;
   end
end
