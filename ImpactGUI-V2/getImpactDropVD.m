function [impF,Vel,Dia,tabVel,tabDia]=getImpactDropVD(d,r)


% Find frames before impact
iniF=find(d>0,1); %1st frame when drop appears
for n=1:length(r)
    if d(n)~=0
        if r{n}(d(n)).SurfContact
            impF=n; %Last frame just before impact
            break
        end
    end
end
finF=impF-1;
F=iniF:finF;


% Gather position data
varNames={'Frame','Cx','Left','Right','Cy','Top','Bottom','Ecc','EqDia'};
tabInfo=array2table(zeros(length(F),9),'VariableNames',varNames);
for n=1:length(F)
    tabInfo.Frame(n)=F(n);
    tabInfo.Cx(n)=r{F(n)}(d(F(n))).Centroid(1);
    tabInfo.Left(n)=r{F(n)}(d(F(n))).BoundingBox(1)+0.5;
    tabInfo.Right(n)=tabInfo.Left(n)+r{F(n)}(d(F(n))).BoundingBox(3);
    tabInfo.Cy(n)=r{F(n)}(d(F(n))).Centroid(2);
    tabInfo.Top(n)=r{F(n)}(d(F(n))).BoundingBox(2)+0.5;
    tabInfo.Bottom(n)=tabInfo.Top(n)+r{F(n)}(d(F(n))).BoundingBox(4);
    tabInfo.Ecc(n)=r{F(n)}(d(F(n))).Eccentricity;
    tabInfo.EqDia(n)=r{F(n)}(d(F(n))).EquivDiameter;
end

% Velocity 
A=table2array(tabInfo);
tabVel=array2table(cat(2,A([2:end],1),A([2:end],[2:7])-A([1:end-1],[2:7])),'VariableNames',varNames([1,2:7]));

% Diameter 
A2=cat(2,A(:,1),A(:,4)-A(:,3)+1,A(:,7)-A(:,6)+1);
tabDia=array2table(cat(2,A2(:,:),A(:,9),nthroot((A2(:,2).^2).*A2(:,3),3),A(:,8)),'VariableNames',[varNames(1),'Dx','Dy',varNames(9),'CalcDia',varNames(8)]);

% Impact velocity and initial diaameter
idxFullDia=(tabInfo.Top>1);
idxFullVel=idxFullDia(2:end);
idxFullVel(find(idxFullVel==1,1,'first'))=false;

if sum(idxFullVel>0)
    idxVel=and(idxFullVel,[height(tabVel):-1:1]'<=3);
    Vel=[mean(tabVel.Cx(idxVel)),mean(tabVel.Cy(idxVel))];
else
    idxVel=([height(tabVel):-1:1]'<=3);
    Vel=[mean(tabVel.Cx(idxVel)),mean(tabVel.Bottom(idxVel))];
end

if sum(idxFullDia>0)
    idxDia=(tabDia.Ecc==min(tabDia.Ecc));
    Dia=mean(tabDia.CalcDia(idxDia));
else
    idxDia=([height(tabVel):-1:1]'<=3);
    Dia=mean(tabDia.Dx(idxDia));
end


end
