clc
close all; 
clear all;

nBlocks = 10000; 
r = 2; 
t = 2; 
No = 1; 
SNRdB = 0:2:14;
SNR = 10.^(SNRdB/10); 
MSE_LS = zeros(1,length(SNRdB)); 
MSE_LMMSE = zeros(1,length(SNRdB)); 
MSE_LSt = zeros(1,length(SNRdB)); 
MSE_LMMSEt = zeros(1,length(SNRdB)); 

for blk =1:nBlocks
    H=1/sqrt(2)*(randn(r,t)+1j*randn(r,t));
    noise=sqrt(No/2)*(randn(r,t)+1j*randn(r,t));
    DFTmat=dftmtx(t);
    for K=1:length(SNRdB)
        Xp=sqrt(SNR(K))*DFTmat;
        Yp=H*Xp+noise;
        
        H_LS=Yp*pinv(Xp);
        MSE_LS(K)=MSE_LS(K)+norm(H-H_LS,'fro')^2;
        MSE_LSt(K)=MSE_LSt(K)+abs(No*r*trace(inv(Xp*Xp')));
        H_LMMSE=Yp*Xp'*inv(Xp*Xp'+No*eye(t));
        MSE_LMMSE(K)=MSE_LMMSE(K)+norm(H-H_LMMSE,'fro')^2;
        MSE_LMMSEt(K)=MSE_LMMSEt(K)+r*abs(trace(inv(Xp*Xp'/No+eye(t))));
    end
end

MSE_LS = MSE_LS/nBlocks;
MSE_LMMSE = MSE_LMMSE/nBlocks;
MSE_LSt = MSE_LSt/nBlocks;
MSE_LMMSEt = MSE_LMMSEt/nBlocks;

semilogy(SNRdB,MSE_LS,'g - ','linewidth',3.0,'MarkerFaceColor','g','MarkerSize',9.0);
hold on
semilogy(SNRdB,MSE_LSt,'r o','linewidth',3.0,'MarkerFaceColor','r','MarkerSize',9.0);
semilogy(SNRdB,MSE_LMMSE,'b -.','linewidth',3.0,'MarkerFaceColor','b','MarkerSize',9.0);
semilogy(SNRdB,MSE_LMMSEt,'m s','linewidth',3.0,'MarkerFaceColor','m','MarkerSize',9.0);
axis tight;
grid on;
title('MSE for MIMO Channel Estimation');
legend('LS','LS Theory','LMMSE','LMMSE Theory','Location','SouthWest');
xlabel('SNR (dB)')
ylabel('MSE') 
