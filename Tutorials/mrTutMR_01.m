%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Tutorial:  Basic MR

% Author:    Wandell Brian
% Date:      03.15.04
% Copyright: Stanford University, Brian A. Wandell
%
% Checked:  
%   2007:       Rory Sayres
%   09.22.09:   Jon Winawer
%   09.18.10    Jon Winawer
%   2011.09.22  B. Wandell
%
% Edited by
%  2015.01.03  Aviv mezer
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This tutorial explains basic principles of magnetic resonance signals.
% As the first tutorial in the series, it also gives you an opportunity to
% examine basic Matlab commands.
%
% In this tutorial, principles are illustrated for signals derived from a bulk
% substance, such as a beaker of water. Various terms used to describe the
% MR principles, including
%
%   spins, parallel and anti-parallel, Boltzman distribution
%
% are introduced.
% 
% Also, tissue properties such as T1 (longitudinal) and T2(spin-spin)
% interactions, are explained and the way in which signal contrast depends
% on these parameters is explained. 
%
% The next tutorial, MRImaging, takes up the topic of how to make
% images that measure these tissue properties in a non-uniform volume, such
% as a head.
%
%
% REFERENCES TO HELP WITH THIS TUTORIAL:
% Huettel et al. Chapters 1-3 (mainly Chapter 3)
% John Hornak online MRI book: http://www.cis.rit.edu/htbooks/mri/index.html
% Especially Chapter 3: http://www.cis.rit.edu/htbooks/mri/inside.htm
% McRobbie et al, MRI, From Picture to Proton, Chapter 8
%
% 1st v. 2nd edition of text: 
% The course text is Huettel et al, 2nd edition. The first and second
% editions are quite similar, especially in the earlier chapters.
% References followed by "ii" are 2nd edition, "i" first edition. Hence p.
% 51i, 60ii means p 51 in the first edition, p 60 in the second. And so on.


%% Spin velocity
% When a substance with net spin is placed in a steady magnetic field, it
% precesses at a frequency that is characteristic of that substance.
% We can compute the precession frequency from the following simple
% formula.  Note the units.
% (see chapter 3 and ca. p. 51i, 60ii for a discussion of precession).

B0 = 1.5;     % Magnetic field strength (Tesla)
g = 42.58e+6; % Gyromagnetic constant for hydrogen (Hz / Tesla)
v = g*B0      % The resonant frequency of hydrogen, also called its Larmor frequency.

%% Question 1
% What are the units of the Larmor frequency, v, for hydrogen as expressed
% above? The gyromagnetic constant of sodium is 11.27e+6 Hz/Tesla.  Compute
% the Larmor frequency of sodium in a 3T magnet.

% Ordinarily, the resonant frequencies are expressed in units of MegaHertz
% (millions of hertz)
fprintf('The resonant frequency of spins in hydrogen is %0.4f (MHz) at %.2f Tesla',v/(10^6),B0);

%% Spin Energy
% The energy in precessing spin is proportional to its resonant frequency, v.
% The constant of proportionality between energy and frequency is a famous
% constant called Planck's constant.
% (Extra credit:  Find out something interesting about Max Planck).  

% Hence, the amount of energy in a hydrogen molecular in this magnetic
% field is
h = 6.626e-34 % Planck's constant (J s)
E = h*v


%% Question 2
% What are the units of E?

% At steady state, say when the subject enters the magnet and prior to
% any measurements, the dipoles align parallel or anti-parallel to the
% magnetic field.

%
% The energy difference between these two states is proportional to the
% mean magnetic field.  This is called the Zeeman effect (see http://mri-q.com/energy-splitting.html). 
%

% The proportion of dipoles aligned parallel (low energy) and anti-parallel
% (high energy) to the main field is described by the Boltzmann
% distribution. The formula that determines the fraction of dipoles in the
% low and high energy states is in Hornak (Chapter 2).

k = 1.3805e-23;      % Boltzmann's constant, J/Kelvin
T = 300;             % Degrees Kelvin at room temperature
dE = h * g * B0;      % Transition energy
ratioHigh2Low = exp(-dE/(k*T));  % Boltzmann's formula, Hornak, Chapter 3; Huettel, p. 76ii

% Under typical conditions the number of dipoles in the low and high energy
% states are very similar.
fprintf('Ratio of dipoles in the high vs. low energy state:  %e',ratioHigh2Low)

% At low temperatures (near absolute zero), very few of the dipoles enter
% the high (anti-parallel) energy state.  No, this is not important for us.
% But I find the numbers interesting and can see why people might want to
% work on low temperature physics for a while.
T = logspace(-3,2.5,50);
r = exp( -dE ./ (k*T));  
mrvNewGraphWin;
semilogx(T,r);
xlabel('Temperature (K)'); ylabel('Ratio of high/low energy state dipoles')
set(gca,'ylim',[-0 1.1]); grid on

%% Question 3
% Where is human body temperature on the graph?  Given human body
% temperature, what is the ratio of high/low energy? Would it matter if we
% kept the room cooler?

%% T1 tissue contrast
%
% The tendency of dipoles to align (either parallel or anti-parallel) with
% the B0 magnetic field imposes an opportunity to probe tissue properties
% using magnetic resonance. MR signals are derived by perturbing the
% ordered spins (excitation) and then measuring the emissions (reception)
% as the dipoles return to their low energy state.  The way the dipoles
% return to their low energy state provides information about the local
% tissue.
%
% Summing the effect of the many many dipoles within a voxel, we obtain a
% measure of the dipoles within the voxel called the net magnetization.
% This is represented by a single vector (see the many examples in Hornak).
% Most reasoning about the MR signal is based on understanding models of
% the net magnetization vector and how it recovers after being perturbed by
% the radio frequency pulses in the presence of changing magnetic fields.
%
mrvNewGraphWin('Z-magnetization');

% The MR measurements that we obtain describe the net magnetization in the
% direction perpendicular to the main axis (B0 field). This direction is
% illustrated in the following figures.

% First, here is a 3D plot that shows the net magnetization as a red circle
% in the steady-state.  The blue lines show the three axes.

% showAxis
plot3(0,0,1,'ro')
set(gca,'xlim',[-2,2],'ylim',[-2 2],'zlim',[-2 2])
line([-1 1],[0 0],[0 0]);
line([0 0],[-1 1],[0 0]);
line([0 0],[0 0],[-1 1]);
grid on
xlabel('x'), ylabel('y'), zlabel('z')
AZ0 = 332.5; EL0 = 30; view(AZ0,EL0);
%%
%  The size of the MR signal we measure depends on how far the net
%  magnetization deviates from the main z-axis.  We can see this deviation
%  more easily by looking at the figure straight from the top.  In this
%  initial situation, the point is at (0,0) in the (x,y) plane.
AZ1 = 0; EL1 = 90 ;  view(AZ1,EL1)
%%
% Notice that from this view, looking down the z-axis, we see only the x-
% and y-axes.  The net magnetization is at (0,0) so we will not see any
% signal. Now, let's put the picture back to the 3D view.
view(AZ0,EL0);
%%
% Suppose we excite the tissue and place the net magnetization along the
% x-axis.
mrvNewGraphWin ('excite magnetization');
plot3(1,0,0,'go')
set(gca,'xlim',[-2,2],'ylim',[-2 2],'zlim',[-2 2]);
line([-1 1],[0 0],[0 0]);
line([0 0],[-1 1],[0 0]);
line([0 0],[0 0],[-1 1]);
grid on
xlabel('x'), ylabel('y'), zlabel('z')
%%
% When we look from the top now, we see that there is a large magnetization
% component.  The green point is removed from (0,0) and falls along the
% x-axis.
AZ1 = 0; EL1 = 90 ;  view(AZ1,EL1)
%%
% When we change the net magnetization from the steady-state position (red
% circle) to the excited position (green circle), it is like introducing a
% 90 deg rotation in the magnetization direction.  This is usually called
% the flip angle. This is one of the parameters that you select when doing
% MR imaging.

mrvNewGraphWin ('magnetization rotation');
% showAxis
plot3(0,0,1,'ro',1,0,0,'go')
set(gca,'xlim',[-2,2],'ylim',[-2 2],'zlim',[-2 2])
line([-1 1],[0 0],[0 0]);
line([0 0],[-1 1],[0 0]);
line([0 0],[0 0],[-1 1]);
grid on
xlabel('x'), ylabel('y'), zlabel('z')
AZ0 = 332.5; EL0 = 30; 
%%
view(AZ0,EL0);

%% Return to steady state video
%  As the net magnetization returns to the steady-state position, the
%  distance from the origin decreases, reducing the signal.  This is
%  illustrated by the collection of green points plotted here that
%  illustrate the net magnetization rotating back towards the z-axis.
theta = (pi/2)*((0:10)/10);
x = cos(theta);  z = sin(theta);  y = zeros(size(x));
mrvNewGraphWin ('magnetization returns towards the z-axis');
plot3(x,y,z,'go')
set(gca,'xlim',[-2,2],'ylim',[-2 2],'zlim',[-2 2])
line([-1 1],[0 0],[0 0]);
line([0 0],[-1 1],[0 0]);
line([0 0],[0 0],[-1 1]);
grid on
xlabel('x'), ylabel('y'), zlabel('z');
AZ0 = 332.5; EL0 = 30; 

view(AZ0,EL0);
%%
% When viewed from the top, you can see that the green points head back
% towards the origin.
AZ1 = 0; EL1 = 90 ;  view(AZ1,EL1)
%%
% After receiving an excitation pulse, this component of the MR signal
% decays gradually over time.  The spin-lattice decay has been measured
% and, in general, it follows an exponential decay rate.

% Specifically, here is the rate of recovery of the T1 magnetization for
% hydrogen molecules in gray matter.
T1 = 0.88;          % Time constant units of S
t = (0.02:0.02:6);  % Time in seconds
Mo = 1;             % Set the net magnetization in the steady state to 1 and ignore.

% This is the exponential rate of recovery of the T1 magnetization, after
% it has been set to zero by flipping the net magnetization 90 degrees.
MzG = Mo *( 1 - exp(-t ./ T1) );
% Plotted is a graph we have the magnetization of gray matter as:
mrvNewGraphWin ('T1 GM');
plot(t,MzG);
xlabel('Time (s)'); ylabel('Transverse magnetization (T1)'); grid on
%%
% The decay rates for various brain tissues (summarized by the parameter T1
% above) differs both with the material and with the level of the B0 field.
% The value T1 = 0.88 seconds above is typical of gray matter at 1.5T.

% The T1 value for white matter is slightly smaller.  Comparing the two we
% see that white matter recovers slightly faster (has a smaller T1):
T1 = 0.64;
MzW = Mo *( 1 - exp(-t ./ T1) );
mrvNewGraphWin ('T1 WM & GM');
plot(t,MzG,'b-',t,MzW,'r--');
xlabel('Time (s)'); ylabel('Transverse magnetization (T1)'); grid on
legend('Gray','White')

% Notice that the time to recover all the way back to Mo is fairly long, on
% the order of 3-4 sec.  This is a limitation in the speed of acquisition
% for T1 imaging.
%%
% The difference in the T1 component of the signal from gray matter and
% white matter changes over time.This difference is plotted in the next
% graph.
mrvNewGraphWin ('T1  WM - GM');
plot(t,abs(MzW - MzG));
xlabel('Time (s)'); ylabel('Magnetization difference'); grid on

%% Question 4
% If you are seeking to make a measurement that optimizes the signal to
% noise ratio between these two materials, at what time would you measure
% the recovery of the T1 signal?

%% Question 5
% Look up the T1 value of cerebro-spinal fluid (CSF).  Plot the T1 recovery
% of CSF.  At what time you would measure to maximize the white/CSF
% contrast.

%% Visualization
% We can visualize this difference as follows. Suppose that we have two
% beakers, adjacent to one another, containing materials with different T1
% values.  Suppose we make a pair of images in which the intensity of each
% image is set to the T1 value over time. What would the T1 images look
% like?
%

% The beakers start with the same, Mo, magnetization.
beaker1 = Mo*ones(32,32);
beaker2 = Mo*ones(32,32);

% They will have different T1 relaxation values
T1(1) = 0.64;       % T1 for white matter
T1(2) = 0.88;       % T1 for gray matter
movieT = (0.001:.1:4);   % We will make images at these sample times (in sec)

% Here is a movie, slowed down, showing the relative intensities of the
% images over a 4 sec period, measured every 100 ms.   The frames are shown
% at 1/4 the real speed (i.e., every 400 ms).
mrvNewGraphWin ('T1 movie');
for ii=1:length(movieT)
    img1 = beaker1*( 1 - exp(-movieT(ii) / T1(1)) );
    img2 = beaker2*( 1 - exp(-movieT(ii) / T1(2)) );
    img = [img1; img2];
    pause(.4);
    image(img*256); axis image; colormap(gray(256))
    text1 = text(-18,12,'Beaker 1');
    text2 = text(-18,44,'Beaker 2');
    text3 = text(40,32,sprintf('Time: %.2f sec',movieT(ii)));
    l1 = line([0 32],[32.5 32.5]);
end

% As you can see, if we make a picture of the net magnetization around
% 0.6-1.0 sec during the decay, there will be a good contrast difference
% between the gray and white matter.  Measured earlier or later, the
% picture will have less contrast.

%% With some noise
%  we should add just a little noise to the measurements.  After all, all measurements have some
% noise.  Let's look again.
mrvNewGraphWin('T1 movie with noise');
for ii=1:length(movieT)
    img1 = beaker1*( 1 - exp(-movieT(ii) / T1(1)) ) + randn(size(beaker1))*0.05;
    img2 = beaker2*( 1 - exp(-movieT(ii) / T1(2)) ) + randn(size(beaker1))*0.05;
    img = [img1; img2];
    pause(.4);
    image(img*256); axis image; colormap(gray(256))
    text1 = text(-18,12,'Beaker 1');
    text2 = text(-18,44,'Beaker 2');
    text3 = text(40,32,sprintf('Time: %.2f sec',movieT(ii)));
    l1 = line([0 32],[32.5 32.5]);
end

%% Question 6
% Instead of plotting the difference, plot the ratio of the
% levels, MzW and MzG. 
%     a) When is the ratio the biggest?
%     b) Why would we measure at a time when the difference, rather than
%     ratio is biggest? 
%%
close all
%% T2 contrast

%
% There is a second physical mechanism, in addition to the spin-lattice
% measurement, that influences the MR signal. This second mechanism is
% called spin-spin interaction (transverse relaxation).  This signaling
% mechanism is particularly important for functional magnetic resonance
% imaging and the BOLD signal.
%
% In describing the T1 signal, we treated the MR signal as a single unified
% vector.  In the example above, we explored what happens to the net
% magnetization of the MR signal when the vector is rotated 90 deg into the
% x-y plane.
%
% But we omitted any discussion the fact that the dipoles are assumed to be
% continuously precessing around the main axis together, in unison. Perhaps
% in a perfectly homogeneous environment, these rotating dipoles would
% precess at the Larmor frequency in perfect synchronization and we could
% treat the single large vector as we have.
%
% But in practice, the  dipoles within a single voxel of a functional image
% each experience slightly different magnetic field environments.
% Consequently, they each have their own individual Larmor frequencies,
% proportional to the magnetic field that they experience. An important
% second mechanism of MR is a consequence of the fact that the individual
% dipoles each have their own local magnetic field and the synchrony soon
% dissipate.
%

% Suppose  we have a large sample of dipoles that are spinning together in
% perfect phase.  We can specify their orientation as an angle in this
% plane, theta.  Let's assume they all share a common angle
nSamples = 10000;
theta = zeros(nSamples,1);

% Then the position of the spins in the (x,y) plane will be
spins = [cos(theta), sin(theta)];

% And they will all fall at the same poisiton
mrvNewGraphWin (' spins in the (x,y) plan ') ;
subplot(1,3,1)
plot(spins(:,1),spins(:,2),'o');
grid on; axis equal
set(gca,'xlim',[-2,2],'ylim',[-2 2])
grid on; xlabel('x'), ylabel('y')
%%
% The total magnetization, summed across all the dipoles, is the vector
% length of the sum of these spins 
% 
averagePosition = sum(spins)/nSamples;         % Type v so you know what it is
netMagnetization = sqrt(averagePosition(1)^2 + averagePosition(2)^2)

% Here is the distribution of the angles
mrvNewGraphWin ('distribution of the angles');
subplot(1,3,1)

hist(theta)
xlabel('Angle'), ylabel('Number of spins');
set(gca,'xlim',[0 2*pi])

%%
% Now, suppose that spins are precessing at slightly different rates.  So
% after a few moments in time they do not fall at exactly the same angle.
% We can express this by creating a new vector theta that has some
% variability in it
theta = rand(nSamples,1)*0.5;       % Uniform random number generator

% Here is the distribution of the angles
figure(2)
subplot(1,3,2)

hist(theta)
xlabel('Angle'), ylabel('Number of spins');
set(gca,'xlim',[0 2*pi])

%% Visualizing the spins spread out in time
% Going through the same process we can make a plot of the spin positions
figure(1);
subplot(1,3,2)
spins = [cos(theta), sin(theta)];
plot(spins(:,1),spins(:,2),'o');
grid on; axis equal
set(gca,'xlim',[-2,2],'ylim',[-2 2])
grid on; xlabel('x'), ylabel('y');

% Now, you can see that the net magnetization is somewhat smaller
averagePosition = sum(spins); 
netMagnetization = sqrt(averagePosition(1)^2 + averagePosition(2)^2)/nSamples


%%
% If the spins grow even further out of phase, say they are spread over a
% full pi radians (180 degrees), then we have a dramatic reduction in the
% net magnetization
figure(2)
subplot(1,3,3)
theta = rand(nSamples,1)*pi;
spins = [cos(theta), sin(theta)];
hist(theta)
xlabel('Angle'), ylabel('Number of spins');
set(gca,'xlim',[0 2*pi])
averagePosition = sum(spins); 
netMagnetization = sqrt(averagePosition(1)^2 + averagePosition(2)^2)/nSamples

%%
% Going through the same process we can make a plot of the spin positions
figure(1);
subplot(1,3,3)
spins = [cos(theta), sin(theta)];
plot(spins(:,1),spins(:,2),'o');
grid on; axis equal
set(gca,'xlim',[-2,2],'ylim',[-2 2])
grid on; xlabel('x'), ylabel('y');

% Now, you can see that the net magnetization is somewhat smaller
averagePosition = sum(spins); 
netMagnetization = sqrt(averagePosition(1)^2 + averagePosition(2)^2)/nSamples


%%
% In a typical experiment, in which the spins are in an inhomogeneous
% environment, the spins spread out more and more with time, and the
% transverse magnetization declines.  The loss of signal from this
% spin-dephasing mechanism follows an exponential time constant.

t = (0.01:0.01:0.3);% Time in secs
T2(1) = 0.08;       % T2 for white matter
T2(2) = 0.11;       % T2 for gray matter
MzG = Mo*exp(-t/T2(1));
MzW = Mo*exp(-t/T2(2));
mrvNewGraphWin ('WM GM T2 ');

plot(t,MzG,'r--',t,MzW,'b-')
xlabel('Time (s)'); ylabel('Transverse magnetization (T2)'); grid on
legend('Gray','White')

%% Typical T1 and T2 values
% Experimental measurements of spin-spin decay shows that it occurs at a
% much  faster rate than spin-lattice. Comparison of T1 (spin-lattice) and
% T2 (spin-spin) decay constants at various B0 field strengths are:
%
% Tissue      T1 (1.5T,3.0T,4T)    T2 (1.5T,3.0T,4T)  (seconds)
%------------------------------------------
% White      0.64, 0.86, 1.04     0.08, 0.08, 0.05
% Gray       0.88, 1.2,  1.4      0.08, 0.11, 0.05
%------------------------------------------
% Source: Jezzard and Clare Chapter 3 in the Oxford fMRI Book

% Also, notice that the peak difference occurs a very short time compared
% to the T1 difference.
mrvNewGraphWin ('WM GM T2 difference');
plot(t,abs(MzG - MzW),'b-')
xlabel('Time (s)'); ylabel('Transverse magnetization difference(T2)'); grid on

%% Question 7
% Suppose you wanted to measure brain structure, and you were particularly
% interested in gray/white differences.  Based on the T1 and T2 curves we
% have drawn, would you choose to distinguish these two tissues using T1 or
% T2?

%% Spin echo 
% The T2 difference is so short that measurement of the T2 signal would be
% a problem were it not for the invention of an important measurement
% method called 'Spin Echo'.  We will begin the next tutorial by explaining
% that idea.

% In fact, there are many essential imaging ideas that we have not yet
% explored.  For example, how can we measure T1 and T2 separately? Perhaps
% most importantly, how can we form an image? These are the topics we will
% take up in the next tutorial.

% END OF TUTORIAL
