{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
    nativeBuildInputs = [ 
        pkgs.dotnet-sdk
    ];
    shellHook = ''
        # set vars
        DOTSETTINGS="Botolution.Platform.sln.DotSettings.user";
        DOTNET_ROOT="${pkgs.dotnet-sdk}";
        
        # create or edit DotSettings
        if test -f "$DOTSETTINGS"; then
            sed -i -E "s:(>)(.*)(</):\1$DOTNET_ROOT/dotnet\3:" $DOTSETTINGS;
        else
            cat > $DOTSETTINGS <<- EOL
        <wpf:ResourceDictionary xml:space="preserve" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" xmlns:s="clr-namespace:System;assembly=mscorlib" xmlns:ss="urn:shemas-jetbrains-com:settings-storage-xaml" xmlns:wpf="http://schemas.microsoft.com/winfx/2006/xaml/presentation">
        <s:String x:Key="/Default/Environment/Hierarchy/Build/BuildTool/DotNetCliExePath/@EntryValue">$DOTNET_ROOT/dotnet</s:String>
        </wpf:ResourceDictionary>
        EOL;
        
        fi    
        
        # initialize dotnet
        dotnet new tool-manifest --force;
    '';
}
