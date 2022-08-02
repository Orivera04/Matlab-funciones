function [bestm,OK]=leastsq(m,X,Y)
%LEASTSQ
%
% m= LEASTSQ(m,X,Y);
%
% This will do a univariate Free knot spline optimisation.
% It has three possible alogorithms:
% LSQnonlin
% Genetic Algorithm
% FminCon

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:30:52 $

% Get the options if any are set.
if ~isempty(m.FitOptions.Param)
    Opts=m.FitOptions.Param;
    KNOT_NUMBER=Opts.Max_Knots;
    Init_Pop=Opts.Init_Pop;
else
    error('No Fit Parameters');
end

% must have at least as much data as number of basis functions
ord= max(get(m.mv3xspline,'polyorder'),1);
OK= size(X,1) >= (ord + get(m.mv3xspline,'numknots') + 1);

if ~OK
    bestm=m;
    return
end


% First try all knot positions and choose 10% to optimise
% Clear previous knot vector
[Xs,ind]= sort(X);
Ys=Y(ind);

knots=zeros(Init_Pop,KNOT_NUMBER);
% Clear previous R
% Calculate 'free data'


xfree=Xs(ord:end-ord+1);
ratio= length(xfree)/KNOT_NUMBER;

Tgt=gettarget(m);
TOL= sqrt(eps)*max(abs(Tgt));
JTgt = sort([max(xfree(1),Tgt(1))+TOL , min(xfree(end),Tgt(2))-TOL]) ;


R=repmat(JTgt',1,KNOT_NUMBER);
knots=  (rand(Init_Pop,KNOT_NUMBER)*(JTgt(2)-JTgt(1))+JTgt(1));
if KNOT_NUMBER>1
    knots= sort(knots,2);
end

m.mv3xspline= setcode(m.mv3xspline,Tgt,cell(size(Tgt)),Tgt);

% constraints to stop invjupp blowing up

LBjupp= ones(KNOT_NUMBER,1)*max(abs(Tgt))*sqrt(eps);
UBjupp= [];

alg= find(strcmp(m.FitOptions.Algorithm,{'LSQnonlin','GA','FminCon'}));

switch alg
    case 1
        Percent_Opt=Opts.Percent_Opt;
        Max_Iter= Opts.Max_Iter;
        Max_Func=Opts.Max_Func;
        options=optimset(optimset('lsqnonlin'),...
            'display','off',...
            'diagnostics','off',...
            'maxiter',Max_Iter,...
            'MaxFunEvals',Max_Func,...
            'largescale','on');
        knots=eval_model(m,knots,X,Y,Percent_Opt);
        km0=get(m.mv3xspline,'knots');
        if length(km0)==size(knots,2);
            % add initial value
            knots= [km0(:)';knots];
        end
        m.mv3xspline= set(m.mv3xspline,'knots',knots(1,:));

        optknots=zeros(size(knots,1),KNOT_NUMBER);


        for j=1:size(knots,1)
            alpha= calc_alpha(knots(j,:),-1,1,1.1);
            k0= sort(knots(j,:))';
            kj0= jupp(m.mv3xspline,k0,JTgt);
            rj= cost_jupp(kj0,m,X,Y,1,alpha,JTgt);
            c0= sum(rj.^2);

            [kf,cj]=lsqnonlin('cost_jupp',kj0,LBjupp,UBjupp,options,...
                m,X,Y,c0,alpha,JTgt);
            cost(j)=cj*c0;
            optknots(j,:)= invjupp(m.mv3xspline,kf',JTgt);
        end
        % Choose the best knot
        bestknot= eval_model(m,optknots,X,Y,'best');
        m3= set(m.mv3xspline,'knots',bestknot);
        [m.mv3xspline,OK] = leastsq(m3,X,Y);
        % copy pev info to unispline model
        [ri,ms,df]= var(m.mv3xspline);
        m= var(m,ri,ms,df);
        bestm= m;
    case 2
        % or GA...
        Bit_Len=Opts.Bit_Len;
        Max_Gen= Opts.Max_Gen;
        xbest= eval_model(m,knots,X,Y,'best');
        % fix penalty function scaling
        alpha= calc_alpha(sort(xbest)',-1,1,1.1);
        UBjupp= ones(size(LBjupp))*1e4;

        x0 = jupp(m.mv3xspline,xbest,JTgt);
        knot_values=gamincon('knot_optim_ga',x0,...
            LBjupp,...      % LB
            UBjupp,...  % UB
            [],[],[],setgaopt('gamincon'),[],...
            m,X,Y,alpha,JTgt);

        knot_values=invjupp(m.mv3xspline,knot_values,JTgt);
        m3= set(m.mv3xspline,'knots',knot_values);
        [m.mv3xspline,OK] = leastsq(m3,X,Y);
        % copy pev info to unispline model
        [ri,ms,df]= var(m.mv3xspline);
        m= var(m,ri,ms,df);
        bestm= m;
    case 3
        % fmincon
        Percent_Opt=Opts.Percent_Opt;
        Max_Iter= Opts.Max_Iter;
        Max_Func=Opts.Max_Func;
        options=optimset(optimset('fmincon'),...
            'display','off',...
            'maxiter',Max_Iter,...
            'MaxFunEvals',Max_Func);
        km0=get(m.mv3xspline,'knots');
        if length(km0)==size(knots,2);
            % add initial value
            knots= [km0(:)';knots];
        end
        m.mv3xspline= set(m.mv3xspline,'knots',knots(1,:));
        % Build bounds and options
        [LB,UB,A,c,nlc,alpha]= constraints(m,X,Y);
        lb= X(3);
        ub= X(end-2);
        cost= zeros(size(knots,1),1);
        knots=eval_model(m,knots,X,Y,Percent_Opt);
        optknots=zeros(size(knots,1),KNOT_NUMBER);
        for j=1:size(knots,1)
            k0= sort(knots(j,:))';
            alpha= calc_alpha(knots(j,:),-1,1,1.1);
            [c0] = costknot(k0,m,X,Y,KNOT_NUMBER,1,alpha);
            [kf,cj]=fmincon('costknot',k0,A,c,[],[],[],[],'',options,...
                m,X,Y,KNOT_NUMBER,c0,alpha);
            optknots(j,:)=kf';
        end
        % Choose the best knot
        bestknot= eval_model(m,optknots,X,Y,'best');
        m3= set(m.mv3xspline,'knots',bestknot);
        [m.mv3xspline,OK] = leastsq(m3,X,Y);
        % copy pev info to unispline model
        [ri,ms,df]= var(m.mv3xspline);
        m= var(m,ri,ms,df);
        bestm= m;
end