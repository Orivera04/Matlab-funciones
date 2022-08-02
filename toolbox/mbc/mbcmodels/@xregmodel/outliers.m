function olIndex= Outliers(m,data,factors);
% XREGMODEL/OUTLIERS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   $Revision: 1.8.2.3 $  $Date: 2004/02/09 07:52:45 $

if isempty(m.Outliers)
   % use default algorithm 
   m.Outliers= DefaultOutliers(m);
end

olAlg= m.Outliers;

olIndex= [];
if ischar(olAlg)
   % user m-file
   try
      olIndex= feval(olAlg,m,data,factors);
      n= size(data,1);
      if islogical(olIndex)
         olIndex= find(olIndex);
      end
      if numel(olIndex)>n | (numel(olIndex) & (any(olIndex~=fix(olIndex)) | max(olIndex)>n | min(olIndex)<1))
         % do some error checking
         olIndex= [];
      else
         olIndex= olIndex(:);
      end
   end
else
   olIndex= zeros(size(olAlg,1),1);
   relop= {@lt,@gt,@le,@ge,@eq,@ne};
   for i=1:size(olAlg,1)
      % chose data column
      d= data(:,olAlg(i,1));
      lim= olAlg(i,4);
      if olAlg(i,2)
         % use absolute value
         d= abs(d);
      end
      if size(olAlg,2)>4
         df=dferror(m);
         %% see if criteria is defined on a distribution
         if olAlg(i,2) & olAlg(i,5)>1
            lim= lim/2;
         end
         %% if so, value coming in is an alpha %age and hence we divide it by 200
         switch olAlg(i,5)
         case 1
            % no dist
         case 2
            % t dist
            if df>30 %% approx by normal distribution
               lim= norminv(1-lim/100);
            else
               lim= tinv(1-lim/100,df);
            end
         case 3
            % normal
            lim= norminv(1-lim/100);
         end
         
      end
      
      % or relation op
      olIndex= olIndex | feval(relop{olAlg(i,3)},d,lim);
   end
   olIndex= find(olIndex);
end
		
	