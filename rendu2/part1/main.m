% Hard vs. Soft Receiver
% @authors: Maxime Favier, Xiaoning Lee
clc
clear all:
close all;

% ======================================================================= %
% Simulation Options
% ======================================================================= %
N = 1e5;  % simulate N bits each transmission (one block)
maxNumErrs = 100; % get at least 100 bit errors (more is better)
maxNum = 1e8; % OR stop if maxNum bits have been simulated
EbN0Min = -1; % power efficiency range
EbN0 = -1:6;
%EbN0 = 4:13;

% modulation constellation
qpsk = [(1 + 1i),(1 - 1i),(-1 + 1i),(-1 -1i)]/sqrt(2);

% simulation for uncoded QPSK
BERqpsk = simUncoded(qpsk, EbN0Min:12, N, maxNumErrs, maxNum);

% simulation for coded hard RX
BERqpskHardE2 = simHardRX(qpsk, EbN0Min:8, N, maxNumErrs, maxNum);

% simulation for coded soft RX
BERqpskSoftE2 = simSoftRX(qpsk, EbN0Min:6, N, maxNumErrs, maxNum);

% upper bound
% uBER=zeros(1,length(EbN0Min:6));
% for j=1:1:10
%    uBER=uBER+(2^j)*(j)*qfunc(sqrt((j+4)*10.^((EbN0Min:6)/10))); 
% end
% upper bound2
trellis = poly2trellis(5,[27 26]);
EbN0L = zeros(1,length(EbN0));
for i=1:length(EbN0)
    EbN0L(i) = 10.^(EbN0(i)/10); 
end
spect = distspec(trellis,15); 
n = length(spect.event); 
BER_Bound = zeros(1,10);
for j = 1:length(EbN0)
  for i = 1:n
     Ad = spect.weight(i);
     d = (spect.dfree + i-1)/2;
     arg = sqrt(EbN0L(j)*d*2); 
     BER_Bound(j) = BER_Bound(j) + Ad*qfunc(arg); 
  end
end


figure();
semilogy(EbN0Min:12, BERqpsk, 'or-','DisplayName','QPSK Uncoded')
hold on
%semilogy(EbN0, BERampm, 'ob-')
semilogy(EbN0Min:8, BERqpskHardE2, 'ok-', 'DisplayName','QPSK HardRX')
semilogy(EbN0Min:6, BERqpskSoftE2, 'ob-', 'DisplayName','QPSK SoftRX')
%semilogy(EbN0Min:6, uBER, 'm-', 'DisplayName','Upper bound')
semilogy(EbN0Min:8, BER_Bound,'m-', 'DisplayName','Upper bound')
title("Error simulation")
xlabel("SNR");
ylabel("BER");
legend;
ylim([1e-4 1]); 
xlim([EbN0Min 12]); 

grid on;