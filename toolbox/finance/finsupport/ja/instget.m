% INSTGET   商品変数からデータ配列を抽出
%
%    [Data_1, Data_2, ... Data_NFIELDS ] = instget(InstSet, ...
%                                        'FieldName', FieldList, ...
%                                        'Index', IndexSet, ...
%                                        'Type', TypeList)
%
% 入力:
% 複数の組のパラメータ値を任意の順序で入力できます。但し、一番目の引数に
% は、必ず InstSet 変数を入力してください。InstSet 変数は必須です。
%
%   InstSet      - 商品の集合からなる変数。商品は、タイプ毎に分類され、
%                  そのそれぞれのタイプについて互いに異なるデータフィー
%                  ルドを設定することができます。記憶されたデータフィー
%                  ルドは、商品のそれぞれに対応する行ベクトル、または、
%                  文字列となっています。
%
%   FieldList    - 各データフィールドの名称をリスト表示する文字列、また
%                  は、その文字列で構成される NFIELDS 行1列のセル配列。
%                  FieldList についても、'Type' か 'Index' のいずれかを
%                  入力できます。このいずれかを入力すれば、それに対応し
%                  てタイプを示す文字列、または、インデックスナンバーが
%                  出力されます。デフォルトでは、全てのフィールドが出力
%                  された商品セットについて利用可能となっています。
%
%   TypeList     - 実行対象となる商品のタイプを TypeList に記載されたタ
%                  イプに適合するものに制約する文字列、または、文字列か
%                  らなる NTYPE 行1列のセル配列。デフォルトでは、商品変
%                  数内の全てのタイプが対象となっています。
%
%   IndexSet     - 実行対象となる商品のポジションを示す NINST 行1列のベ
%                  クトルです。TypeList も同時に設定された場合、参照され
%                  る商品は、TypeList に記載された、いずれか1つのタイプ
%                  であると同時に、IndexSet に含まれている商品でなければ
%                  なりません。デフォルトでは、商品変数の全てのインデッ
%                  クスが利用可能となっています。
%
% 出力:
%
%   Data_1       - FieldList の最初のフィールドに対応するデータ内容から
%                  なる NINST 行 M 列の配列。この配列を構成するそれぞれ
%                  の行は、IndexSet に含まれる別々の商品にそれぞれ対応し
%                  ています。利用可能でないデータについては、NaN または
%                  スペースで出力されます。
%
%   Data_NFIELDS - FieldList の最後のフィールドに対応するデータ内容から
%                  なる NINST 行 M 列の配列。
%
% 例題：
% 1) InstSet 変数、ExampleInst をデータファイルから取得します。この変数
%    の中には、つぎの3つのタイプの商品が含まれています。
%    'Option', 'Futures', 'TBill'
%
%    load InstSetExamples.mat
%    instdisp(ExampleInst)
%
%    Index Type   Strike Price Opt  Contracts
%    1    Option  95    12.2  Call     0    
%    2     Option 100     9.2  Call     0    
%    3     Option 105     6.8  Call  1000    
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
% 2) 全ての商品から価格を抽出します。
%   P = instget(ExampleInst,'FieldName','Price')
%   
% 3) 価格と保持している契約数の双方を取得します。
%   [P,C] = instget(ExampleInst, 'FieldName', {'Price', 'Contracts'})
%   
% 4) 価値 V を計算し、その結果を変数 ISet に記憶します。
%   V = P.*C
%   ISet = instsetfield(ExampleInst, 'FieldName', 'Value', 'Data', V);
%   instdisp(ISet)
%   
% 5) ゼロでない契約を有する証券のみを抽出します。
%   Ind = find( C ~= 0 )
%   
% 6) 商品から Type 及び Opt パラメータを取得します。
%    オプションのみ 'Opt' フィールドに記憶します。
%   [T,O] = ...
%    instget(ExampleInst, 'Index', Ind, 'FieldName', {'Type', 'Opt'})
%   
% 7) Type, Opt, Value の3つのパラメータを含む文字列のレポートを出力し
%    ます。
%   rstring = [T, O, num2str(V(Ind))]
%
% 参考 : INSTGETCELL, INSTADDFIELD, INSTSETFIELD, INSTDISP.


%   Copyright 1995-2002 The MathWorks, Inc. 
