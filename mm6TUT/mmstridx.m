function idx=mmstridx(s1,s2)
%MMSTRIDX Index of One String Array or Cell Array to Another. (MM)
% MMSTRIDX(S1,S2) where S1 and S2 are different orderings of
% the same string array or cell array of strings, returns an
% index vector such that S1=S2(idx,:) for string arrays or
% S1=S2(idx) for cell arrays of strings.
%
% If no idx vector can be found, [] is returned.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 6/01/01
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if ischar(s1)  % convert to cell array if required
   s1=mmcellstr(s1);
end
if ischar(s2)
   s2=mmcellstr(s2);
end
s1=s1(:)';   % make into rows
s2=s2(:)';
slen=length(s1);
if slen~=length(s2)  % quick exit if no solution possible
   idx=[];
   return
end
if isequal(s1,s2)    % quick exit if identical
   idx=1:length(s1);
   return
end
mask=logical(ones(size(s1))); % mark elements not matched already
idx=zeros(size(s1));          % preallocate result
for i=1:slen
   id=find(strcmp(s2,s1(i))&mask);
   if isempty(id)
      idx=[];
      return
   else
      mask(id(1))=0;
      idx(i)=id(1);
   end
end