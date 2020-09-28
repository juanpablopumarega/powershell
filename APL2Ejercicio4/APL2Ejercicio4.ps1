﻿<#
.SYNOPSIS
    Actividad Práctica de Laboratorio Nro: 2 - Primera Entrega
    Integrantes:
        # Fernández Durante Cynthya Alexandra   DNI:48693815
        # López Pumarega Juan Pablo             DNI:34593023
        # Miranda Andres                        DNI:32972232
        # Paiva Gordillo Nahuel Alejo           DNI:38455227
        # Salerti Natalia                       DNI:41559796        
    
.DESCRIPTION
    Identificar y matar procesos que se encuentran en el archivo de blacklist. Se informa en un archivo de log los eventos.

.PARAMETER Blacklist
    [Requerido] Path absoluto o relativo del archivo con la blacklist de procesos.

.PARAMETER Resultado
    [Opcional] Path absoluto o relativo del directorio donde se generará el archivo de salida. Si no se informa se generará en el directorio de ejecución

.EXAMPLE
    .\APL2Ejercicio4.ps1 -Blacklist "C:\powershell\APL2Ejercicio4\files\blacklist" -Resultado "C:\powershell\APL2Ejercicio3\files\"

#>

Param(
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
                     if(-Not ($_ | Test-Path) ){
                        throw "No existe el directorio o el File especificado";
                        }
                     return $true 
                     })]
    [string]$Blacklist,

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
                    if(-Not ($_ | Test-Path) ){
                      throw "No existe el directorio o el File especificado";
                      }
                    return $true 
                    })]
    [string]$Resultado=$PWD
)

function global:Detener-Proceso()
{
    [CmdLetBinding()]
    Param(
            [Parameter(Mandatory=$True,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
            [String[]]$ProcessName
    )
    Process{
        
        foreach ($proc in $ProcessName)
        {
            try{
                    Stop-Process -Name $proc -Force
                    Write-Output "El proceso $proc fue detenido exitosamente"
                }
            catch{
                Write-Warning "El proceso $proc no existe en el sistema"
            }
        }
    }
}
function global:Blacklist-Reader ()
{
  Process{
        $BlackContent = Get-Content "$Global:Blacklist"
        foreach( $proc in $BlackContent ){
            try{
                get-process -Name $proc* | Select-Object -Unique -Property ProcessName | Detener-Proceso
                }
            catch{
             Write-Warning "El proceso $proc no existe en el sistema"
            }
        }
  }
} 





$Timer = New-Object -Type Timers.Timer

$Timer.Interval  = 10000

$Global:blacklist= $Blacklist

Register-ObjectEvent -InputObject $Timer  -EventName Elapsed  -SourceIdentifier TimerEvent  -Action { global:Blacklist-Reader
}
$Timer.Start()



