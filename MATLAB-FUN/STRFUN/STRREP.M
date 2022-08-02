function s = strrep(s1,s2,s3)
%STRREP String search and replace utility.
%	S = STRREP(S1,S2,S3) replaces all occurrences of S2 in S1 with S3.
%	Example:
%	    s1='This is a good example';
%	    strrep(s1,'good','great') returns 'This is a great example'
%	    strrep(s1,'bad','great')  returns 'This is a good example'
%	    strrep(s1,'','great')     returns 'This is a good example'
%	See also FINDSTR.

%	Rick Spada  11-23-92
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Take care of trivial cases:
%   s2 > s1
%   s1 is empty
%   s2 is empty
if (length(s2)>length(s1)) | isempty(s2) | isempty(s1),
  s=s1;
  return;
end;

% Find all occurances of s2 in s1
s2len=length(s2);
s2pos=findstr(s1,s2)-1;

% Build resulting string
s=[];
s1pos=1;
for i=1:length(s2pos),
  s=[s,s1(s1pos:s2pos(i)),s3];
  s1pos=s2pos(i)+s2len+1;
end;
s=[s,s1(s1pos:length(s1))];
