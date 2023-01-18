% ======================================================================= %
% SSY125 Project
% ======================================================================= %
% @author: Maxime Favier
clc;
clear all;
close all;
% ======================================================================= %
% Simulation Options
% ======================================================================= %
N = 1e5;  % simulate N bits each transmission (one block)
maxNumErrs = 100; % get at least 100 bit errors (more is better)
maxNum = 1e6; % OR stop if maxNum bits have been simulated
EbN0 = -1:8; % power efficiency range
%EbN0 = 4:13;
% ======================================================================= %
% Other Options
% ======================================================================= %
% constellations
bpsk = [(-1 +realmin('single')*1i), (1 +realmin('single')*1i)];
qpsk = [(1 + 1i), (1 - 1i),(-1 + 1i) , (-1 -1i)]/sqrt(2);
ampm = [(1 - 1i), (-3 +3i), (1 + 3i), (-3 -1i), (3 - 3i), (-1 + 1i), (3 + 1i), (-1 -3i)] *0.5;

% ======================================================================= %
% Simulation Chain
% ======================================================================= %
%BERbpsk = modulationSimulation(bpsk, EbN0, N, maxNumErrs, maxNum, 0, 0);
BERqpskE1 = modulationSimulation(qpsk, EbN0, N, maxNumErrs, maxNum, 0, 1);
BERqpsk = modulationSimulation(qpsk, EbN0, N, maxNumErrs, maxNum, 0, 0);
%BERampm = modulationSimulation(ampm, EbN0, N, maxNumErrs, maxNum, 0, 0);

figure(2);
%semilogy(EbN0, BERbpsk, 'or-')
semilogy(EbN0, BERqpsk, 'og-')
hold on
%semilogy(EbN0, BERampm, 'ob-')
semilogy(EbN0, BERqpskE1, '+k-')
title("Error simulation")
xlabel("SNR");
ylabel("BER");
%legend("BPSK", "QPSK", "AMPM");
legend("QPSK", "QPSK E1");
ylim([1e-4 1]); 
grid on;
% ======================================================================= %
% End
% ======================================================================= %