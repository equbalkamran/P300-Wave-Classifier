clc
clear all
close all
z=load('ProjectData_2020.mat');%reading the file
%%
%extracting all the data from the structure
train_sig=z.signal_training; %training data
test_sig=z.signal_testing; %testing data
stimulussignal_training=z.StimulusSignal_training; %epoch vector for training 
flashingsignal_testing=z.FlashingSignal_testing; %epoch vector for testing
solution=z.solution; %solution to the testing dataset
solution=solution-1; %Now zero represents non stimulus epoch and one represents stimulus epoch
fs=240; %sampling frequency
ttrain=(0:1:length(train_sig)-1)/fs; %time vector for training 
ttest=(0:1:length(test_sig)-1)/fs; %time vector for testing
traindata1=train_sig(:,11); %Importing data from Cz electrode
%%
%working on training dataset
figure(1)
subplot(2,1,1)
plot(ttrain,traindata1) %plotting raw signal
xlim([0 0.65*5]) %limiting to positive side of spectrum for length of 5 epochs
xlabel('Time in seconds'); 
ylabel('Amplitude in au'); 
title('Raw EEG training data of Cz Electrode'); 
N = 1000; %the number of samples
X = fftshift(abs(fft(traindata1,N))); %frequency spectrum
F = (-N/2:N/2-1)/N; %X axis for frequency spectrum
subplot(2,1,2)
plot(F,X); %plot frequency spectrum
xlabel('Normalized Frequency'); 
xlim([0 0.5]) %Focusing on the positive side of spectrum
ylabel('Amplitude in au'); 
title('Frequency Spectrum'); 
traindata2=filter(projectbandpass,traindata1); %Filtering components from 1hz to 30hz
figure(2)
subplot(2,1,1)
plot(ttrain,traindata2) %plotting bandpass filter output
xlim([0 0.65*5]) %limiting to positive side of spectrum for length of 5 epochs
xlabel('Time in seconds'); 
ylabel('Amplitude in au'); 
title('Bandpass filtered EEG training data of Cz Electrode'); 
X = fftshift(abs(fft(traindata2,N))); %frequency spectrum
subplot(2,1,2)
plot(F,X); %plot frequency spectrum
xlabel('Normalized Frequency'); 
xlim([0 0.5]) %focusing on positive side of frequency
ylabel('Amplitude in au'); 
title('Frequency Spectrum');
%%
%Implementing spatial filter on training data data
e1=train_sig(:,4); %extracting the signal of electrode on top
e2=train_sig(:,10); %extracting the signal of electrode on bottom
e3=train_sig(:,12); %extracting the signal of electrode on left
e4=train_sig(:,18); %extracting the signal of electrode on right
de1=filter(projectbandpass,e1); %filtering adjacent electrode signals
de2=filter(projectbandpass,e2);
de3=filter(projectbandpass,e3);
de4=filter(projectbandpass,e4);
deavg=mean([de1,de2,de3,de4],2); %taking a mean of adjacent filters
traindata3=traindata2-deavg; %EEG signal post spatial filtering for training dataset
figure(3)
subplot(2,1,1)
plot(ttrain,traindata3) %plotting fully filtered data
xlim([0 0.65*5]) %limiting to positive side of spectrum for length of 5 epochs
xlabel('Time in seconds'); 
ylabel('Amplitude in au'); 
title('Cz electrode training data post spatial filtering'); 
X = fftshift(abs(fft(traindata2,N))); %frequency spectrum
subplot(2,1,2)
plot(F,X); %plot frequency spectrum
xlabel('Normalized Frequency'); 
xlim([0 0.5])
ylabel('Amplitude in au'); 
title('Frequency Spectrum');
%%
%Filtering the testing dataset
testdata1=test_sig(:,11); %extracting Cz electrode data
figure(4)
subplot(2,1,1)
plot(ttest,testdata1) %Plotting raw testing dataset
xlim([0 0.65*5]) %limiting to 5 epoch length for better visualization
xlabel('Time in seconds'); 
ylabel('Amplitude in au'); 
title('Raw EEG signal of testing dataset for Cz Electrode'); 
X = fftshift(abs(fft(testdata1,N))); %Frequency spectrum
subplot(2,1,2)
plot(F,X); %plot frequency spectrum
xlabel('Normalized Frequency'); 
xlim([0 0.5]) %focusing on postive side
ylabel('Amplitude in au'); 
title('Frequency Spectrum'); 
testdata2=filter(projectbandpass,testdata1); %bandpass filtering same as training dataset
figure(5)
subplot(2,1,1)
plot(ttest,testdata2) %plotting output of bandpass filter
xlim([0 0.65*5]) %limiting to 5 epoch length for better visualization
xlabel('Time in seconds'); 
ylabel('Amplitude in au'); 
title('Bandpass filtered training dataset of Cz Electrode'); 
X = fftshift(abs(fft(testdata2,N))); %frequency spectrum
subplot(2,1,2)
plot(F,X); %plot frequency spectrum
xlabel('Normalized Frequency'); 
xlim([0 0.5])%focusing on positive spectrum
ylabel('Amplitude in au'); 
title('Frequency Spectrum');
%%
%implementing spatial filter on testing data
e1=test_sig(:,4); %testing data for electrode on top
e2=test_sig(:,10); %testing data for electrode on bottom
e3=test_sig(:,12); %testing data for electrode on left
e4=test_sig(:,18); %testing data for electrode on right
de1=filter(projectbandpass,e1); %filtering all the electrodes
de2=filter(projectbandpass,e2);
de3=filter(projectbandpass,e3);
de4=filter(projectbandpass,e4);
deavg=mean([de1,de2,de3,de4],2); %averaging the adjacent electrodes
testdata3=testdata2-deavg; %spatial filtering
figure(6)
subplot(2,1,1)
plot(ttest,testdata3) %plotting testing dataset post spatial filtering
xlim([0 0.65*5]) %limitng to length of 5 epochs for better visualization
xlabel('Time in seconds'); 
ylabel('Amplitude in au'); 
title('Testing dataset of Cz Electrode post spatial filtering'); 
X = fftshift(abs(fft(testdata3,N))); %frequency spectrum
subplot(2,1,2)
plot(F,X); %plot frequency spectrum
xlabel('Normalized Frequency'); 
xlim([0 0.5]) %focusing on positive side
ylabel('Amplitude in au'); 
title('Frequency Spectrum');
%%
%extracting stimulus and non-stimulus epoch without spatial filtering
e_length=fs*0.65; %no of samples for each epoch which exists for 650ms or 0.65seconds
sepoch=[]; %initialization of stimulus epoch vector
for i = 2:length(stimulussignal_training) %scanning the entire length of training period
    if ((stimulussignal_training(i-1)==0) && (stimulussignal_training(i)==2)) %checking for transition to identify start of an epoch
        sepoch=[sepoch traindata2(i:i+e_length-1)]; 
    end
end
nsepoch=[]; %initializing non stimulus epoch vector
for i = 2:length(stimulussignal_training) %scanning the entire length of training period
    if ((stimulussignal_training(i-1)==0) && (stimulussignal_training(i)==1)) %checking for transition to identify start of an epoch
        nsepoch=[nsepoch traindata2(i:i+e_length-1)];
    end
end
avgsepoch=mean(sepoch,2); %averaging all stimulus epochs
avgnsepoch=mean(nsepoch,2); %averaging all non stimulus epochs
figure(7)
tepoch=(0:1:156-1)/fs; %time vector for individual epochs
subplot(2,1,1)
plot(tepoch,avgsepoch) %plotting average of stimulus epoch
hold on
plot(tepoch,avgnsepoch) %plotting average of non stimulus epoch
legend('Stimulus','Non-Stimulus')
title('Average epoch without spatial filtering')
xlabel('time in second')
ylabel('amplitude in au')
subplot(2,1,2)
plot(periodogram(avgsepoch)) %plot frequency spectrum of average stimulus epoch
hold on
plot(periodogram(avgnsepoch)) %plot frequency spectrum of average non stimulus epoch
xlabel('Frequency in hertz'); 
ylabel('Amplitude in au'); 
title('Frequency spectrum');
legend('Stimulus','Non-Stimulus')
%%
%extracting stimulus and non-stimulus epoch with spatial filtering
%no of samples for each epoch which exists for 650ms or 0.65seconds
sepoch=[]; %initialization of stimulus epoch vector
for i = 2:length(stimulussignal_training) %scanning the entire length of training period
    if ((stimulussignal_training(i-1)==0) && (stimulussignal_training(i)==2)) %checking for transition to identify start of an epoch
        sepoch=[sepoch traindata3(i:i+e_length-1)]; 
    end
end
nsepoch=[]; %initializing non stimulus epoch vector
for i = 2:length(stimulussignal_training) %scanning the entire length of training period
    if ((stimulussignal_training(i-1)==0) && (stimulussignal_training(i)==1)) %checking for transition to identify start of an epoch
        nsepoch=[nsepoch traindata3(i:i+e_length-1)];
    end
end
avgsepoch=mean(sepoch,2); %averaging all stimulus epochs
avgnsepoch=mean(nsepoch,2); %averaging all non stimulus epochs
figure(8)
tepoch=(0:1:156-1)/fs; %time vector for individual epochs
subplot(2,1,1)
plot(tepoch,avgsepoch) %plotting average of stimulus epoch
hold on
plot(tepoch,avgnsepoch) %plotting average of non stimulus epoch
legend('Stimulus','Non-Stimulus')
title('Average epoch post spatial filtering')
xlabel('time in second')
ylabel('amplitude in au')
subplot(2,1,2)
plot(periodogram(avgsepoch)) %plot frequency spectrum of average stimulus epoch
hold on
plot(periodogram(avgnsepoch)) %plot frequency spectrum of average non stimulus epoch
xlabel('Frequency in hertz'); 
ylabel('Amplitude in au'); 
title('Frequency spectrum');
legend('Stimulus','Non-Stimulus')
%%
%finalizing the dataset for training of classifier
epoch=[nsepoch sepoch]; %combining stimulus and on stimulus epochs
z1=repmat((1),1,30); %identifier for stimulus epoch
z2=repmat((0),1,150); %identifier for non stimulus epoch
z0=[z2 z1]; %identifier for combined epochs
fepoch=periodogram(epoch); %converting each epoch to frequency spectrum
epoch=[epoch; z0];
fepoch=[fepoch; z0];
%%
%extracting the testing dataset epochs
tepoch=[]; %initializing vector for storing unindentified epochs of testing dataset
for i = 2:length(flashingsignal_testing) %scanining the entire length
    if ((flashingsignal_testing(i-1)==0) && (flashingsignal_testing(i)==1)) %identifying transition
        tepoch=[tepoch testdata3(i:i+e_length-1)]; %appending each identified epoch
    end
end
ftepoch=periodogram(tepoch); %converting each epoch to frequency domain
%%
%feature ranking using chi square test
idx = fscchi2(epoch.',z0);
idx2 = fscchi2(fepoch.',z0);