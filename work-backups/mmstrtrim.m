function s=mmstrtrim(si,huh)
%MMSTRTRIM Trim Leading and/or Trailing White Space. (MM)
% MMSTRTRIM(S) or MMSTRTRIM(S,'both') removes leading and trailing
% white space and nulls from the string S. If S is a string array,
% leading and trailing white space and null columns are removed.
% MMSTRTRIM(S,'left') or MMSTRTRIM(S,'lead') removes left or leading
% white space and nulls.
% MMSTRTRIM(S,'right') or MMSTRTRIM(S,'trail') removes right or
% trailing white space and nulls.
%
% See also: ISSPACE, DEBLANK

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 2/16/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1
   huh='both';
end
if isempty(huh) | ~ischar(huh)
   error('Second Argument Must be a String.')
end
if ~isempty(si) & ~ischar(si)
   error('Input Must be a String.')
end
if isempty(si)
   s=si;
else  % remove leading and/or trailing white space
   [nr,nc]=size(si);
   [r,c]=find(~isspace(si)|si~=0);
   if isempty(c)
      s='';
   else
      switch lower(huh(1))
      case 'l'
         s=si(:,min(c):nc);
      case {'r' 't'}
         s=si(:,1:max(c));
      case 'b'
         s=si(:,min(c):max(c));
      otherwise
         error('Unknown Second Argument.')
      end
   end
end
