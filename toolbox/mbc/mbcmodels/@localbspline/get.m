function Value=get(m,Property);
% LOCALBSPLINE/GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:38:11 $


if nargin==1;
   Value= [{'fitparams'};get(m.localmod);get(m.xreg3xspline)];
else
   switch lower(Property)
   case 'fitparams'
      Value= m.fitparams;
   case 'feat.index'
      Value= get(m.localmod,Property);
      
      if ~all(Value)
          %% match strings to find indices
          %% first get all RFs avaiable for this model class
          RFs=DatumDisplay(m,features(m));
          RFdisp = {RFs.Display};
          curRFs=get(m,'feat.disp');
          for i = 1:length(curRFs)
              Value(i)=strmatch(curRFs{i},RFdisp,'exact');
          end
          %%check
      end
      
  otherwise
      try
         Value= get(m.localmod,Property);
      catch
         try
            Value=get(m.xreg3xspline,Property);
         catch
            error('LOCALBSPLINE/GET invalid property');
         end
      end  
   end   
end