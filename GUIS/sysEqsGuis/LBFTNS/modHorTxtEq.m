
function nStr=modHorTxtEq(oldFtnStr,newFtnStr,caseNum)

	oldFtnSize=length(oldFtnStr);
	newFtnSize=length(newFtnStr);
	if(caseNum==1)
	%keep the oldFtnSize but add white spaces
		numWhiteSpace=oldFtnSize-newFtnSize;
		w='';
		%trick to cat white space
		for(i=1:numWhiteSpace)
			w=strcat(w,'_');
		end
		q=strcat(w,newFtnStr);
		for(i=1:numWhiteSpace)
			q(1,i)=' ';
		end
		nStr=q;
	elseif(caseNum==2)
		%expand to the newFtnSize and change it's function
		%expand it's size		
		numWhiteSpace=newFtnSize-oldFtnSize;
		w='';
		%trick to cat white space
		for(i=1:numWhiteSpace)
			w=strcat(w,'_');
		end
		q=strcat(w,newFtnStr);
		for(i=1:numWhiteSpace)
			q(1,i)=' ';
		end
		nStr=q;
		
	elseif(caseNum==3)
		%expand it's size		
		numWhiteSpace=newFtnSize-oldFtnSize;
		w='';
		%trick to cat white space
		for(i=1:numWhiteSpace)
			w=strcat(w,'_');
		end
		q=strcat(w,oldFtnStr);
		for(i=1:numWhiteSpace)
			q(1,i)=' ';
		end
		nStr=q;
	else %case 4
	     %just modify the equation without change it's size		
		nStr=newFtnStr;
	end
