% INSTGETCELL   ���i�ϐ�����f�[�^�y�уR���e�N�X�g�𒊏o
%
%   [DataList, FieldList, ClassList , IndexSet, TypeSet ] = ... 
%      instgetcell(InstSet, ...
%                 'FieldName', FieldList, ...
%                 'Index', IndexSet, ...
%                 'Type', TypeList)
%
% ����:
% �����̃p�����[�^�l�̑g��C�ӂ̏����œ��͂ł��܂��B�������A�ŏ��̈�����
% InstSet �łȂ��Ă͂Ȃ�܂���B�Ȃ��AInstSet �����͕K�{�ł��B
%
% InstSet - ���i�̏W������Ȃ�ϐ��B���i�́A�^�C�v���ɕ��ނ���A���̂���
%           ����̃^�C�v�ɂ��Č݂��ɈقȂ�f�[�^�t�B�[���h��ݒ肷�邱
%           �Ƃ��ł��܂��B�L�����ꂽ�f�[�^�t�B�[���h�́A���i�̂��ꂼ���
%           �Ή�����s�x�N�g���A�܂��́A������ƂȂ��Ă��܂��B
%
%   FieldList  - 
%           �e�f�[�^�t�B�[���h�̖��̂����X�g�\�����镶����A�܂��́A����
%           ������ō\������� NFIELDS �s1��̃Z���z��BFieldList �ɂ�
%           �Ă��A'Type' �� 'Index' �̂����ꂩ����͂ł��܂��B���̂�����
%           ������͂���΁A����ɑΉ����ă^�C�v������������ƃC���f�b�N
%           �X�ԍ����A���ꂼ��o�͂���܂��B�f�t�H���g�ł́A�S�Ẵt�B�[
%           ���h���o�͂��ꂽ���i�Z�b�g�ɂ��ė��p�\�ƂȂ��Ă��܂��B
%   TypeList   - 
%           ���s�ΏۂƂȂ鏤�i�̃^�C�v�� TypeList �ɋL�ڂ��ꂽ�^�C�v�ɓK
%           ��������̂ɐ��񂷂镶����A�܂��́A�����񂩂�Ȃ� NTYPE �s1
%           ��̃Z���z��B�f�t�H���g�ł́A���i�ϐ����̑S�Ẵ^�C�v���Ώ�
%           �ƂȂ��Ă��܂��B
%   IndexSet   - 
%           ���s�ΏۂƂȂ鏤�i�̃|�W�V���������� NINST �s1��̃x�N�g����
%           ���BTypeList �������ɐݒ肳�ꂽ�ꍇ�A�Q�Ƃ���鏤�i�́A
%           TypeList �ɋL�ڂ��ꂽ�A�����ꂩ1�̃^�C�v�ł���Ɠ����ɁA
%           IndexSet �Ɋ܂܂�Ă��鏤�i�łȂ���΂Ȃ�܂���B�f�t�H���g
%           �ł͏��i�ϐ��̑S�ẴC���f�b�N�X�����p�\�ƂȂ��Ă��܂��B
% 
% �o�́F
%   DataList   - 
%           �e�t�B�[���h�ɓ��͉\�Ȓl������ NFIELDS �s1��̃Z���z��ł��B
%           �z����\������e�Z���́ANINST �s M ��̔z��ƂȂ��Ă���A
%           ���̊e�s�́AIndexSet ���\������e�X�̏��i�ƑΉ����Ă��܂��B
%           ���p�\�łȂ��S�Ẵf�[�^�́ANaN �A�܂��́A�X�y�[�X�ŏo��
%           ����܂��B
%   FieldList  - 
%           DataList �̊e�t�B�[���h�������X�g�\�����镶����� NFIELDS �s
%           1��̃Z���z��
%   ClassList  - 
%           DataList �̊e�t�B�[���h�̃N���X�����X�g�\�����镶����� 
%           NFIELDS �s1��̃Z���z��B�����ɁA�L�ڂ����f�[�^�N���X��
%           ����āA���̓f�[�^�̉��ߖ@�����܂�܂��B�Ȃ��A���͉\��
%           ������ 'dble', 'date', 'char'�ł��B 
%   IndexSet   - 
%           DataList �ɏo�͂���鏤�i�̃|�W�V���������� NINST �s1��̃x
%           �N�g��
%   TypeSet    - 
%           DataList �ɏo�͂���鏤�i�������e�s�̃^�C�v�����X�g�\������
%           �����񂩂�Ȃ� NINST �s1��̃Z���z��
%
% ���ӁF
% ���̊֐��́A���i�ϐ��̍\�������m�ł���P�[�X�ł̃v���O���~���O�ŗp����
% �̂��ł��K���Ă��܂��B�ϐ����̃f�[�^�ւ̃A�N�Z�X�ɂ��ẮAINSTGET ��
% �p���������蒼�ړI�ȃA�N�Z�X���\�ł��B
%
% ���:
% 1) InstSet �ϐ��AExampleInst ���f�[�^�t�@�C������擾���܂��B���̕ϐ�
%    �̒��ɂ́A����3�̃^�C�v�̏��i���܂܂�Ă��܂��B
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
% 2) �S�Ă̏��i��Ώۂɂ��̉��i�ƌ_�񐔂��擾���܂��B
%   FieldList = {'Price'; 'Contracts'}
%   DataList = instgetcell(ExampleInst, 'FieldName', FieldList )
%   P = DataList{1}
%   C = DataList{2}
%   
% 3) ���̃I�v�V�����f�[�^��S�Ď擾���܂��B 
%       Strike, Price, Opt, Contracts
%   [DataList, FieldList, ClassList] = ....
%          instgetcell(ExampleInst,'Type','Option')
%   
% 4) �f�[�^���R���}��؂胊�X�g�ŕ\�����܂��B
%    �Z���z�񃊃X�g�̏ڍׂɂ��ẮA "help lists"���^�C�v���Ă��������B
%   DataList{:}
%   
% �Q�l : INSTGET, INSTADDFIELD, INSTDISP.


%   Author(s): J. Akao, 31-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
