% generate a vector of spike times (seconds) with inter-spike intervals
% following a poisson process. 
%
%
% SYNTAX:
%
% spkTimes = spkpoiss(fr,nSpks)
% spkTimes = spkpoiss(fr,dt,tSim)
% 
%
% DESCRIPTION:
%
% spkTimes = spkpoiss(fr,nSpks) generates spike train based on "fr" firing
% rate (spikes/sec, lambda parameter of poisson process) and the number of
% desired spike times "nSpks". With this method we control for number of
% spikes rather than total time of spiking.
%
% spkTimes = spkpoiss(fr,tSim, dt) generates spike train based on "fr" firing
% rate (spikes/sec, lambda parameter of poisson process), with total
% simulated time specified by "tSim" (seconds), and discrete time-bins for
% single-spike occurrences specified by "dt" (seconds). Math assumption: 
% dt is very small, so that fr*dt << 1. Typically dt = 0.001 sec should be
% ok. With this method we contorl for desired total time of spiking rather 
% than total number of spikes. Also not that if you call too small a dt 
% with too large a tSim, you'll run out of memory.
%
%
% INPUT ARGUMENTS:
%
%    fr - scalar (spikes/second), mean firing rate of poisson spike train (lambda parameter)
% nSpks - integer, number of total spike-time occurrences to simulate.
%  tSim - scalar (seconds), total time that spike train is being simulated for. 
%    dt - scalar (seconds), size of each "time-bin" that a spike can happen within.      
%
%
% OUTPUT ARGUMENTS:
%
% spkTimes - a vector of spike times (seconds) with first time always being zero
% 
% 

% To-Do:
% -

function [spkTimes] = spkpoiss(fr, varargin)
% Parse inputs
method = 0; % default: proper methods won't get called in input syntax is bad

if nargin > 3 || nargin < 2
    error('Check number of input arguments.');
    
end

if nargin == 2
    nSpks = varargin{1};
    method = 1;
    
end

if nargin == 3
    tSim = varargin{1};
    dt = varargin{2};
    method = 2;

end



% execute code with appropriate method

switch method
    case 1
        % Method 1
        isi = exprnd((1/fr), (nSpks-1), 1);

        spkTimes = zeros(nSpks, 1);
        for  iSpk = 2:nSpks
            spkTimes(iSpk) = spkTimes(iSpk-1) + isi(iSpk-1);

        end
        
        
    case 2
        % Method 2
        nBins = floor(tSim / dt) ;
        spkMat = rand(1 , nBins ) < fr * dt ;
        tVec = 0: dt : tSim - dt ;

        spkTimes = tVec(spkMat);
       
        
    otherwise
        error('method = 0. Incorrect input syntax.')
        
end


end
