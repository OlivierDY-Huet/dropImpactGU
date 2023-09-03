% function [percRef]=getOptimisedPerc(imgsR)
% 
% perc=[5:5:95];
% percIntM=zeros(length(imgsR), length(perc));
% for n=1:length(imgsR)
%     for k=1:length(perc)
%         percIntM(n,k)=prctile(imgsR{n}(:),perc(k));
%     end
% end
% 
% figure,
% for k=1:length(perc)  
% plot(percIntM(:,k)), hold on
% end
%  ylim([0 255])
% 
% 
% 
% end