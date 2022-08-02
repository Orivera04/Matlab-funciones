function y=strrepx(x,s1,s2,s3)
%STRREPX  Replace string with another using exception.
%   S = STRREPX(S1,S2,S3,S4)  Replaces all occurrences of the string S2
%   in string S1 with the string S3 except for in functions with name S4.
%   If S4 is empty then any substring in the given string S1 can be replaced.
%   S4 can also be a cell array of strings.
%
%   See also STRREP, FINDSTR.

% Copyright (c) 2001-04-18, B. Rasmus Anthin.

tok=scanner(x);
if ~iscell(s3),s3={s3};end
i1=[];i2=[];
for i=1:length(s3)
   [ii1 ii2]=findfunc(tok,s3{i});
   i1=[i1 ii1];
   i2=[i2 ii2];
end

tmp='';
for i=1:size(tok,1)
   if ~any(i1+1<i & i<i2) & strcmp(deblank(tok(i,:)),s1)
         tmp=strvcat(tmp,deblank(strrep(tok(i,:),s1,s2)));
   else
      tmp=strvcat(tmp,tok(i,:));
   end
end
y=tokcat(tmp);