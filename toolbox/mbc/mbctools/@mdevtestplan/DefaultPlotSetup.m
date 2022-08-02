function T= DefaultPlotSetup(T);
%MDEVTESTPLAN/DEFAULTPLOTSETUP 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.2 $  $Date: 2004/02/09 08:07:06 $


m= HSModel(T.DesignDev);
mlist= getModel(T.DesignDev,':');

[LB,UB,r]= range(m);
mid= (LB(:)+UB(:))/2;

cs= [mid r(:)/10];

T.PlotSetup.CrossSection= cs;



stInd= 1;
for i=1:length(mlist)

    switch nfactors(m)-stInd+1;
        case 1
            rs= { {LB(stInd) UB(stInd), 21} };
        case 2
            rs= { {LB(stInd) UB(stInd), 21} {LB(stInd+1) UB(stInd+1), 21} };
        otherwise
            rs= [ {{LB(stInd) UB(stInd), 21}} {{LB(stInd+1) UB(stInd+1), 21}} num2cell( mid(stInd+2:end)') ];
    end
    
    if nfactors(mlist{i})==1
        DispType= 2;
    else
        DispType= 5;
    end
    % stage model (local, global etc)
    nf= nfactors(mlist{i});
    T.PlotSetup.RespSurf(i).Stage = {rs(1:nf), DispType};
    
    if i~=length(mlist)
        if  nfactors(m)-stInd+1==1
            DispType= 2;
        else
            DispType= 5;
        end
        % response model - don't do for the last one
        T.PlotSetup.RespSurf(i).Response = {rs,DispType} ;
    end 
    
    stInd= stInd+ nf;
end


xregpointer(T);
