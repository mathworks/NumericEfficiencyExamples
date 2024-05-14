function cfg = getMatlabCoderLibConfig(useLongLong,useC99,use16BitInt)
    % getMatlabCoderLibConfig get common MATLAB Coder lib config object
    %
    % Goal is to make it easier to do some experiments like
    % testing code
    %    when maximum integer is 64 bits vs 32 bits.
    %    when C99 lib is and is not available
    %
    % Named
    
    if ~exist('useLongLong','var')
        useLongLong = true;
    end
    if ~exist('useC99','var')
        useC99 = true;
    end
    if ~exist('use16BitInt','var')
        use16BitInt = false;
    end

    cfg = coder.config('lib');
    
    cfg.HardwareImplementation.ProdHWDeviceType = 'Generic->Custom';
    cfg.HardwareImplementation.ProdEqTarget = true;
    
    cfg.HardwareImplementation.ProdEndianess = 'Unspecified';
    cfg.HardwareImplementation.ProdIntDivRoundTo = 'Zero';
    cfg.HardwareImplementation.ProdLargestAtomicFloat = 'None';
    cfg.HardwareImplementation.ProdLargestAtomicInteger = 'Char';
    cfg.HardwareImplementation.ProdShiftRightIntArith = true;
    
    cfg.HardwareImplementation.ProdBitPerDouble = 64;
    cfg.HardwareImplementation.ProdBitPerFloat = 32;
    
    cfg.HardwareImplementation.ProdBitPerChar = 8;
    cfg.HardwareImplementation.ProdBitPerShort = 16;
    if use16BitInt
        cfg.HardwareImplementation.ProdBitPerInt = 16;
    else
        cfg.HardwareImplementation.ProdBitPerInt = 32;
    end
    cfg.HardwareImplementation.ProdBitPerLong = 32;
    
    cfg.HardwareImplementation.ProdBitPerLongLong = 64;
    
    cfg.EnableSignedLeftShifts = true;
    cfg.EnableSignedRightShifts = true;
    
    cfg.SaturateOnIntegerOverflow = true;
    cfg.SupportNonFinite = true;
    
    if useC99
        cfg.TargetLangStandard = 'C99 (ISO)';
    else
        cfg.TargetLangStandard = 'C89/C90 (ANSI)';
    end

    if useLongLong
        bigInt = 64;
    else
        bigInt = 32;
    end
    cfg.HardwareImplementation.ProdLongLongMode = useLongLong;
    cfg.HardwareImplementation.ProdBitPerPointer = bigInt;
    cfg.HardwareImplementation.ProdBitPerPtrDiffT = bigInt;
    cfg.HardwareImplementation.ProdBitPerSizeT = bigInt;
    cfg.HardwareImplementation.ProdWordSize = bigInt;
        
    %-------------------------------- Report -------------------------------   
    cfg.EnableTraceability = true;
    cfg.GenerateCodeMetricsReport = true;
    cfg.GenerateCodeReplacementReport = true;
    cfg.GenerateReport = true;
    cfg.HighlightPotentialDataTypeIssues = true;
    cfg.LaunchReport = false;
    cfg.ReportPotentialDifferences = true;
    %------------------------------- Debugging -----------------------------
    cfg.RuntimeChecks = false;
    %---------------------------- Code Generation --------------------------
    cfg.BuildConfiguration = 'Faster Builds';
    cfg.CodeExecutionProfiling = false;
    %cfg.CustomToolchainOptions = [[] cell];
    cfg.DataTypeReplacement = 'CoderTypedefs';
    cfg.FilePartitionMethod = 'MapMFileToCFile';
    cfg.GenCodeOnly = false;
    cfg.GenerateExampleMain = 'GenerateCodeOnly';
    cfg.GenerateMakefile = true;
    cfg.HighlightPotentialRowMajorIssues = true;
    cfg.MultiInstanceCode = false;
    cfg.OutputType = 'LIB';
    cfg.PassStructByReference = true;
    cfg.PostCodeGenCommand = '';
    cfg.PreserveArrayDimensions = false;
    cfg.RowMajor = false;
    cfg.SILDebugging = false;
    cfg.SILPILCheckConstantInputs = true;
    cfg.TargetLang = 'C';
    cfg.Toolchain = 'Automatically locate an installed toolchain';
    cfg.VerificationMode = 'None';
    %------------------------ Language And Semantics -----------------------
    cfg.CodeReplacementLibrary = 'None';
    cfg.CompileTimeRecursionLimit = 50;
    cfg.ConstantFoldingTimeout = 40000;
    cfg.DynamicMemoryAllocation = 'Threshold';
    cfg.DynamicMemoryAllocationThreshold = 65536;
    cfg.EnableAutoExtrinsicCalls = true;
    cfg.EnableRuntimeRecursion = true;
    cfg.EnableVariableSizing = true;
    cfg.GenerateNonFiniteFilesIfUsed = true;
    cfg.InitFltsAndDblsToZero = true;
    cfg.PreserveVariableNames = 'None';
    cfg.PurelyIntegerCode = false;
    cfg.SILPILSyncGlobalData = true;
    %---------------- Function Inlining and Stack Allocation ---------------
    %cfg.InlineStackLimit = 4000;
    %cfg.InlineThreshold = 10;
    %cfg.InlineThresholdMax = 200;
    %cfg.StackUsageMax = 200000;
    %----------------------------- Optimizations ---------------------------
    cfg.ConvertIfToSwitch = false;
    cfg.EnableMemcpy = true;
    cfg.EnableOpenMP = true;
    cfg.EnableStrengthReduction = false;
    cfg.LoopUnrollThreshold = 5;
    cfg.MemcpyThreshold = 64;
    %------------------------------- Comments ------------------------------
    cfg.GenerateComments = false;
    cfg.MATLABFcnDesc = false;
    cfg.MATLABSourceComments = false;
    cfg.Verbose = false;
    %------------------------------ Custom Code ----------------------------
    cfg.CustomHeaderCode = '';
    cfg.CustomInclude = '';
    cfg.CustomInitializer = '';
    cfg.CustomLibrary = '';
    cfg.CustomSource = '';
    cfg.CustomSourceCode = '';
    cfg.CustomTerminator = '';
    cfg.ReservedNameArray = '';
    %------------------------------ Code Style -----------------------------    
    cfg.CastingMode = 'Explicit';
    %cfg.CodeTemplate = [];
    cfg.ColumnLimit = 80;
    cfg.CommentStyle = 'Auto';
    cfg.CustomSymbolStrEMXArray = 'emxArray_$M$N';
    cfg.CustomSymbolStrEMXArrayFcn = 'emx$M$N';
    cfg.CustomSymbolStrFcn = '$M$N';
    cfg.CustomSymbolStrField = '$M$N';
    cfg.CustomSymbolStrGlobalVar = '$M$N';
    cfg.CustomSymbolStrMacro = '$M$N';
    cfg.CustomSymbolStrTmpVar = '$M$N';
    cfg.CustomSymbolStrType = '$M$N';
    %cfg.DataTypeAlias = [1x1 coder.DataTypeAlias];
    cfg.EnableCustomReplacementTypes = false;
    cfg.GenerateDefaultInSwitch = false;
    cfg.IncludeTerminateFcn = true;
    cfg.IndentSize = 2;
    cfg.IndentStyle = 'K&R';
    cfg.MaxIdLength = 31;
    cfg.ParenthesesLevel = 'Nominal';
    cfg.PreserveExternInFcnDecls = true;
    
end