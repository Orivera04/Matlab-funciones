function [Y,Yg,Datum,Lparams]= presspred(TS,x,DataInd)
%PRESSPRED

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:00:11 $

nl= nfactors(TS.Local);
if nargin<3
	DataInd=':';
end

Xr2pk=0;
   
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
	% code 
	
else
   XL= x(:,1:nl);
   XG= x(:,nl+1:end);
   XL= double(XL);
   SWbySWrecon= 0;
end

XG= code(TS,double(XG),nl+1:nfactors(TS));
   

Yg= zeros(size(XG,1),length(TS.Global));
for i= 1:length(TS.Global)
	y = EvalModel(TS.Global{i},XG);
   Yg(:,i)= presspred(TS.Global{i},y,DataInd);
end

if ~DatumType(TS.Local)
   % no datum model so set datum tp zero
   Datum= zeros(size(XG,1),1);
else
	y = EvalModel(TS.datum,XG);
   Datum= presspred(TS.datum,y,DataInd);
end


L= get(TS,'Local');
if SWbySWrecon;
   nr= size(Yg,1);
   Y= cell(nr,1);
   Ns= size(XL,3);
   Lparams= zeros(nr,size(TS.Local,1));
   for i= 1:nr
      % reconstruct one sweep at a time
      xl= code(L,XL{min(i,Ns)});
      if ~Xr2pk
         xl= xl-Datum(i);
      end
      [yl,Lparams(i,:)]= reconstruct(TS.Local,Yg(i,:),xl,Datum(i));   
      Y{i}=yl;
   end
   Y= cat(1,Y{:});
else
   % Fast reconstruction if only one local value/global value
	XL= code(L,double(XL));
   if ~Xr2pk & DatumType(TS.Local)
      % adjust for Datum if ~not Xr2pk
      XL= XL(:,1)-Datum;
   end

   [Y,Lparams]= reconstruct(TS.Local,Yg,XL,Datum);   
end
Y= yinv(TS.Local,Y);
   

if ~isreal(Y)
	Y(abs(imag(Y))>eps)= NaN;
	Y =real(Y);
end