clear all
close all

% load in audio file
audioFile = 'happyBirthday.wav';
[input Fs] = audioread(audioFile);

% sum to mono if necessary
channels = size(input, 2);
if channels > 1
    input = sum(input, 2);
    input./channels;
end

file_length = length(input);
window_length = 50/1000 * Fs;
jump_size = floor(0.5 * window_length);
num_frames = floor((file_length - window_length - 1)/jump_size);

max_tau = floor(1/20 * Fs);
threshold = floor(1/1500 * Fs);

frame_index = [0:1:num_frames -1] * jump_size + 1;
n = [0:file_length - 1];

pitch = nan(num_frames, 1);

d_matrix = nan(max_tau, num_frames);

for frame = 1 : num_frames
    
    frame_begin = frame_index(frame);
    frame_end = frame_begin + jump_size;
    
    for tau = 1 : max_tau
        d_matrix(tau, frame) = sum((input(frame_begin: frame_end) - input(frame_begin+ tau: frame_end + tau)).^2);
    end
    
    % Normalize
    for tau = 1: max_tau
        d_prime_matrix(tau, frame) = d_matrix(tau, frame) / ((1/tau)*sum(d_matrix(1:tau, frame)));
    end
    
end


%% Find Pitch

for tau = 1: max_tau
    if tau > threshold && d_prime(tau) < 0.7 && d_prime(tau) < d_prime(tau - 1) && d_prime(tau) < d_prime(tau + 1);
        pitch(frame) = Fs/tau;
        break;
    end
end

    
    plot(d_prime);
    
