function m = set(m,prop,value)
%SET Overloaded set function for xreg3xspline
%
%  Value= get(m,'Property')
%  Properties
%    'symbol'       Factor Labels
%    'order'        Factor Order
%    'knots'        Knot Position (in (-1,1)).
%    'naturalknots' Raw knots
%    'interact'     Interaction Level
%    'spline'       Index to Spline Variable

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.3 $  $Date: 2004/04/20 23:19:02 $

switch lower(prop)
    case 'knots'
        Tgt=gettarget(m,m.splinevar);
        if any(value<=Tgt(1) | value>=Tgt(2))
            error('Knots must be in model range')
        end
        nk= length(m.knots);
        m.knots= sort(value(:)');
        if length(m.knots) ~= nk
            nterms=i_countterms(m);
            m= update(m,(1:nterms)');
        end

    case 'naturalknots'

        i=m.splinevar ;
        [L,U]=range(m);
        if any(value<L(i) | value>U(i))
            error('Knots must be in model range')
        end

        K= code(m,value(:),i);

        nk= length(m.knots);
        m.knots= K(:)';
        if length(m.knots) ~= nk
            nterms=i_countterms(m);
            m= update(m,(1:nterms)');
        end

    case 'interact'
        ni= m.interact;
        m.interact= value;
        if m.interact ~= ni
            nterms=i_countterms(m);
            m= update(m,zeros(nterms,1));
        end

    case 'spline'
        % change spline variable
        %   Knots are kept in their coded positions.
        %   Need to reassemble label and orders from xregcubic and here, then redistribute
        if value==m.splinevar
            return
        end
        nf=nfactors(m);
        if value>0  && value<=nf
            symb=get(m,'symbol');
            ord=get(m,'order');
            oldsplord=m.poly_order;

            m.splinevar=value;
            m.poly_order=ord(value);
            ord(value)=[];
            symb(value)=[];
            m.cubic=xregcubic(ord,symb);
            o3= reorder(m.cubic);
            i=m.splinevar ;
            o3(o3>=i)= o3(o3>=i)+1;
            % insert spline variable in correct position
            m.reorder = [i o3];
            if m.poly_order~=oldsplord
                % update xreglinear
                nterms=i_countterms(m);
                m= update(m,zeros(nterms,1));
            end
        end
    case 'order'
        if any(value>3) || any(value<0)
            return
        end
        nf=nfactors(m);
        if length(value)~=nf
            return
        end
        splord=value(m.splinevar);
        value(m.splinevar)=[];
        % update data
        m.poly_order=splord;
        symb=get(m.cubic,'symbol');
        % reconstruct xregcubic
        m.cubic=xregcubic(value,symb);
        o3= reorder(m.cubic);
        i=m.splinevar ;
        o3(o3>=i)= o3(o3>=i)+1;
        % insert spline variable in correct position
        m.reorder = [i o3];

        % update xreglinear
        nterms=i_countterms(m);
        m= update(m,(1:nterms));
    case 'numknots'
        nk= value;
        [L,U]=range(m);
        k= linspace(L(m.splinevar),U(m.splinevar),nk+2);
        m= set(m,'naturalknots',k(2:end-1));
    otherwise
        % Call parent set
        m.xreglinear= set(m.xreglinear,prop,value);
end

if nargout==0
    assignin('caller',inputname(1),m)
end





function len=i_countterms(m)

Ns= length(m.knots) + m.poly_order + 1;
N=order(m.cubic);

% PHI Terms
len= Ns;
for i=1:N(1)
    if m.interact>=1
        % Xi * PHI terms
        len = len + Ns;
    else
        % Xi * [1 X1 X1^2] terms
        len=len+3;
    end
    for j=i:N(2)
        if m.interact>=2
            % Xi * Xj * PHI terms
            len = len + Ns;
        else
            % Xi * Xj * [1 X1] terms
            len=len+2;
        end
        for k=j:N(3)
            % Xi * Xj * Xk  terms
            len=len+1;
        end
    end
end
return