% Coding can increase efficiency
% @author: Maxime Favier, Xiaoning Lee
clc
clear all:
close all;

% ======================================================================= %
% Simulation Options
% ======================================================================= %
N = 1e5;  % simulate N bits each transmission (one block)
maxNumErrs = 100; % get at least 100 bit errors (more is better)
maxNum = 1e7; % OR stop if maxNum bits have been simulated
EbN0Min = -1; % power efficiency range
EbN0 = -1:6;

% modulation constellation
bpsk = [(-1 +realmin('single')*1i), (1 +realmin('single')*1i)];
qpsk = [(1 + 1i), (1 - 1i),(-1 + 1i) , (-1 -1i)]/sqrt(2);
ampm = [(1 - 1i), (-3 +3i), (1 + 3i), (-3 -1i), (3 - 3i), (-1 + 1i), (3 + 1i), (-1 -3i)]./sqrt(10);

% simulation for coded soft RX BPSK E3
e3_code_b = simSoftRX(bpsk, EbN0Min:6, N, maxNumErrs, maxNum,3,1);

% simulation for coded soft RX QPSK E3
e3_code_q = simSoftRX(qpsk, EbN0Min:6, N, maxNumErrs, maxNum,3,1);

% simulation for coded soft RX E4
e4_code = simSoftRX(ampm, EbN0Min:10, N, maxNumErrs, maxNum,4,1);

% simulation for uncoded soft RX BPSK E3
e3_uncode_b = simSoftRX(bpsk, EbN0Min:12, N, maxNumErrs, maxNum,3,2);

% simulation for uncoded soft RX QPSK E3
e3_uncode_q = simSoftRX(qpsk, EbN0Min:12, N, maxNumErrs, maxNum,3,2);

% simulation for coded soft RX E4
e4_uncode = simSoftRX(ampm, EbN0Min:16, N, maxNumErrs, maxNum,4,2);


figure();
semilogy(EbN0Min:6, e3_code_b, 'red-', 'DisplayName','E3 BPSK')
grid on
hold on
semilogy(EbN0Min:6, e3_code_q, 'green-', 'DisplayName','E3 QPSK')
semilogy(EbN0Min:10, e4_code, 'blue-', 'DisplayName','E4 AMPM')
semilogy(EbN0Min:12, e3_uncode_b, 'r--', 'DisplayName','E3 BPSK UNC')
semilogy(EbN0Min:12, e3_uncode_q, 'yellow--', 'DisplayName','E3 QPSK UNC')
semilogy(EbN0Min:16, e4_uncode, 'blue--', 'DisplayName','E4 AMPM UNC')
title("Error simulation")
xlabel('EbN0')
ylabel('BER')
legend;
ylim([1e-4 1])
xlim([-1 16])



grid on;