function [] = LA4()

%SETUP 

%(1) load spectra.mat
load('spectra.mat','C1', 'C2');


%(2) separate into training and testing data
trainingC1 = C1(:,1:8000);
trainingC2 = C2(:,1:8000);
testingC1 = C1(:,8001:10000);
testingC2 = C2(:,8001:10000);

disp('TRAINING DATA');
classifier(trainingC1,trainingC2);
pause;

disp('TESTING DATA');
classifier(testingC1,testingC2);

        














