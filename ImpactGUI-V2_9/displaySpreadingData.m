function []=displaySpreadingData(obsTab,D0,U0)



a=2;
b=2/a;

YLeftAxisVal=zeros(2,2);
YRightAxisVal=zeros(2,2);
figure,
p{1}=subplot(a,b,1);
hold on
title('Left side of the drop')
xlabel('Frame number')
yyaxis left
ylabel('Relative radius [-]')
plot(obsTab.Frame,obsTab.edgeL/(D0/2))
plot(obsTab.Frame,obsTab.wetL/(D0/2))
YLeftAxisVal(1,1)=min(p{1}.YLim);
YLeftAxisVal(2,1)=max(p{1}.YLim);
yyaxis right
ylabel('Angle [deg]')
plot(obsTab.Frame,obsTab.contAngL)
YRightAxisVal(1,1)=min(p{1}.YLim);
YRightAxisVal(2,1)=max(p{1}.YLim);
legend({'Edge radius','Wet radius','Contact angle'})

p{2}=subplot(a,b,2);
hold on
title('Right side of the drop')
xlabel('Frame number')
yyaxis left
ylabel('Relative radius [-]')
plot(obsTab.Frame,obsTab.edgeR/(D0/2))
plot(obsTab.Frame,obsTab.wetR/(D0/2))
YLeftAxisVal(1,2)=min(p{2}.YLim);
YLeftAxisVal(2,2)=max(p{2}.YLim);
yyaxis right
ylabel('Angle [deg]')
plot(obsTab.Frame,obsTab.contAngR)
YRightAxisVal(1,2)=min(p{2}.YLim);
YRightAxisVal(2,2)=max(p{2}.YLim);
legend({'Edge radius','Wet radius','Contact angle'})

subplot(a,b,1)
yyaxis left
ylim([min(YLeftAxisVal(1,:)) max(YLeftAxisVal(2,:))])
yyaxis right
ylim([min(YRightAxisVal(1,:)) max(YRightAxisVal(2,:))])

subplot(a,b,2)
yyaxis left
ylim([min(YLeftAxisVal(1,:)) max(YLeftAxisVal(2,:))])
yyaxis right
ylim([min(YRightAxisVal(1,:)) max(YRightAxisVal(2,:))])

%--------------------------------------------------------------------------

figure,
hold on
title('Relative diameter and height over time')
xlabel('Frame number')
yyaxis left
ylabel('Relative diameter [-]')
plot(obsTab.Frame,obsTab.edge/D0)
plot(obsTab.Frame,obsTab.wet/D0)
yyaxis right
ylabel('Relative height [-]')
plot(obsTab.Frame,obsTab.height/D0)
legend({'Edge diameter','Wet diameter','Height'})


%--------------------------------------------------------------------------

figure,
hold on
title('Contact angle in terms of the contact line velocity')
xlabel('Relative velocity [-]')
ylabel('Contact angle [deg]')

plot(obsTab.contVelL/U0,obsTab.contAngL)
plot(obsTab.contVelR/U0,obsTab.contAngR)
legend({'Left side','Right side'})




end