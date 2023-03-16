close all;
clear all;

blockLength = 1000;
nBlocks=10000;
L=2;
EbdB = 1.0:1.5:18.0;
Eb = 10.^(EbdB/10);
No = 1;
SNR = 2*Eb/No;
SNRdB = 10*log10(SNR);
BER = zeros(1,length(EbdB));
BERt = zeros(1,length(EbdB));

for blk=1:nBlocks
    h=1/sqrt(2)*(randn(L,1)+1j*randn(L,1));
    BitsI=randi([0,1],1,blockLength);
    BitsQ=randi([0,1],1,blockLength);
    Sym=(2*BitsI-1)+1j*(2*BitsQ-1);
    noise=sqrt(No/2)*(randn(L,blockLength)+1j*randn(L,blockLength));
    for K=1:length(EbdB)
        TxSym=sqrt(Eb(K))*Sym;
        RxSym=h*TxSym+noise;
        MRCout=h'*RxSym;
        DecBitsI=(real(MRCout)>0);
        DecBitsQ=(imag(MRCout)>0);
        BER(K)=BER(K)+sum(DecBitsI~=BitsI)+sum(DecBitsQ~=BitsQ);
    end
end

BER = BER/blockLength/nBlocks/2;
BERt = nchoosek(2*L-1, L)/2^L./SNR.^L;

semilogy(SNRdB,BER,'g  s','linewidth',3.0,'MarkerFaceColor','g','MarkerSize',9.0);
hold on;
semilogy(SNRdB,BERt,'b -  ','linewidth',3.0);
axis tight;
grid on;
legend('BER','BER Theory')
xlabel('SNR (dB)');
ylabel('BER');
title('BER vs SNR(dB) for Multiantenna System with MRC');