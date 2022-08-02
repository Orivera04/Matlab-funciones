function [anios,capital]=interes(capin,anioin,aniofin)
    anios=0;
    capital=capin;
    for i=anioin+1:aniofin;
        anios=anios+1;
        capital=capital+capital*0.06;
    end
end
