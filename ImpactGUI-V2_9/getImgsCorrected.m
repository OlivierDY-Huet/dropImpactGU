function [imgsC]=getImgsCorrected(imgsR,xy)


imgsC=imgsR;

medIntImgs=zeros(size(imgsR));
for n=1:length(imgsR)
    imgRZone=imgsR{n}(xy(3):xy(4),xy(1):xy(2));
    medIntImgs(n)=median(imgRZone(:)); 
end
intTarget=prctile(medIntImgs,25);

for n=1:length(imgsR)  
    imgsC{n}=uint8(double(imgsR{n})*double(intTarget)/double(medIntImgs(n)));
    imgCZone=imgsC{n}(xy(3):xy(4),xy(1):xy(2));
    medIntImgsCheck(n)=median(imgCZone(:)); 
end
    
% 'test'
% figure,plot(medIntImgs), ylim([0 255]), hold on, plot(medIntImgsCheck)


% 
% imgsC=imgsR;
% %percRef=75;
% percIntImgs=zeros(size(imgsR));
% for n=1:length(imgsR)
%     percIntImgs(n)=prctile(imgsR{n}(:),percRef); 
% end
% intTarget=prctile(percIntImgs,50);
% 
% 
% 
% % imgF=zeros(s(1),s(2),200);
% % for n=1:L
% %     imgF(:,:,n)=imgsR{n}(:,:);
% % end
% % imgStd=std(imgF,0,3);
% 
% 
% 
% 
% for n=1:length(imgsR)
%     imgsC{n}=uint8(double(imgsR{n})*double(intTarget)/double(prctile(imgsR{n}(:),percRef)));
%     percIntImgsCheck(n)=prctile(imgsC{n}(:),percRef);
% end
    
%figure,plot(percIntImgs), ylim([0 255]), hold on, plot(percIntImgsCheck)

'test'




end