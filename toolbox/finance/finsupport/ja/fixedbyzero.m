% FIXEDBYZERO   1�g�̃[���Ȑ�����m�藘�t�،��̉��i���o��
%
%   Price = fixedbyzero(RateSpec, CouponRate, Settle, Maturity)
%
%   Price = fixedbyzero(RateSpec, CouponRate, Settle, Maturity, ...
%                                 Reset, Basis,  Principal)
%
% ����(�K�{): 
% ���̊֐��̓��͂́A���Ɏw�肪�Ȃ�����A�S�ăX�J���A�܂��́ANINST �s1��
% �̃x�N�g���ł��B���t�́A�V���A�����t�ԍ��A�܂��́A���t������ł��B�I�v
% �V�����̈����́A��s�� [] ��ݒ肵�āA�f�t�H���g�l���g�p���邱�Ƃ��ł�
% �܂��B
%
%   RateSpec     - �N�����Z���ꂽ�[���������ԍ\����
%   CouponRate   - 10�i�@�\�L�̃N�[�|������(�N��)
%   Settle       - ���ϓ�
%   Maturity     - ������
%
% ����(�I�v�V����):
%   Reset        - �N�ɉ��񌈍ϓ����K��邩�������l�B�f�t�H���g��1
%   Basis        - �����̃J�E���g��B�f�t�H���g��0 (actual/actual).
%   Principal    - �z�茳�{(���ڌ��{)�B�f�t�H���g��100�ł��B
%
% �o��:
%   Price        - �m�藘�t�،��̉��i������NINST�sNUMCURVES��̍s��ł��B
%                  �s��̊e�񂪂��ꂼ��P�̃[���Ȑ��ɑΉ����Ă��܂��B
%
% �Q�l : BONDBYZERO, CFBYZERO, FLOATBYZERO, SWAPBYZERO.


%   Author(s): M. Reyes-Kattar, 07-28-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
