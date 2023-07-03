function [out] = T2_blochSim__fillGaps(varargin)
% Fill in gaps in pulse simulation (just to give prettier plots).

opt = processVarargin(varargin{:});

if isfield(opt,'out')
    out = opt.out;
else
    out = struct(...
        'tp_s',zeros(1,0),...
        'b1_Hz',zeros(1,0),...
        'grad',zeros(1,0),...
        'spoil',false(1,0),...
        'readout',false(1,0));
end

tsteps = diff(out.tp_s);
gapList = find(tsteps > (opt.maxGap));

for gapDx=numel(gapList):-1:1 % Avoid invalidating indices by working from the end to the start.
	gapStart = out.tp_s(gapList(gapDx));
    gapEnd = out.tp_s(gapList(gapDx)+1);

    ptsNeeded = ceil((gapEnd - gapStart) / opt.maxGap) + 1;
    newTp = linspace(gapStart, gapEnd, ptsNeeded);
    
    out.tp_s((gapList(gapDx)+1):(end+numel(newTp)-2)) = [newTp(2:end-1) out.tp_s(gapList(gapDx)+1:end)];
    out.b1_Hz(gapList(gapDx)+1:end+numel(newTp)-2) = [repmat(out.b1_Hz(gapList(gapDx)),1,numel(newTp)-2) out.b1_Hz(gapList(gapDx)+1:end)];
    out.grad(gapList(gapDx)+1:end+numel(newTp)-2) = [repmat(out.grad(gapList(gapDx)),1,numel(newTp)-2) out.grad(gapList(gapDx)+1:end)];
    out.spoil(gapList(gapDx)+1:end+numel(newTp)-2) = [false(1,numel(newTp)-2) out.spoil(gapList(gapDx)+1:end)];
    out.readout(gapList(gapDx)+1:end+numel(newTp)-2) = [false(1,numel(newTp)-2) out.readout(gapList(gapDx)+1:end)];
end
