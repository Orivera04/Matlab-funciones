% BLSPRICE   Black-Scholesのプット価格及びコール価格の決定
%
% [CALL,PUT] = BLSPRICE(SO,X,R,T,SIG,Q) は、Black-Scholes の価格決定式を
% 使用して、コールオプションとプットオプションの価値を出力します。SO は
% 現行資産価格、X は権利行使価格、R は安全利子率、T はオプションの
% 満期までの年数、SIG は年率換算した株式の連続複利収益率の標準偏差(ボラ
% ティリティとも言います)、Q は資産の配当率です。Q のデフォルトは0です。
%        
% 注意： 
% R と T が同じ期間に基づいていることを確かめてください。すなわち、
% R が年率の場合、T は年表示でなければなりません。
%
% この関数は、Statistics Toolboxの正規累積分布関数 normcdf を使用します。
% 
% 例題：
% ある資産の現行価格が$100、権利行使価格が$95、安全利子率が10%、オ
% プションの満期までの年数が0.25年、資産の標準偏差が50%とします。
% 
%       call = blsprice(100,95,.1,.25,.5,0)
% 
% この結果、コールオプション価格は$13.70と出力されます。
%        
% 参考文献 : Bodie, Kane, and Marcus, Investments, page 681. 
% 
% 参考 : BLSIMPV, BLSDELTA, BLSGAMMA, BLSLAMBDA, BLSTHETA, BLSRHO. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
