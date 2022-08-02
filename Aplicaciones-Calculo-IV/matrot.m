%Programa de Transformaciones
clear
clc
syms a2 a3 r3 r4 t1 t2 t3 t4 t5 t6;
T_12 =   [[  cos(t1),        0,  sin(t1),        0]
          [  sin(t1),        0, -cos(t1),        0]
          [        0,        1,        0,        0]
          [        0,        0,        0,        1]];
                    

 
  T_23 = [[    cos(t2),          0,    sin(t2), a2*cos(t2)]
          [    sin(t2),          0,   -cos(t1), a2*sin(t2)]
          [          0,          1,          0,          0]
          [          0,          0,          0,          1]];
          

 
 T_34 =[[    cos(t3),          0,    sin(t3), a3*cos(t3)]
        [    sin(t3),          0,   -cos(t2), a3*sin(t3)]
        [          0,          1,          0,         r3]
        [          0,          0,          0,          1]]; 
    

 
T_45 =[[  cos(t4),        0,  sin(t4),        0]
       [  sin(t4),        0, -cos(t4),        0]
       [        0,        1,        0,       r4]
       [        0,        0,        0,        1]]; 
   

 
T_56 =[[  cos(t5),        0,  sin(t5),        0]
       [  sin(t6),        0, -cos(t5),        0]
       [        0,        1,        0,        0]
       [        0,        0,        0,        1]];
 

 
 T_67 =[[  cos(t6),        0,  sin(t6),        0]
        [  sin(t6),        0, -cos(t6),        0]
        [        0,        1,        0,        0]
        [        0,        0,        0,        1]];  
       
  a2 = 0.431;
  a3 = 0.019;
  r3 = 0.125;
  r4 = 0.431;
  t1 = 15;
  t2 = 105;
  t3 = 145;
  t4 = 0;
  t5 = 215;
  t6 = 55;
  
  T12=eval(T_12);
  T23=eval(T_23);
  T34=eval(T_34);
  T45=eval(T_45);
  T56=eval(T_56);
  T67=eval(T_67);
  T17 = T12*T23*T34*T45*T56*T67
  
  