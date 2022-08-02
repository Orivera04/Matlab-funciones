function val= get(m,prop)
%GET Overloaded get for xregcubic
%
%  VALUE = GET(M, PROP) returns the value of the specified property.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.4.3 $  $Date: 2004/02/09 07:45:22 $

if nargin==1
    val= [{'order','reorder','maxinteract'}';get(m.xreglinear)];
else
    switch lower(prop)
        case 'order'
            N= m.N;
            ord= ([-diff(N) N(end)]);
            order= [];
            for i=length(ord):-1:1
                order= [order i*ones(1,ord(i))];
            end
            % Number of 3rd, 2nd, and 1st order factors
            % order= [3*ones(1,N(3)), 2*ones(1,N(2)-N(3)) , ones(1,N(1)-N(2))];
            % Add zero order factors
            order = [order zeros(1,length(m.reorder)-length(order))];
            % Need to reoder as they were stored in descending order
            [s,i]=sort(m.reorder);
            val= order(i);
        case 'reorder'
            val = m.reorder;
        case 'maxinteract'
            val = m.MaxInteract;
        case 'maxallowedinteract'
            val = max(get(m, 'order'));
        otherwise
            % get properties from parent
            val = get(m.xreglinear,prop);
    end
end
