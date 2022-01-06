%%
project1a
n=input('Enter the classifier number (1-3) whose result you would like to view');
if n==1
    class=trainClassifiert1(epoch); %training the classifier based on the training dataset
elseif n==2
    class=trainClassifiert2(epoch); %training the classifier based on the training dataset
elseif n==3
    class=trainClassifiert3(epoch); %training the classifier based on the training dataset
else
    disp('Wrong input please run again')
    return
end
yfit=class.predictFcn(tepoch([43,58,74,75,92,110],:));  %getting predictions from classifier t1,t2 and t3
%%
%Analyzing the testing data and comparing it with the classifier
ctn=0; %true negative count
ctp=0; %true positive count
cfp=0; %false positive count
cfn=0; %false negative count
for i=1:length(yfit)
    if (yfit(i)==0) & (solution(i)==0) %checking for true negatives
        ctn=ctn+1;
    elseif (yfit(i)==1) & (solution(i)==1) %checking for true positives
        ctp=ctp+1;
    elseif (yfit(i)==0) & (solution(i)==1) %checking for false negatives
        cfn=cfn+1;
    elseif (yfit(i)==1) & (solution(i)==0) %checking for false postives
        cfp=cfp+1;
    end
end
cacc=(ctp+ctn)/(ctp+ctn+cfp+cfn); %calculating accuracy
cspec=ctn/(ctn+cfp); %calculating specificity
csen=ctp/(ctp+cfn); %calculating sensitivity
str=['The details of classifier are:'];
disp(str)
str=['Acuuracy: ',num2str(cacc*100),'%'];
disp(str)
str=['Sensitivity: ',num2str(csen*100),'%'];
disp(str)
str=['Specificity: ',num2str(cspec*100),'%'];
disp(str)