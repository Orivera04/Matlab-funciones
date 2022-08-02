function [k,g]=nhieutrenduoi(s)
    k=1;
    for i=1:(length(s)-11)        
        mau=min([s(i) s(i+1) s(i+2) s(i+3) s(i+4) s(i+5) s(i+6) s(i+7) s(i+8) s(i+9) s(i+10) s(i+11)]);
        d=[round(s(i)/mau) round(s(i+1)/mau) round(s(i+2)/mau) round(s(i+3)/mau) round(s(i+4)/mau) round(s(i+5)/mau) round(s(i+6)/mau) round(s(i+7)/mau) round(s(i+8)/mau) round(s(i+9)/mau) round(s(i+10)/mau) round(s(i+11)/mau)];        
        if (max(d)-min(d)) > 3
            k=k+1;
        elseif (max(d)-min(d)) <= 3
            break;
        end
    end
    k=k;
    g=1;
    for i=length(s):-1:12        
        mau=min([s(i) s(i-1) s(i-2) s(i-3) s(i-4) s(i-5) s(i-6) s(i-7) s(i-8) s(i-9) s(i-10) s(i-11)]);
        d=[round(s(i)/mau) round(s(i-1)/mau) round(s(i-2)/mau) round(s(i-3)/mau) round(s(i-4)/mau) round(s(i-5)/mau) round(s(i-6)/mau) round(s(i-7)/mau) round(s(i-8)/mau) round(s(i-9)/mau) round(s(i-10)/mau) round(s(i-11)/mau)];       
        if (max(d)-min(d)) > 3
            g=g+1;
        elseif (max(d)-min(d)) <= 3
            break;
        end
    end
    g=g;