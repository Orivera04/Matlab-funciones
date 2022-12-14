function zt = estdatch(z,Tmod)
%ESTDATCH Checking an IDDATA object before estimation

%   Copyright 1986-2003 The MathWorks, Inc.
%   $Revision: 1.1.4.1 $  $Date: 2004/04/10 23:15:47 $

zt = z;
docheck = 1;
if nargin<2
    Tmod = 1;
end
try
    if z.Utility.Checkdone
        docheck = 0;
    end
end
if docheck
    zt.Utility.Checkdone = 1;
    td = unique(cat(1,z.Ts{:}));
    ints = unique(z.InterSample);
    
    if length(td)>1|length(ints)>1
        if Tmod
            warning(sprintf(['The data set contains experiments with different sampling',...
                    ' intervals, \nand/or different intersample behaviours.',...
                    '\nThe estimated model will be marked by sampling interval ',...
                    num2str(z.Ts{1}), ' and intersample ',z.InterSample{1,1},...
                    '\nSince you estimate a discrete time model this could',...
                    ' give a bad estimate. \nA proper way of dealing with this would be to',...
                    ' estimate one model for each experiment,\nconvert these to continuous time',...
                    ' by D2C and then merge the continuous time models using MERGE.']))
        else
            warning(sprintf(['The data set contains experiments with different sampling',...
                    ' intervals, \nand/or different intersample behaviours.',...
                    '\nThe current code does not support this situation, but all data will',...
                    ' be considered to \nhave sampling interval ',...
                    num2str(z.Ts{1}), 'and intersample behaviour',z.Intersample{1,1},...
                    '\nThis could',...
                    ' give a bad estimate. \nA proper way of dealing with this would be to',...
                    ' estimate one model for each experiment,\nand then merge these',...
                    ' continuous time models using MERGE.']))
        end
    end
    blnr = find(strcmp(ints,'bl'));
    if ~isempty(blnr)
        if strcmp(lower(z.Domain),'time')
            zt.InterSample(blnr) = {'foh'};
            if Tmod
                warning(sprintf(['You have a time domain data set that is marked as ''BandLimited''.',...
                        '\nSince you estimate a  discrete time model, this will be ignored and',...
                        '\nthe estimated model will be be marked by ''foh'' intersample behaviour.']))
            else
                warning(sprintf(['You have a time domain data set that is marked as ''BandLimited''.',...
                        '\nThe best way to build a continuous time model from these data is to',...
                        '\nconvert to the frequency domain:\n DATAF = FFT(DATA) and then call the',...
                        ' estimation routine.\nNow the data will be treated as ''FOH'' (first',...
                        ' order hold = piecewise linear).']))
            end
        else
            if zt.Ts{1}
                warning(sprintf(['You have a frequency domain data set that is marked both as \n''BandLimited'' and discrete time.',...
                        '\nIf you estimate a discrete time model, this will be ignored and',...
                        '\nthe estimated model will be be marked by ''foh'' intersample behaviour.',...
                        '\nIf you intend to build continuous time models, you should set Ts=0 in your data set.']))
                zt.InterSample(blnr) = {'foh'};
            end
        end
    end 
end  