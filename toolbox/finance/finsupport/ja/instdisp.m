% INSTDISP   ���i�W���ϐ���\�ŕ\��
%
% ���i�W���ϐ� InstSet �̍\�����e��\�����镶���z����o�͂��܂��B
% INSTDISP ���o�͈����𔺂�Ȃ��`�Ŏ��s���ꂽ�ꍇ�ɂ́A�\�ɂ̓R�}���h
% �E�B���h�E���\������܂��B
%
%   CharTable = instdisp(InstSet);
%   instdisp(InstSet)
%
% ����:
%   InstSet   - ���Z���i�W���ϐ��ł��B�ϐ����\�������ɂ��ẮA
%               "help instaddfield" ���^�C�v���Ă��������B
%
% �o��:
%   CharTable - InstSet ���\�����鏤�i�̕\����Ȃ镶���z��ł��B���i��\
%               ������s�̂��ꂼ��ɂ��āAIndex �y�� Type ���t�B�[���h
%               �̓��e�Ƌ��ɕ\������܂��B�t�B�[���h�̃w�b�_�́A���
%               �g�b�v�ɕ\������܂��B
%
% ���:
%   % �f�[�^�t�@�C������ InstSet �ϐ� ExampleInst ���擾���܂��B
%   % �ϐ����ɂ͎���3�̃^�C�v�̏��i���܂܂�Ă��܂��B
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
% �Q�l : INSTGET, INSTADDFIELD, DATESTR, NUM2STR.


%   Author(s): J. Akao 9-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
