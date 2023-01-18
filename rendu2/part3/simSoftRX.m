function [BER] = simSoftRX(modul, EbN0, N, maxNumErrs, maxNum, encoder,con_code)
%SIMSOFTRX simulate the BER over an AWGN channel
%   Simulation of errors of a modulation over an AWGN channel for a coded
%   system with soft decoding
% @author: Maxime Favier, Xiaoning Lee

M = length(modul);    % Number of symbols in the constellation
bpsymb = log2(M);     % Number of bits per symbol

BER = zeros(1, length(EbN0)); % pre-allocate a vector for BER results

if con_code == 1
        parfor i = 1:length(EbN0) % use parfor ('help parfor') to parallelize  
          totErr = 0;  % Number of errors observed
          num = 0; % Number of bits processed
        
          while((totErr < maxNumErrs) && (num < maxNum))
          % ===================================================================== %
          % Begin processing one block of information
          % ===================================================================== %
          % [SRC] generate N information bits 
          %a = randsrc(1,N - mod(N,bpsymb),[0 1]);
          a = randi([0 1],1, N); 
          %a = [a zeros(1, 4)]; zeros for non trucating ?
          
          % [ENC] convolutional encoder
          if (encoder==1)
              aEnc  = encoder1(a);
          elseif(encoder ==2)
              aEnc  = encoder2(a);
          elseif(encoder==3)
              aEnc  = encoder3(a);
          elseif(encoder==4)
              aEnc  = encoder4(a);
          end
          
          % [MOD] symbol mapper
          %Reshaping bits to constellation points
          if (encoder~=4)
            m = buffer(aEnc, bpsymb)';                          % Group bits into bits per symbol
            m = bi2de(m, 'left-msb')'+1;                     % Bits to symbol index
            x = modul(m);                                     % Look up symbols using the indices
          elseif(encoder==4)
          x = mapper_4(aEnc);
          end
        
        
        
        
          % [CHA] add Gaussian noise
          rx_vec = awgn(x, EbN0(i), 'measured');
          
          
          % [RX]
        
         if encoder == 4
                   a_hat=EN4(rx_vec);
         else
                  if(length(modul) == 4)
                      % Receiver QPSK
                      y0 = real(rx_vec) * (-1)/sqrt(2) + 0.5; % the real axis set the fist bit in qpsk grey
                      y1 = imag(rx_vec) * (-1)/sqrt(2) +0.5;  % the img axis map the second bit
                      % combine the two for input into the decoder
                      a_hat = zeros(1,length(y0)+length(y1));
                      a_hat(1:2:end) = y0;
                      a_hat(2:2:end) = y1;
                  else %if(length(modul) == 2)
                      % RX BPSK
                      a_hat = real(rx_vec) * 1/2 + 0.5;
                  end          
                  a_hat = decoder3(a_hat, N);
                  
          end
          
          
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
          BER(i) = totErr./num; 
        
        end
elseif con_code == 2
        parfor i = 1:length(EbN0) % use parfor ('help parfor') to parallelize  
          totErr = 0;  % Number of errors observed
          num = 0; % Number of bits processed
        
          while((totErr < maxNumErrs) && (num < maxNum))
          % ===================================================================== %
          % Begin processing one block of information
          % ===================================================================== %
          % [SRC] generate N information bits 
          %a = randsrc(1,N - mod(N,bpsymb),[0 1]);
          a = randi([0 1],1, N); 
          %a = [a zeros(1, 4)]; zeros for non trucating ?
          
          % [ENC] convolutional encoder
         if encoder == 4
                   x=mapper_4(a);
         else
                  if(length(modul) == 4)
                      x=mapper_3(a);

                  else 
                      x=mapper_2(a);
                  end          
                  
         end         
        
        
          
          % [CHA] add Gaussian noise

          rx_vec = awgn(x, EbN0(i), 'measured');
          
          
          % [RX]
        
         if encoder == 4
                   a_hat=uncoded(rx_vec,3);
         else
                  if(length(modul) == 4)
                      a_hat=uncoded(rx_vec,2);

                  else 
                      a_hat=uncoded(rx_vec,1);
                  end          
                  
         end
          
          
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
          BER(i) = totErr./num; 
        
        end


end


end

