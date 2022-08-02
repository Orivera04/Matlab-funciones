
function resultStr=showEq(ftnStr, fullConstStr)
%ie. ftnStr(1,:)=>'x*2*z=Yn', fullConstStr(1,:)=>'x=12' result=> '12*2*z=Yn'
%need strvcat to recollect it in a vertical sense
[r c]=size(ftnStr);
[cR cC]=size(fullConstStr);

%separate the const and the values into two vector
strCon='';
numVal=(1:cR)';
for(t=1:cR)
	[con rem]=strtok(fullConstStr(t,:),'=');
	strCon=strvcat(strCon,con);
	numVal(t)=str2num(rem(2:end));
end
%substitute these values into the the ftns
resultStr='';
needSub=-1;
for(i=1:r)%for each equation
    tempEq='';
    prevTemp='';
    updateFtn=ftnStr(i,:);
	for(ithCon=1:cR)
        [f L]=strtok(ftnStr(i,:),strCon(ithCon,:));
        if(length(L)>0)
            needSub=1;
            tempEq=subs(updateFtn,strCon(ithCon,:),numVal(ithCon));
            tempEq=char(tempEq);
            updateFtn=tempEq;
        end
    end
    if(needSub==1)
        resultStr=strvcat(resultStr,updateFtn);
    else
        resultStr=strvcat(resultStr,ftnStr(i,:));
    end
    needSub=-1;
end





	