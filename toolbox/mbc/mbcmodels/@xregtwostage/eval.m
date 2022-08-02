function [Y,Yg,Datum,Lparams] = eval(TS,x,varargin);
% TWOSTAGE/EVAL evaluate twostage model
%
% [Y,Yg,Datum,Lparams] = eval(TS,x,Xr2pk);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.3 $  $Date: 2004/02/09 07:59:37 $

nl= nfactors(TS.Local);
if nargin<3
   Xr2pk=0;
else
   Xr2pk= varargin{end};      
end
   
if isa(x,'sweepset') & size(x,1)~=size(x,3)
   % sweep by sweep reconstruction
   XL= x(:,1:nl);
   XG= x(:,nl+1:end);
   XG= smean(XG);
   SWbySWrecon= 1;
elseif isa(x,'cell')
   XL= x(1);
	if isa(XL{1},'sweepset')
		XL= XL{1};
	end
   XG= x{2};
   SWbySWrecon= 1;
else
   XL= x(:,1:nl);
   XG= x(:,nl+1:end);
   XL= double(XL);
   SWbySWrecon= 0;
end
   
GMods= TS.Global;

Yg= zeros(size(XG,1),length(GMods));
for i= 1:length(GMods)
   Yg(:,i)= EvalModel(GMods{i},XG);
end

L= TS.Local;
if any( strcmp(class(L),{'localbspline','localtruncps'}) )
   % need coding for localbspline and localtruncps but this is expensive
   % unless this is absolutely necessary.
   L= get(TS,'Local');
end

if DatumType(L)
   if Xr2pk 
      if ~RFstart(L) & DatumType(L)~=3
         Yg(:,1)=0;
         Datum= Yg(:,1);
      else
         Datum= zeros(size(Yg,1),1);
      end
   else
      Datum= EvalModel(TS.datum,XG);
   end
else   
   % no datum model so set datum tp zero
   Datum= zeros(size(XG,1),1);
end

if SWbySWrecon;
   nr= size(Yg,1);
   Y= cell(nr,1);
   Ns= size(XL,3);
   Lparams= zeros(nr,size(L,1));
   for i= 1:nr
      % reconstruct one sweep at a time
      xl= XL{min(i,Ns)};
      if ~Xr2pk
         xl= xl-Datum(i);
      end
      [yl,Lparams(i,:)]= reconstruct(L,Yg(i,:),xl,Datum(i));   
      Y{i}=yl;
   end
   Y= cat(1,Y{:});
else
   % Fast reconstruction if only one local value/global value
   if ~Xr2pk & DatumType(L)
      % adjust for Datum if ~not Xr2pk
      XL= XL(:,1)-Datum;
   end

   [Y,Lparams]= reconstruct(L,Yg,XL,Datum);   
end
Y= yinv(L,Y);
   
