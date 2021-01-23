<#
.SYNOPSIS
    Actividad Práctica de Laboratorio Nro: 2 - Primera Entrega
    
    
.DESCRIPTION
    Identificar y matar procesos que se encuentran en el archivo de blacklist. Se informa en un archivo de log los eventos.

.PARAMETER Blacklist
    [Requerido] Path absoluto o relativo del archivo con la blacklist de procesos.

.PARAMETER Resultado
    [Opcional] Path absoluto o relativo del directorio donde se generará el archivo de salida. Si no se informa se generará en el directorio de ejecución

.EXAMPLE
    .\APL2Ejercicio4.ps1 -Blacklist ".\files\blacklist.txt" -Resultado ".\files\"

#>


Param(
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
                     if(-Not (Test-Path $_ -PathType Leaf) ){
                        throw "No existe el File especificado";
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


# Funcion que lee el archivo de blacklist y escribe el archivo de salida.
    function global:Blacklist-Reader ()
    {
      Process{
        
            $BlackContent = Get-Content "$Global:Blacklist"
            # Cargo y recorro un array con los nombres de los procesos a cerrar, y los envio a la funcion Detener-Proceso
            foreach( $proc in $BlackContent ){

                    # Guardo en un archivo como lista, fecha de creacion, pid, nombre                
                    Get-Process -Name $proc -IncludeUserName | Select-Object Name, UserName, StartTime, Id| Format-Table >> $Global:OutputFileName

                    # Envio los nombres de los procesos que se encontraron corriendo
                    get-process -Name $proc | Select-Object -Unique -Property ProcessName

                    # Se detiene el proceso
                    Stop-Process -Name $proc -Force
                 
                }         
      }
    } 




# Declaracion de timer para que el proceso ejecute cada 10 segundos (10000 ms).
    $Timer = New-Object -Type Timers.Timer
    $Timer.Interval  = 10000

# Declaracion de las variables como globales para que se puedan ver desde el entorno de las funciones.
# Se verifica que el archivo de Blacklist no esté vacío para de ser así, cerrar el proceso y no efectuar tareas.
    if(Get-Content $Blacklist) {
        $Global:blacklist= $Blacklist
    }
    else {
        Write-Host "El archivo blacklist está vacío."
        exit 0;
    }

# Formo la ruta del archivo de salida.
    $Global:OutputFileName = $Resultado + "\" + "blacklist" + "_" + (Get-Date -Format yyyy-MM-dd_hhmmss) + ".out";

# Inicio del programa a traves del registro del evento, ambas funciones son globales para que existan en el scope global
    Register-ObjectEvent -InputObject $Timer  -EventName Elapsed  -SourceIdentifier TimerEvent  -Action { global:Blacklist-Reader
    }
    $Timer.Start()

#FIN
