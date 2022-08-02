function[pre_resid, alpha]=testHSDT(x,resid,testType)
    if nargin<3, testType='Breusch-Pagan';
    end

    %regress residues against x to compute test statistic
    switch lower(testType)
        case {'harvey'}
            %Harvey-Godfrey test
            [beta, rsq] = getRegressionRsq(x,log(power(resid,2)));
             pre_resid = sqrt( exp(x * beta));
        case {'glesjer'}
            %Glesjer test
            [beta, rsq] = getRegressionRsq(x,abs(resid));
            pre_resid = abs(x * beta);
        otherwise
            %Breusch-Pagan / whites test
            [beta, rsq] = getRegressionRsq(x,power(resid,2));
            pre_resid = sqrt( abs(x * beta));
    end
    
    % rsqure * N is the Chi square test-statistic with x-1 dof
    alpha = 1- chi2cdf( rsq * size(x,1), size(x,2)-1);
end

