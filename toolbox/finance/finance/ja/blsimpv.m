% BLSIMPV   Black-Scholesのインプライド・ボラティリティ
%
% V = BLSIMPV(SO,X,R,T,CALL,MAXITER,Q,TOL) は、現行資産価格 SO、権利行使
% 価格 X、安全利子率 R、満期までの年数 T、コールオプション価値 CALL が
% 与えられたときに、原資産のインプライド・ボラティリティを出力します。
% MAXITER は、V を求めるときに使用する最大反復回数です。デフォルトは、
% MAXITER = 50 です。Q は、配当のある証券の配当率で、デフォルトは0です。
% TOL は、収束の許容誤差で、デフォルトは 1e-6 です。
%        
% 注意：R と T が同じ期間に基づいていることを確かめてください。すなわち、
% R が年率の場合、T は年表示でなければなりません。
%
% 例題：
% ある資産の現行価格が$100、権利行使価格が$95、安全利子率が7.5%、
% オプションの満期までの年数が0.25年、コールオプションの価値が$10.00と
% します。
% 
% blsimpv(100,95,.075,.25,10)を用いれば、インプライド・ボラティリティ  
% 0.31、すなわち、31%が出力されます。
% 
% 参考 : BLSPRICE.
% 
% 参考文献： Chriss, Black-Scholes and Beyond: Option Pricing Models,
%            Chapter 4 and 8. 


%    Author(s): C.F. Garvin, 2-23-95, M. Reyes-Kattar, 01-22-2002 
%    Copyright 1995-2002 The MathWorks, Inc.  
