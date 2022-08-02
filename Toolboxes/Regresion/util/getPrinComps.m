function [xOut, num, latent, coeff, xProjOut]= getPrinComps(xIn, varCutOff, poolSizeMin, xProj)
    
    xProjFlag=true;
    if nargin<4, xProjFlag=false;
    end

    if nargin <2 || isempty(varCutOff), varCutOff = 1e-6;
    end
    
    if nargin <3 || isempty(poolSizeMin), poolSizeMin =1;        
    end

    poolSize = size(xIn,2);
    if poolSizeMin>poolSize
        error(' Minimum No of indicators asked for is higher than input number of indicators');
    end
     
    [coeff,score,latent] = princomp(xIn);
    
    indexArray = latent >= varCutOff;
    if sum(indexArray)<poolSizeMin, indexArray(1:poolSizeMin) =1;
    end
    
    num = sum(indexArray);
    xOut = score(:,indexArray);
    xProjOut = zeros(1,num);
    
    if xProjFlag && ~isempty(xProj)
        xProj = xProj - mean(xIn);
        xProjOut = xProj*coeff;
        xProjOut = xProjOut(:,indexArray);
    end
    coeff(:,~indexArray)=[];
end
