function [fvals,OutofRange]= evalfeatures(f);
% LOCALMOD/EVALFEATURES evaluation response features
% 
% [fvals,OutofRange]= evalfeatures(f);
%  2nd output indicates whether rf is out of range

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:56 $

fvals= zeros(1,size(f.Values,1));
p= double(f);
for i=1:length(fvals);
   fvals(i)= eval(f.Type(i).Function,'NaN');
end
if ~isreal(fvals)
   fvals(abs(imag(fvals))>1e-8)= NaN;
   fvals= real(fvals);
end
if nargout >1
   OutofRange= ~isfinite(fvals) |  fvals<f.Limits(1,:) | fvals>f.Limits(2,:);
end