function [B,res,J,yhat]= gls_fitB(L,B,DATA,varargin)
% LOCALMOD/GLS_FITB fit coefficients (B) in IGLS
%
% [B,res,J,yhat]= gls_fitB(L,B,DATA,Wc) 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:39:09 $



% fopts= fitoptions(L);


% get limits
if nargin<4
   Wc=[];
else
   Wc= varargin{1};
end


Bi={1};
resi={1};
yhat= {1};

s= size(DATA);
Ns= s(3);
fs=0;
i=1;
while fs < Ns
   % limit max number of sweeps to process at one time
   fs= min(100,Ns);
   
   ts= tstart(DATA);
   f= find(ts>5000);
   if ~isempty(f)
      % limit number of data points to 5000
      fs= min(f(1),fs);
   end
   % fit sweeps 1:fs
   [Bi{i},resi{i},Ji{i},yhati{i}]= i_fitB(L,B(:,1:fs),DATA(:,:,1:fs),Wc);  
   if fs < Ns
      % reduce data set
      B=B(:,fs+1:end);
      DATA= DATA(:,:,fs+1:end);
      if ~isempty(Wc)
         Wc= Wc(fs+1:end);
      end
      % calculate new sizes
      s=size(DATA);
      Ns= s(3);
      fs=0;
   end
   i=i+1;
end

% concatenate results
B  = cat(2,Bi{:});
J  = cat(1,Ji{:});
yhat  = cat(1,yhati{:});
res= resi{1};
for i=2:length(resi);
   res= [res;resi{i}];
end


function [B,res,J,yhat]= i_fitB(L,B,DATA,Wc)

[optfunc,cfunc,constrArgs,fopts,optparams]=optimargs(L,B,DATA,Wc);

InvScale= optparams{1};
Scale= diag(1./diag(InvScale));

B0= Scale*B;



if strcmp(optfunc,'lsqnonlin')
   [B,resnorm,r,exitflag,output] = feval(optfunc,cfunc,B0,constrArgs{:},fopts,L,DATA,Wc,optparams{:});
else
   % fmincon
   [B,resnorm,exitflag,output] = feval(optfunc,cfunc,B0,constrArgs{:},fopts,L,DATA,Wc,optparams{:});
end

if exitflag>0
   DisplayFit(L,'LSQ solution converged');
elseif exitflag==0
   DisplayFit(L,'LSQ exceeded maximum number of iterations -> rerun ');
else
   DisplayFit(L,'LSQ solution did not converge');
end
B= reshape(B,size(L,1),size(DATA,3));
B= InvScale*B;

[res,J,yhat]= gls_costB(B,L,DATA,Wc);
% outputs are [sweepset,cell,sweepset]

drawnow



