function y=mmstrcmpl(s1,s2)
%MMSTRCMPL Lexical String Comparison. (MM)
% MMSTRCMPL(S1,S2) compares the string S2 to S1 in the
% dictionary order sense.
% If S2 appears ahead of (less than) S1, -1 is returned,
% if S2 is identical to S1,               0 is returned, and
% if S2 appears after (greater than) S1, +1 is returned.
%
% S1 and S2 are compared ignoring case based on ASCII order.
% If either S1 or S2 is empty, NaN is returned.

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/2/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin~=2 | ~ischar(s1) | ~ischar(s2)
   error('Two String Inputs Required.')
end
if isempty(s1)|isempty(s2)
   y=nan;
   return
end
s1s=size(s1);
s2s=size(s2);
s1l=length(s1);
s2l=length(s2);
if max(s1s)~=s1l | max(s2s)~=s2l
   error('String Arrays Not Allowed.')
end
s=double(char(lower(s1(:)'),lower(s2(:)'))); % stack and convert to doubles
d=diff(s,2);         % column difference gives differences between S1 and S2
idx=find(d);         % find indices of differences
if isempty(idx)% identical strings
   y=0;
else
   y=sign(d(idx(1)));% sign of first non equal element gives result
end
