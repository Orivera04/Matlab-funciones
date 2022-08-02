function ver=modVerTxtEq(ithEq,allEq,newFtnStr)
[r currColSize]=size(allEq);
newColSize=length(newFtnStr);
ver=allEq;
oldFtnStr=allEq(ithEq,:);
v='';
if(currColSize>newColSize)
%don't shrink all of them just "shrink" the ithEq(while still keep the length at currColSize)
%case 1
ver(ithEq,:)=modHorTxtEq(oldFtnStr,newFtnStr,1);%keep the same old length

elseif(currColSize<newColSize)
%expand all to the new length
    for(i=1:r)
        %case 2
        if(i==ithEq)%need to expand it's size and change it's function
            vCat=modHorTxtEq(ver(i,:),newFtnStr,2);
        %case 3
        else %it just needs to change it's size
            vCat=modHorTxtEq(ver(i,:),newFtnStr,3);
        end
        v=strvcat(v,vCat);
    end
    ver=v;
else
%just modify this one
%case 4
	ver(ithEq,:)=modHorTxtEq(oldFtnStr,newFtnStr,4)%keep the same old length
end

