function [r,rNew,d,modTab,frame2use]=getTracking(r0,r,rNew,d,modTab,imgS,trackStep,frame2use)

% r0: initial object properties
% r:  initial object properties + ID
% rNew: modified object properties
% d: drop ref to rNew
% modTab: modification of tracking by the user
% imgS: image surface
% trackStep: 1:main drop ; 2:additinal sub drops
% frame2use: 'all':start tracking from 0, 

% clearvars -except keepVariables r0 r rNew d modTab imgS imgL maxStep fuse

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parametres
distLim=100;

%--------------------------------------------------------------------------
%Effect of the user modifications

%   %Identification of modifications
frame2mod=1;
modArray0=table2array(modTab); %{'Frame','Obj','Frame0','Obj0','Action'}
modIdxID1=[];
if height(modTab)>0 %
    modRow=size(modArray0,1); % Last row that have an effect
    if modArray0(end,5)==4 %if delete action, go to the previous modification
        modRow=modRow-1;
    end
    switch modArray0(modRow,5)
        case 0 %Last frame
            frame2mod=modArray0(modRow,1);
        case 1 %New drop: Add a specific object as a new drop
            frame2mod=modArray0(modRow,1);
        case 2 % Fuse drop
            frame2mod=modArray0(modRow,1);
        case 3 %Associate drops
            frame2mod=modArray0(modRow,3);
    end
    if modRow<size(modArray0,1) %Delete modifications
        modTab(end,:)=[]; %Delete the line that resquests to delete the last active modification
        modTab(end,:)=[]; %Delete the last active modification
        modArray0=table2array(modTab);
    end
    if height(modTab)>0
        modIdxID1=false(size(modArray0,1),1); %Detect modifications that implies the main drops
        for w=1:length(modIdxID1)
            modIdxID1(w)=checkID1(r,modArray0,w);
        end
    end
end

%   %Prepare the future modifications
ghostTab0=array2table(cell(height(modTab),4),'VariableNames',{'dropID','centroid','velocity','angle'});
frames=[1:length(r)];
modFrame0=zeros(height(modTab),length(r));
for w=1:height(modTab)
    if modArray0(w,5)==3
        modFrame0(w,:)=and(frames>modArray0(w,3),frames<modArray0(w,1)).*10;
        if ~isempty(find(modFrame0(w,:)==10,1))
            ghostTab0.dropID{w,1}=r{modArray0(w,3)}(modArray0(w,4)).dropID;
            [ghostTab0.centroid{w,1},ghostTab0.velocity{w,1},ghostTab0.angle{w,1}]=ghostCentroid(modArray0(w,:),(modFrame0(w,:)==10),r);
        end
    end
    modFrame0(w,modArray0(w,1))=1;
end

   
%   %Clean d
switch frame2use
    case 'all'
        frame2mod=1;
    case 'modification'
        frame2use='all'; %Reset for the next tracking
end

if ~isempty(find(trackStep==1,1))
    d(1,frame2mod:end)=NaN;
    if size(d,1)>1
        d(2:end,1:end)=NaN;
    end  
end
if ~isempty(find(trackStep==2,1))
    if size(d,1)>1
        d(2:end,frame2mod:end)=NaN;
    end
end
d(sum(or(isnan(d),d==0),2)==size(d,2),:)=[];


%--------------------------------------------------------------------------
% Paring
for activeStep=trackStep
    
    if activeStep==1 % Main drop
        % Initialisation if empty tracking
        if isempty(d)
            frame2mod=1;
            for n=1:length(r0)
                r{n}=r0{n};
                rNew{n}=r{n};
                d(1,n)=0;
                if ~isempty(r0{n})
                    row=length(r0{n});
                    r{n}(row).dropID=1;
                    rNew{n}=r{n};
                    d(1,n)=row;
                    frame2mod=n+1;
                    break
                end
                
            end
        end 
        [modArray,modFrame,ghostTab]=selectModif(activeStep,modIdxID1,modArray0,modFrame0,ghostTab0);   
        for n=frame2mod:length(r0)
            r{n}=r0{n};
            d(1,n)=NaN;
            [r,rNew,d]=pairing(r0,r,rNew,d,n,activeStep,distLim,imgS,modArray,modFrame,ghostTab);
        end
    else %Secondary drops
        [modArray,modFrame,ghostTab]=selectModif(activeStep,modIdxID1,modArray0,modFrame0,ghostTab0);
        for n=frame2mod:length(r0)
            if size(d(1,n),1)>1
                d(1:end,n)=NaN;
            end
            if length(r{n})>0
                idx2clean=find(~(cat(1,r{n}(:).dropID)==1)==1);
                for k=1:length(idx2clean)
                    r{n}(idx2clean(k))=r0{n}(idx2clean(k));
                end
                [r,rNew,d]=pairing(r0,r,rNew,d,n,activeStep,distLim,imgS,modArray,modFrame,ghostTab);
            end
        end
        
    end
end


end 


%=========================== Sub fonctions ================================

% Check modification on drop ID=1
function [B]=checkID1(r,A,idx)
cond=zeros(1,2);
for t=1:length(cond)
    if ~or(isnan(A(idx,1+2*(t-1))),isnan(A(idx,2+2*(t-1))))
        cond(t)=(r{A(idx,1+2*(t-1))}(A(idx,2+2*(t-1))).dropID==1);
    end
end
B=or(cond(1),cond(2));
end

%--------------------------------------------------------------------------
% Create a ghost drop
function [cent,vel,ang]=ghostCentroid(mod,modF,r)
frames=[1:length(r)]';
A=r{mod(3)}(mod(4));
B=r{mod(1)}(mod(2));

coefM=NaN(length(r),1);
coefM(modF)=(frames(modF)-mod(3))/(mod(1)-mod(3));

cent=NaN(length(r),2);
for j=1:2
    cent(:,j)=A.Centroid(j)+(B.Centroid(j)-A.Centroid(j))*coefM;
end

vel=sqrt(sum((A.Centroid-B.Centroid).^2,2))/(mod(3)-mod(1));
ang=atan2d(-(B.Centroid(2)-A.Centroid(2)),(B.Centroid(1)-A.Centroid(1)));

end

%--------------------------------------------------------------------------
function [modArray,modFrame,ghostTab]=selectModif(activeStep,modIdxID1,modArray0,modFrame0,ghostTab0)
if ~isempty(modIdxID1)
    if activeStep==1
       idx2keep=modIdxID1;
    else
        idx2keep=~modIdxID1;
    end
    modArray=modArray0(idx2keep,:);
    modFrame=modFrame0(idx2keep,:);
    ghostTab=ghostTab0(idx2keep,:); 
else
    modArray=modArray0;
    modFrame=modFrame0;
    ghostTab=ghostTab0;
end
end

%--------------------------------------------------------------------------
% Pairing between the frames n and n-1
function [r,rNew,d]=pairing(r0,r,rNew,d,n,activeStep,distLim,imgS,modArray,modFrame,ghostTab)

%	% Select the objects in frames n-1 and n
k{1}=1:length(r0{n-1});
k{2}=1:length(r0{n});
if (activeStep==1)
    if ~isempty(k{1})
        idx2keep=(cat(1,r{n-1}(:).dropID)==1);
        k{1}=k{1}(idx2keep); %Keep only ID 1 in n-1
    end
else
    for u=1:2
        if ~isempty(k{u})
            switch u
                case 1
                    idx2keep=~(cat(1,r{n-1}(:).dropID)==1);
                case 2
                    idx2keep=~(cat(1,r{n}(:).dropID)==1);
            end
            k{u}=k{u}(idx2keep); %Remove ID 1 at frame n-1 and n
        end
    end
end

%   % User mofications
if ~isempty(modFrame)
    idx2apply=find(modFrame(:,n)==1);
    if ~isempty(idx2apply)
        for w=idx2apply
            if modArray(w,5)==0
                k{1}(k{1}==modArray(w,4))=[];
            else
                k{2}(k{2}==modArray(w,2))=[];
                if and(modArray(w,5)==3,modFrame(w,n-1)==0) 
                    k{1}(k{1}==modArray(w,4))=[];
                end
            end
        end
    end
end

%   % Pairing
linkDist=inf(length(k{2}),1);
if ~or(isempty(k{1}),isempty(k{2}))
    pairingInfo=NaN(length(k{1}),length(k{2}),2); %1:distance,2:modified distance
    
    ArrayOnes=ones(length(k{1}),length(k{2}));
    c1=cat(1,r0{n-1}(k{1}).Centroid);
    c2=cat(1,r0{n}(k{2}).Centroid);
    v1=cat(1,r{n-1}(k{1}).deltaPos);
    a1=cat(1,r{n-1}(k{1}).Ang);
    
    c1Mod=c1;
    for p=1:size(c1Mod,1)
        if ~isnan(v1(p))
            c1Mod(p,:)=c1(p,:)+v1(p)*[cosd(a1(p)),-sind(a1(p))];       
        end
    end
    
    X1=c1(:,1).*ArrayOnes;
    Y1=c1(:,2).*ArrayOnes;
    X1Mod=c1Mod(:,1).*ArrayOnes;
    Y1Mod=c1Mod(:,2).*ArrayOnes;
    X2=c2(:,1)'.*ArrayOnes;
    Y2=c2(:,2)'.*ArrayOnes;  
    
    pairingInfo(:,:,1)=sqrt((X2-X1).^2+(Y2-Y1).^2);
    pairingInfo(:,:,2)=sqrt((X2-X1Mod).^2+(Y2-Y1Mod).^2);
      
    pairingBase=pairingInfo(:,:,2);
    pairingBase((pairingInfo(:,:,1)>distLim))=NaN;
    
    for w=1:length(1:size(pairingBase,1))
        [lowestVal,row2link]=sort(min(pairingBase,[],2),'ascend');
        if ~isnan(lowestVal(1))
            col2link=find(lowestVal(1)==pairingBase(row2link(1),:),1);
            r{n}(k{2}(col2link)).dropID=r{n-1}(k{1}(row2link(1))).dropID;
            linkDist(col2link)=lowestVal(1);
            pairingBase(:,col2link)=NaN;
            pairingBase(row2link(1),:)=NaN;
        else
            break
        end
    end  
end


%   % Complete r
drops2fuse=zeros(0,2);
if ~isempty(modFrame)
    idx2apply=find(modFrame(:,n)==1);
    if ~isempty(idx2apply)
        for w=idx2apply
            switch modArray(w,5)
                case 2
                    drops2fuse=cat(1,drops2fuse,[modArray(w,2),modArray(w,4)]);
                case 3
                    r{n}(modArray(w,2)).dropID=r{modArray(w,3)}(modArray(w,4)).dropID;                        
            end       
        end
    end
end
if activeStep==1
    for w=1:length(r{n})
        if sum(~isempty(drops2fuse))>0 
            p=find(w==drops2fuse(:,1),1);
            if ~isempty(p)
                r{n}(drops2fuse(p,1)).dropID=r{n}(drops2fuse(p,2)).dropID;
            end
        end
    end
else
    ID2add=size(d,1);
    for w=1:length(r{n})
        if sum(~isempty(drops2fuse))>0 
            p=find(w==drops2fuse(:,1),1);
            if ~isempty(p)
                if isnan(r{n}(drops2fuse(p,2)).dropID)
                    ID2add=ID2add+1;
                    r{n}(drops2fuse(p,2)).dropID=ID2add;
                end
                r{n}(drops2fuse(p,1)).dropID=r{n}(drops2fuse(p,2)).dropID;
            end
        end
        if isnan(r{n}(w).dropID)            
            ID2add=ID2add+1;
            r{n}(w).dropID=ID2add;
        end
    end
end


%   %Fuse r
[r,rNew,d]=fusion(n,imgS,r,rNew,d);

%   %Velocity
[r,rNew]=getObjsVel(n,r,rNew);

%   %Insert ghost drops in rNew
if ~isempty(modFrame)
    idx2apply=find(modFrame(:,n)==10);
    if ~isempty(idx2apply)
        for w=idx2apply
            p=length(rNew{n})+1;
            rNew{n}(p).dropID=ghostTab.dropID{w};
            rNew{n}(p).Centroid=ghostTab.centroid{w}(n,:);
            rNew{n}(p).deltaPos=ghostTab.velocity{w};
            rNew{n}(p).Ang=ghostTab.angle{w};
            rNew{n}(p).SurfContact=0;                 
            %'Area','BoundingBox','Centroid','Eccentricity','EquivDiameter','MajorAxisLength','MinorAxisLength','Orientation','Perimeter','PixelIdxList','PixelList'
        end
        [~,idx2sort]=sort(cat(1,rNew{n}.dropID));
        rNew{n}=rNew{n}(idx2sort);
    end
end

%   %Complete d
for w=1:length(rNew{n})
    if ~isnan(rNew{n}(w).dropID)
        d(rNew{n}(w).dropID,n)=w;
    end
end
for w=1:size(d,1)
    if d(w,n)==0
        d(w,n)=NaN;
    end
end


end


%--------------------------------------------------------------------------
% Fusion of drops with the same ID: r
function [r,rNew,d]=fusion(n,imgS,r,rNew,d)

rNew{n}=r{n};

if ~isempty(r{n})
    fields=fieldnames(r{n}(1));
    imgBlack=imgS.*0;
    k=cat(1,r{n}(:).dropID);
    [~,ik,iU]=unique(k);
    for w=1:max(iU)
        if ~isnan(iU(w))
            idx2fuse=find(iU==iU(w));
            if length(idx2fuse)>1
                img2fuse=imgBlack;
                for p=1:length(idx2fuse)
                    img2fuse(r{n}(idx2fuse(p)).PixelIdxList)=true; %work with image label instead?
                end
                nbrFields=11;
                newProps=regionprops('table',img2fuse,fields{1:nbrFields});
                for fld=1:nbrFields
                    if or(fld==9,fld==10)
                        rNew{n}(idx2fuse(1)).(fields{fld})=newProps.(fields{fld}){:,:};
                    else
                        rNew{n}(idx2fuse(1)).(fields{fld})=newProps.(fields{fld});
                    end
                end
                rNew{n}(idx2fuse(1)).SurfContact=(sum(cat(1,rNew{n}(idx2fuse).SurfContact))>0);
            end
        end
    end
    
    %Delete the extra information and put the drops in the right order
    rNew{n}=rNew{n}(ik);
end
end

%--------------------------------------------------------------------------
%Calculate velocity and angle
function [r,rNew]=getObjsVel(n,r,rNew)

if and(~isempty(rNew{n-1}),~isempty(rNew{n}))
    [IDs,idx1,idx2]=intersect(cat(1,rNew{n-1}.dropID),cat(1,rNew{n}.dropID));  
    if ~isempty(IDs)
        for w=1:length(IDs)
            c1=rNew{n-1}(idx1(w)).Centroid;
            c2=rNew{n}(idx2(w)).Centroid;
            
            rNew{n}(idx2(w)).deltaPos=sqrt(sum((c1-c2).^2,2));
            rNew{n}(idx2(w)).Ang=atan2d(-(c2(2)-c1(2)),(c2(1)-c1(1)));
            
            p=find(cat(1,r{n}.dropID)==IDs(w));
            for q=1:length(p)               
                r{n}(p(q)).deltaPos=rNew{n}(idx2(w)).deltaPos;
                r{n}(p(q)).Ang=rNew{n}(idx2(w)).Ang;
            end
                
        end
    end  
end

end
