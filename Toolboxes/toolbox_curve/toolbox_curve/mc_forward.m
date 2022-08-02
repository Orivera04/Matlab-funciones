function mc = mc_forward( c, J, type )

% mc_forward - perform fwd multiresolution curve.
%
% mc = mc_forward( c, J, type );
%
%   'type' is the kind of predictor used, can be either 'linear' or 'cubic'
%   J is the level of subdivision (ie. the transform will use 2^J coefs).
%
%   The wavelets coefficients are stored in 'mc.coef' and the extremity
%   points are in 'mc.begin' and 'mc.end'.
%
%   Copyright (c) 2004 Gabriel Peyré

if nargin<2
    J = 4;
end

if nargin<3
    type = 'linear';
end


mc.type = type;


mc.begin = c(:,1);
mc.end   = c(:,end);
mc.coef = [];

% reconstructed curve at current level
cc = [c(:,1), c(:,end)];
Icc = [1, size(c,2)];       % index of the selected points 

for j=1:J
    P = size(cc,2);  % number of points
    
    cc1 = [];   % new points to add at current level
    Icc1 = [];
    
    for i = 1:P-1
        
        x1 = cc(:,i);
        x2 = cc(:,i+1);
        Ix1 = Icc(i);
        Ix2 = Icc(i+1);
        
        if i>1
            x0 = cc(:,i-1);
        else
            x0 = x1;
        end
        if i<P-1
            x3 = cc(:,i+2);
        else
            x3 = x2;
        end
        
        % perform prediction
        if strcmp(type,'linear')
            x = (x1+x2)/2;    
        elseif strcmp(type,'cubic')
            x = -x0/16 + x1*9/16 + x2*9/16 - x3/16;    
        else
            error('Unknown scheme.');
        end

        % compute normal
        n = x2-x1;  n = [-n(2); n(1)];  
        if norm(n,'fro')>0
            n = n / norm(n,'fro');
        end
        % signed distance from point y in c to line (x,n) is d=(xy^u)/|u|
        xy = [ c(1,:) - x(1); c(2,:) - x(2) ];
        D = ( xy(1,:).*n(2)-xy(2,:).*n(1) );
        
        % locate zero crossing
        I1 = findzeros(D);
        if isempty(I1)
            warning('Fail to find an intersection point.');    
            [tmp, I1] = min(abs(D));
        end
        
        % extract the zeros that lies between x1 and x2
        if Ix1>Ix2 % swap index
            tmp = Ix1; Ix1 = Ix2; Ix2 = tmp;
        end
        
        I2 = find( I1>=Ix1 & I1<=Ix2 );
        if isempty(I2)
            warning('Fail to find an intersection point.');
            [m,I2] = min( abs(I1 - (Ix1+Ix2)/2) );
        end
        I = I1(I2(1));
        Icc1 = [Icc1, I];
        
        % find closest point
        y1 = c(:,I);  d1 = D(I);
        if I>1 && D(I)*D(I-1)<0
            y2 = c(:,I-1);    d2 = D(I-1);
        else
            y2 = c(:,I+1);    d2 = D(I+1);
        end
        % interpolate position
        y = abs(d2)/(abs(d1)+abs(d2))*y1 + abs(d1)/(abs(d1)+abs(d2))*y2;
        
        % the coefficient !
        mc.coef = [mc.coef, dot( y-x,n )];
        cc1 = [cc1,y];
        
    end
    
    % create new vector by entrelacing new/old
    cc(:,1:2:2*P-1) = cc;
    cc(:,2:2:2*P-1) = cc1;
    Icc(1:2:2*P-1) = Icc;
    Icc(2:2:2*P-1) = Icc1;
    
end
