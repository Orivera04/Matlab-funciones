subplot(2,2,1)
       a = zeros(30,30);          
       a(:,15) = 0.2*ones(30,1);  
       a(7,:) = 0.1*ones(1,30);   
       a(15,15) = 1;              
       mesh(a),grid off