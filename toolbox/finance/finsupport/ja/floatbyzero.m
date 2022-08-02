% FLOATBYZERO   1�g�̃[���Ȑ�����ϓ����t�،��̉��i������
%
%   Price = floatbyzero(RateSpec, Spread, Settle, Maturity)
%
%   Price = floatbyzero(RateSpec, Spread, Settle, Maturity, ...
%                                 Reset,  Basis,  Principal)
%
% ����(�K�{): 
% ���̊֐��̓��͂́A���Ɏw�肪�Ȃ�����A�S�ăX�J���A�܂��́ANINST �s1��
% �̃x�N�g���ł��B���t�́A�V���A�����t�ԍ��A�܂��́A���t������ł��B�I�v
% �V�����̈����́A��s�� [] ��ݒ肵�āA�f�t�H���g�l���g�p���邱�Ƃ��ł�
% �܂��B
%
%   RateSpec     - �N�����Z���ꂽ�[���������ԍ\����
%   Spread       - �N�����Z���ꂽ�[���Ȑ���ɂ���x�[�V�X�|�C���g�̐��B
%                  �f�t�H���g��0
%   Settle       - ���ϓ�
%   Maturity     - ������
%
% ����(�I�v�V����):
%   Reset        - �N�ɉ��񌈍ϓ����K��邩�������l�B�f�t�H���g��1
%   Basis        - �����̃J�E���g��B�f�t�H���g��0 (actual/actual).
%   Principal    - �z�茳�{(���ڌ��{)�B�f�t�H���g��100�ł��B
%
% �o��:
%   Price        - �ϓ����t�،��̉��i������NINST�sNUMCURVES��̍s��ł��B
%                  �s��̊e�񂪂��ꂼ��P�̃[���Ȑ��ɑΉ����Ă��܂��B
%
%
% �Q�l : BONDBYZERO, CFBYZERO, FIXEDBYZERO, SWAPBYZERO.


%   Author(s): M. Reyes-Kattar, 07/29/1999
%   Copyright 1995-2002 The MathWorks, Inc. 
