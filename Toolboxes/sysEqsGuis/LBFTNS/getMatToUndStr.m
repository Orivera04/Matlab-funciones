function vertStr=getMatToUndStr(m)

[r c]=size(m);
mL=zeros(1,c);%maxL
for(ithC=1:c)
	for(ithR=1:r)
		if(mL(1,ithC)<length(num2str(m(ithR,ithC))))
			mL(1,ithC)=length(num2str(m(ithR,ithC)));
		end
	end
end
%create the undScores
vertStr='';
for(ithR=1:r)
    tempStr='';
	for(ithC=1:c)
		
			xNumUnd=mL(1,ithC)-length(num2str(m(ithR,ithC)));
            tempUnds='';
			for(i=1:(xNumUnd+1))%it has to go through this atleast once due to the separation
				tempUnds=strcat(tempUnds,'_');
            end
            if(ithC==1)
                  tempStr='';
            end
                
              tempStr=strcat(tempStr,num2Str(m(ithR,ithC)),tempUnds);
    end
   
   vertStr=strvcat(vertStr,tempStr);
end

