% PRTBILL   財務省証券の価格を出力
%
% P = PRTBILL(SD,MD,RV,DISC) は、財務省証券の価格を出力します。SD は決済
% 日、MD は満期日、RVは償還価格、DISC は割引率です。決済日と満期日は、
% シリアル日付番号、または、日付文字列で入力してください。
% 
% 例題：
% ある財務省証券の決済日が1992年2月10日、満期日が1992年8月6日、割引率が
% 3.77%、償還価格が$1,000とします。このデータを使用すると、 
% p = prtbill('2/10/1992', '8/6/1992', 1000, 0.0377)
% から、財務省証券の価格 p = 981.36 が出力されます。
%  
% 参考 : BEYTBILL, YLDTBILL.
%
% 参考文献: Bodie, Kane, and Marcus, Investments, pages 41-43. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc. 
