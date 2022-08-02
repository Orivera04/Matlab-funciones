function [res,B,J,YHAT,PS] = costB(knots,ps,DATA,Wc)
%COSTB

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.4.3 $  $Date: 2004/04/04 03:29:42 $

Ns= size(DATA,3);
if nargout>1
    B= zeros(size(ps,1),Ns);
    J= cell(1,Ns);
    PS= J;
    YHAT= cell(1,Ns);
end

if nargin<4
    Wc=[];
end

res= cell(Ns,1);
for i= 1:Ns
    % extract data for current sweep
    d= DATA{i};
    x= d(:,1:end-1);
    y= d(:,end);

    ny = length(y);

    % Residual Calculation
    ps.knot= knots(i);
    % possibly expand data
    [x,y]= symmetric(ps,x,y);

    Xs= x2fxlin(ps,x);
    % do we have to weight the conditional problem ?
    p= Xs\y;

    yhat= Xs*p;

    r = y-yhat;
    r = r(1:ny);

    % weighting
    if ~isempty(Wc)
        wc= Wc{i}(1:ny,1:ny);
        r= wc*r;
    end

    % should be in a sweepset
    res{i}= r;

    if nargout > 1
        % Model object setup

        % set up polynomial objects in x-k

        ps= update(ps,[ps.knot;p]);

        % do we still want this

        ps.Store.X= x;
        ps.Store.y= y;
        ps.Store.r= r;

        Ji= jacobian(ps,x);
        if ~isempty(Wc)
            if size(wc,1)~=size(Ji,1)
                yhat= Xs*p;
                wc= choltinv(covmodel(ps),yhat,x);
            end
            Ji= wc*Ji;
        end
        ps.Store.Jacob = Ji;

        % what length should these be ? ni
        YHAT{i}= yhat;

        PS{i}= ps;

        % parameter matrix
        B(:,i)= double(ps);
        J{i}= Ji;
    end
end

if nargout>1 && isa(DATA,'sweepset')
    res= cell2sweeps(DATA(:,1),res);
else
    res= cat(1,res{:});
end