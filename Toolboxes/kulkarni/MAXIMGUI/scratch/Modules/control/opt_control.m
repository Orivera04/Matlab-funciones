function [I,g] = opt_control(std_state, scalar,workbench_item)

% Computes the optimal cost/revenue rate for the chosen design model
% Usage:  std_state: Standard Model chosen
%         scalar: vector of input scalars for the model selected
global Primary_state  state_vector  

switch std_state
case {-1 0}
   % Model from the file or a New model
   load new_model_parameters action_vector state_vector new_model_title;

   switch workbench_item
   case 1
      I = new_control_model([],-1);
      g=[action_vector state_vector];
      
   case 2
      init_scalar = 0;
      action = add_scalar_input('Control Output',...
         'action_id_new', 'Specify action a to view P(a) = [P_(i,j)(a)]',init_scalar) ;
      if isempty(action)
         I=[];g=[];
         return
      end

      act = find(action_vector == action);
      I = new_control_model([],act);
      g=[state_vector action];

   case 3
      I = new_control_model([],-2);
      g=[action_vector state_vector];

   case 4
      
      load new_model_parameters W;
   if all(W == 1)
      [I,g]=dtmdp('new_control_model',[]);
   else
      [I,g] = smdp('new_control_model',[]);
   end;
   end;
   
   % 'Optimal Group Maintenance'  
case 1
   x=[scalar(4),scalar(5),scalar(3),scalar(2),scalar(1)];
    switch workbench_item
   case 1
      I = ex9ogm(x,-1);
      g=[[0:scalar(4)][0:scalar(4)]];
      
   case 2
      init_scalar = 0;
      action = add_scalar_input('Optimal Group Maintenance',...
         sprintf('action_id_ogm%i',scalar(4)), 'Specify action a to view P(a) = [P_(i,j)(a)]',init_scalar) ;
      if isempty(action)
         I=[];g=[];
         return
      end

      I = ex9ogm(x,action+1);
      g=[[0:scalar(4)] action];
   case 3
      I = ex9ogm(x,-1);
      I=ones(size(I));
      g=[[0:scalar(4)][0:scalar(4)]];

   case 4

   [I,g] = dtmdp('ex9ogm',x);
   I=max(I-1,-1);
   state_vector = [0:scalar(4)];
   end
   
     % 'Optimal Inventory Control' 
  case 2
     x=[scalar(6),scalar(5),scalar(4),scalar(3),scalar(2),scalar(1)];
      switch workbench_item
     case 1
      I = ex9inv(x,-1);
      g=[[0:scalar(2)][0:scalar(2)]];
      
   case 2
      init_scalar = 0;
      action = add_scalar_input('Optimal Inventory Control',...
         sprintf('action_id_inv%i',scalar(2)), 'Specify action a to view P(a) = [P_(i,j)(a)]',init_scalar) ;
      if isempty(action)
         I=[];g=[];
         return
      end

      I = ex9inv(x,action+1);
      g=[[0:scalar(2)] action];
      
   case 3
      I = ex9inv(x,-1);
      I=ones(size(I));
      g=[[0:scalar(2)][0:scalar(2)]];
   case 4

     [I,g] = dtmdp('ex9inv',x);
     I=max(I-1,-1);
     state_vector = [0:scalar(5)];
  end
  

     %  'Optimal Processor Sceduling' 
  case 3
     
     x=fliplr(scalar);
      switch workbench_item
     case 1
        I = ex9ops(x,-1);
        g=[[0:x(3)][0:x(4)]];
      
   case 2
      init_scalar = 0;
      action = add_scalar_input('Optimal Processor Scheduling',...
         sprintf('action_id_ops%i',x(3)), 'Specify action a to view P(a) = [P_(i,j)(a)]',init_scalar) ;
      if isempty(action)
         I=[];g=[];
         return
      end

      I = ex9ops(x,action);
      g=[[0:x(4)] action+1];
      
   case 3
      I = ex9ops(x,-2);
      [m1 m2] = size(I);
      g=[[0:x(3)][0:x(4)]];
   case 4

     [I,g] = smdp('ex9ops',x);
     I=max(I-1,-1);
     state_vector = [0:scalar(4)]
  end
  
     % 'Optimal Machine Operation'
  case 4
     x=fliplr(scalar)
      switch workbench_item
       case 1
      I = ex9omo(x,-1);
      g=[[0:1][0:2*x(3)+1]];
      
   case 2
      init_scalar = 0;
      action = add_scalar_input('Optimal Machine Operation',...
         'action_id_omo1', 'Specify action a to view P(a) = [P_(i,j)(a)]',init_scalar) ;
      if isempty(action)
         I=[];g=[];
         return
      end
      
      I = ex9omo(x,action+1);
      [m1 m2] = size(I);
      g=[[0:m2-1] action];
   case 3
      I = ex9omo(x,-2);
      [m1 m2] = size(I);
      g=[[0:m2-1][0:m1-1]];

   case 4


     [I,g] = smdp('ex9omo',x);
     I=max(I-1,-1);
     state_vector = [0:2*scalar(5)+1];
  end
  
end  % switch std_state


