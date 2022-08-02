function m= setcode(m,Bnds,g,Target)
%SETCODE Set new coding limits and functions
%
%  M = SETCODE(M, [L,U], g, [L_t,U_t])

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:30:25 $

if nargin==2 && isstruct(Bnds)
    m.code= Bnds;
    return
end

tol= sqrt(eps);
nf= nfactors(m);
if nargin<3 || isempty(g)
    g= cell(nf,1);
else
    % Need to transform the bounds
    for i=1:size(Bnds,1)
        if Bnds(i,1)>=Bnds(i,2)
            error('Coding Error: min>=max')
        end
        if ~builtin('isempty',g{i})
            gi= g{i};
            ws = warning('off');
            ginv= inline(finverse(sym(gi)));
            warning(ws);
            if any( abs(ginv(gi(Bnds(i,:)))-Bnds(i,:))> tol*max(abs(Bnds(i,:)),1) )
                error('Coding Transform Error: transform must be unique at bounds')
            end
            x= linspace(Bnds(i,1),Bnds(i,2),101);
            gx= gi(x);
            if ~all(isfinite(gx)) || ~isreal(gx);
                % transform real and finite over [min,max]
                error('Coding Transform Error: transform must be real and finite over [min,max]')
            end
            dg= diff(gx);
            if any(sign(dg)~=sign(dg(1)))
                % inverse unique over [min,max]
                error('Coding Transform Error: transform must be monotonically increasing or decreasing over [min,max]')
            end
            if Bnds(i,1)<=0 && Bnds(i,2)>=0 && ~isfinite(gi(0))
                % transform works at zero
                error('Coding Transform Error: transform must be defined zero')
            end
            Bnds(i,:)= gi(Bnds(i,:));
            if Bnds(i,1)==Bnds(i,2)
                error('Coding Transform Error: transform maps [min,max]->[a,a]')
            end
        end
    end
end


if nargin<4
    % default is to target [-1,1]
    Target= repmat([-1 1],nf,1);
elseif numel(Target)==1 && Target
    % Target==1 means use the Bounds as the target
    Target= Bnds;
    Target(:,2)= Inf;
end

for i=1:nf
    r= Target(i,2)-Target(i,1);
    if isfinite(r)
        if r==0
            error('Coding Error: Target range must be non-zero')
        end
        mid= Bnds(i,1) - (Bnds(i,2)-Bnds(i,1))*Target(i,1)/r;
    else
        mid=0;
    end
    m.code(i)= struct('min',Bnds(i,1),...
        'max',Bnds(i,2),...
        'g',g{i},...
        'mid',mid,...
        'range',r);
end
