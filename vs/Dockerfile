# escape=`
FROM mcr.microsoft.com/powershell:lts-windowsservercore-1809
SHELL ["powershell", "-Command"]

# System dependencies
RUN Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')
RUN choco install -y `
        git `
        visualstudio2019-workload-vctools

# Install vcpkg
ENV VCPKG_PATH=C:\vcpkg
RUN mkdir $Env:VCPKG_PATH; `
    git clone https://github.com/Microsoft/vcpkg.git $Env:VCPKG_PATH; `
    cd $Env:VCPKG_PATH; `
    .\bootstrap-vcpkg.bat
RUN setx /M PATH $($Env:PATH + ';' + $Env:VCPKG_PATH)
