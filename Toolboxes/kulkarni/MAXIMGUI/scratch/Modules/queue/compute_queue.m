function results = compute_queue (dist_called,std_state, scalar)

% Computes all applicable results for any Queueing model
% Usage:  std_state: Standard Model chosen
%         scalar: vector of input scalars for the model selected
global Primary_state node_id num_qpmf num_qpmfa   

switch std_state
  % M/M/1/K
  case 1
     res = mm1k(scalar(3), scalar(2), scalar(1)) ;
     num_qpmf = [[0:scalar(1)]' res{5}'];
     num_qpmfa= [[0:scalar(1)]' res{6}'];
     results = {res{1} res{2} res{3} res{4} 1-num_qpmf(1,2) num_qpmf(scalar(1)+1,2) ...
           1-num_qpmf(1,2) num_qpmf num_qpmfa}
  % M/M/s/K
  case 2
     res = mmsk(scalar(4), scalar(3), scalar(2), scalar(1)) ;
     num_qpmf = [[0:scalar(1)]' res{5}'];
     num_qpmfa= [[0:scalar(1)]' res{6}'];
     results = {res{1} res{2} res{3} res{4} res{7} num_qpmf(scalar(1)+1,2) ...
           res{8} num_qpmf num_qpmfa}


  % M/M/1
  case 3
     res = mm1(scalar(2), scalar(1)) ;
     [K1,K2]=size(res{5});
     num_qpmf = [[0:K2-1]' res{5}'];
     num_qpmfa= [[0:K2-1]' res{5}'];
     results = {res{1} res{2} res{3} res{4} scalar(2)/scalar(1) 0 ...
           scalar(2)/scalar(1) num_qpmf num_qpmfa}

  % M/M/s
  case 4
     res = mms(scalar(3), scalar(2), scalar(1));
     [K1,K2]=size(res{5});
     num_qpmf = [[0:K2-1]' res{5}'];
     num_qpmfa= [[0:K2-1]' res{5}'];
     results = {res{1} res{2} res{3} res{4} res{6} 0 ...
           num_qpmf(scalar(1)+1,2)/(1-(scalar(3)/(scalar(2)*scalar(1)))) num_qpmf num_qpmfa}


  % M/M/infinity
  case 5
    res = mminf(scalar(2), scalar(1)) ;
    [K1,K2]=size(res{5});
    num_qpmf = [[0:K2-1]' res{5}'];
    num_qpmfa= [[0:K2-1]' res{5}'];
    results = {res{1} res{2} res{3} res{4} res{6} 0 ...
           0 num_qpmf num_qpmfa}
  % M/G/1
  case 6
     res = mg1(scalar(3), scalar(2), scalar(1)) ;
     results = {res{1} res{2} res{3} res{4} res{5} 0 ...
           res{5} [] []}


  % G/M/1
  case 7
     switch dist_called
     case 3
        par = str2num(char(Primary_state(5).distribution_parm{std_state}{3}));
        i=1;
        l=par;
     case 2
        par = str2num(char(Primary_state(5).distribution_parm{std_state}{2}));
        i=2;
        l=par(2)/par(1);
     case 4
        par = str2num(char(Primary_state(5).distribution_parm{std_state}{4}));
        i=7;
        l= par
     case 8
        par = Primary_state(5).vector_matrix
        i=5;
        mp=size(par,2);
        l=1/(par*[0:mp-1]');
     end
     if scalar(1) <= l
        e=msgbox('Queue is unstable. Please reinput parameters');
        uiwait(e);
        results={};
        return;
     end;
     
     a=funeq(i,par,scalar(1));
     res = gm1(l, scalar(1), a) 
     [K1,K2]=size(res{5});
     num_qpmf = [[0:K2-1]' res{5}'];
     num_qpmfa= [[0:K2-1]' res{6}'];

     results = {res{1} res{2} res{3} res{4} l/scalar(1) 0 ...
            l/scalar(1) num_qpmf num_qpmfa};

     % Jackson Networks
  case 8
     %one_or_whole = generic_menu('Jackson Network', 'Compute Results For:',...
     %   {'Single Node' 'The Whole Network'}) ;
     %if one_or_whole == 1
     RM=Primary_state(5).matrix_matrix;
     valid_node_id = 0;
     while valid_node_id == 0
        valid_node_id = 1;
        node_id = add_scalar_input('Jackson Network','node_id','Which node?',[]);
        if node_id < 1 | node_id > size(RM,2) | fix(node_id) - node_id ~= 0
           valid_node_id = 0;
           e=msgbox('Invalid node index');
           uiwait(e);
        end;
     end;
     
           
     
     %else
     %   node_id = 0;
     %end;
        
     
     s=Primary_state(5).vector_matrix(1,:);
     m=Primary_state(5).vector_matrix(2,:);
     l=Primary_state(5).vector_matrix(3,:);
     a=Primary_state(5).vector_matrix(4,:);
  if node_id ~= 0
        res = mms(a(node_id),m(node_id),s(node_id));
     [K1,K2]=size(res{5});
     num_qpmf = [[0:K2-1]' res{5}'];
     num_qpmfa= [[0:K2-1]' res{5}'];
     results = {res{1} res{2} res{3} res{4} res{6} 0 ...
           num_qpmf(s(node_id)+1,2)/(1-(l(node_id)/(m(node_id)*s(node_id)))) num_qpmf num_qpmfa};
  end
  

end  % switch std_state


