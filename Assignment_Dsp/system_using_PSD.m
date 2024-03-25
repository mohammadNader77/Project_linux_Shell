% Load audio files
testing_file_male = dir('/MATLAB Drive/Assignment_Dsp/testing/male/*.wav');
training_file_male = dir('/MATLAB Drive/Assignment_Dsp/training/male/*.wav');
training_file_female = dir('/MATLAB Drive/Assignment_Dsp/training/female/*.wav');
testing_file_female = dir('/MATLAB Drive/Assignment_Dsp/testing/female/*.wav');
%------------Training_male----------

data_male = [];
for i = 1:length(training_file_male)
    file_path = strcat(training_file_male(i).folder,'/',training_file_male(i).name);
    [y,fs] = audioread(file_path);

    % Calculate Power Spectral Density
    [Pxx, ~] = pwelch(y, [], [], [], fs);

    energy_male = sum(Pxx);
    data_male = [data_male energy_male];
end
energy_male = mean(data_male);
fprintf('The energy of male is \n');
disp(energy_male);


%------------Training_female----------

data_female = [];
for i = 1:length(training_file_female)
    file_path = strcat(training_file_female(i).folder,'/',training_file_female(i).name);
    [y,fs] = audioread(file_path);

    % Calculate Power Spectral Density
    [Pxx, ~] = pwelch(y, [], [], [], fs);

    energy_female = sum(Pxx);
    data_female = [data_female energy_female];
end
energy_female = mean(data_female);
fprintf('The energy of female is \n');
disp(energy_female);


correct_male_classifications = 0;
correct_female_classifications = 0;
% Calculate correlation coefficients
correlation_male = corrcoef(data_male);
correlation_female = corrcoef(data_female);

%------------Testing_female----------

for i = 1:length(testing_file_female)
    file_path = strcat(testing_file_female(i).folder,'/',testing_file_female(i).name);
    [y, fs] = audioread(file_path);

    % Plot the recorded signal in the time domain
    figure;
    subplot(2,1,1);
    plot((0:(length(y)-1))/fs, y);
    title(['Time Domain - feMale Test File #' num2str(i)]);
    xlabel('Time (s)');
    ylabel('Amplitude');

    % Plot the frequency domain representation (Power Spectral Density)
    subplot(2,1,2);
    [Pxx, f] = pwelch(y, [], [], [], fs);
    plot(f, 10*log10(Pxx));
    title(['Frequency Domain - feMale Test File #' num2str(i)]);
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');

    % Calculate Power Spectral Density
    y_energy = sum(Pxx);
    if(abs(y_energy - energy_female) < abs(y_energy - energy_male))
        fprintf('Test file [female] #%d classified as female , E=%d\n', i, y_energy);
        correct_female_classifications = correct_female_classifications + 1;

    else
        fprintf('Test file [female] #%d classified as male , E=%d\n', i, y_energy);
    end
end




%------------Testing_male----------

for i = 1:length(testing_file_male)
    file_path = strcat(testing_file_male(i).folder,'/',testing_file_male(i).name);
    [y, fs] = audioread(file_path);

    % Plot the recorded signal in the time domain
    figure;
    subplot(2,1,1);
    plot((0:(length(y)-1))/fs, y);
    title(['Time Domain - Male Test File #' num2str(i)]);
    xlabel('Time (s)');
    ylabel('Amplitude');

    % Plot the frequency domain representation (Power Spectral Density)
    subplot(2,1,2);
    [Pxx, f] = pwelch(y, [], [], [], fs);
    plot(f, 10*log10(Pxx));
    title(['Frequency Domain - Male Test File #' num2str(i)]);
    xlabel('Frequency (Hz)');
    ylabel('Power/Frequency (dB/Hz)');

    % Calculate Power Spectral Density
    y_energy = sum(Pxx);
    if(abs(y_energy - energy_male) < abs(y_energy - energy_female))
        fprintf('Test file [male] #%d classified as male , E=%d\n', i, y_energy);
        correct_male_classifications = correct_male_classifications + 1;

    else
        fprintf('Test file [male] #%d classified as female , E=%d\n', i, y_energy);
    end
end

% Calculate accuracy
total_male_files = length(testing_file_male);
total_female_files = length(testing_file_female);

accuracy_male = correct_male_classifications / total_male_files * 100;
accuracy_female = correct_female_classifications / total_female_files * 100;

fprintf('Accuracy for male testing files: %.2f%%\n', accuracy_male);
fprintf('Accuracy for female testing files: %.2f%%\n', accuracy_female);

overall_accuracy = (correct_male_classifications + correct_female_classifications) / (total_male_files + total_female_files) * 100;
fprintf('Overall Accuracy: %.2f%%\n', overall_accuracy);

