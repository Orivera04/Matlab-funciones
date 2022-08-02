function Value=get(m,Property);
% USERLOCAL/GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:43:48 $

if nargin==1;
   Value= [{'userdefined'};get(m.localmod);get(m.xregmodel)];
else
   switch lower(Property)
   case 'userdefined'
      Value= m.userdefined;
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
            error('USERLOCAL/GET invalid property');
         end
      end  
   end   
end