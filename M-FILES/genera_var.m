%Generación de variables


    M=[2,3;5,7];
    for i=1:2
        for j=1:2
         strcat('M(',num2str(i),',',num2str(j),') = ',num2str(M(i,j)))
    
        end
    end
