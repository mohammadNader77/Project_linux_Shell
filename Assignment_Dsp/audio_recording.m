recObj = audiorecorder(44100, 24, 1);
for i=1 : 5
fprintf ('start speaking for audio #%d\n',i)
recordblocking(recObj, 2);
fprintf('Audio #%d ended\n',i)
y=getaudiodata(recObj);
y=y-mean(y);
%file_name = sprintf ('training/male/male%d.wav', i);
%file_name = sprintf ('training/female/female%d.wav', i);
%file_name = sprintf ('testing/male/male%d.wav', i);
%file_name = sprintf ('testing/female/female%d.wav', i);
audiowrite (file_name, y, recObj.SampleRate);
end