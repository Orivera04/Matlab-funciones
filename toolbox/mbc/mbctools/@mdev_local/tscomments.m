function out= tscomments(mdev,c);
% MDEV_LOCAL/TSCOMMENTS comments for twostage model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:05:14 $

if nargin==1
   TS= BestModel(mdev);
   if ~isempty(TS)
	  out= comments(TS);
   else
	  out='';
   end
else
   TS= BestModel(mdev);
   if ~isempty(TS)
	  if mle_best(mdev)
		 TS= comments(TS,c);
		 mdev.MLE.Model= TS;
		 mdev.TwoStage{2}= TS;
	  else
		 mdev.TwoStage{1}= comments(TS,c);
		 
	  end
	  pointer(mdev);
   end
   out =mdev;
end
