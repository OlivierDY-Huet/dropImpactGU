function [nOpt]=getNbrBackground(imgsR)

nLim=[10,min([round(length(imgsR)/2),100])];
nbrPts=10;
dn=round((nLim(2)-nLim(1))/(nbrPts-1));
n=nLim(1):dn:nLim(2);

gph=zeros(length(n),2);
for k=1:length(n)
    [imgBG]=getImgBackground(imgsR,n(k),100);
    BW=imbinarize(imgBG);
    colMin=ones(size(BW,1),1).*min(BW,[],2);
    gph(k,1:2)=[n(k),sum(colMin)]; % colMin is lower if the drop is present in the background image
end
idx=find(gph(:,2)==max(gph(:,2)));
nOpt=gph(idx(end),1);
% [imgBG]=getImgBackground(imgsR,nOpt);
% figure,imshow(imgBG)
% figure,plot(gph(:,1),gph(:,2),'-r')

 end