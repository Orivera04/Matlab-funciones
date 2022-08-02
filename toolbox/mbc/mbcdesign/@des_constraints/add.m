function [c,sel]=add(c,Type,varargin);
% DES_CONSTRAINTS/ADD add constraints
%
% [c,OK]=add(c,Type,varargin);
%   c=add(c,'linear',A,b);           % A*x <= b
%   c=add(c,'table',X,Y,Zmax,ind);   % Z(X,Y)<= Zmax ind specifies which factors to use
%   c=add(c,'ellipsoid',W,Xc)        % (x-Xc)'*W*(x-Xc) <= 1 
%   c=add(c,'table2D',X,Zmax,ind)     % Z(X)<= Zmax ind specifies which factors to use
%   c=add(c,CONOBJECT)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:40 $

OK=1;
sel=0;
if ischar(Type)
   switch lower(Type)
   case 'linear'
      if length(varargin)==0;
         varargin= {ones(1,length(c.Factors)) , 0 };
      end
      [con,msg]=conlinear(length(c.Factors),'A',varargin{1},'b',varargin{2});
   case 'table'
      if length(varargin)==0;
         varargin= {[-1:0.5:1] , -1:0.5:1 , ones(5) , 1:3,1};
      end
      [con,msg]=contable2(length(c.Factors),'breakx',varargin{1},'breaky',varargin{2},...
         'table',varargin{3},'factors',varargin{4},'le',varargin{5});
   case 'ellipsoid'
      if length(varargin)==0;
         varargin= {zeros(length(c.Factors),1) , eye(length(c.Factors)) };
      end
      [con,msg]=conellipsoid(length(c.Factors),'xc',varargin{1},'W',varargin{2});
   case 'table2d'
      if length(varargin)==0;
         varargin = {[-1:0.5:1], ones(1,5), [1 2], 1};
      end
      [con,msg]=contable1(length(c.Factors),'breakx',varargin{1},...
         'table',varargin{2},'factors',varargin{3},'le',varargin{4});
   otherwise
      msg= {'Unknown Constraint Type'};
   end
else
   con=Type;
   msg={};
end
if isempty(msg)
   c.Constraints=[c.Constraints,{con}];
   sel=length(c.Constraints);
else
   error(msg{1});
end





