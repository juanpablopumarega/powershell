<#
.SYNOPSIS
    Actividad Práctica de Laboratorio Nro: 2 - Primera Entrega
    
.DESCRIPTION
    Comprimir historias clinicas segun última visita mayour a 30 dias. Descomprimir historia clinica según nombre de paciente.

.PARAMETER Comprimir
    [Opcional] Opción de comprimir las historias clinicas de los pacientes que no realizaron una visita en los ultimos 30 dias.

.PARAMETER Descomprimir
    [Opcional] Opción de descomprimir las historias clinicas de los pacientes a través del parametro -Nombre.

.PARAMETER Nombre
    [Opcional] Si se envía con la opción de descomprimir, indica el nombre del paciente del cual se quiere descomprimir las historias clinicas.

.PARAMETER Historias
    [Obligatorio] Path absoluto o relativo del directorio en donde se encuentran las historias clinicas y el archivo "ultimas visitas.txt"

.PARAMETER DirectorioZip
    [Obligatorio] Path relativo o absoluto del directorio donde se guardaran los archivos comprimidos.

.EXAMPLE
    .\APL2Ejercicio6.ps1 -Comprimir -Historias ".\files2" -DirectorioZip ".\comprimidos"

.EXAMPLE1
    .\APL2Ejercicio6.ps1 -Descomprimir -Nombre "Nahuel Paiva" -Historias ".\files2" -DirectorioZip ".\comprimidos"
#>


Param(
    [parameter(ParameterSetName='Descomprimir',Mandatory=$false)][switch]$Descomprimir,
    [parameter(ParameterSetName='Descomprimir',Mandatory=$true)][string]$Nombre,
    [parameter(ParameterSetName='Comprimir',Mandatory=$false)][switch]$Comprimir,
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
                     if(-Not ($_ | Test-Path ) ){
                        throw "No existe el directorio especificado";
                        }
                     return $true 
                     })]
    [string]$Historias,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
                    if(-Not ($_ | Test-Path) ){
                      throw "No existe el directorio especificado";
                      }
                    return $true 
                    })]
    [string]$DirectorioZip   
)

# Comprime solo si el parametro Comprimir existe cargado
    if($Comprimir) {

        # Me traigo la fecha de hoy
            $hoy = Get-Date -Format yyyy-MM-dd
            $cantidadDeArchivos=0

        # Iteramos el archivo de ultmias visitas para luego comprimir cuando la fecha es mayor a 30 dias    
            foreach ($paciente in (Get-Content -path "$Historias\ultimasvisitas.txt")) {
                $nombre = $paciente.split("|")[0]
                $fecha = [datetime]::parseexact($paciente.split("|")[1], 'yyyy-MM-dd', $null)
        
                $diferenciaDeFechas = NEW-TIMESPAN –Start $fecha –End $hoy
    
                #Primero se valida que registros cumplen con antigüedad mayor a 30 dias. Si el directorio a comprimir existe se comprime y se borra.
                if($diferenciaDeFechas.Days -gt 30){
                    if (Test-Path "$Historias\$nombre"){
                        #Para contar la cantidad de coincidencias en cantidad de visitas.
                        $cantidadDeArchivos++
                        Compress-Archive -Path "$Historias\$nombre" -DestinationPath "$DirectorioZip\$nombre.zip" -Force
                        Remove-Item "$Historias\$nombre" -Force -Recurse
                    }
                }
    
            }
            if($cantidadDeArchivos -ne 0) {
                Write-Host "Resultado exitoso --- La cantidad de Historias Clinicas comprimidas es de $cantidadDeArchivos"
            } else {
                Write-Host "Ups... Parece que ninguna carpeta cumplía con la antigüedad"
            }
        
    }

# Comprime solo si el parametro Descomprimir existe cargado
    if($Descomprimir) {

        #Si existe el archivo a descomprimir descomprimo reemplazando en el directorio de salida, borro el archivo e informo por pantalla
        if(Test-Path "$DirectorioZip\$Nombre.zip" -PathType Leaf) {
            Expand-Archive -Path "$DirectorioZip\$Nombre.zip" -DestinationPath "$Historias" -Force
            Write-Host "Resultado exitoso --- Se ha discomprimido la historia clinica de $Nombre"
            Remove-Item "$DirectorioZip\$Nombre.zip" -Force
        } else {
            Write-Host "Ups... Parece que no existe ningun archivo $Nombre.zip para descomprimir"
        }
    }

#FIN
