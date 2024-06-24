% Compare three simplistic convolution 2D algorithms to determine if they
% give the exact same results

clc

nCase = 2;

switch nCase
    case 1
        %% First and second input specs
        nt1 = numerictype(1,8,3);
        dim1 = [2,2];

        % Second input specs
        nt2 = numerictype(1,16,4);
        dim2 = [3,3];
    otherwise
        %% First and second input specs
        nt1 = numerictype(1,16,3);
        dim1 = [2,2];

        % Second input specs
        nt2 = numerictype(1,16,4);
        dim2 = [3,3];
end

%% Get rich inputs
% work around that directly calling fixed.DataSpecification
% would error out due to execessive combinations
%
nCases = 50;
inSet = createRichDataExcessiveComboCase(nCases,nt1,dim1,nt2,dim2);

%% Show case
%
fprintf('Case\n');
fprintf('    %s \n',nt1.tostring);
fprintf('  conv2D\n');
fprintf('    %s \n',nt2.tostring);
fprintf('  %d element mask.\n',numel(inSet(1).mask));

%% Test expected reference implemenation vs. a first fixed-point
% implementation
%
for i=1:nCases
    yRef = conv_ref(inSet(i).u,inSet(i).mask);
    yEmb1 = conv_embed1(inSet(i).u,inSet(i).mask);

    absErr1 = fixed.unifiedErrorCalculator.absoluteError(yEmb1, yRef);

    if any(absErr1 > 0)
        inSet(i).u
        inSet(i).mask
        yRef
        yEmb1
        absErr1
        error('Test for Embed1 failed')
    end
end
fprintf('\nTest for Embed1 passed\n\n')

%% Test expected reference implemenation vs. a second implementation
%  that is numerically lazy and converts to single precision floating-point
%  for the numerics.
%
for i=1:nCases
    yRef = conv_ref(inSet(i).u,inSet(i).mask);
    yEmb2 = conv_embed2(inSet(i).u,inSet(i).mask);

    absErr2 = fixed.unifiedErrorCalculator.absoluteError(yEmb2, yRef);

    if any(absErr2 > 0)
        ui = inSet(i).u
        maski = inSet(i).mask
        yRef
        yEmb2
        absErr2
        error('Test for Embed2 failed')
    end
end
fprintf('Test for Embed2 passed\n')


%%
function y = mulSR16(vA,vB)
    a2 = fi(vA,1,32,0);
    b2 = fi(vB,1,32,0);
    fullProd = a2 .* b2;
    sr = 16;
    y = fi( fullProd, 1, 32, -sr, fimathLean() );
    %y = stripscaling(y);
end

%%
function y = mulSR16_alt(vA,vB)
    a2 = double(vA);
    b2 = double(vB);
    doubleProd = a2 .* b2;
    sr = 16;
    y = fi( doubleProd, 1, 32, -sr, fimathLean() );
    %y = stripscaling(y);
end


function fm = fimathLean()
    fm = fimath('RoundingMethod', 'Floor', ...
        'OverflowAction', 'Wrap', ...
        'ProductMode', 'FullPrecision', ...
        'SumMode', 'FullPrecision');
end


function inSet = createRichDataExcessiveComboCase(nCases,nt1,dim1,nt2,dim2)
    %createRichDataExcessiveComboCase create rich data for case when
    % direct use of fixed.DataSpecification would error out do to excessive
    % combination size. That easily happens when prod(dim1)*prod(dim2)
    % not very small
    %
    % Instead of using fixed.DataSpecification to directly handle all the
    % combination, just
    %   1) use fixed.DataSpecification to get rich individual values.
    %   2) manually create a few extremes
    %   3) randomly mix other rich values

    % First step
    % Create numerically rich values for each input independently
    %
    ds1 = fixed.DataSpecification(nt1);
    dg = fixed.DataGenerator('DataSpecifications',{ds1},...
        'NumDataPointsLimit',1000);
    v1 = dg.outputAllData;
    n1 = numel(v1);
    lo1 = repmat(v1(1),  dim1);
    hi1 = repmat(v1(end),dim1);

    ds2 = fixed.DataSpecification(nt2);
    dg = fixed.DataGenerator('DataSpecifications',{ds2},...
        'NumDataPointsLimit',1000);
    v2 = dg.outputAllData;
    n2 = numel(v2);
    lo2 = repmat(v2(1),  dim2);
    hi2 = repmat(v2(end),dim2);

    % Step 2
    %  Manually set a few key cases

    % extreme lo lo
    example1.mask = lo1;
    example1.u = lo2;

    % pre-allocate the set of output sets for testing
    inSet = repmat(example1,nCases);

    % extreme lo h
    inSet(2).mask = lo1;
    inSet(2).u = hi2;

    % extreme hi lo
    inSet(3).mask = hi1;
    inSet(3).u = lo1;

    % extreme hi hi
    inSet(4).mask = hi1;
    inSet(4).u = hi2;

    % Step 3   create random input sets from the rich values
    %
    for i=5:nCases
        ii1 = randi(n1,dim1);
        ii2 = randi(n2,dim1);
        inSet(i).mask = v1(ii1);
        inSet(i).u = v2(ii2);
    end
end


function y = conv_ref(u,mask)
    %conv_ref tutorial example Reference of Simplistic 2D Convolution
    %
    % Use double for the reference
    % since double has a bit span of signed 54
    % this will be full-precision for many fixed-point cases
    % Example
    %    53 > log2(size(mask)) + u.WordLength + mask.WordLength
    % assuming range between realmin and realmax

    ud = double(u);
    md = double(mask);

    sizeY = size(ud) - size(md) + 1;

    ir = 0:(size(md,1)-1);
    ic = 0:(size(md,2)-1);

    y = zeros(sizeY);

    for iRow = 1:sizeY(1)
        for iCol = 1:sizeY(2)

            temp = md .* ud(iRow+ir,iCol+ic);
            y(iRow,iCol) = sum(temp(:));
        end
    end
end

function y = conv_embed1(u,mask)
    %conv_embed1 tutorial example Simplistic Full-Precision 2D Convolution
    % full-precision fixed-point implemenation
    %
    sizeY = size(u) - size(mask) + 1;

    ir = 0:(size(mask,1)-1);
    ic = 0:(size(mask,2)-1);

    temp1 = mask .* u(1+ir,1+ic);
    yProto = sum(temp1(:));

    y = zeros(sizeY,'like',yProto);

    for iRow = 1:sizeY(1)
        for iCol = 1:sizeY(2)

            temp = mask .* u(iRow+ir,iCol+ic);
            y(iRow,iCol) = sum(temp(:));
        end
    end
end


function y = conv_embed2(u,mask)
    %conv_embed2 tutorial example Simplistic Full-Precision 2D Convolution
    %
    % lazy implementation that converts to singles to do the computations
    %

    ud = single(u);
    md = single(mask);

    sizeY = size(u) - size(mask) + 1;

    ir = 0:(size(mask,1)-1);
    ic = 0:(size(mask,2)-1);

    yProto = u(1)*mask(1)*fixed.internal.type.tightFi([1,numel(mask)]);

    y = zeros(sizeY,'like',yProto);

    for iRow = 1:sizeY(1)
        for iCol = 1:sizeY(2)

            temp = md .* ud(iRow+ir,iCol+ic);
            y(iRow,iCol) = sum(temp(:));
        end
    end
end


% Copyright 2024 The MathWorks, Inc.
