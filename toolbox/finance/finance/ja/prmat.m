% PRMAT   満期時利払いの有価証券の価格を出力
%
% [P,AI] = PRMAT(SD,MD,ID,RV,CPN,YLD,BASIS) は、満期時利払いの有価証券の
% 価格 P と経過利子 AI を出力します。SD は決済日、MD は満期日、IDは発行日、
% RV は額面価格、CPN はクーポンレート、YLD は利回り、BASIS は、
% 0 =actual/actual(デフォルト),1= 30/360, 2 = actual/360, 3 = actual/365
% です。日付は、シリアル日付番号、または、日付文字列で入力してください。
% この関数は、CPN = 0とすることにより、ゼロクーポン債にも純割引有価証券
% にも適用されます。
%
% 例題：つぎのデータを使用すると、
% 
%              SD = '02/07/1992'
%              MD = '04/13/1992'
%              id = '10/11/1991'
%              RV = 100
%              CPN = 0.0608
%              YLD = 0.0608
%              BASIS = 1
%       
%              [p,ai] = prmat(sd,md,id,rv,cpn,yld,basis)
%       
% この結果、p = 99.98 と ai = 1.96 が出力されます。
% 
% 参考 : YLDMAT, PRBOND, PRDISC.
%
% 参考文献: Mayle, Standard Securities Calculation Methods, Volumes
%           I-II, 3rd edition.  Formula 4. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
