clear

% what happens if z follows the typical default trajectory while fe keeps
% as zero (no expansion in transfer)?

load typdef.mat 
load fiscal_zf2.mat q para default bp z f b nz nb

z = exp(z) ;

%% Choose a transfer shock and save results into a Mat file. 
% ife = 9 ;
% ife = 13 ;
ife = 10 ;

%%
def_vec = nan(17,1) ;
q_vec = nan(17,1) ;

i = 8 ;

    shock = zt_mean(i) ;
    [~,iz] = sort(abs(z - shock)) ;
    z1 = z(iz(1)); % 1st nearest value
    z2 = z(iz(2)); % 2nd nearest value
    lamb_z = (shock - z2) / (z1-z2) ; %

    is1 = (ife-1)*nz + iz(1) ;
    is2 = (ife-1)*nz + iz(2) ;

    state_b = d_mean(i) ;
    [~,ib] = sort(abs(b - state_b)) ;
    b1 = b(ib(1)) ;
    b2 = b(ib(2)) ;
    lamb_b = (state_b - b2) / (b1-b2) ;

    ib1 = ib(1) ;
    ib2 = ib(2) ;

    def_vec(i) = lamb_b*lamb_z * default(is1,ib1) + (1-lamb_b)*lamb_z * default(is1,ib2) +...
                 lamb_b*(1-lamb_z) * default(is2,ib1) + (1-lamb_b)*(1-lamb_z) * default(is2,ib2) ;

    q_vec(i) = lamb_b*lamb_z * q(is1,bp(is1,ib1)) + (1-lamb_b)*lamb_z * q(is1,bp(is1,ib2)) +...
                 lamb_b*(1-lamb_z) * q(is2,bp(is2,ib1))  + (1-lamb_b)*(1-lamb_z) * q(is2,bp(is2,ib2)) ;

    bp11 = bp(is1,ib1) ;
    bp12 = bp(is1,ib2) ;
    bp21 = bp(is2,ib1) ;
    bp22 = bp(is2,ib2) ;

    prob_bp11 = lamb_b*lamb_z; 
    prob_bp12 = (1-lamb_b)*lamb_z ;
    prob_bp21 = lamb_b*(1-lamb_z) ;
    prob_bp22 = (1-lamb_b)*(1-lamb_z) ;


%%
%=========================================================================
% After finishing i=8 calculations, we know:
%   1) def_vec(8), q_vec(8).
%   2) We have four possible next b-states (bp11, bp12, bp21, bp22)
%      with probabilities prob_bp11, prob_bp12, prob_bp21, prob_bp22.
%
% Let's collect them in arrays so we can iterate from i=9..17
%=========================================================================

% We'll store the distribution of (bIndex, Probability).
bInds = [ bp11; bp12; bp21; bp22 ];
bProbs= [ prob_bp11; prob_bp12; prob_bp21; prob_bp22 ];

% -- Merge duplicates if they exist (some of the bp's might be the same):
[bIndsUnique,~,ic] = unique(bInds);  
% bIndsUnique is the set of distinct b indices
% ic is a mapping telling you which unique index each entry of bInds matched
bProbsMerged = zeros(size(bIndsUnique));
for k=1:length(bInds)
    bProbsMerged(ic(k)) = bProbsMerged(ic(k)) + bProbs(k);
end
% Now bIndsUnique, bProbsMerged is a distribution of next b states after i=8
bInds = bIndsUnique;
bProbs= bProbsMerged;

%=========================================================================
% Now we iterate from i=9 up to i=17
%=========================================================================

for t = 9:17
    
    shock = zt_mean(t);
    
    % 1. Interpolate in Z
    [~, izsort] = sort(abs(z - shock));
    iz1 = izsort(1);
    iz2 = izsort(2);
    
    z1 = z(iz1);
    z2 = z(iz2);
    lamb_z = (shock - z2)/(z1 - z2);
    
    is1 = (ife-1)*nz + iz1;
    is2 = (ife-1)*nz + iz2;
    
    % We'll build a new distribution for the next b states:
    bInds_next  = [];
    bProbs_next = [];
    
    % We'll compute def_vec(t) and q_vec(t) as probability-weighted sums.
    def_t = 0.0;
    q_t   = 0.0;
    
    % 2. Loop over each possible b-state from previous period's distribution
    for nState = 1:length(bInds)
        
        ibPrev  = bInds(nState);    % integer index of b in [1..length(b)]
        pPrev   = bProbs(nState);   % probability mass for this state
        if pPrev < 1e-14
            continue;  % skip effectively zero-prob states
        end
        
        % 2A. Interpolate in B dimension
        bVal = b(ibPrev); % actual numeric b-value
        [~, ibsort] = sort(abs(b - bVal));
        ib1 = ibsort(1);
        ib2 = ibsort(2);
        
        b1 = b(ib1);
        b2 = b(ib2);
        
        lamb_b = (bVal - b2) / (b1 - b2);
        
        % 2B. Compute default, q for this node (before branching)
        def_node = ...
            lamb_b*lamb_z         * default(is1, ib1) + ...
            (1-lamb_b)*lamb_z     * default(is1, ib2) + ...
            lamb_b*(1-lamb_z)     * default(is2, ib1) + ...
            (1-lamb_b)*(1-lamb_z) * default(is2, ib2);
        
        % For q, remember we look up the next b index in bp
        q11 = q(is1, bp(is1, ib1));
        q12 = q(is1, bp(is1, ib2));
        q21 = q(is2, bp(is2, ib1));
        q22 = q(is2, bp(is2, ib2));
        
        q_node = ...
            lamb_b*lamb_z         * q11 + ...
            (1-lamb_b)*lamb_z     * q12 + ...
            lamb_b*(1-lamb_z)     * q21 + ...
            (1-lamb_b)*(1-lamb_z) * q22;
        
        % 2C. Accumulate into def_t, q_t
        def_t = def_t + pPrev * def_node;
        q_t   = q_t   + pPrev * q_node;
        
        % 2D. Next b states from the 4 corners (2x2)
        cornerProbs = pPrev * [ lamb_b*lamb_z;
                                (1-lamb_b)*lamb_z;
                                lamb_b*(1-lamb_z);
                                (1-lamb_b)*(1-lamb_z) ];
        cornerIS    = [ is1; is1; is2; is2 ];
        cornerIB    = [ ib1; ib2; ib1; ib2 ];
        
        cornerNextBinds = zeros(4,1);
        for cc = 1:4
            cornerNextBinds(cc) = bp( cornerIS(cc), cornerIB(cc) );
        end
        
        % 2E. Add these corners to the new distribution
        for cc = 1:4
            if cornerProbs(cc) < 1e-14
                continue;
            end
            newBind = cornerNextBinds(cc);
            newProb = cornerProbs(cc);
            
            % If newBind is already in bInds_next, add to it; else add new row
            idx = find(bInds_next == newBind, 1);
            if ~isempty(idx)
                bProbs_next(idx) = bProbs_next(idx) + newProb;
            else
                bInds_next  = [bInds_next;  newBind];
                bProbs_next = [bProbs_next; newProb];
            end
        end
    end
    
    % 3. Done with all nodes at time t => store def_vec(t), q_vec(t)
    def_vec(t) = def_t;
    q_vec(t)   = q_t;
    
    % 4. Prepare the distribution for the next iteration
    bInds = bInds_next;
    bProbs= bProbs_next;
    
end  % for t=9:17


r_annual = ((1+para.rbase)^4-1)*100 ;
PM = (((para.eta+(1-para.eta)*para.coup) ./q_vec + 1 - para.eta ).^4-1)*100 - r_annual ;

PM(1:7) = pm_mean(1:7)' ;

disp('the probability of default and spreads are')
disp(def_vec(17))

if ife == 13
    save analyze_event_ife13.mat PM def_vec
elseif ife == 10
    save analyze_event_ife10.mat PM def_vec
elseif ife == 9 
    save analyze_event_ife9.mat PM def_vec
end


