function [obsTab,pxList,ellAxis]=getMainDropUnderObs(obsTab,imgsEu,imgsBu,aShp,alpha)

pxList=cell(1,length(imgsBu));
ellAxis=cell(1,length(imgsBu));
ellAxis(:)={nan(1,2)};

%Drop centre
imgsBu0=imgsBu{obsTab.Frame(1)};
imgB0 = imfill(imgsBu0,'holes');
r=regionprops(imgB0,'Centroid','Area','PixelList');
idxM=find(cat(1,r.Area)==max(cat(1,r.Area)),1);
posC0=r(idxM).Centroid; %[X,Y]

%Initialisation
s=size(imgsBu{1});
[qx,qy] = meshgrid(1:s(2),1:s(1));
imgF=cell(height(obsTab),1);
imgBlack=false(s+2);

%Underneath drop information
%   %Area
posC=posC0;
for n=1:height(obsTab)
    f=obsTab.Frame(n);
    imgB = imfill(imgsBu{f},'holes'); %figure, imshow(imfuse(imgB,imgsBu{f}))
    r=regionprops(imgB,'Centroid','Area','PixelList','PixelIdxList');
    if aShp==1
        XY=[];
        for k=1:length(r)
            XY=cat(1,XY,r(k).PixelList);
        end
        if alpha==0
            shp=alphaShape(XY(:,1),XY(:,2));
        else
            shp=alphaShape(XY(:,1),XY(:,2),alpha);
        end
        
        
        obsTab.underPeri(n) = perimeter(shp);
        obsTab.underArea(n) = area(shp);
        obsTab.underCircul(n) = 4*obsTab.underArea(n)*pi/(obsTab.underPeri(n)^2);
        
        tf=inShape(shp,qx,qy); %figure,imshow(tf)
        imgB=imfill(tf,'holes'); %figure,imshow(imgB)
    end
    r=regionprops(imgB,'Centroid','Area','PixelIdxList','Eccentricity','Orientation','MajorAxisLength','MinorAxisLength');
    [~,k0]=min(sum((cat(1,r.Centroid)-posC).^2,2));
    for k=1:length(r)
        if k~=k0
            for p=1:length(r(k).PixelIdxList)
                imgB(r(k).PixelIdxList(p))=0;
            end
        end
    end
    posC=r(k0).Centroid;
    %obsTab.underArea(n)=r(k0).Area;
    obsTab.underEcc(n)=r(k0).Eccentricity;
    obsTab.underOrient(n)=r(k0).Orientation;
    obsTab.underRmajor(n)=r(k0).MajorAxisLength;
    obsTab.underRminor(n)=r(k0).MinorAxisLength;
    
    imgF{n}=imgB;
    
    axisMajorPt1=round(r(k0).Centroid-(r(k0).MajorAxisLength/2)*[cosd(r(k0).Orientation), -sind(r(k0).Orientation)]);
    axisMajorPt2=round(r(k0).Centroid+(r(k0).MajorAxisLength/2)*[cosd(r(k0).Orientation), -sind(r(k0).Orientation)]);
    axisMinorPt1=round(r(k0).Centroid-(r(k0).MinorAxisLength/2)*[-sind(r(k0).Orientation), -cosd(r(k0).Orientation)]);
    axisMinorPt2=round(r(k0).Centroid+(r(k0).MinorAxisLength/2)*[-sind(r(k0).Orientation), -cosd(r(k0).Orientation)]);
    ellAxis{f}=cat(1,axisMajorPt1,axisMajorPt2,nan(1,2),axisMinorPt1,axisMinorPt2,nan(1,2));
    
end
%   %Maximum and minimum rad
for n=1:height(obsTab)
    imgMask=imgBlack;
    for i= 0:2
        for j=0:2
            imgMask((1:s(1))+i,(1:s(2))+j)=or(imgMask((1:s(1))+i,(1:s(2))+j),~imgF{n});
        end
    end
    imgEdge=and(imgMask(2:s(1)+1,2:s(2)+1),imgF{n}); %figure,imshow(imfuse(imgB,imgEdge)) %figure,imshow(imgEdge)
    r=regionprops(imgEdge,'PixelList','PixelIdxList');
    if length(r)>1
        for k=length(r):-1:2
            r(1).PixelList=cat(1,r(1).PixelList,r(k).PixelList);
            r(1).PixelIdxList=cat(1,r(1).PixelIdxList,r(k).PixelIdxList);
            r(k)=[];
        end
    end
    radii=sqrt(sum((r.PixelList-posC0).^2,2))+0.5; %0.5:pixel thicknes
    obsTab.underRmax(n)=max(radii);
    obsTab.underRmin(n)=min(radii);
    f=obsTab.Frame(n);
    pxList{f}=r.PixelIdxList;
end

% figure,plot(obsTab.Frame,obsTab.underArea)
% figure,plot(obsTab.Frame,obsTab.underRmax*2)
% figure,plot(obsTab.Frame,obsTab.underRmin*2)
% figure,plot(obsTab.Frame,obsTab.wet)
% figure,plot(obsTab.Frame,obsTab.edge), hold on


%---------------------



% for n=1:20%1:height(obsTab)
%     f=obsTab.Frame(n);
%     imgF2=uint8(double(imgF{n}).*double(imcomplement(imgsEu{f}))); %figure,imshow(imgF2)
%     Y=fft2(double(imgF2));
%     fg=figure('Units','Pixels'); 
%     sp(1)=subplot(1,2,1);
%     imshow(imgF2)
%     sp(2)=subplot(1,2,2);
%     imagesc(abs(fftshift(Y)))
%     axis equal
%     xlim([1,size(imgF2,2)])
%     ylim([1,size(imgF2,1)])
%     set(sp(2),'visible','off')
%     
%     sp(1).Units = fg.Units; 
%     sp(2).Units = fg.Units; 
%     sp(1).Position(1) = -(sp(1).Position(3)-sp(1).Position(4))/2 + 1;
%     sp(2).Position(1) = sum(sp(1).Position([1,3])) + sp(1).Position(1) + 5;
%     
%     fg.Position(1) = sp(1).Position(1);
%     fg.Position(3) = sum(sp(2).Position([1,3]));
%     fg.Position(2) = sp(1).Position(2);
%     fg.Position(4) = sum(sp(1).Position([2,4]));
%     
%     fg.Position(3) = sum(sp(2).Position([1,3]))+sp(2).Position(3); 
% 
%     fr(n)=getframe(fg);
%     drawnow
%     %close(fg)
% end


% for n=1:30%1:height(obsTab)
%     f=obsTab.Frame(n);
%     imgF2=uint8(double(imgF{n}).*double(imcomplement(imgsEu{f}))); %figure,imshow(imgF2)
%     Y=fft2(double(imgF2));
%     fh=figure('Units','Normalized');
%     fh.WindowState = 'maximized';
%     sfh(1)=subplot(1,2,1);
%     imshow(imgF2)
%     sfh(2)=subplot(1,2,2);
%     imagesc(abs(fftshift(Y)))
%     axis equal
%     xlim([1,size(imgF2,2)])
%     ylim([1,size(imgF2,1)])
%     set(sfh(2),'visible','off')
%     
%     sfh(1).Units = fh.Units; 
%     sfh(2).Units = fh.Units; 
%     sfh(1).Position(1) = 0;
%     sfh(2).Position(1) = sum(sfh(1).Position([1,3]));
%     sfh(1).Position(2) = 0;
%     sfh(2).Position(2) = 0;
%     
%     fh.Units='Pixels';
%     sfh(1).Units = fh.Units; 
%     sfh(2).Units = fh.Units; 
%     fh.Position(3) = sum(sfh(2).Position([1,3]));
%     fh.Position(4) = sfh(1).Position(4)*0.75;
%     
%     fr(n)=getframe(fh);
%     %drawnow
%     close(fh)
% end





% v = VideoWriter('testFFT2.avi','Uncompressed AVI');
% v.FrameRate = 2;
% open(v)
% for n=1:length(fr)
%     writeVideo(v,fr(n))
% end
% close(v)


end