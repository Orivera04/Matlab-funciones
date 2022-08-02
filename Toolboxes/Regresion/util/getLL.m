function [z]=getLL(y,x,b,fitType)

    if nargin<4, fitType='LOGIT';
    end

    switch lower(fitType)
        case 'logit'
            z = sum( y.*(x*b) - log( exp(x*b)+1 ) );
        otherwise
            z= -( numel(y) ./ 2 ) * ( 2.8379 + log( (norm(y-x*b)^2) ./ numel(y) )  );
    end
    
end

    