function [obsTab,FrameDmax]=getMainDropObs(d,rNew,imgS,iniF)
%function [obsTab,FrameDmax]=getMainDropObs(d,rNew,imgS,imgsE,T,methodAng,zone,constraint,filter)


% When the main drop is on contact with the surface
finF=length(rNew);
for n=iniF:length(rNew)-1
    if rNew{n}(d(n)).SurfContact
        if isnan(d(1,n+1))
            finF=n;
            break
        elseif rNew{n+1}(d(1,n+1)).SurfContact==0
            finF=n;
            break
        end
    end
end
F=iniF:finF;


%Additinal information for the main drop
refCx=rNew{iniF-1}(d(iniF-1)).Centroid(1); % Position reference

varNames={'Frame','height','edge','edgeL','edgeR','wet','wetL','wetR','contLx','contRx','contLy','contRy','contAngL','contAngR','contVelL','contVelR','underPeri','underArea','underCircul','underEcc','underOrient','underRmajor','underRminor','underRmax','underRmin'};
obsTab=array2table(zeros(length(F),length(varNames)),'VariableNames',varNames);

s=size(imgS);
imgMask=~cat(1,imgS(2:end,:),false(1,s(2)));
imgBlack=false(s(1),s(2));

for n=1:length(F)
    %Frame
    obsTab.Frame(n)=F(n);
    
    %Height
    obsTab.height(n)=rNew{F(n)}(d(F(n))).BoundingBox(4);
    
    %Edge
    obsTab.edge(n)=rNew{F(n)}(d(F(n))).BoundingBox(3);
    obsTab.edgeL(n)=refCx-rNew{F(n)}(d(F(n))).BoundingBox(1)+0.5;
    obsTab.edgeR(n)=rNew{F(n)}(d(F(n))).BoundingBox(1)+0.5+rNew{F(n)}(d(F(n))).BoundingBox(3)-refCx;
    
    %Wet radius
    imgContact=imgBlack;
    imgContact(rNew{F(n)}(d(F(n))).PixelIdxList)=true(length(rNew{F(n)}(d(F(n))).PixelIdxList),1);
    imgContact=imgContact.*imgMask; %figure,imshow(imgContact)
    [row,col]=find(imgContact==1);
    obsTab.wet(n)=max(col)-min(col);
    obsTab.wetL(n)=refCx-min(col);
    obsTab.wetR(n)=max(col)-refCx;
    
    %Extreme points of contact
    obsTab.contLx(n)=min(col);
    obsTab.contRx(n)=max(col);
    obsTab.contLy(n)=row(find(col==obsTab.contLx(n),1));
    obsTab.contRy(n)=row(find(col==obsTab.contRx(n),1));
    
end
obsTab.contAngL=nan(length(F),1);
obsTab.contAngR=nan(length(F),1);
obsTab.contVelL(1)=NaN;
obsTab.contVelL(2:end)=diff(obsTab.wetL);
obsTab.contVelR(1)=NaN;
obsTab.contVelR(2:end)=diff(obsTab.wetR);




%Beta max
FrameDmax=zeros(2,1);
FrameDmax(1)=obsTab.Frame(find(obsTab.wet==max(obsTab.wet),1,'last'));
FrameDmax(2)=obsTab.Frame(find(obsTab.edge==max(obsTab.edge),1,'last'));


end

