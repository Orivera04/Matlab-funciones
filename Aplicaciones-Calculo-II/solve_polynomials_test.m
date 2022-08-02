%                               431-400 Year Long Project 
%                           LA1 - Medical Image Processing 2003
%  Supervisor     :  Dr Lachlan Andrew
%  Group Members  :  Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%                    Lee Siew Teng   102519  s.lee1@ugrad.unimelb.edu.au
%                    Loh Jien Mei    103650  j.loh1@ugrad.unimelb.edu.au
% 
%  File and function name : test_solve_polynomials
%  Version                : 1.0
%  Date of completion     : 30 September 2003   
%  Written by    :   Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%
%  Inputs        :  
%                   None
%
%  Outputs       :  
%                   None
%
%  Description   : 
%       To test the function "solve_polynomials" and to determine its proper
%       usage
%
%  To Run >> test_solve_polynomials

function test_solve_polynomials
% ----------------------------------------------------------------
num_polynomials = -1;
while num_polynomials < 0
    clc
    A = input('Enter number of random polynomials to try (>1):','s');
    A = str2num(A);
    if ~isempty(A)
        if (A > 1) & ~isinf(A)
            num_polynomials = A;
        end
    end
end
% ----------------------------------------------------------------
max_poly_degree = -1;
while max_poly_degree < 0
    clc
    A = input('Enter maximum degree for polynomials :','s');
    A = str2num(A);
    if ~isempty(A)
        if (A >= 0) & ~isinf(A)
            max_poly_degree = A;
        end
    end
end

% ----------------------------------------------------------------
max_coeff_value = inf;
while isinf(max_coeff_value) 
    clc
    A = input('Enter maximum value for coefficients :','s');
    A = str2num(A);
    if ~isempty(A)
        if ~isinf(A)
            max_coeff_value = A;
        end
    end
end
% ----------------------------------------------------------------
min_coeff_value = inf;
while isinf(min_coeff_value) 
    clc
    A = input('Enter minimum value for coefficients :','s');
    A = str2num(A);
    if ~isempty(A)
        if ~isinf(A) & (A < max_coeff_value-max_poly_degree)
            min_coeff_value = A;
        end
    end
end

% ================================================================
clc
disp('======================================================');
disp('Randomly generating coefficient values based on constraints');
disp('======================================================');
coefficients = {};
for n= 1:1:num_polynomials
    degree = randperm(max_poly_degree);
    current_coeff = randperm(max_coeff_value-min_coeff_value+1)+min_coeff_value-1;
    coefficients = {coefficients{:} current_coeff([1:1:degree(1)])};
end

for n = 1:1:num_polynomials
    disp(num2str(coefficients{n}));
end
% ================================================================

disp('');
disp('');
disp('======================================================');
disp('Solve the two polynomials using "solve_polynomials"');
disp('======================================================');
tic
    [intersection,real_intersection,complex_intersection,polystr] = ...
    solve_polynomials(coefficients{:});
toc
disp('======================================================');
disp('');
disp('');

% ================================================================
disp('-----------------------------');
disp('intersection');
disp('-----------------------------');
intersection

disp('');
disp('-----------------------------');
disp('real_intersection');
disp('-----------------------------');
real_intersection

disp('');
disp('-----------------------------');
disp('complex_intersection');
disp('-----------------------------');
complex_intersection

disp('');
disp('-----------------------------');
disp('polystr');
disp('-----------------------------');
for n = 1:1:length(polystr)
    disp(polystr{n});
end
% ================================================================

if ~isempty(real_intersection)
	% ----------------------------------------------------------------
    disp('');
    disp('');
	disp('----------------------------------------------------------------');
	display_ans = [];
	while isempty(display_ans)
        A = input('Display answers and polynomials? (Y/N)','s');
        A = upper(A);
        if ~isempty(A)
            if (strcmp(A,'Y')==1) | (strcmp(A,'N')==1)
                display_ans = A;
            end
        end
	end
	% ----------------------------------------------------------------
    if strcmp(display_ans,'Y')==1
        if length(real_intersection(:,1)) == 1
        	side_range = 10;
        else
            percentage = 0.1;
            side_range = (max(real_intersection(:,1)) - ...
                          min(real_intersection(:,1))) .* percentage;
            side_range = ceil(side_range);
        end
        % colours_avaliable = ['y','m','c','r','g','b','w','k'];
        colours_avaliable = ['m','g','b','k'];
        elements_avaliable = ['.','o','x','+','*','s','d','v','^','<','>','p','h'];
        
        disp('calculating coordinates');
        xvalue = [min(real_intersection(:,1))-side_range:0.1:...
                  max(real_intersection(:,1))+side_range];
        figure;
        symbol_representation = {};
		for n = 1:1:num_polynomials
            yvalue = polyval(coefficients{n},xvalue);
            p = randperm(length(colours_avaliable));
            representation = strcat(colours_avaliable(p(1)),'.-');
            plot(xvalue,yvalue,representation);
            symbol_representation = {symbol_representation{:} polystr{n}};
            if n == 1
                hold on;
            end
		end
        plot(real_intersection(:,1),real_intersection(:,2),'r*');
        legend(symbol_representation{:},'Real intersections',0);
    end    
else
    % ==========================================================
    % Displaying polynomials
    % ==========================================================
    disp('');
    disp('');
	disp('----------------------------------------------------------------');
	display_ans = [];
	while isempty(display_ans)
        A = input('Display all polynomials? (Y/N)','s');
        A = upper(A);
        if ~isempty(A)
            if (strcmp(A,'Y')==1) | (strcmp(A,'N')==1)
                display_ans = A;
            end
        end
	end
	% ----------------------------------------------------------------
    if strcmp(display_ans,'Y')==1
		% ----------------------------------------------------------------
		max_X_value = inf;
		while isinf(max_X_value) 
            clc
            A = input('Enter maximum X value :','s');
            A = str2num(A);
            if ~isempty(A)
                if ~isinf(A)
                    max_X_value = A;
                end
            end
		end
		% ----------------------------------------------------------------
		min_X_value = inf;
		while isinf(min_X_value) 
            clc
            A = input('Enter minimum value for coefficients :','s');
            A = str2num(A);
            if ~isempty(A)
                if ~isinf(A) & (A < max_X_value)
                    min_X_value = A;
                end
            end
		end

        % ----------------------------------------------------------------
        disp('calculating coordinates');
        % colours_avaliable = ['y','m','c','r','g','b','w','k'];
        colours_avaliable = ['m','g','b','k'];
        elements_avaliable = ['.','o','x','+','*','s','d','v','^','<','>','p','h'];

        xvalue = [min_X_value:0.1:max_X_value];
        figure;
        symbol_representation = {};
		for n = 1:1:num_polynomials
            yvalue = polyval(coefficients{n},xvalue);
            p = randperm(length(colours_avaliable));
            representation = strcat(colours_avaliable(p(1)),'.-');
            plot(xvalue,yvalue,representation);
            symbol_representation = {symbol_representation{:} polystr{n}};
            if n == 1
                hold on;
            end
		end
        legend(symbol_representation{:},'Real intersections',0);
    end
end
