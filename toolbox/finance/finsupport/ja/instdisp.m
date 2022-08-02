% INSTDISP   商品集合変数を表で表示
%
% 商品集合変数 InstSet の構成内容を表示する文字配列を出力します。
% INSTDISP が出力引数を伴わない形で実行された場合には、表にはコマンド
% ウィンドウが表示されます。
%
%   CharTable = instdisp(InstSet);
%   instdisp(InstSet)
%
% 入力:
%   InstSet   - 金融商品集合変数です。変数を構成する例については、
%               "help instaddfield" をタイプしてください。
%
% 出力:
%   CharTable - InstSet を構成する商品の表からなる文字配列です。商品を表
%               示する行のそれぞれについて、Index 及び Type がフィールド
%               の内容と共に表示されます。フィールドのヘッダは、列の
%               トップに表示されます。
%
% 例題:
%   % データファイルから InstSet 変数 ExampleInst を取得します。
%   % 変数内には次の3つのタイプの商品が含まれています。
%      'Option', 'Futures', 'TBill'.
%
%   load InstSetExamples.mat
%   instdisp(ExampleInst)
%
%    Index Type  Strike Price Opt  Contracts
%    1     Option   95     12.2  Call     0    
%    2     Option  100      9.2  Call     0    
%    3     Option  105      6.8  Call  1000    
%     
%    Index Type    Delivery       F     Contracts
%    4     Futures 01-Jul-1999    104.4 -1000    
%     
%    Index Type   Strike Price Opt  Contracts
%    5     Option 105     7.4  Put  -1000    
%    6     Option  95     2.9  Put      0    
%     
%    Index Type  Price Maturity       Contracts
%    7     TBill 99    01-Jul-1999    6        
%
% 参考 : INSTGET, INSTADDFIELD, DATESTR, NUM2STR.


%   Author(s): J. Akao 9-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
