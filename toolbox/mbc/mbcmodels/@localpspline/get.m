function Value=get(m,Property);
% QUADSPLINE/GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:11 $


if nargin==1;
   Value= [{'knot'};get(m.localmod);get(m.xregmodel)];
else
   switch lower(Property)
   case 'knot'
      Value= m.knot;
   case 'store'
      Value= m.Store;
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
            Value=get(m.xregmodel,Property);
         catch
            error('QUADSPLINE/GET invalid property');
         end
      end  
   end   
end