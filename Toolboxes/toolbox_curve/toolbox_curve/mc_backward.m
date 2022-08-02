function c = mc_backward( mc )

% mc_backward - perform bwd multiresolution curve.
%
% c = mc_backward( mc )
%
%   Copyright (c) 2004 Gabriel Peyré


type = mc.type;

coef = mc.coef;
% nbr coef = 2^J-1;
J = floor( log2(length(coef)+1) );

% reconstructed curve at current level
c = [mc.begin, mc.end];


k = 1;  % number of extracted coef

for j=1:J
    
    P = size(c,2);  % number of points
    
    cc1 = [];   % new points to add at current level
    
    for i = 1:P-1
        
        x1 = c(:,i);
        x2 = c(:,i+1);
        
        % perform prediction
        if i>1
            x0 = c(:,i-1);
        else
            x0 = x1;
        end
        if i<P-1
            x3 = c(:,i+2);
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
        n = x2-x1;  n = [-n(2); n(1)];  n = n / norm(n,'fro');
        
        y = x + n*coef(k);
        k = k+1;
        
        cc1 = [cc1,y];
        
    end
    
    % create new vector by entrelacing new/old
    cc_new = zeros(2,2*P-1);
    cc_new(:,1:2:end) = c;
    cc_new(:,2:2:end) = cc1;
    c = cc_new;    
end