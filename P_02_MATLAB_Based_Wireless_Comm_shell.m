close all;
clear all;

blockLength = 1000;
nBlocks=10000;
EbdB = 1.0:4.0:45.0;
Eb = 10.^(EbdB/10);
No = 1;
SNR = 2*Eb/No;
SNRdB = 10*log10(SNR);
BER = zeros(1,length(EbdB));

for blk=1:nBlocks
    h=1/sqrt(2)*(randn+1j*randn);
    BitsI=randi([0,1],1,blockLength);
    BitsQ=randi([0,1],1,blockLength);
    Sym=(2*BitsI-1)+1j*(2*BitsQ-1);
    noise=sqrt(No/2)*(randn(1,blockLength)+1j*randn(1,blockLength));
    for K=1:length(EbdB)
        TxSym=sqrt(Eb(K))*Sym;
        RxSym=h*TxSym+noise;
        EqSym=RxSym/h;
        DecBitsI=(real(EqSym)>0);
        DecBitsQ=(imag(EqSym)>0);
        BER(K)=BER(K)+sum(DecBitsI~=BitsI)+sum(DecBitsQ~=BitsQ);
    end
end

BER = BER/blockLength/nBlocks/2;

semilogy(SNRdB,BER,'g  s','linewidth',3.0,'MarkerFaceColor','g','MarkerSize',9.0);
hold on;
semilogy(SNRdB,1/2./SNR,'b -  ','linewidth',3.0);
axis tight;
grid on;
legend('BER','BER Theory')
xlabel('SNR (dB)');
ylabel('BER');
title('BER vs SNR(dB) for Wireless System with QPSK');

