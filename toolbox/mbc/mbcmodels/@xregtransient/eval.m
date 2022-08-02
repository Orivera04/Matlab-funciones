function Y = eval(D,X)
%% DYNAMIC/EVAL
%% X = [t, u(t)]
%% t = time vector. Negative time are not permitted
%% the only place that the simulink model is called
%% returns Y, output from simulink model with D, X

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:58:47 $

%% The parameters are in D.param = p = [tau, x,... , delay]

% deal with empty X input
if isempty( X )
    Y = zeros( 0 , 1);
    return;
end

t = X(:,1);
%% initialize output
Y = zeros(size(t));

%% find where time vector is monotonic
ChangeSim= [0;find(t(2:end)<=t(1:end-1));length(t)];


Ysim= cell(length(ChangeSim)-1,1);
for i=1:length(ChangeSim)-1
    % divide up into monotonic parts and simulate each part
    ind= ChangeSim(i)+1:ChangeSim(i+1);
    
    tzero = t(ind);
    
    %% need to start at t=0 where state0 is defined
    if tzero(1)~=0 %% need to add a zero at start
        tzero = [0; tzero(:)];
        extended = 1;
    else
        extended = 0;
    end
    
    if size(X,2)>1 %% if there are some input factors
        u = X(ind,2:end); %%read in all columns (except time) as the input factors
        uzero=u;
        if extended %% need to add a zero at start
            uzero= uzero([1 1:end],:);
        end
        [Tout,Y]= i_HiddenEval(D,tzero,[tzero,uzero]);
    else 
        [Tout,Y]= i_HiddenEval(D,tzero);
    end

    if extended
        Tout = Tout(2:end);
        Y = Y(2:end,:);
    end
    if length(ind)==1
        % Simulated a single time point x
        Y = Y(end, :);
    elseif length(ind)==2 && t(ind(1))==0
        % Simulated sequence of form t = [0 x]
        Y = Y([1 end], :);
    end
    
    Ysim{i}= Y;
end
if length(Ysim)>1
    Y= cat(1,Ysim{:});
end

return


function [Tout,Y]= i_HiddenEval(DyNObJ,sImTiMe,ExTInPuTs);
% note common variable names are not used 

% default is to allow SIMULINK model to use parameter vector 'p'
SiM_PaRaM= double(DyNObJ);
eval('p=SiM_PaRaM;',[]);

% SIMULINK model parameters which are held constant
[SiM_CoNsTvArS,SiM_CoNsTs]= simconstants(DyNObJ);
for i=1:length(SiM_CoNsTvArS)
   % set up variables 
   eval([SiM_CoNsTvArS{i},'=SiM_CoNsTs(i);'])
end

% SIMULINK parameters to be fitted
for i=1:length(DyNObJ.simVars)
   % set up variables 
   eval([DyNObJ.simVars{i},'=SiM_PaRaM(i);'],[]);
end

Tout=zeros(0,1);
Y=zeros(0,1);
try
   if nargin == 3 %% there are input factors = ExTInPuTs
      sTaTe0Ic = state0(DyNObJ,ExTInPuTs);
      [Tout,gamma,Y]=sim(DyNObJ.simName,sImTiMe,...
         simset('SrcWorkspace','current','InitialState',sTaTe0Ic,'MaxStep',max(diff(ExTInPuTs(:,1)))),...
         ExTInPuTs);
   else
      sTaTe0Ic = state0(DyNObJ);   
      [Tout,gamma,Y]=sim(DyNObJ.simName,sImTiMe,...
         simset('SrcWorkspace','current','InitialState',sTaTe0Ic));
   end
catch
   if length(Tout)~=length(sImTiMe)
      Tout(end+1:length(sImTiMe))= sImTiMe;
      Y(end+1:length(sImTiMe),:)=NaN;
   else
      error(lasterr)
   end
end

