% Record audio to use as training data

% Editable parameters
word = 'test1'; % The word prefix under which samples are saved

% Audio Sample parameters
audioDirectory = 'audio_samples/';
extension = '.wav';
% Recording parameters
Fs = 44100;
nBits = 16;
channels = 1;
duration = 2; % Duration of recording
samples = 20; % Number samples to record

recObj = audiorecorder(Fs, nBits, channels);

for i = 1:samples
	pause(0.5);
	% Record your voice for 'duration' seconds.
	fprintf('Start recording.\n');
	recordblocking(recObj, duration);
	fprintf('End recording %.0f.\n\n', i);
	% Write data to file
	filename = strcat(audioDirectory, word, '_', random_string(), extension);
	audiowrite(filename, getaudiodata(recObj), Fs);
end

clear;
