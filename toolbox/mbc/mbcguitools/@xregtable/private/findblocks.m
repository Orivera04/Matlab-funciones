function [xout,yout]=findblocks(maskin)
%FINDBLOCKS
%   [x, y] = findblocks(A) searches the matrix A for blocks of ones
%   and returns the limits of each block in x and y.  
%
%   x and y are two-column matrices  which indicate the beginning and end
%   points of each block in A.
%
%   e.g.
%       A=logical([0 0 0 1 0 0
%                  0 1 1 1 1 0
%                  0 1 1 1 0 0
%                  0 1 1 1 0 1
%                  0 0 1 1 0 0
%                  0 0 0 0 0 0])
%
%       [x y]=findblocks(A) 
%
%       x = 1     5       y = 4     4
%           2     4           2     3
%           2     2           5     5
%           4     4           6     6
%           5     5           3     3

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:58 $


% 7/6/2000 - This algorithm is now hand-coded in c.  This file has been left since
%            it more clearly illustrates the process.  The c version differs in that
%            the rows are iterated before the columns.  This makes more sense in c
%            because the mxArray data is stored columnwise.



x=1;
endx=size(maskin,1);
endy=size(maskin,2);
extx=0;
exty=0;
% Initialise xout and yout to be 33% length of maskin
n=1;

szout=floor(length(maskin(:))/3);
szextra=floor(szout/7);

mbintscalar(szout);
mbintscalar(szextra);

xout=zeros(szout,2);
yout=xout;


while x<=endx
   y=1;
   while y<=endy
      if maskin(x,y)==1
         % Found a start point
         flag=1;
         while flag
            % keep trying extension until neither direction is possible
            if y+exty<endy
               if maskin(x:x+extx,y+exty+1)
                  % Try extending in y-direction
                  exty=exty+1;
                  xflag=1;
               else 
                  xflag=0;
               end
            else
               xflag=0;
            end
            
            if x+extx<endx
               if maskin(x+extx+1,y:y+exty)
                  % Try extending in x-direction
                  extx=extx+1;
                  yflag=1;
               else
                  yflag=0;
               end
            else
               yflag=0;
            end
            flag=(xflag | yflag);
         end
         % Save block start and end coords
         xout(n,1:2)=[x,x+extx];
         yout(n,1:2)=[y,y+exty];
         n=n+1;
         if n>szout
            % Need to extend output arrays by a bit
            % Dumb reasoning - just add 5% extra
            xout(end+1:end+szextra,1:2)=0;
            yout(end+1:end+szextra,1:2)=0;
            szout=szout+szextra;            
         end
         
         % Delete block from in-matrix so it isn't done again
         maskin(x:x+extx,y:y+exty)=0;
         
         % Can skip a few in y-direction.
         y=y+exty;
         extx=0;
         exty=0;
      end
      y=y+1; 
   end
   x=x+1;
end

% Chop xout and yout down to size
xout=xout(1:n-1,1:2);
yout=yout(1:n-1,1:2);

return


