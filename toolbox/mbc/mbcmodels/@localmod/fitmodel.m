function [L,Bhat,Wchat,OK]= fitmodel(L,X,Y,B,Wc)
%FITMODEL Main fit model method for localmods
%
% [L,Bhat,Wchat,OK]= FITMODEL(L,X,Y,B,Wc)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.4.4 $  $Date: 2004/02/09 07:39:03 $

ws= warning;
warning('off');

% localmod method for cleaning data and doing ytrans
[Xb,Yb,OK,BadIndex]= checkdata(L,X,Y);

% remove tests which don't have enough data
% this code used to be in checkata
TestOK= tsizes(Yb) >= size(L,1);
ptsOK=  find(TestOK);
if length(ptsOK)<size(Yb,3)
   ptsBD=  find(~TestOK);

   % need to update badIndex
   bds= RecPos(Yb,ptsBD);
   tmp= BadIndex(~BadIndex);
   tmp(bds)= true;
   BadIndex(~BadIndex)= tmp;
   
   % remove these sweeps
   Yf= Yb(:,:,ptsOK);
   Xf= Xb(:,:,ptsOK);
   
   OK= ismember(testnum(Y),testnum( Yf ));
else
   Yf= Yb;
   Xf= Xb;
end   


if isTBS(L)
   % need to initialise model with raw data
   Yraw= Y(~BadIndex);
else
   % use possible transformed data
   Yraw= Yf;
end

Bhat= B;
B= B(:,OK);

Wchat= Wc;
Wc= Wc(OK);

Bok= all(isfinite(B), 1);

if any(~Bok)
   %obtain initial estimates of parameters
   
   InitSweeps= find( ~Bok );
   NsOK= size(Yf,3);
   
   % Loop over uninitialised sweeps to find initial parameters
   initOK= ones(NsOK,1);
   for i=InitSweeps
      Xs= Xf{i};
      Ys= Yraw{i};
      [B(:,i),MINB,MAXB,initOK(i)] = initial(L,Xs,Ys);
   end
   
   if ~all(initOK)
      % get rid of sweeps which are no good
      initOK= (initOK~=0);
      OK(OK)= initOK;
      
      Xf= Xf(:,:,initOK);
      Yf= Yf(:,:,initOK);
      
      B= B(:,initOK);
      Wc= Wc(initOK);
   end
end

if size(Yf,1)< size(L,1)*size(Yf,3);
	warning('mbc:localmod:InsufficentData', 'Insufficient data to support this local model')
	OK(:)= false;
	B= B(:,OK);
	Wc= Wc(OK);
end

OKnow=[];
if any(OK)
   if ~isempty(L.covmodel)
      % check Wc sizes
      Lt= L;
      for i= 1:size(B,2)
         Xs= Xf{i};
         Lt= update(Lt,B(:,i));
         wc= Wc{i};
         if ~isempty(wc) && size(Xs,1)~=size(wc,1)
            yhat= eval(Lt,code(Lt,Xs));
            if isTBS(Lt)
               yhat= ytrans(Lt,yhat);
            end
            Wc{i}= choltinv(Lt.covmodel,yhat,Xs);
         end
      end
   end
   % now do fit
   FitMethod= get(L,'fitalg');
   if strcmp(FitMethod,'leastsq')
      if isempty(L.covmodel);
         % this was the default model.fitalg
         FitMethod= 'ols';
      else
         FitMethod= 'gls';
      end
      set(L,'fitalg',FitMethod);
   end
   [L,B,Wc,sigma2,J]= feval(FitMethod,L,Xf,Yf,B,Wc);
	% final check of model
	[B,Wc,OKnow]= finalcheck(L,B,[Xf Yf],Wc,OK(OK));
end


warning(ws);

if ~isreal(B)
   warning('mbc:localmod:ComplexCoefficents', 'Complex Coefficients for Local Models');
   % make sure coeffs are real
   OKnow= OKnow | any(imag(B));
   B= real(B);
end
% update parameters and weights
Bhat(:,OK)=B;
if isempty(Wc)
   Wchat= Wc;
else
   Wchat(OK)= Wc;
end

OK(OK)= OKnow;

% set bad sweep parameters to NaN/[]
Bhat(:,~OK)  = NaN;
if ~all(OK)
   [Wchat{~OK}] = deal([]);
end
