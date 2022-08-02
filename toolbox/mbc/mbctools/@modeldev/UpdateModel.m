function [OK]= UpdateModel(MD,KeepOutliers,UnChangedTests);
% MODELDEV/UPDATEMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.5 $  $Date: 2004/04/12 23:34:55 $

OK=1;
if nargin==1
   KeepOutliers=0;
end


if isa(MD.Model,'xregtwostage')
   % Do Nothing - fit only required for globals and datum 
   % not the twostage itself.
else   % (one-stage resp, resp feat, global, datum)
   try
       p= Parent(MD);
       if MD.Status==2 && strcmp(p.class,'modeldev')
           % copy model from parent and save a refit
           MD.Model = p.model;
           MD.Statistics = p.statistics;
           xregpointer(MD);
       else
           if ~KeepOutliers
               MD.Outliers=[];
           end
           % do a full refit on model
           MD= refit(MD);
           % don't keep internal stores
           MD= cleanup(MD);
       end
   catch
      OK=0;
   end
end
