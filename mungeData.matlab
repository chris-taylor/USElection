function newdata = mungeData(data,window,method)
%MUNGEDATA
%
%   When there are polls from the last month, take the mean.
%   If there is no poll in the last month, use the most recent month, or
%   the 2008 results when no poll is available.
    
    % Config for model. Take the average of all polls from the last 'win' days.
    if nargin < 2
        window = 30;
    end
    if nargin < 3
        method = 'mean';
    end
    if ischar(method)
        method = str2func(method);
    end
    
    % Electoral vote data
    ev = loadElectoralVotes;
    
    % Munge poll data
    states = unique(data.state);
    
    lastDay = max(data.datenum);
    
    newdata.state  = cell(51,1);
    newdata.p      = zeros(51,2);
    newdata.npolls = zeros(51,1);
    newdata.ev     = zeros(51,1);

    for ii = 1:length(states)
       
        state = states{ii};
        
        stateIdx = strmatch(state,data.state,'exact');
        
        lastMonthIdx = (lastDay - data.datenum(stateIdx)) < window;
        
        if ~any(lastMonthIdx)
            idx = stateIdx(1);
        else
            idx = stateIdx(lastMonthIdx);
        end
        
        p = bsxfun(@rdivide,[data.dem(idx) data.gop(idx)] ,(data.dem(idx)+data.gop(idx)));
        n = size(p,1);
        p = method(p,1);
        
        newdata.state{ii}    = state;
        newdata.p(ii,:)      = p;
        newdata.npolls(ii,:) = n;
        
        idx = strmatch(state,ev.state,'exact');
        newdata.ev(ii)       = ev.ev(idx);
         
    end

end