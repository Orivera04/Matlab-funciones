function [U,OK]= checkin(U,fname,x);
%CHECKIN Test and check a user-defined model into MBC Toolbox
% 
%  [U,OK]= CHECKIN(U,FNAME,X) checks the user-defined model, U, into the MBC
%  Toolbox.  FNAME is the name of the function file that contains the
%  required model definition information.  X is a matrix of test input data
%  that is used to check if the model file can be executed.
%
%  Example usage:
%    u = xregusermod('name','weibul'); [u,ok] = checkin(u,'weibul',[0.1:0.01:0.2 ]');
%
%  See also XREGUSERMOD/WEIBUL.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.4 $  $Date: 2004/02/09 08:00:57 $

try
	if nargin < 3
		error('Not enough arguments; calling syntax must be CHECKIN(model, name, data). ');
	end

	
   % initialise function
   U=funcinit(U,fname);
   
   nf= nfactors(U);
   % check data is the right size
   if size(x,2) ~= nf
	   error('Input data not compatible with model. Check number of input factors required.');
   end
	 
   np= numParams(U);
   
   yf = eval(U,x);
   
   if length(yf)~=size(x,1)
      error('Incompatible outputs and inputs. Possibly eval expression is not vectorised.');
   end
   
   % add some noise
   yf = yf; % + randn(size(yf))*max(abs(yf))/20;
   
   x0 = initial(U,x,yf);
   
   g= evalConstraints(U,x0,x,yf);
   
   U0=U;
   U0.parameters=x0;
   
   Jf = feval(U.funcName,U,'Jacobian',x);
   if ~isempty(Jf) 
       if any( size(Jf)~=[size(x,1),np] )
           error('Incorrect Jacobian size ');
       end
       fopts= optimset(optimset('fmincon'),...
           'DerivativeCheck','on',...
           'largescale','off',...
           'MaxIter',0);
       xf= fmincon('lsqcon',x0,ones(size(x0(:)))',sum(x0),[],[],[],[],'',fopts,U,x,yf);
         
   end
   
   Uf = leastsq(U0,x,yf);
   
   figure;
   hold on;
   if size(x,2) > 1 %% plot all input factors
	   plot(x(:,1),x(:,2:end));
   end
   plot(x(:,1),eval(U,x),x(:,1),eval(Uf,x));
   U,U0,Uf
   
   % display info
   text(0.05,0.25,char(Uf,1),'units','norm');
   lab= labels(U);
   if length(lab)~=np
      error('Incorrect parameter label size ');
   end
      
   text(0.05,0.15,sprintf('%s ',lab{:}),'units','norm');
   text(0.05,0.05,str_func(Uf),'units','norm');
   
   % local regression checks
   [rf,dG]= rfvals(Uf);
   if ~isempty(rf)
      if ~any(size(rf)==1)
         error('Response feature values must be a vector')
      end
      if size(dG,1)~=length(rf) | size(dG,2)~=np
         error(sprintf('delg/delp must be %dx%d',length(rf),np))
      end
      % test delG/delb
      b= double(Uf);
      ui= U;
      dGn=zeros(size(dG));
      for i=1:np
         bi=b;
         di= max(1e-8,abs(b(i))*1e-8);
         bi(i)= b(i)+ di;
         ui.parameters= bi;
         rfi= rfvals(ui);
         dGn(:,i)= (rfi(:)-rf(:))/di;
      end
      err= norm(dGn-dG)/max(norm(dG),1);
      if err>1e-3
         warning('delG does not match numerical estimate')
      end   
      % make a localusermod model
      Ulr= localusermod(Uf);
      % add all the user defined response features to localmod
      Ulr= AddFeat(Ulr,zeros(length(rf),1),np+1:np+length(rf));
      
      % what combinations can you use for reconstruction
      selrf= SelectRF(Ulr);
      if size(selrf,1)==1
         error('user-defined response features not used for reconstruction');
      end
   end
   
   modelcfg(U0,'add');
   
   disp('Model successfully registered for MBC')
   OK=1;
catch
   
   modelcfg(U,'delete');
   
   errmsg= str2mat('Model did not initialise','Error Message',lasterr');
   error(lasterr); 
end
