function n_clock=clockwise(P)
%CLOCKWISE judging the direction(clockwise or anti-clockwise) of a closed curve by provided coordinates of nodes
% N_CLOCK=CLOCKWISE(P)
%  P is a two row matrix which provides the coordinates of the nodes of curve in the following way
%  P=[x1 x2 ... xn
%    y1 y2 ... yn]
% N_CLOCK=1  for clockwise
% N_CLOCK=-1  for anti-clockwise
len=size(P,2); %number of nodes

% three continuous nodes for judging: A->C->B
c_index=min(find(P(2,:)==max(P(2,:)))); % index of the node with maximum y
if(c_index==1) % if C is the first point in P
    a_index=len;
else
    a_index=c_index-1;
end
if(c_index==len) % if C is the last point in P
    b_index=1;
else
    b_index=c_index+1;
end
xa=P(1,a_index);
ya=P(2,a_index);
xb=P(1,b_index);
yb=P(2,b_index);
xc=P(1,c_index);
yc=P(2,c_index);
 
if(xa<=xc)
    if(xb>=xc)
        n_clock=1;
    else % xa<=xc and xb<xc 
        if(xa==xc) % Ka is infinity
            n_clock=-1;
        else
            Ka=(yc-ya)/(xc-xa);
            Kb=(yc-yb)/(xc-xb);
            if(Ka>Kb)
                n_clock=-1;
            else
                n_clock=1;
            end
        end
    end
else % xa>xc
    if(xb<=xc)
        n_clock=-1;
    else % xa>xc and xb>xc
            Ka=(yc-ya)/(xc-xa);
            Kb=(yc-yb)/(xc-xb);
            if(Ka>Kb)
                n_clock=-1;
            else
                n_clock=1;
            end
    end
end