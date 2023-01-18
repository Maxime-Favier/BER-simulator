function [BER] = simHardRX(modul, EbN0, N, maxNumErrs, maxNum)
%SIMHARDRX simulate the BER over an AWGN channel
%   Simulation of errors of a modulation over an AWGN channel for a coded
%   system with hard decoding
% @author: Maxime Favier

M = length(modul);    % Number of symbols in the constellation
bpsymb = log2(M);     % Number of bits per symbol

BER = zeros(1, length(EbN0)); % pre-allocate a vector for BER results

parfor i = 1:length(EbN0) % use parfor ('help parfor') to parallelize  
  totErr = 0;  % Number of errors observed
  num = 0; % Number of bits processed

  while((totErr < maxNumErrs) && (num < maxNum))
  % ===================================================================== %
  % Begin processing one block of information
  % ===================================================================== %
  % [SRC] generate N information bits 
  a = randsrc(1,N - mod(N,bpsymb),[0 1]);
  %a = [a zeros(1, 4)]; zeros for non trucating ?
  
  % [ENC] convolutional encoder
  aEnc  = encoder2(a);
  
  % [MOD] symbol mapper
  %Reshaping bits to constellation points
  m = buffer(aEnc, bpsymb)';                          % Group bits into bits per symbol
  m = bi2de(m, 'left-msb')'+1;                     % Bits to symbol index
  x = modul(m);                                     % Look up symbols using the indices

  % [CHA] add Gaussian noise
  rx_vec = awgn(x, EbN0(i), 'measured');
 
  % [HR] Receiver
  metric = abs(repmat(rx_vec.',1,M) - repmat(modul, length(rx_vec), 1)).^2; % compute the distance to each possible symbol
  [~, m_hat] = min(metric, [], 2); % find the closest for each received symbol
  m_hat = m_hat'-1;   % get the index of the symbol in the constellation
  
  m_hat = de2bi(m_hat, bpsymb, 'left-msb')'; %make symbols into bits
  a_hat = m_hat(:)'; %write as a vector
  
  a_hat = decoder2(a_hat, N);
  % ===================================================================== %
  % End processing one block of information
  % ===================================================================== %
  BitErrs = sum(a ~= a_hat); % count the bit errors and evaluate the bit error rate
  totErr = totErr + BitErrs;
  num = num + N; 

  disp(['+++ ' num2str(totErr) '/' num2str(maxNumErrs) ' errors. '...
      num2str(num) '/' num2str(maxNum) ' bits. Projected error rate = '...
      num2str(totErr/num, '%10.1e') '. +++']);
  end 
  BER(i) = totErr/num; 

end

end