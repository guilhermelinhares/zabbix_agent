REM # Criado por Guilherme Linhares, guilherme.linharees@gmail.com
REM # Alterar somente as váriaveis #Server #ServerActive #TLSPSKIdentity #Chave PSK.KEY
REM # Observe o diretorio proposto C:\Zabbix 


@echo off
REM ## Instalando Chocolatey ##
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
REM # Instalando Wget # 
choco install wget -y
REM # Instalando Unzip #
choco install unzip -y
REM # Instalando Sed #
choco install sed -y
REM #Criando Pasta Zabbix #
mkdir c:\Zabbix
cd C:\Zabbix
REM # Baixando Zabbix_Agent#
wget https://cdn.zabbix.com/zabbix/binaries/stable/5.2/5.2.5/zabbix_agent-5.2.5-windows-amd64-openssl.zip
REM # Descompactando ZIP #
unzip zabbix_agent-5.2.5-windows-amd64-openssl.zip
del zabbix_agent-5.2.5-windows-amd64-openssl.zip
echo Criando Arquivos de configuração
REM #######################################################
sed -i "s/Server=127.0.0.1/Server=172.16.30.200/g" C:\Zabbix\conf\zabbix_agentd.conf
sed -i "s/ServerActive=127.0.0.1/ServerActive=172.16.30.200/g" C:\Zabbix\conf\zabbix_agentd.conf
type nul > psk.key >> C:\Zabbix
echo 64EE63CE889404A911471E9BAF6A4A03 >> psk.key
sed -i "s/Hostname=Windows host/Hostname=%COMPUTERNAME%/g" C:\Zabbix\conf\zabbix_agentd.conf
sed -i "s/# TLSConnect=unencrypted/TLSConnect=psk/g" C:\Zabbix\conf\zabbix_agentd.conf
sed -i "s/# TLSAccept=unencrypted/TLSAccept=psk/g" C:\Zabbix\conf\zabbix_agentd.conf
sed -i "s/# TLSPSKIdentity=/TLSPSKIdentity=001/g" C:\Zabbix\conf\zabbix_agentd.conf
sed -i "s/# TLSPSKFile=/TLSPSKFile=C:\\Zabbix\\psk.key/g" C:\Zabbix\conf\zabbix_agentd.conf
REM # Inicia o serviço #
REM ###########################################################
echo Instalando o Serviço
C:\Zabbix\bin\zabbix_agentd.exe -i -c C:\Zabbix\bin\zabbix_agentd.conf
C:\Zabbix\bin\zabbix_agentd.exe -s -c C:\Zabbix\bin\zabbix_agentd.conf

REM # Reiniciando  #
net stop "Zabbix Agent"
net start "Zabbix Agent"
REM ###########################################################
@pause
