function d=mmempty(a,b)
%MMEMPTY Substitute Value if Empty. (MM)
% MMEMPTY(A,B) returns A if A is not empty,
% otherwise B is returned.
%
% Example: the empty array problem in logical statements
% let a=[]; then use MMEMPTY to set default logical state
% (a==1) is false, but MMEMPTY(a,1)==1 is true 
% (a==0) is false, but MMEMPTY(a,0)==0 is true
% Also:
% sum(a) is 0,  but sum(MMEMPTY(a,b))=sum(b)
% prod(a) is 1, but prod(MMEMPTY(a,b))=prod(b)
% find(a~=0) is 1, but find(MMEMPTY(a,0)~=0) is []
%
% See also ISEMPTY, SUM, PROD, FIND

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 8/26/96
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if isempty(a)
   d=b;
else
   d=a;
end
