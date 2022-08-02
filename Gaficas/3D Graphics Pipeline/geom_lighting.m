



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% World transformation co-ordiantes%%%%%%%%%%%
Tx =  0;
Ty =  0;
Tz =  0;

Qx = pi;   %rotation angle used for rotation along x-axis
Qy = 0;   %rotation angle used for rotation along x-axis
Qz = 0;   %rotation angle used for rotation along x-axis

%must set all of the values(rot_x ....) to 0 or 1
rot_x  = 0;  % set to 1 for rotation accoss x-axis 
rot_y = 1;   % set to 1  for rotation accross y-axis
rot_z = 0;   % set to 1 for rotation accorss z-axis

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Scaling factor scaling
Sx = 4;
Sy = 4;
Sz = 4;
%%%%%%%%%%%%%%%%%%% view transformation parameter%%%%%%%%
a = pi/6;  % field of view
r = 1;     % aspect ratio
n = 0.5;   % near plan;
f = 1.2;   % far plan

%%%%%%%%%%%%%%%%%% parameters for on/off of stages in pipeline %%%%%%%%%%

rot   =   1;    % if set = 1 turn on the rotation stage
world_trans =   1;    % if set = 1 turn on the translation 
proj  =   1;    % for prospective projection
culon =   1;    % for  culling 
lighting = 1;   % for lighting
view_method =1; % for view transform
clipping =1;    % for clipping

zsort = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
color_info = []; % it should be left as it is

%%%%%%%%%%%%%%%%%   parameters for view transformation %%%%%%%%%%%%%%%
        cam_pos = [100 100 100];
        look_pt = [0   0     0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% light position             %%%%%%%%%%%%%%%%%%%%%%%
 Light_pos = [10 -5 10];
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
%%%%%%                 emissive              %%%%%%%%%%%%%%%%%%%%%%%
  
         Cemis = [0.21 0.30 0.43];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
 
%%%%%%%%%%%%%%%%%        diffusion            %%%%%%%%%%%%%%%%%%%%%%%%
Mdiff = [0.34 0.46 0.98];
Ldiff = [0.52 0.62 0.52];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%% ambient               %%%%%%%%%%%%%%%%%%%%%%%%%%%%
Mamb = [0.25 0.35 0.40];
Lamb = [0.21 0.31 0.31];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%% specular           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SMspec =    [0.54 0.35 0.46];  
Lspec =     [0.42 0.52 0.35];  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%         Translation matrix      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   T  = [1  0   0  0 
         0  1   0  0
         0  0   1  0
         Tx Ty  Tz 1] ; 
     
  




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%         Rotational  matrix      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 
 
rotx = [1    0         0        0         
        0    cos(Qx)    sin(Qx)   0
        0   -sin(Qx)    cos(Qx)   0
        0    0         0        1];
    
roty = [cos(Qy)    0        -sin(Qy)        0         
        0          1        0               0
        sin(Qy)    0        cos(Qy)        0
        0         0        0             1];
    
rotz =  [ cos(Qz)    sin(Qz)   0   0
         -sin(Qz)    cos(Qz)   0   0
          0         0        1   0
          0         0        0   1];       
      
          
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%         Scaling  matrix      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   S  = [Sx 0 0 0 
         0 Sy 0 0
         0 0 Sz 0
         1 1 1  1] ; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%         Projection   matrix      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Tproj  =     [1/r*cot(a/2)     0              0               0  
                  0                cot(a/2)       0               0
                  0                0              f/(f-n)         1 
                  0                0             -(f*n)/(f-n)     0] ; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% Triangle drawing and object forming
x = load('shuttle_breneman_whitfield.raw');
set(0,'DefaultPatchEdgeColor','none');
[row col] = size(x);
X = [];
Y=  [];
Z = [];
for i = 1:row
    j =1; 
    
    K = [ x(i,j)   ;   x(i,j+3) ;  x(i,j+6)];
    L = [ x(i,j+1) ;  x(i,j+4)  ; x(i,j+7)];
    M = [ x(i,j+2) ;  x(i,j+5)  ; x(i,j+8)];  
    
%   patch(K,L,M,'FaceColor','interp');
 
    X = [X;K];
    Y = [Y;L];
    Z = [Z;M];
end  

  % translation  from object to word
  % combine to make on matrix
  C  = [X Y Z]; 
  C  = [C ones(row*3,1)]; 
  figure
  title('original object');
  for i = 1:3 : 3*row
   H=  [  C(i,1)  ;   C(i+1,1)   ;     C(i+2,1)];
   G = [  C(i,2)  ;   C(i+1,2)  ;     C(i+2,2)];
   N = [  C(i,3)  ;   C(i+1,3)  ;    C(i+2,3)];  
   patch(H,G,N, [rand(1) rand(1) rand(1)]);
  end 



%%%%%%%%%   Translation   %%%%%%%%%%%%%%%%%%%%%
   if(world_trans == 1)
          
   %%%%% Translation      %%%%%%%%%%%%%%%%%%%%       
         for i = 1 : 3*row
         C(i,:)  =  C (i,:)* T;
         end  
         
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
         %%%%%%%%%   rotation      %%%%%%%%%%%%%%%%%%%%%
          if(rot_x == 1)
              for i = 1 : 3*row
              C(i,:)  =  C (i,:)* rotx;
              end
          end
          if(rot_y == 1)
              for i = 1 : 3*row
              C(i,:)  =  C (i,:)* roty;
              end
          end
          if(rot_z == 1)
              for i = 1 : 3*row
              C(i,:)  =  C (i,:)* rotz;
              end
          end
          
     end
  



  
 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%  view transform  %%%%%%%%%%%%%%%%%
if(view_method ==1)
        figure
        title('after view transform');
        set(0,'DefaultPatchEdgeColor','none'); 
        
        n_vec = look_pt - cam_pos;
        n_vec = n_vec./norm(n_vec);
        u_vec = cross(n_vec,[0 1 0]);
        u_vec = u_vec./norm(u_vec);
        
        v_vec = cross(u_vec,n_vec);
        v_vec = v_vec./norm(v_vec);
 Tmet = [u_vec(1,1)                v_vec(1,1)                      n_vec(1,1)                   0 
         u_vec(1,2)                v_vec(1,2)                      n_vec(1,2)                   0
         u_vec(1,3)                v_vec(1,3)                      n_vec(1,3)                   0 
         -(dot(u_vec,cam_pos))    -(dot(v_vec,cam_pos))           -(dot(n_vec,cam_pos))         1] ;
        
        for i = 1 : 3*row
        C(i,:)  =  C (i,:)* Tmet;     %Translation
        end 
        for i = 1:3 : 3*row 
        H=  [  C(i,1)  ;   C(i+1,1)   ;     C(i+2,1)];
        G = [  C(i,2)  ;   C(i+1,2)  ;     C(i+2,2)];
        N = [  C(i,3)  ;   C(i+1,3)  ;    C(i+2,3)];  
        patch(H,G,N,[rand(1) rand(1) rand(1)]);
        end
end     


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%         Lighting          %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
if(lighting == 1)
 figure
 title('after lighting')
 set(0,'DefaultPatchEdgeColor','none'); 
 

Camb = Mamb.*Lamb; %% element wise product;



%Light_pos1 = [0.5 2.5 2.0];


Light_pos ;
Diff = Mdiff.*Ldiff;


Spec = SMspec.*Lspec
%Spec = Spec./norm(Spec);
   
for i = 1 : 3 : 3*row
      cull = 0;
      V1 = [(C(i,1)- C(i+2,1)) (C(i,2)- C(i+2,2)) (C(i,3)- C(i+2,3)) ];
      V2 = [(C(i+1,1)- C(i+2,1)) (C(i+1,2)-C(i+2,2)) (C(i+1,2)- C(i+2,3)) ];
      point = [ (C(i,1)+ C(i+1,1)+C(i+2,1)) (C(i,2)+C(i+1,2)+C(i+2,2))  (C(i,3)+C(i+1,3)+C(i+1,3))];
      point = point./3;
      light_vec = Light_pos - point;
      light_vec = light_vec/norm(light_vec);
      V3 = cross(V1,V2);
      V3 = V3./norm(V3);
      Cdiff = max(dot(light_vec,V3),0).*Diff;

% specular lighting 
   
  %%   H1 =  (H1 + E)/ |H1+E|
       S =  2;
       V4 = [ (C(i,1)+ C(i+1,1)+C(i+2,1)) (C(i,2)+C(i+1,2)+C(i+2,2))  (C(i,3)+C(i+1,3)+C(i+1,3))];
       V4 =   V4./3;           % E = 0 - point at triangle; 
       E =   cam_pos - V4;       
       Light_vec = Light_pos - V4;
       H1 = (E + (Light_vec))./norm((E + (Light_vec)));
       
       Cspec = ((max(dot(V3,H1),0)).^S).*Spec;
           
      
         Ctot = (Cemis + Cspec + Cdiff + Camb);
         color_info(i,:) = Ctot;
      
         H  =  [  C(i,1)   ;   C(i+1,1) ;          C(i+2,1)];
         G =   [  C(i,2)   ;   C(i+1,2)   ;        C(i+2,2)];
         N =   [  C(i,3)   ;   C(i+1,3)   ;        C(i+2,3)] ;  
         patch(H,G,N,[min(1,Ctot(1,1)) min(1,Ctot(1,2)) min(1,Ctot(1,3))]); 
         
      end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% Lighting  END           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 

 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%    Prospective Projection   %%%%%%%%%%%%%%%%%%%%%
      if(proj == 1)
          figure
          title('prospective projection')
          set(0,'DefaultPatchEdgeColor','none');
          for i = 1 : 3*row
          C(i,:)  =  (C (i,:)* Tproj)./abs(C(i,3));
          end
          for i = 1:3 : 3*row
              H=  [  C(i,1)  ;   C(i+1,1)   ;     C(i+2,1)];
              G = [  C(i,2)  ;   C(i+1,2)  ;     C(i+2,2)];
              N = [  C(i,3)  ;   C(i+1,3)  ;    C(i+2,3)];  
             patch(H,G,N,color_info(i,:));
           end 
      end   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Back face culling %%%%%%%%%%%%%%%%%%%
z_sort =0;

if (culon ==1)
figure
title('after culling');
set(0,'DefaultPatchEdgeColor','none');

      V4 = [look_pt 1];
      V4 = V4*Tmet;
       V4(:,4) = [];
      cam_new = cam_pos;
      cam_new = [cam_new 1];
      cam_new = cam_new*Tmet;
      cam_new(:,4) = [];
      V4 = cam_new - V4;
for i = 1 : 3 : 3*row
      cull = 0;
      V1 = [(C(i,1)- C(i+2,1)) (C(i,2)-C(i+2,2)) (C(i,3)- C(i+2,3)) ];
      V2 = [(C(i+1,1)- C(i+2,1)) (C(i+1,2)-C(i+2,2)) (C(i+1,3)- C(i+2,3)) ];
      
      V3 = cross(V1,V2);
     
      if(dot(V3,V4) < 0)
          cull = 1;
      end
         if(cull ==0)
         H  =  [  C(i,1) ;   C(i+1,1)   ;     C(i+2,1)];
         G =   [  C(i,2)   ;   C(i+1,2)   ;     C(i+2,2)];
         N =   [  C(i,3)   ;   C(i+1,3)   ;    C(i+2,3)] ;  
         patch(H,G,N,color_info(i,:));    
         end        
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Z - sorting  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if( z_sort ==1)
    figure
    set(0,'DefaultPatchEdgeColor','none');
    z_sort = [];
    for i = 1:3:3*row 
     z_values = [ C(i,:) (C(i,3)+C(i+1,3)+C(i+1,3))/3 ];
    end
    z_values = sortrows(z_values,-4);
    z_values(:,4) = [];

    C = z_values;
    for i =1 :3:3*row
     H  =          [  C(i,1) ;   C(i+1,1)   ;     C(i+2,1)];
             G =   [  C(i,2)   ;   C(i+1,2)   ;     C(i+2,2)];
             N =   [  C(i,3)   ;   C(i+1,3)   ;    C(i+2,3)] ;  
             patch(H,G,N,color_info(i,:));    
     end
end
%%%%%%%%%%%%%%%%%%%%%%    Z-sorting Ends %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%     Clipping       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (clipping ==1)
figure
title('Final figure after World transform +  view transform + lighting +  Culling + zsort + clipping ')
set(0,'DefaultPatchEdgeColor','none');

for i = 1 : 3 : 3*row
     
            
         H  =  [  C(i,1) ;   C(i+1,1)   ;     C(i+2,1)];
         G = [  C(i,2)   ;   C(i+1,2)   ;     C(i+2,2)];
         N = [  C(i,3)   ;   C(i+1,3)   ;    C(i+2,3)] ;  
         patch(H,G,N);
          if( (n< N(1,1)  < f )|| (n< N(2,1)  < f )||(n< N(3,1)  < f ))
             patch(H,G,N,color_info(i,:));
         
          end        
     end
end




%%%%%%%%%%%%%%%%%%%% Clipping Ends       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

