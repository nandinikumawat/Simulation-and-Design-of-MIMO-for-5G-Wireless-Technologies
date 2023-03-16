clear all;
close all;
clc;
ITER = 5000;
K = 10;
Mv = 20:30:500;
EudB = 10;
Eu = 10^(EudB/10);
rateMRC = zeros(1,length(Mv));
boundMRC = zeros(1,length(Mv));





figure;
plot(Mv,rateMRC,'b - s','LineWidth',3,'MarkerFaceColor','blue','MarkerSize',8.0)
hold on
plot(Mv,boundMRC,'g -. ','LineWidth',3,'MarkerFaceColor','green','MarkerSize',8.0)
grid on
title('Information Rate of Massive MIMO with Channel Estimation')
legend('MRC', 'Bound MRC','Location','SouthEast');
xlabel('Number of BS Antennas')
ylabel('Uplink Sum Rate (bits/s/Hz)')