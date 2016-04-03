% Get the LPC data for a signal
% Y -> Input signal

function lpcs = get_lpc(Y)
	% Y = (((Y - min(Y)) / (max(Y) - min(Y))) * 2) - 1;
	Fs = 44100;
	N = 100; % Number of desired coefficients per frame
	frameSize = 60; % division of audio in milliseconds
	overlapSize = 15; % the overlap of frames in milliseconds
	Ts = length(Y); % Total number of samples
	T = (Ts / Fs) * 60; % Total time in milliseconds
	samplesPerFrame = Ts * (frameSize / T);
	samplesPerOverlap = Ts * (overlapSize / T);
	% Loop through and calculate LPCS for samples
	lpcs = [];
	i = 1;
	for j = samplesPerFrame:samplesPerFrame - samplesPerOverlap:Ts
		l = lpc(Y(i:j), N);
		l = l(2:end); % Remove first coefficient, always 1
		lpcs = horzcat(lpcs, l);
		i = j - samplesPerOverlap;
	end
	% Calluclate coefficients for any straggling pieces of Y
	if j ~= Ts
		l = lpc(Y(i:end), N);
		l = l(2:end); % Remove first coefficient, always 1
		lpcs = horzcat(lpcs, l);
	end

	% fprintf('get_lpc\n')
end
