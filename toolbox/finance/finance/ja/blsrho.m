% BLSRHO   金利の変化に対するBlack-Scholesの感応度
%
% [CR,PR] = BLSRHO(SO,X,R,T,SIG,Q)は、金利に対する有価証券の価値の変化率
% を出力します。SO は現行有価証券価格、X は権利行使価格、R は安全利子率、
% T はオプションの満期までの年数、SIG は年率換算した株式の連続複利収益率
% の標準偏差(ボラティリティとも言います)、Q は配当率です。Q のデフォルト
% は 0です。CR はコールオプションのロー、PR はプットオプションのローです。
%        
% 注意：
% この関数は、Statistics Toolboxの正規累積分布関数 normcdf を使用します。
% 
% たとえば、[c,p] = blsrho(50,50,.12,.25,.3,0) は、c = 6.6686 と 
% p = -5.4619 を出力します。
% 
% 参考 : BLSPRICE, BLSDELTA, BLSGAMMA, BLSTHETA, BLSVEGA, BLSLAMBDA. 
% 
% 参考文献 : Hull, Options, Futures, and Other Derivative Securities, 
%            2nd edition, Chapter 13. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
