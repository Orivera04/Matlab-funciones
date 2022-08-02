% This is not setup like Wolfram's!  I don't know how he represents the
% concept of a cell staying the same in binary.  I tried different ideas
% w/o success.  My system uses a value one higher than your cell value
% choices to represent staying the same.  But my code numbers will be
% different from his.  GOL is 45
gol=a(:,:,end);
for ro = 2:(totalrows-1);
    for col = 2:(columns-1);
        neighbors=a(ro-1,col,end)+a(ro+1,col,end)+a(ro,col-1,end)+a(ro,col+1,end)+a(ro-1,col-1,end)+a(ro-1,col+1,end)+a(ro+1,col-1,end)+a(ro+1,col+1,end);
        neighbors=(possiblestates+1)-neighbors-1;
        changetoo=rulenumberbinary(neighbors);
        if changetoo<rulecolors;
            gol(ro,col)=changetoo;
        end;
    end;
end;
a(:,:,end)=gol;
