% Get data from the record auido samples

% Editable parameters
libFilename = 'data';
% What word prefixes to get
words = {'start1', 'stop1', 'left1', 'right1'};
% words = {'C4', 'D4', 'E4', 'F4', 'G4', 'A4', 'B4', 'C5'};
% words = {'test1', 'test2'};
% words = {'one1', 'two1', 'three1', 'four1', 'five1', ...
% 		 'six1', 'seven1', 'eight1', 'nine1', 'zero1', ...
% 		 'add1', 'subtract1', 'multiply1', 'divide1', 'equal1'};

% The SVM label for each word in words
wordLabels = 1:100; % This just has to be longer than words

% Audio Sample parameters
audioDirectory = 'audio_samples/';
% Lib parameters
libDirectory = 'libs/';
libFilepath = strcat(libDirectory, libFilename);

% Initialize feature and label arrays
labels = [];
features = [];

% Collect data
for i = 1:length(words)
	files = dir(strcat(audioDirectory, words{i}, '*'));
	for file = files'
		Y = audioread(strcat(audioDirectory, file.name));
		f = get_lpc(Y);
		features = cat(1, features, f);
		labels = cat(1, labels, wordLabels(i));
	end
end

% Write scaled lib
libsvmscaledwrite(libFilepath, labels, features);
fprintf('Wrote scaled lib %s\n', libFilepath);

% Write unscaled lib
% libsvmwrite(libFilepath, sparse(labels), sparse(features));
% fprintf('Wrote lib %s\n', libFilepath);

clear;
