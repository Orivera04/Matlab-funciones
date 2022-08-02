function [tok,rem]=mmstrtok(s,d)
%MMSTRTOK Find Tokens in a String. (MM)
% MMSTRTOK(S,D) returns a cell array containing all tokens in
% the string S delimited by any of the characters in D. If D
% is empty of not given, white space is assumed.
% Leading delimiter characters are ignored.
%
% [Tok,Rem]=MMSTRTOK(S) or [Tok,Rem]=MMSTRTOK(S,D) returns a
% single token and remainder string just as STRTOK does.
% Tok and Rem are both string arrays.
%
% S and/or D can be a cell array of strings.
%
% This function is 10 to 30 times faster than STRTOK.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 11/29/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<2 | isempty(d)
   d=char([9:13 32]); % white space characters
end
if iscellstr(s)
   s=char(s);
end
if iscellstr(d)
   d=char(d);
end
if ~ischar(s) | ~ischar(d)
   error('Inputs Must be Strings or Cell Strings.')
end
s=[d(1) s(:)' d(1)];
idx=find(ismember(s,d));
tmp=[idx(1:end-1)+1;idx(2:end)-1];
tmp=tmp(:,find(tmp(1,:)<=tmp(2,:)));
if nargout==2
   if size(tmp,2)>0 % get first token and remainder
      tok=s(tmp(1,1):tmp(2,1));
      rem=s(tmp(2,1)+1:end);
   else % no token found
      tok='';
      rem='';
   end
else % get all tokens
   tok=cell(size(tmp,2),1);
   for k=1:size(tmp,2)
      tok{k}=s(tmp(1,k):tmp(2,k));
   end
end
