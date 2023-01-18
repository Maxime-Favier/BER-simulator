% Encoder Comparaison
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
%EbN0 = 4:13;

% modulation constellation
qpsk = [(1 + 1i),(1 - 1i),(-1 + 1i),(-1 -1i)]/sqrt(2);

% simulation for coded soft RX E1
BERqpskSoftE1 = simSoftRX(qpsk, EbN0Min:6, N, maxNumErrs, maxNum, 1);

% simulation for coded soft RX E2
BERqpskSoftE2 = simSoftRX(qpsk, EbN0Min:6, N, maxNumErrs, maxNum, 2);

% simulation for coded soft RX E3
BERqpskSoftE3 = simSoftRX(qpsk, EbN0Min:6, N, maxNumErrs, maxNum, 3);


% simulation for uncoded QPSK
%BERqpsk = simUncoded(qpsk, EbN0Min:12, N, maxNumErrs, maxNum);


% upper bound
trellis_1 = poly2trellis(3,[5 7]);
trellis_2 = poly2trellis(5,[27 26]);
trellis_3 = poly2trellis(5,[23 33]);
EbN0L = zeros(1,length(EbN0));
for i=1:length(EbN0)
    EbN0L(i) = 10.^(EbN0(i)/10); 
end

spect = distspec(trellis_1,15); 
n = length(spect.event); 
BER_Bound_1 = zeros(1,10);
for j = 1:length(EbN0)
  for i = 1:n
     Ad = spect.weight(i);
     d = (spect.dfree + i-1)/2;
     arg = sqrt(EbN0L(j)*d*2); 
     BER_Bound_1(j) = BER_Bound_1(j) + Ad*qfunc(arg); 
  end
end

spect2 = distspec(trellis_2,15); 
n = length(spect2.event); 
BER_Bound_2 = zeros(1,10);
for j = 1:length(EbN0)
  for i = 1:n
     Ad = spect2.weight(i);
     d = (spect2.dfree + i-1)/2;
     arg = sqrt(EbN0L(j)*d*2); 
     BER_Bound_2(j) = BER_Bound_2(j) + Ad*qfunc(arg); 
  end
end


spect3 = distspec(trellis_3,15); 
n = length(spect3.event); 
BER_Bound_3 = zeros(1,10);
for j = 1:length(EbN0)
  for i = 1:n
     Ad = spect3.weight(i);
     d = (spect3.dfree + i-1)/2;
     arg = sqrt(EbN0L(j)*d*2); 
     BER_Bound_3(j) = BER_Bound_3(j) + Ad*qfunc(arg); 
  end
end


figure();
semilogy(EbN0Min:6, BERqpskSoftE2, 'ob-', 'DisplayName','E2')
hold on
%semilogy(EbN0, BERampm, 'ob-')
semilogy(EbN0Min:6, BERqpskSoftE1, 'ok-', 'DisplayName','E1')
semilogy(EbN0Min:6, BERqpskSoftE3, 'or-', 'DisplayName','E3')

%semilogy(EbN0Min:6, uBERE1, 'k-', 'DisplayName','UB E1')
%semilogy(EbN0Min:6, uBERE2, 'b-', 'DisplayName','UB E2')
%semilogy(EbN0Min:6, uBERE3, 'r-', 'DisplayName','UB E3')
semilogy(EbN0Min:8, BER_Bound_1, 'k--', 'DisplayName','UB E1')
semilogy(EbN0Min:8, BER_Bound_2, 'b--', 'DisplayName','UB E2')
semilogy(EbN0Min:8, BER_Bound_3, 'r--', 'DisplayName','UB E3')
%semilogy(EbN0Min:12, BERqpsk, 'or-','DisplayName','QPSK Uncoded')


title("Error simulation")
xlabel("SNR");
ylabel("BER");
legend;
ylim([1e-4 1]); 
xlim([EbN0Min 6]); 

grid on;