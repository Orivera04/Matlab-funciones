% CORR2COV   �W���΍��Ƒ��ւ������U�ɕϊ�
%
% N �̃����_���v���Z�X�̃{���e�B���e�B�ƃv���Z�X�Ԃ̑��֓x����N�sN���
% �����U�s��ɕϊ����܂��B
%
% ExpCovariance = corr2cov(ExpSigma, ExpCorrC)
%
% ���́F
%   ExpSigma : �e�v���Z�X�̕W���΍����܂ޒ��� N �̃x�N�g��
%
%   ExpCorrC : N�sN��̑��֌W���s��BExpCorrC �����w��̏ꍇ�A�v���Z�X
%              �ɂ́A���ւ��Ȃ��Ɖ��肳��A�P�ʍs�񂪎g�p����܂��B
%
% �o�́F
%   ExpCovariance  : N�sN��̋����U�s��B(i,j) �ւ̓��͗v�f�́A���ς����
%                    i�Ԗڂ̕΍� x ���ς����j�Ԗڂ̕΍��̊��Ғl�ł��B
% 
%         ExpCov(i,j)= ExpCorrC(i,j)*( ExpSigma(i)*ExpSigma(j))
% 
% �Q�l : EWSTATS, COV, CORRCOEF, STD, COV2CORR.


%   Author: J. Akao 11/17/97
%   Copyright 1995-2002 The MathWorks, Inc.  
