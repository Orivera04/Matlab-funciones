% Example file that demostrates working of 
% the solver for fuzzy linear system of equations 
% 
%
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.


A=[0.8 0.8 0
   0 0.6 0.6
   0.7 0 0.7];

B=[0.8
   0.6
   0.7];

s=FillHelpMatrix(A,B)

if s.exist
    hs=sterm(s.hlp(1,:));
    for i=2:length(s.hlp(:,1))
        hs=hs*sterm(s.hlp(i,:));
    end
end

minsol=sterm2num(hs,length(s.Xgr));
for i=1 : length(minsol) disp_f2('',minsol{i}); end;

fuzzy_maxmin(A,s.Xgr')

for i=1 : length(minsol) 
    if any(fuzzy_maxmin(A,minsol{i}')-B)
        disp(' Wrong solution')
    else
        solu=sprintf('%5.2f',minsol{i});
        disp(['Minimal solution ' num2str(i) ' is correct!. S=[' solu ' ]T'])
    end
end;
