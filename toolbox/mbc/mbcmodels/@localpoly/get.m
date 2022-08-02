function Value=get(m,Property,varargin);
% POLYNOM/GET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:40:24 $

if nargin==1;
   Value= [get(m.localmod);get(m.xreglinear)];
else
   switch lower(Property)
   case 'order'
      Value= order(m);
   case 'feat.index'
      Value= get(m.localmod,Property,varargin{:});
      
      if ~all(Value)
          %% match strings to find indices
          %% first get all RFs avaiable for this model class
          RFs=DatumDisplay(m,features(m));
          RFdisp = {RFs.Display};
          curRFs=get(m,'feat.disp');
          for i = 1:length(curRFs)
              Value(i)=strmatch(curRFs{i},RFdisp,'exact');
          end
      end
      
   otherwise
      try
         Value= get(m.localmod,Property,varargin{:});
      catch
         try
            Value=get(m.xreglinear,Property,varargin{:});
         catch
            error('POLYNOM/GET invalid property');
         end
      end  
   end   
end