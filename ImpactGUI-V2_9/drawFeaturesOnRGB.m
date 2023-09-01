function [imgsRGB]=drawFeaturesOnRGB(imgsRGB,pxList,colorInfo)

if ischar(colorInfo)    
    nbrC=size(pxList,1);
    colorMapOptions={'parula';'jet';'hsv';'hot';'cool';'spring';'summer';'autumn';'winter';'gray';'bone';'copper';'pink'}; 
    switch find(strcmp(colorInfo,colorMapOptions)==1)
        case 1
            color2apply=parula(nbrC);
        case 2
            color2apply=jet(nbrC);
        case 3
            color2apply=hsv(nbrC);
        case 4
            color2apply=hot(nbrC);
        case 5
            color2apply=cool(nbrC);
        case 6
            color2apply=spring(nbrC);
        case 7
            color2apply=summer(nbrC);
        case 8
            color2apply=autumn(nbrC);
        case 9
            color2apply=winter(nbrC);
        case 10
            color2apply=gray(nbrC);
        case 11
            color2apply=bone(nbrC);
        case 12
            color2apply=copper(nbrC);
        case 13
            color2apply=pink(nbrC);
    end
    color2apply=color2apply.*255;        
else
    color2apply=colorInfo;
end

if and(size(pxList,2)==1,length(imgsRGB)>1)
    pxList=repmat(pxList,1,length(imgsRGB));
end

s=size(imgsRGB{1});
for n=1:length(imgsRGB)
    for k=1:size(pxList,1)
        if ~isempty(pxList{k,n})
            L=length(pxList{k,n});
            idx=cat(1,pxList{k,n},pxList{k,n}+s(1)*s(2),pxList{k,n}+2*s(1)*s(2));
            t=min(k,size(color2apply,1));
            col=uint8(reshape(color2apply(t,:).*ones(L,3),L*3,1));
            imgsRGB{n}(idx)=col;
        end
    end
end

end