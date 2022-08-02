function x=invcode(m,x,factnum)
%INVCODE Invert X coding transformation [-1,1]-> [min,max]
%
%  x=INVCODE(m,x)
%
%  x=INVCODE(m,x,factornum) inverse codes all the values in x using the
%  coding for the factor specified.  Several factor numbers may be
%  specified, so long  as there are the same number of columns in x.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.4.3 $  $Date: 2004/04/04 03:30:22 $

if isempty(x)
    return
end

if ~isempty(m.code)
    if nargin<3
        factnum=1:size(x,2);
    else
        nf=nfactors(m);
        if length(factnum)~=size(x,2)
            error('The number of factors and the size of x do not match!');
        end
        if any(factnum>nf | factnum<1)
            error('The number of factors and the size of x do not match!');
        end
        smallx=x;
        x=zeros(size(smallx,1),nf);
        x(:,factnum)=smallx;
    end
    if length(m.code) == size(x,2)
        s = warning('off');
        for i=factnum;
            c= m.code(i);
            g = c.g;
            % g is an inline object or empty
            if isfinite(c.range)
                % c.range is set to Inf if coding is 1:1
                range= c.max-c.min;
                if ~isempty(g)
                    ginv= finverse( sym(g) );
                    ginv= inline( ginv );
                    x(:,i)= ginv(x(:,i)*range/c.range + c.mid);
                else
                    x(:,i)= x(:,i)*range/c.range + c.mid;
                end
            else
                if isfinite(c.mid)
                    x(:,i)= x(:,i) + c.mid;
                end
                if ~isempty(g)
                    ginv= finverse( sym(g) );
                    ginv= inline( ginv );
                    x(:,i)= ginv(x(:,i));
                end
            end
        end
        warning(s);
    else
        error('Coding information does not match X matrix')
    end
    if nargin>2
        % extract just the columns that were passed in
        x=x(:,factnum);
    end
end
