function [wts, hetroFlag, wtx, wty, alpha] = wtdLSRgression(x, y, alphaIn, testType)

    if nargin<4, testType='harvey';
        if nargin<3, alphaIn=0.05;
        end
    end
    
    bOrig = x\y;
    
    yhat = x * bOrig;
    resid = y - yhat;
    hetroFlag = false;
    
    %test for Heteroskedasticity and get weights
    [wts, alpha] = testHSDT(x,resid, testType);
    
    if (alpha > alphaIn), hetroFlag = true;
    end
    
    % weight the input data based on this
    wty = y ./wts;
    wtx =x ./ repmat(wts, 1, size(x,2));
    
end
  
    
