%task_1.m  is used in guidm_5 and _6
function task_1(h,k)
val=get(k,'Value');
    if val==1, fprintf('A is selected\n')
elseif val==2, fprintf('B is selected\n')
elseif val==3, fprintf('C is selected\n')
elseif val==4, fprintf('D is selected\n')
elseif val==5, close(h)
end

