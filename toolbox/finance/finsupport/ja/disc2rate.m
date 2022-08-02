% DISC2RATE   �L���b�V���t���[�����t�@�N�^�𗘗��Ɋ��Z
%
% NPOINTS �̎��ԊԊu�ɓn���āA�ݒ肵���L���b�V���t���[�������痘����
% �v�Z���܂��BNCURVES �̈قȂ闘���Ȑ��́A�����̗����Ȑ�������̎���
% �\�������ꍇ�Ɍ���A��x�ɕϊ����邱�Ƃ��ł��܂��B�C���^�[�o���́A
% �[���Ȑ��A�܂��́A�t�H���[�h�Ȑ��ŕ\�����邱�Ƃ��\�ł��B
%
% �g�p�@ 1: �C���^�[�o���|�C���g�́A���ԒP�ʕ\���̎��Ԃœ��͂��܂��B
%   [Rates] = disc2rate(Compounding, Disc, EndTimes, StartTimes)
%   [Rates] = disc2rate(Compounding, Disc, EndTimes)
%
% �g�p�@ 2: ValuationDate �͏ȗ��ł��܂��B�܂��A�C���^�[�o���|�C���g��
%           ���t�œ��͂��܂��B
%   [Rates, EndTimes, StartTimes] = disc2rate(Compounding, Disc, ... 
%     EndDates, StartDates, ValuationDate)
%
% ����:
%   Compounding - �N�����Z���ɁA���͂��ꂽ�[�������ǂ̂悤�ȓx���ŕ���
%                 �v�Z���邩�������X�J���l�ł��B���̈����́A�����t�@�N�^
%                 �y�� Times �̉��߂ɓK�p���鎮�����̂悤�Ɍ��肵�܂��B
%     1)Compounding = 1, 2, 3, 4, 6, 12 = F
%        Disc = (1 + Z/F)^(-T), �����ŁAF �͕����x���ł��BZ �̓[�����A 
%        T �͊��ԒP��(periodic unit)�Ŏ����ꂽ�񐔂ŁAT = F �̏ꍇ�A1�N��
%        �w�������܂��B
%     2)Compounding = 365 
%        Disc = (1 + Z/F)^(-T)�A�����ŁAF �͊�ƂȂ�N�̓����AT �͊
%        �ƂȂ�N�Ɋ�Â��Čv�Z�����o�ߓ����ł��B
%     3)Compounding = -1
%        Disc = exp( -T * Z ), T �͔N�Ŏ����ꂽ���Ԃ������Ă��܂��B
%
%   Disc        - ���������� NPOINTS x NCURVES �̃x�N�g���ł��BDisc �́A
%                 �L���b�V���t���[���]������� StartTimes ����A�L���b
%                 �V���t���[�̎����ł��� EndTimes ���I�_�Ƃ���C���^�[
%                 �o���ɑ΂���P�ʍ����i�ł��B
%
%   �g�p�@1: ValuationDate ���ȗ�����Ȃ������P�[�X�ł́A3�Ԗڋy��4�Ԗ�
%            �̈����͎��ԂƂ��ĉ��߂���܂��B
%
%   EndTimes    - �������K�p�����C���^�[�o���̏I�_�ƂȂ鎞�Ԃ����ԒP��
%                 �Ŏ��� NPOINTS �s1��̃x�N�g���ł��B
%
%   StartTimes  - �������K�p�����C���^�[�o���̎n�_�ƂȂ鎞�Ԃ����ԒP��
%                 �Ŏ��� NPOINTS �s1��̃x�N�g���ł��BStartTimes �̓I�v
%                 �V�����̈����ŁA�f�t�H���g�l��0�ł��B
%
%   �g�p�@ 2 : ValuationDate ���ȗ����ꂽ�ꍇ�A3�Ԗڋy��4�Ԗڂ̈����͓�
%              �t�Ƃ��ĉ��߂���܂��B ���t ValuationDate �́A���Ԃ��v�Z
%              ����ۂ̃[���_�Ƃ��ėp�����܂��B
%
%   EndDates    - �������K�p�����C���^�[�o���̏I�_�ƂȂ閞�������V���A
%                 �����t�`���Ŏ����X�J���l�A�܂��́ANPOINTS �s1��̃x�N
%                 �g���ł��B
%
%   StartDates  - �������K�p�����C���^�[�o���̎n�_�ƂȂ���t���V���A��
%                 ���t�`���Ŏ����X�J���l�A�܂��́ANPOINTS �s 1��̃x�N�g
%                 ���ł��BStartDates �̓I�v�V�����̈����ŁA�f�t�H���g�l
%                 �� ValuationDate �ł��B
%
%   ValuationDate - 
%                 StartDates �� EndDates �œ��͂��ꂽ�������E�̊ϑ���
%                 (observation date)���V���A�����t�`���Ŏ����X�J���l��
%                 ���BValuationDate �́A�g�p�@2�ł͕K�{�ƂȂ�܂��B��
%                 ���A�g�p�@1�ł́AValuationDate �͏ȗ����邩�A��s��
%                 �ɂ���ē��͂��p�X���Ȃ���΂Ȃ�܂���B
%
% �o��:
%   Rates       - NPOINTS ��̎��ԃC���^�[�o���ɑΉ����闘�������� 
%                 NPOINTS x NCURVES �̍s��ł��B
% 
%   StartTimes  - �������K�p�����C���^�[�o���̎n�_�ƂȂ鎞�Ԃ����� 
%                 NPOINTS �s 1��̗�x�N�g���ł��B�����āA���̎��Ԃ́A
%                 ���ԒP�ʂő��肳��܂��B
%
%   EndTimes    -  �������K�p�����C���^�[�o���̏I�_�ƂȂ鎞�Ԃ����� 
%                  NPOINTS �s 1��̗�x�N�g���ł��B�����āA���̎��Ԃ́A
%                  ���ԒP�ʂő��肳��܂��B
%  
% ���ӁF
% Compounding = 365 (��������)�̏ꍇ�A StartTimes �� EndTimes �́A���P��
% �ő��肳��܂��B����ȊO�̏ꍇ�A���̈����́ASIA ���N�^�C���t�@�N�^ 
% Tsemi ����A����  T = Tsemi/2 * F �ɂ���Čv�Z���ꂽ�l���܂ނ��Ƃ�
% �Ȃ�܂��B�����ŁAF �͕����v�Z�̕p�x�������Ă��܂��B���Ƃ��΁A�A������
% �̏ꍇ�AF ��1�ɐݒ肳��܂��B
%
% �����C���^�[�o���́A���͂��ꂽ����(�g�p�@ 1)�A�܂��́A���͂��ꂽ���t
% (�g�p�@ 2)�̂����ꂩ�Ɏw��ł��܂��B���� ValuationDate �����͂�����
% ���t���߂��Ăяo������� ValuationDate ���ȗ������ƁA�f�t�H���g��
% ���ԉ��߂��Ăяo����邱�ƂɂȂ�܂��B
%
% �Q�l : RATE2DISC, RATETIMES.


%   Author(s): J. Akao 11/03/98
%   Copyright 1995-2002 The MathWorks, Inc. 
