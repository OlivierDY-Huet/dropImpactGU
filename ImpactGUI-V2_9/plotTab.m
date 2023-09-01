function []=plotTab(T,yName)

varNames=T.Properties.VariableNames;
A=table2array(T);
s=size(A);

figure,
for j=2:s(2)
   plot(A(:,1),A(:,j)),hold on
   
end
ylabel(yName)
xlabel(varNames{1})
legend(varNames(2:end),'Location','southeast')