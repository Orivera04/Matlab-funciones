b=a(end,:,end);
for point = 1:columns;
    if 1<point & point<columns;
        pointleft=(point-1);
        pointright=(point+1);
    elseif point==1;
        pointleft=columns;
        pointright=(point+1);
    elseif point==columns;
        pointleft=(point-1);
        pointright=1;
    end;
    if (a(end,pointleft,end)==1 & a(end,point,end)==0 &...
            a(end,pointright,end)==0)  | (a(end,pointleft,end)==0 &...
            a(end,point,end)==0 & a(end,pointright,end)==1);
        b(end,point)=1;
    else b(end,point)=0;
    end;
end;
a(end,:,end)=b;