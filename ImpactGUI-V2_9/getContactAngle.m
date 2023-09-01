function [obsTab]=getContactAngle(obsTab,imgS,imgsE,zone,methodAng,T,offset,smoothVal,weightPower)

if methodAng>1 %methodAng = no method
    dimI=size(imgsE{1});
    imgB=uint8(zeros(zone*2+1));
    for n=1:height(obsTab)
        f=obsTab.Frame(n);
        for s=1:2
            %Get the zone
            imgEZ=imgB;
            imgSZ=false(size(imgEZ));
            if s==1
                x0=obsTab.contLx(n);
                y0=obsTab.contLy(n);
            else
                x0=obsTab.contRx(n);
                y0=obsTab.contRy(n);
            end
            dy=[max([y0-zone,1]),min([y0+zone,dimI(1)])]-y0;
            dx=[max([x0-zone,1]),min([x0+zone,dimI(2)])]-x0;
            imgEZ(zone+1+dy(1):zone+1+dy(2),zone+1+dx(1):zone+1+dx(2))=imgsE{f}(y0+dy(1):y0+dy(2),x0+dx(1):x0+dx(2)); %figure,imshow(imgEZ)
            imgSZ(zone+1+dy(1):zone+1+dy(2),zone+1+dx(1):zone+1+dx(2))=imgS(y0+dy(1):y0+dy(2),x0+dx(1):x0+dx(2)); %figure,imshow(imgSZ)
            if s==1
                imgEZ=fliplr(imgEZ);
                imgSZ=fliplr(imgSZ);
            end
            
            maxLenght=0.2;
            switch methodAng
                case 2 %Poly2-Auto
                    [Cont]=getContour(imgEZ,T,[zone+1,zone+1],offset);
                    [~,alpha]=AngPoly2(Cont{2},maxLenght,smoothVal,weightPower,1);
                case 3 %Poly2
                    [Cont]=getContour(imgEZ,T,[zone+1,zone+1],offset);
                    [~,alpha]=AngPoly2(Cont{2},maxLenght,smoothVal,weightPower,0);
                case 4 %Spline
                    [Cont]=getContour(imgEZ,T,[zone+1,zone+1],offset);
                    [~,alpha]=AngSpline(Cont{2},maxLenght,smoothVal);
                case 5 %Gradien
                    [alpha]=AngGrad(imgSZ,imgEZ);
            end
            CA=alpha+180;
            if s==1
                obsTab.contAngL(n)=CA;
            else
                obsTab.contAngR(n)=CA;
            end
        end
        
    end
    
end
end


function [C0]=getContour(imgGS,greyLimit,xyCL,dyCL)

%Find the right contour
%   %Create countour lines from greyscale img
C=(contourc(double(imgGS),[greyLimit greyLimit]))'; %figure, plot(C(:,1),C(:,2),'.'), axis equal, hold on
%   %Change contour format
i=1;
while i<size(C,1)
    iNew=i+C(i,2)+1;
    C(i,:)=[NaN,NaN];
    i=iNew;
end
%   %Delete small "circular" sections
iNaN=cat(1,find(isnan(C(:,1))==1),size(C,1)+1);
idx2check=find((diff(iNaN)-1)<=10);
for i=length(idx2check):-1:1
    if all(C(iNaN(idx2check(i))+1,:)==C(iNaN(idx2check(i)+1)-1,:))
        C(iNaN(idx2check(i)):iNaN(idx2check(i)+1)-1,:)=[];
    end
end
%   %Find the closest contour from the contact line pixel
C(:,3)=sqrt(sum((C-xyCL).^2,2));
iNaN=cat(1,find(isnan(C(:,1))==1),size(C,1)+1);
i0=find(C(:,3)==min(C(:,3)),1,'first');
idxNaN0=find((iNaN-i0)<0,1,'last');
C0{1}=C(iNaN(idxNaN0)+1:iNaN(idxNaN0+1)-1,:); %figure, plot(C0{1}(:,1),C0{1}(:,2),'.'), axis equal, hold on

%   %Select the part that above the surface
[C0{2}]=selectSection(C0{1},xyCL,dyCL);

%   %Contour starts at the contact line
if find(C0{2}(:,3)==min(C0{2}(:,3)))>(size(C0{2},1)/2)
    C0{2}=flip(C0{2},1);
end

%Clean data
C0{1}=C0{1}(:,1:2);
C0{2}=C0{2}(:,1:2);

end

function [Cfit,alpha]=AngPoly2(C,dLmax,smoothPara,weightPW,autoCont)
%Start data at (0,0)
C=C-C(1,:);
idxEnd=size(C,1);
dL0=sqrt(sum((diff(C,1,1)).^2,2));
L0=cat(1,0,cumsum(dL0));

%Std
F1=fit(L0,C(:,1),'smoothingspline','SmoothingParam',smoothPara);
F2=fit(L0,C(:,2),'smoothingspline','SmoothingParam',smoothPara);
Cfit=cat(2,F1(L0),F2(L0));
[areaSpline]=getArea(C,Cfit);
% figure, plot(C(:,1),C(:,2),'-O'),hold on, plot(Cfit(:,1),Cfit(:,2),'-O'), set(gca,'YDir','reverse'), axis equal
% title('Original and fitted data'), xlabel('x'), ylabel('y'), legend({'Orininal data','Fitted data'})

%Change density
[C,idx0,dL,L]=increaseDataDensity(C,dLmax);
%Poly2
loopSwitch=true;
while loopSwitch
    % Auto mode?
    if autoCont==0
        loopSwitch=false;
    end
    
    %Change variable size
    areaSpline=areaSpline(1:idxEnd-1);
    idx0=idx0(1:idxEnd);
    C=C(1:idx0(idxEnd),:);
    dL=dL(1:idx0(idxEnd)-1);
    L=L(1:idx0(idxEnd));
    
    %Weight
    %   %based on dL
    wDP=cat(1,dL(1),dL)+cat(1,dL,dL(end));
    wDP=wDP/max(wDP);
    %   %based on L
    wF0=1-(L/max(L));
    wF0=wF0/max(wF0);
    wF0=wF0.^weightPW;
    %   %Combine
    w=wDP.*wF0;
    %w=w/max(wF0);
    
    %Fitting
    F1=fit(L,C(:,1),'poly2','Weight',w);
    F2=fit(L,C(:,2),'poly2','Weight',w);
    
    %Area control (Do not use the HD version)
    [~,Cfit]=getProjectedLengthFit(F1,F2,C(idx0,:)); %figure, plot(C((idx0),1),C((idx0),2),'-Ok'),hold on, plot(Cfit(:,1),Cfit(:,2),'-Or'), set(gca,'YDir','reverse'), axis equal
    [delData]=getAreaCheck(C(idx0,:),Cfit,std(areaSpline));
    if and(delData,idxEnd>5)
        idxEnd=idxEnd-1;
    else
        loopSwitch=false;
    end
end
%Contact angle
alpha=atan2d(F2.p2,F1.p2);

end

function  [Cfit,alpha]=AngSpline(C,dLmax,smoothPara)
%Start data at (0,0)
C=C-C(1,:);
dL0=sqrt(sum((diff(C,1,1)).^2,2));
L0=cat(1,0,cumsum(dL0));
[C,idx0,~,L]=increaseDataDensity(C,dLmax);

%Fitting
F1=fit(L,C(:,1),'smoothingspline','SmoothingParam',smoothPara);
F2=fit(L,C(:,2),'smoothingspline','SmoothingParam',smoothPara);
Cfit=cat(2,F1(L0),F2(L0));
% figure, plot(C(idx0,1),C(idx0,2),'-O'),hold on, plot(Cfit(:,1),Cfit(:,2),'-O'), set(gca,'YDir','reverse'), axis equal
% title('Original and fitted data'), xlabel('x'), ylabel('y'), legend({'Orininal data','Fitted data'})

%Contact angle
dL=0.001;
alpha=atan2d((F2(dL)-F2(0))/dL,(F1(dL)-F1(0))/dL);
end


function [alpha]=AngGrad(imgSsub,imgEsub)
%Gradient
[Gx,Gy]=imgradientxy(imgEsub,'sobel'); %figure,imshowpair(Gx,Gy,'montage')
intGrad=sqrt(Gx.^2+Gy.^2); %figure,imshow(uint8(255*intGrad./(max(max(intGrad)))))

%Directional mask
m=size(imgKernel,1);
b=(m+1)/2;
dir_m=-b+[1:m]';
dir_x=ones(m,m).*dir_m';
dir_y=dir_m.*ones(m,m);
dirMask=atan2(dir_y,dir_x);
dirMask(dir_x<0&dir_y==0)=-pi; %figure,imshow(uint8(255*(double(dirMask)+pi)/(2*pi)))

%Weighing mask
weightMask=zeros(m,m);
dirMask(dir_x==0&dir_y==0)=nan;
for row=1:m
    for col=1:m
        weightMask(row,col)=length(find(dirMask==dirMask(row,col)));
    end
end
dirMask(dir_x==0&dir_y==0)=0;
weightMask=(1./weightMask-1/(max(weightMask(:))+1))/(1-1/(max(weightMask(:))+1));
weightMask(dir_x==0&dir_y==0)=0; %figure,imshow(uint8(255*(weightMask-min(min(weightMask)))/(max(max(weightMask))-min(min(weightMask)))))

%Probability distribution of the edge slope
probaDistSlope=conv2(intGrad,rot90(weightMask.*dirMask.*imgSsub,2),'same')./conv2(intGrad,rot90(weightMask.*imgSsub,2),'same')*(180/pi);
alpha=probaDistSlope(b,b);

end


%========================Sub Functions ====================================

function [Ms]=selectSection(M,xy0,dy0)
yLim=xy0(2)+dy0;%+0.5;

%could do better with -1 +1 from diff!!!!
% try
Ms=M;
idxTop=Ms(:,2)<=yLim;
ind0F=find(idxTop==0,1,'first');
if ~isempty(ind0F)
    ind0L=find(idxTop==0,1,'last');
    if sum(diff(idxTop(ind0F+1:ind0L-1))==-1)>0
        idxTop(ind0F:ind0L)=0;
        if Ms(ind0F,3)>Ms(ind0L,3)
            idxTop(1:ind0F)=0;
            if ~(Ms(ind0L+1,2)==yLim)
                Ms(ind0L,1)=interp1([Ms(ind0L,2);Ms(ind0L+1,2)],[Ms(ind0L,1);Ms(ind0L+1,1)],yLim);
                Ms(ind0L,2)=yLim;
                idxTop(ind0L)=1;
            end
        else
            idxTop(ind0L:end)=0;
            if ~(Ms(ind0F-1,2)==yLim)
                Ms(ind0F,1)=interp1([Ms(ind0F,2);Ms(ind0F-1,2)],[Ms(ind0F,1);Ms(ind0F-1,1)],yLim);
                Ms(ind0F,2)=yLim;
                idxTop(ind0F)=1;
            end
        end
    end
end
% catch
%     'test'
% end
Ms=Ms(idxTop,:);
%figure, plot(M(:,1),M(:,2),'-k')
%figure, plot(M(:,1),M(:,2),'.k',Ms(:,1),Ms(:,2),'.r')
end

%Increase density
function [xyHD,idx0,dL,L]=increaseDataDensity(xy,dTL)
%xy: x (1st column) and y (2st column) positions
%dTL: target length between the new points
%xyHD: like xy but with a higher density of points (interpollation)
%w: distance between the new points

%Increase density
lengthSect=sqrt(sum(diff(xy,1,1).^2,2));
ptsNbr=max(floor(lengthSect/dTL)-1,0);
ptsDelta=lengthSect./(ptsNbr+1);
ptAng=atan2(diff(xy(:,2)),diff(xy(:,1)));
maxCol=max(ptsNbr)+1;
distA=repmat(ptsDelta,[1,maxCol]);
[uVal]=unique(ptsNbr);
for u=1:length(uVal)
    idx2mod=(uVal(u)==ptsNbr);
    distA(idx2mod,(uVal(u)+2):end)=NaN;
end
dx=reshape((distA.*cos(ptAng))',[],1);
dy=reshape((distA.*sin(ptAng))',[],1);
dx=dx(~isnan(dx));
dy=dy(~isnan(dy));
xyHD=cat(1,[0,0],cat(2,cumsum(dx),cumsum(dy)))+xy(1,:); %figure, plot(xy(:,1),xy(:,2),'O'),hold on, plot(xyHD(:,1),xyHD(:,2),'.'), axis equal

%Index of previous points
idx0=cumsum(cat(1,0,ptsNbr)+1);

%Distance between new points
dL=sqrt(dx.^2+dy.^2);
L=cat(1,0,cumsum(dL));
end

%Get projected points on fitting curve
function [lengthFit,xyFit]=getProjectedLengthFit(poly2X,poly2Y,xy)
%poly2X: fonction x=fct(L)
%poly2Y: fonction y=fct(L)
%xy: original data(x,y)
%lengthFit: length that gives xyFit
%xyFit: data on the fitted curve that are at the minimum distance from xy

%Initialisation
lengthFit=zeros(size(xy,1),1);
t=zeros(1,4);
minDistRoots=nan(length(lengthFit),3);
%Find length using the minimum distance btw fitting curve and data
%   %Roots
t(1)=4*(poly2X.p1^2+poly2Y.p1^2);
t(2)=3*2*(poly2X.p1*poly2X.p2+poly2Y.p1*poly2Y.p2);
for k=1:length(lengthFit)
    t(3)=2*(poly2X.p2^2+poly2Y.p2^2+2*poly2X.p1*(poly2X.p3-xy(k,1))+2*poly2Y.p1*(poly2Y.p3-xy(k,2)));
    t(4)=2*(poly2X.p2*(poly2X.p3-xy(k,1))+poly2Y.p2*(poly2Y.p3-xy(k,2)));
    r=roots(t);
    for i=length(r):-1:1
        if ~isreal(r(i))
            r(i)=[];
        end
    end
    minDistRoots(k,1:length(r))=r;
end
%   %Select the right root if more than one real by data
idx=(sum(~isnan(minDistRoots),2)==1);
lengthFit(idx)=minDistRoots(idx,1);
if any(~idx)
    idx2check=find(~idx);
    for k=1:length(idx2check)
        if idx2check(k)==1
            Lp=0;
        else
            Lp=lengthFit(idx2check(k)-1);
        end
        [~,v]=min(abs(minDistRoots(idx2check(k),:)-Lp));
        v=v(1);
        lengthFit(idx2check(k))=minDistRoots(idx2check(k),v);
    end
end
xyFit=cat(2,poly2X(lengthFit),poly2Y(lengthFit)); %figure,plot(xy(:,1),xy(:,2),'k',xyFit(:,1),xyFit(:,2),'r')

end

%Area
function [delD]=getAreaCheck(xyD,xyF,stdArea)
%xyD: [x,y] positions of the original data)
%xyF: [x,y] positions of the fitted data
%controlDist: distance used for extracting the std
%delD: 1: the test shows that the gap (=area) between the original data and the fitted data is too big->need to take less points; 0: the fitting is ok

%Get Area
[areaSect]=getArea(xyD,xyF);

%Test if the size of the data is too big
[iupper,~]=cusum(areaSect,5,1,0,stdArea);
delD=false;
if ~isempty(iupper)
    delD=true;
end

% if length(areaSect)<=9
% lengthSect=sqrt(sum(diff(xyF,1,1).^2,2));
% figure,plot(xyD(:,1),xyD(:,2),'-O'), hold on,
% plot(xyF(:,1),xyF(:,2),'-O'),set(gca, 'YDir','reverse'), axis equal,
% title('Original and fitted data'), xlabel('x'), ylabel('y'), legend({'Orininal data','Fitted data'})
% figure,plot(cumsum(lengthSect),areaSect,'-'), hold on, line(xlim(),[0,0],'LineStyle','--','LineWidth',1,'Color',0.5*ones(1,3))
% title('Area between original and fitted data for each section'), xlabel('Cumulative length of fitted sections [px]'), ylabel('Area [px^2]')
% figure,plot(cumsum(lengthSect),cumsum(areaSect),'-'), hold on, line(xlim(),[0,0],'LineStyle','--','LineWidth',1,'Color',0.5*ones(1,3))
% title('Cumulative area between original and fitted data'), xlabel('Cumulative length of fitted sections [px]'), ylabel('Cumulative area [px^2]')
% 'test'
% end


end

function [areaSect]=getArea(xyD,xyF)
%xyD: [x,y] positions of the original data)
%xyF: [x,y] positions of the fitted data

%Intersection
%(https://web.archive.org/web/20091003070719/http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/)
idxPos=cat(1,1:size(xyD,1)-1,2:size(xyD,1))';
term=cell(3,2);
term{1,1}=diff(xyD(:,1),1,1); %x2-x1
term{1,2}=diff(xyD(:,2),1,1); %y2-y1
term{2,1}=diff(xyF(:,1),1,1); %x4-x3
term{2,2}=diff(xyF(:,2),1,1); %y4-y3
term{3,1}=xyD(idxPos(:,1),1)-xyF(idxPos(:,1),1); %x1-x3
term{3,2}=xyD(idxPos(:,1),2)-xyF(idxPos(:,1),2); %y1-y3
den=term{2,2}.*term{1,1}-term{2,1}.*term{1,2};
ua=(term{2,1}.*term{3,2}-term{2,2}.*term{3,1})./den;
ub=(term{1,1}.*term{3,2}-term{1,2}.*term{3,1})./den;
crossSegment=all(([ua ub]>=0)&([ua ub]<1),2); %figure,plot(xyD(:,1),xyD(:,2),'-'), hold on, plot(xyF(:,1),xyD(:,2),'-')

%Sign area
signVal=(-1).^cumsum(crossSegment);
signVal=repmat(signVal,[1,2]);
signVal(crossSegment)=signVal(crossSegment)*(-1);

%Area
xA=cat(2,xyD(idxPos(:,1),1),xyD(idxPos(:,2),1),xyF(idxPos(:,2),1),xyF(idxPos(:,1),1));
yA=cat(2,xyD(idxPos(:,1),2),xyD(idxPos(:,2),2),xyF(idxPos(:,2),2),xyF(idxPos(:,1),2));
areaSect=polyarea(xA,yA,2); %data in clock- or anticlock- wise
areaSect=areaSect.*signVal(:,1);

%Correction area for intersections: 2 triangles instead of 1 qualidrateral shape
idxIN=find(crossSegment==1);
for i=1:length(idxIN)
    xi=xyD(idxIN(i),1)+ua(idxIN(i))*term{1,1}(idxIN(i));
    yi=xyD(idxIN(i),2)+ua(idxIN(i))*term{1,2}(idxIN(i));
    A=zeros(1,2);
    xA1=cat(2,xyD(idxIN(i),1),xyF(idxIN(i),1),xi);
    yA1=cat(2,xyD(idxIN(i),2),xyF(idxIN(i),2),yi);
    A(1)=polyarea(xA1,yA1,2);
    xA2=cat(2,xyD(idxIN(i)+1,1),xyF(idxIN(i)+1,1),xi);
    yA2=cat(2,xyD(idxIN(i)+1,2),xyF(idxIN(i)+1,2),yi);
    A(2)=polyarea(xA2,yA2,2);
    A=A.*signVal(idxIN(i),:);
    areaSect(idxIN(i))=sum(A);
end

end
