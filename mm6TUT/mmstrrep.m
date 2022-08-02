function s=mmstrrep(s1,s2,s3)
%MMSTRREP String Replacement Without Overlaps. (MM)
% MMSTRREP(S1,S2,S3) replaces nonoverlapping occurances of
% the string S2 in string S1 with string S3.
%
% This is different from STRREP in MATLAB. For example:
% S1 = 'abcdddef'
% STRREP(S1,'dd','xx')   returns 'abcxxxxef' % replaces overlaps too 
% MMSTRREP(S1,'dd','xx') returns 'abcxxdef'  % ignores overlaps

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 1/23/00, 4/9/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin~=3 | ~ischar(s1) | ~ischar(s2) | ~ischar(s3)
   error('Three String Inputs Required.')
end
s1=s1(:)'; s1len=length(s1);
s2=s2(:)'; s2len=length(s2);
s3=s3(:)'; s3len=length(s3);

if s2len>s1len
   s=s1;
elseif isequal(s1,s2)
   s=s3;
else
   s=s1;
   k=findstr(s1,s2);
   while ~isempty(k)
      ks=k(1);
      s=cat(2,s(1:ks-1),s3,s(ks+s2len:end));
      k=findstr(s,s2);
      k(k<ks+s3len)=[]; % no overlap
   end
end