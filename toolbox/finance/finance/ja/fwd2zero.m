% FWD2ZERO   �^����ꂽ���ݓI�t�H���[�h�Ȑ�����[���Ȑ��𓱏o
%
%     [ZeroRates, CurveDates] = ....
%        fwd2zero(ForwardRates, CurveDates, Settle, ....
%        OutputCompounding, OutputBasis, InputCompounding,InputBasis)
%
% �ڍׁF
% ���͂Ƃ��ē��ݓI�t�H���[�h�Ȑ��ƈ�g�̖��������^������ƁA���̊֐���
% ���͂��ꂽ�������ɂ���Ď�����鏊�L���Ԃɑ΂��ă[���Ȑ����o�͂��܂��B
% 
% ����:
% �@ ForwardRates      - (�K�{)�^����ꂽ���L���Ԃɑ΂���t�H���[�h�Ȑ�
%                        �𑊑ΓI�Ɏ����N�����Z���ꂽ���ݓI�t�H���[�h����
%                        (10�i���\��)��N�s1��̃x�N�g��
%    CurveDates        - (�K�{)���͂��ꂽ�t�H���[�h�����ɑΉ����閞������
%                         �V���A�����t�Ŏ���N�s1��x�N�g��
%    MSettle           - (�K�{)���͂��ꂽ���ݓI�t�H���[�h�Ȑ��ɑ΂��Č�
%                         �ϓ����V���A�����t�`���ŕ\������X�J���l
%    OutputCompounding - (�I�v�V����)�o�͂����[��������N���Ɋ��Z����
%                         �Ƃ��ɁA�ǂ̂��炢�̗��ŕ����v�Z���s��������
%                         ���X�J���l�B���͂ł���l�͂��̒ʂ�ł��B
%              OutputCompounding = 1   -  ��N�����v�Z
%              OutputCompounding = 2   -  (�f�t�H���g)���N�����v�Z
%              OutputCompounding = 3   -  �N3�񕡗��v�Z
%              OutputCompounding = 4   -  �N4�񕡗��v�Z
%              OutputCompounding = 6   -  �u�������v�Z
%              OutputCompounding = 12  -  ��1�񕡗��v�Z
%              OutputCompounding = 365 -  ��������v�Z
%              OutputCompounding = -1  -  �A�������v�Z
%     OutputBasis      - (�I�v�V����)�o�͂����[��������N���Ɋ��Z����
%                        �Ƃ��ɂǂ̓����J�E���g���p���邩������
%                        �X�J���l�B���͂ł���l�́A���̒ʂ�ł��B
%              1)Basis = 0 - actual/actual(�f�t�H���g)
%              2)Basis = 1 - 30/360
%              3)Basis = 2 - actual/360
%              4)Basis = 3 - actual/365
%     InputCompounding - (�I�v�V����)���͂����t�H���[�h������N���Ɋ��Z
%                        ����Ƃ��ɂǂ̂��炢�̊����ŕ����v�Z���s������
%                        �����X�J���l�B�f�t�H���g�ł́AOutputCompounding
%                        �Ɠ����l�ƂȂ��Ă��܂��B
%     InputBasis       - (�I�v�V����)���͂����t�H���[�h������N���Ɋ��Z
%                        ����Ƃ��ɂǂ̓����J�E���g���p���邩������
%                        �X�J���l�B�f�t�H���g�ł́AOutputBasis �Ɠ����l
%                        �ɂȂ��Ă��܂��B
%
% �o��: 
%           ZeroRates  - 10�i�@�\�L�̃[���������܂�Nx1��x�N�g��
%           CurveDates - ZeroRates �Ɋ܂܂��e�[�������̖��������V���A��
%                        ���t�`���Ŏ������������̓��t�ō\�������N�s1��
%                        �̃x�N�g��
%
% �Q�l : ZERO2FWD, ZBTPRICE, ZBTYIELD, ZERO2DISC, DISC2ZERO, TERMFIT, 
%        PYLD2ZERO, ZERO2PYLD.


%Author(s): J. Akao and C. Bassignani, 11/21/97 
%   Copyright 1995-2002 The MathWorks, Inc. 
