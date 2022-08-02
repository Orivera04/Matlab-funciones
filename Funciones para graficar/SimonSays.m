function SimonSays


prompt={'Enter the max number of turns:'};
def={'10'};
dlgTitle='Max Turns';
lineNo=1;
answer=inputdlg(prompt,dlgTitle,lineNo,def);

max_times = str2num(answer{1});

open_graph_window(360, 500, 'Simon Says');
%y=wavread('c:\windows\temp\click.wav');

Set_Default_Value('Filled',true);
Set_Default_Value('Style','--');
Set_Default_Value('Rounded',[.5,.5]);

h(1) = Draw_Box(20, 50, 170, 200, 'Color','red');
pause(0.025);
h(2) = Draw_Box(190, 50, 340, 200, 'Color','green');
pause(0.025);
h(3) = Draw_Box(20, 220, 170, 370, 'Color','blue');
pause(0.025);
h(4) = Draw_Box(190, 220, 340, 370, 'Color','yellow');

Set_Default_Value('Filled',false);
Set_Default_Value('Style','--');
Set_Default_Value('Rounded',[0,0]);

t = Draw_Text(20, 400, 'Click on the same squares that flashed', 'Color','blue', 'FontSize', 12);
Draw_Text(60, 450, 'SIMON', 'Color','blue', 'FontSize',48);
answers = {'doing Great','are Super','doing Brilliant','a Genus','Fanstastic','like an Instructor','Dr Carlisle'};

for i = 1:max_times
    pattern(i) = Get_Random(1,4,'integer');
end

for i = 1:max_times
    
    pause(2)

    % play pattern
    for j = 1:i
        Hide_Object(h(pattern(j)));
        pause(.2);
        Show_Object(h(pattern(j)));
        pause(.2);
    end
    
    % get pattern
    for j = 1:i
        user_h(j) = Select_Object;
%        wavplay(y(2000:end))

    end

    % match pattern
    success = true;
    for j = 1:i
        if user_h(j) ~= h(pattern(j))
            success = false;
            break
        end
    end
    
    if success == false
        break;
    else
        Delete_Object(t)
        t = Draw_Text(20, 400, ['You are ' answers{Get_Random(1,length(answers),'integer')}], 'Color','blue','FontSize',12);

    end
end

Delete_Object(t)
if success
    t = Draw_Text(20, 400, 'Congratulations of beating Simon','Color','blue','FontSize',12);
else
    t = Draw_Text(20, 400, 'Better luck next time','Color','red','FontSize',12);
end

pause(2)
Delete_Object(t)
t = Draw_Text(20, 400, 'Type any key to quit', 'Color','red','FontSize',36,'Rotation',-45);
Wait_For_Key;
close_graph_window;

