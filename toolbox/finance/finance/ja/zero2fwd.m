% ZERO2FWD   �^����ꂽ�[���Ȑ�������݃t�H���[�h�����Ȑ��𓱏o
%
%  [ForwardRates, CurveDates] = zero2fwd(ZeroRates, CurveDates, ......
%     Settle,OutputCompounding, OutputBasis,InputCompouding,InputBasis)
%
% �ڍׁF
% �[���Ȑ���1�g�̖����������͂Ƃ��ė^������ƁA���̊֐��͓��͂��ꂽ
% �������ɂ���Ď�����鏊�L���Ԃɑ΂��ē��ݓI�t�H���[�h�����Ȑ����o�͂�
% �܂��B
%
% ����:  
%    ZeroRates         
%        (�K�{)�^����ꂽ���L���Ԃ̃[���Ȑ��𑍑̓I�Ɏ����[����(10�i���\
%         �L)�� N �s1��̃x�N�g��
%    CurveDates        
%        (�K�{)���͂��ꂽ�[�����ɑΉ����閞�������V���A�����t�ԍ��Ŏ��� 
%        N �s1��̃x�N�g��
%    MSettle           
%        (�K�{)���͂��ꂽ�[���Ȑ��̖��������V���A�����t�ԍ��Ŏ����X�J��
%        �l(���Ȃ킿�A�[���Ȑ����u�[�g�X�g���b�v�������̖�����)
%    OutputCompounding 
%        (�I�v�V����)�o�͂������ݓI�t�H���[�h������N���Ɋ��Z����Ƃ�
%        �ɂǂ̂��炢�̊����ŕ����v�Z���s�����������X�J���l�B���͂ł���
%        �l�́A���̒ʂ�ł��B
%              OutputCompounding =   1 - 1�N�����v�Z
%              OutputCompounding =   2 - (�f�t�H���g)���N�����v�Z
%              OutputCompounding =   3 - �N3�񕡗��v�Z
%              OutputCompounding =   4 - �N4�񕡗��v�Z
%              OutputCompounding =   6 - �u�������v�Z
%              OutputCompounding =  12 - ��1�񕡗��v�Z
%              OutputCompounding = 365 - ���������v�Z
%              OutputCompounding =  -1 - �A�������v�Z
%
%    OutputBasis       
%         (�I�v�V����)�o�͂������ݓI�t�H���[�h������N���Ɋ��Z����Ƃ�
%         �ɂǂ̓����J�E���g���p���邩�������X�J���l�B���͂ł���l��
%         ���̒ʂ�ł��B
%              1)Basis = 0 - actual/actual(�f�t�H���g)
%              2)Basis = 1 - 30/360
%              3)Basis = 2 - actual/360
%              4)Basis = 3 - actual/365
%
%    InputCompounding  
%         (�I�v�V����)���͂��ꂽ�[������N���Ɋ��Z����Ƃ��ɁA�ǂ̂��炢
%         �̊����ŕ����v�Z���s�����������X�J���l�B�f�t�H���g�l�́A
%         OutputCompounding �̒l�ƂȂ��Ă��܂��B
%
%    InputBasis        
%         (�I�v�V����)���͂��ꂽ�[������N���Ɋ��Z����Ƃ��ɁA�ǂ̓���
%          �J�E���g���p���邩�������X�J���l�B�f�t�H���g�l�́A
%          OutputBasis �̒l�ƂȂ��Ă��܂��B
%
% �o��: 
%    ForwardRates      
%           ���ݓI�t�H���[�h������10�i�@�Ŏ��� N �s1��̗�x�N�g��
%    CurveDates        
%           ForwardRates ���\������e���ݓI�t�H���[�h�����̖��������V��
%           �A�����t�ԍ��Ŏ��� N �s1��̗�x�N�g��
%
% �Q�l : FWD2ZERO, ZBTPRICE, ZBTYIELD, ZERO2DISC, DISC2ZERO, TERMFIT, 
%        PYLD2ZERO, ZERO2PYLD.


%Author(s): J. Akao and C. Bassignani, 11/21/97 
%   Copyright 1995-2002 The MathWorks, Inc. 
