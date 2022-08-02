function p = le(v,w)
% function p = le(v,w)
% "smaller than than or equal " for two terms
% p =1 if  v <= w
% p =0 if  v >= w
% p =-1 if  not comparable   ne sa sravnimi
% 
% Fuzzy Relational Calcululs Toolbox Rel. 1.1a   
% Copyright (C) 2004-2009 Yordan Kyosev and Ketty Peeva 
% Fuzzy Relational Calcululs Toolbox comes 
% with ABSOLUTELY NO WARRANTY; for details see License.txt 
% This is free software, and you are welcome to redistribute 
% it under certain conditions; see license.txt for details.

Lv=length(v);
Lw=length(w);
if Lv<=Lw
    
    [vn,vd]=term2num(v);
    [wn,wd]=term2num(w);
    [tf,loc]=ismember(vd,wd);
    
    if all(tf)
        for i=1:length(tf)
            if v(i).n<=w(loc(i)).n
                v_Less_w(i)=1;
       %         w_Less_v(i)=0;
            else
                v_Less_w(i)=0;
        %        w_Less_v(i)=1;
            end
        end
        if all(v_Less_w)
            p=1;
            %elseif all(w_Less_v)
           % p=0;
        else
            p=-1;
        end
    else
        p=-1;
    end
    
else
    p=le(w,v);
    switch p
        case 1
            p=0;
        case 0
            p=1;
    end
    %    change v i w i Lv i Lw, ili recursia and change the result
    % and the result
end
