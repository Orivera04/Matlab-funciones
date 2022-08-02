function nVal=getNextIter(ftnStr,ICStr,ICVal)
%ftnStr includes all the numeric values of the string
%ICVal is a row vector
[r c]=size(ftnStr);
[iR iC]=size(ICVal);

if(iR==1)%this way you get the right vector size
    iR=iC;
end

%obtain just the next values
for(i=1:r)
    tempEq='';
    updateFtn=ftnStr(i,:);
	for(ithIC=1:iR)  %loop through all the IC,there's mult. substitution but u can't auto. do it   	 
        
        tempEq=subs(updateFtn,ICStr(ithIC,:),ICVal(ithIC));
          	  updateFtn=char(tempEq);
    	end
    %at this point you should just have a single value
    	[q remain]=strtok(updateFtn,'=');
	nextVal(i)=str2num(remain(2:end));
end
nVal=nextVal;


	