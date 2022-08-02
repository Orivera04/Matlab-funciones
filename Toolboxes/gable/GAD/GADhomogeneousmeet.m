     disp('>> % 	INTERSECTION OF SUBSPACES');
     % 	INTERSECTION OF SUBSPACES
     GAfigure; clc; %/
     disp('>> % 	INTERSECTION OF SUBSPACES');
     % 	INTERSECTION OF SUBSPACES
     disp('>> %');
     %
     global e P Q R S PQ RS M MM; %/
     e = e3;         %/
     size = 1; 	%/
     IP = {e+size*(-e1-e2),e+size*(-e1+e2),e+size*(e1+e2),e+size*(e1-e2)}; %/
     disp('>>      % LINE INTERSECTION AS MEET OF BIVECTORS');
          % LINE INTERSECTION AS MEET OF BIVECTORS
          clf; %/
     disp('>> % extra dimension of the affine embedding');
     % extra dimension of the affine embedding
     disp('>>      e = e3;            ');
          e = e3;            
          draw(e,'k'); %/
          GAview([30 15]); %/
     	axis off; %/
          DrawPolygon(IP,'w'); %/
     disp('>> % points P,Q,R,S');
     % points P,Q,R,S
     disp('>>      P = e- e1/3+0.9*e2;    ');
          P = e- e1/3+0.9*e2;    
          DrawHomogeneous(e,P,'n','b'); GAtext(1.07*P,'P'); %/
     disp('>>      Q = e+ 0.9*e1+e2/2;    ');
          Q = e+ 0.9*e1+e2/2;    
          DrawHomogeneous(e,Q,'n','b'); GAtext(1.07*Q,'Q'); %/
     disp('>>      R = e- e1/2-e2/4;  ');
          R = e- e1/2-e2/4;  
          DrawHomogeneous(e,R,'n','b'); GAtext(1.07*R,'R'); %/
     disp('>>      S = e+ 0.9*(e1+e2);');
          S = e+ 0.9*(e1+e2);
          DrawHomogeneous(e,S,'n','b'); GAtext(1.07*S,'S'); %/
          axis([-size size -size size (-2*size+1.2) 1.2]); %/
     disp('>> % lines');
     % lines
     disp('>>      PQ = join(P,Q);  ');
          PQ = join(P,Q);  
          %% DrawHomogeneous(e,PQ,'n','c'); %/
     GAprompt;
          DrawSimplex({P,Q},'n','c'); %/
          draw(PQ,'c'); %/
          axis([-size size -size size (-2*size+1.2) 1.2]); %/
     disp('>>      RS = join(R,S);  ');
          RS = join(R,S);  
          %% DrawHomogeneous(e,RS,'n','g'); %/
     GAprompt;
          DrawSimplex({R,S},'n','g'); %/
          draw(RS,'g'); %/
          axis([-size size -size size (-2*size+1.2) 1.2]); %/
          GAprompt; %/
     disp('>> % intersection of those lines');
     % intersection of those lines
     disp('>>      MM = meet(PQ,RS)       ');
          MM = meet(PQ,RS)       
          DrawHomogeneous(e,MM,'n','m'); %/
     	draw(MM,'m'); %/
     disp('>>      M = MM/inner(e,MM); ');
          M = MM/inner(e,MM); 
          DrawHomogeneous(e,M,'n','m'); GAtext(1.07*M,'M'); %/
          axis([-size size -size size (-2*size+1.2) 1.2]); %/
          GAprompt; %/
          GAtilt(-20,5); %/
          GAtilt(40,10); %/
