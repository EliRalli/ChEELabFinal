function gui_motor_servo
clear;
a = open_scope('COM9'); %open the serial interface to the scope
motor_scope(a,0); %Brake the motor
enczero_scope(a); %Zero the encoder count
fig1 = figure;
fig1.Position = [20,100,700,500];
fig1.Name = 'GUI Lego Servo Test';
%Add one chart to the figure
ax1 = axes('Box','on','Units','pixels','Position',[60,150,600,300]);
%Add a pushbutton 35x25 pixels Left=200 Bottom=50
pb = uicontrol('Style','pushbutton');
pb.Position = [20,50,45,25];
pb.String = 'Step'; %Write Step on the button
pb.Callback = @pb_Callback; %Add a function to do something
%Add a slider 300x25 pixels Left=120 Bottom=20
sd = uicontrol('Parent', fig1,'Style','slider');
sd.Position = [120,50,300,25];
sd.Max = 1000;
sd.Min = -1000;
sd.Callback = @sd_Callback; %Add a function to update the text value
%Add text to show current slider pulses position
tx = uicontrol('Style', 'text');
tx.Position = [200,15,180,25];
tx.String = 'Position in Pulses 0';
%Call back function for the pushbutton. Runs servo loop and plots it
function pb_Callback(h, eventdata, handles)
axes(ax1); %assign plotting to ax1
tz = tic; %mark zero time
p = zeros(512,1); %predefine position array
t = zeros(512,1); %predefine time array
 for i = 1:512
p(i) = encin_scope(a); %get encoder count
t(i) = toc(tz); %mark time
e = (sd.Value-p(i))* 0.001; %position error times Gain of 0.001
motor_scope(a,e); %drive the motor
 end
motor_scope(a,0); %brake the motor
plot(t,p); %plot the servo response
grid ON;
end
function sd_Callback(h, eventdata)
tx.String = "Position in Pulses " + num2str(h.Value,4);
end
end