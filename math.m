% math.m -> real time prediction for doing arithmatic

% editable parameters
svmFilename = 'svm.mat';
rngFilename = 'data.rng';
threshold = 0.015;

% SVM parameters
audioDirectory = 'audio_samples/';
svmDirectory = 'svms/';
libDirectory = 'libs/';
svmPath = strcat(svmDirectory, svmFilename);
rngPath = strcat(libDirectory, rngFilename);
SVM = load(svmPath);

% Recording parameters
Fs = 44100;
nBits = 16;
channels = 1;
duration = 2;
samples = 50;

recObj = audiorecorder(Fs, nBits, channels);
str = '';

% files = dir('audio_samples/*2_*');
% for file = files' 
for i = 1:samples
	pause(0.5);

	% Record your voice for 'duration' seconds.
	fprintf('--> ');
	recordblocking(recObj, duration);
	Y = getaudiodata(recObj);
	% Y = audioread(strcat('audio_samples/', file.name));

	% Check that audio was not silence
	if mean(mean(abs(Y))) > threshold
		% Write audio to wav file and read it back in to scale properly (this is inefficient)
		audiowrite('temp.wav', Y, Fs);
		Y = audioread('temp.wav');
		system('rm temp.wav');
		% Calculate the coefficients and scale appropriatly
		feature = get_lpc(Y);
		[labels features] = libsvmapplyscale(0, feature, rngPath);
		% Predict label
		[lab, ~, ~] = svmpredict(labels, features, SVM.svm, '-b 1 -q');
		fprintf('%s\n', SVM.words{lab});
		str = strcat(str, SVM.words{lab});
		fprintf('%s', str);
		if strcmp(SVM.words{lab}, '=')
			fprintf('%4.2f\n', eval(str(1:end-1)));
			break;
		else
			fprintf('\n');
		end
	else
		% Did not break threshold therfore silence
		fprintf('\n\n')
	end
end

clear;
