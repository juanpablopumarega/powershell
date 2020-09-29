<#
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
# Funcion para detener los procesos por nombre
function global:Detener-Proceso()
{
    [CmdLetBinding()]
    Param(
            [Parameter(Mandatory=$True,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
            [String[]]$ProcessName
    )
#Los procesos fueron recibidos a traves del " | "
    Process{
        
        foreach ($proc in $ProcessName)
        {
            
            try{
                    # Mato al proceso buscando por su nombre
                    Stop-Process -Name "$proc" -Force
                }
            catch{
                
                Write-Warning " El proceso $proc no existe en el sistema"
            }
        }
    }
}

# Funcion que lee el archivo de blacklist y escribe el archivo de salida.
function global:Blacklist-Reader ()
{
  Process{
        
        $BlackContent = Get-Content "$Global:Blacklist"
        # Cargo y recorro un array con los nombres de los procesos a cerrar, y los envio a la funcion Detener-Proceso
        foreach( $proc in $BlackContent ){
            try{
                    $match=$proc + ".exe"
                    
                    # Guardo en un archivo como lista, fecha de creacion, pid, nombre
                    Get-WmiObject Win32_Process -Filter "name='$match'" | Select CreationDate, ProcessId, Name, @{Name="UserName";Expression={$_.GetOwner().Domain+"\"+$_.GetOwner().User}}|Sort-Object UserName, Name, ProcessId | Format-List >> $Global:OutputFileName
                    
                    # Envio los nombres de los procesos que se encontraron corriendo
                    get-process -Name $proc* | Select-Object -Unique -Property ProcessName | global:Detener-Proceso
                }
            catch{
             Write-Warning "El proceso $proc no existe en el sistema"
            }
        }
  }
} 




# Declaracion de timer para que el proceso ejecute cada 10 segundos (10000 ms).
$Timer = New-Object -Type Timers.Timer
$Timer.Interval  = 10000

# Declaracion de las variables como globales para que se puedan ver desde el entorno de las funciones.
$Global:blacklist= $Blacklist

# Formo la ruta del archivo de salida.
$Global:OutputFileName = $Resultado + "\" + "blacklist" + "_" + (Get-Date -Format yyyy-mm-dd_hhmmss) + ".out";



# Inicio del programa a traves del registro del evento, ambas funciones son globales para que existan en el scope global
Register-ObjectEvent -InputObject $Timer  -EventName Elapsed  -SourceIdentifier TimerEvent  -Action { global:Blacklist-Reader
}
$Timer.Start()

