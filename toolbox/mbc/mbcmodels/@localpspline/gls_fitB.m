function [B,yhat,res,J]= gls_fitB(ps,B,DATA,Wc)
% localpspline/GLS_FITB least-squares estimation of localpspline
%
% [B,res,J,yhat]= gls_fitB(ps,B,DATA,Wc)
%   ps    localpspline object
%   B     initial parameter matrix (cols= sweeps)
%   DATA  sweepset of data to fit [X,Y]
%   Wc    optional weights Wc'*Wc= inv(covmatrix)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:41:14 $



Ns= size(DATA,3);

if nargin < 4 | isempty(Wc)
   Wc=[];
else
   % make sure weights are the same size as the data
   ts= tsizes(DATA);
   for i=1:Ns
      if size(Wc{i},1) > ts(i);
         Wc{i}= Wc{i}(1:ts(i),1:ts(i));
      end
   end
end

% setup Jacobian pattern



% initial knots

ps= datum(ps,0);
ps.knot= 0;
% Now try quadspline

FitBlocks= 0;
if ~FitBlocks
    % fit one sweep at a time
    
    options= optimset('display','off',...
        'Jacobian','off',...
        'TolFun',1e-6,...
        'Tolx',1e-6,...
        'LargeScale','on');
    
    Ns= size(DATA,3);
    J= cell(1,Ns);
    k0= B(1,:);
    k= zeros(size(k0));
    wci= Wc;
    for i=1:Ns
        if iscell(Wc)
            wci= Wc{i};
        end
        [k(i),resnorm,r,exitflag,output,lam,J{i}] = lsqnonlin(@costknotsingle,k0(i),[],[],options,ps,DATA{i},wci);
    end
    [res,B,J,yhat,PS]= costknot(k,ps,DATA,Wc);
    
else
    % old block approach - this is much faster but less accurate
    % leave this code for now in case we ever decide to have a quick fit option
    
    knots= B(1,:);
   
    [res,B,J,yhat,PS]= costknot(knots,ps,DATA,Wc);
    c0=sum(double(res).^2);

    
    options= optimset('display','off',...
        'Jacobian','off',...
        'TolFun',1e-6*c0,...
        'Tolx',1e-3/Ns^2,...
        'LargeScale','on');
    
    options= foptions(ps,options);
    
    Bi={1};
    resi={1};
    yhat= {1};
    wci=[];
    i=1;
    s= size(DATA);
    Ns= s(3);
    fs=0;
    
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
        % initial knots
        k0= B(1,1:fs);
        if ~isempty(Wc)
            % weights
            wci= Wc(1:fs);
        end
        di= DATA(:,:,1:fs);
        
        % jacobian pattern
        Jcell= cell(1,fs);
        ts= tsizes(DATA);
        
        for j=1:fs;
            Jcell{j}= ones(ts(j),1);
        end
        JPattern= spblkdiag(Jcell{:});
        options= optimset(options,'JacobPattern',JPattern);
        
        % least squares estimation
        [k,resnorm,r,exitflag,output,lam,J] = lsqnonlin('costknot',k0,[],[],options,ps,di,wci);
        
        % collect ith output info
        
        [resi{i},Bi{i},Ji{i},yhati{i},PS]= costknot(k,ps,di,wci);
        
        if fs < Ns
            % reduce data set
            B=B(:,fs+1:end);
            DATA= DATA(:,:,fs+1:end);
            if ~isempty(Wc)
                Wc= Wc(fs+1:end);
            end
            % calculate new sizes
            fs= 0;
            Ns= size(DATA,3);
        end
        i=i+1;
    end
    
    % concatenate results
    B  = cat(2,Bi{:});
    J  = cat(2,Ji{:});
    yhat  = cat(2,yhati{:});
    res= resi{1};
    for i=2:length(resi);
        res= [res;resi{i}];
    end
end

drawnow
% not sure if I want to do this in here or whether this is best post GLS 


