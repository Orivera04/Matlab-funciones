function saveStrEqValToFile(dirFile,s)
    %s is the StrEqVal
    %it must have the str=Val format
    file=fopen(dirFile,'w');
    [r c]=size(s);
    s
    for(i=1:r)
        [fir rem]=strtok(s(i,:),'=')
        fir=strcat(fir,'=');
        if(i==1)
            fprintf(file,[fir num2str(rem(2:end))]);
        else
            fprintf(file,['\n' fir num2str(rem(2:end))]);
        end
    end
	fclose(file);