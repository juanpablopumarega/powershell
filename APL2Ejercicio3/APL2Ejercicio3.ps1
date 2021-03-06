﻿<#
.SYNOPSIS
    Actividad Práctica de Laboratorio Nro: 2 - Primera Entrega        
    
.DESCRIPTION
    Determinar la existencia de archivos duplicados en el File System y cuáles archivos superan en tamaño un umbral determinado.

.PARAMETER Path
    [Requerido] Path absoluto o relativo a analizar.

.PARAMETER Resultado
    [Opcional] Path absoluto o relativo del directorio donde se generará el archivo de salida. Si no se informa se generará en el directorio de ejecución

.PARAMETER Umbral
    [Opcional] Tamaño definido en KB para definir el umbral a analizar. Opcional. Si no es indicado, se considerará como umbral el promedio de peso de los archivos inspeccionados

.EXAMPLE
    .\APL2Ejercicio3.ps1 -Path ".\files\" -Resultado ".\files\" -Umbral "1"

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
    [string]$Path,

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [Int]$Umbral="-1",

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
                    if(-Not ($_ | Test-Path) ){
                      throw "No existe el directorio o el File especificado";
                      }
                    return $true 
                    })]
    [string]$Resultado=(Get-Location)
)

#Calculamos el promedio de los files si el umbral no existe
    if($Umbral -eq -1){
        $Umbral=Get-ChildItem -Path $Path -File -Recurse | Measure-Object -Average Length | Select-Object -ExpandProperty average
    } else {
        $Umbral=$Umbral*1024
    }

#Creamos el nombre de la variable de salida
    [string]$OutputFileName=$Resultado + "\" + "resultado" + "_" + (Get-Date -Format yyyy-mm-dd_hhmmss) + ".out";

#Armo una tabla con los archivos a analizar
    $table = Get-ChildItem -Path $Path -File -Recurse #| Select-Object Name,Directory,Length,LastWriteTime
    
#Generamos un array con la cantidad de ocurrencias por files
    $arraydefiles=@{};

    foreach($linea in $table) {
    
            $filename=$linea.Name;

            if($arraydefiles.ContainsKey($filename)){
                $arraydefiles[$filename] = $arraydefiles[$filename] + 1;
            } else {
                $arraydefiles[$filename]=1;
            }

        }

#Buscamos los archivos duplicados y los informamos
    Write-Output "ARCHIVOS DUPLICADOS" >> $OutputFileName

    foreach($filename in $arraydefiles.Keys) {
        if($arraydefiles[$filename] -gt 1){
            $table | Where-Object {$_.Name -eq "$filename"} | Format-Table -Property Name,Directory,Length,LastWriteTime >> $OutputFileName
        }
    }

#Buscamos los que superen el Umbral y los informamos
    Write-Output "ARCHIVOS QUE SUPERAN EL UMBRAL: $Umbral Bytes" >> $OutputFileName

    $table | Where-Object {$_.Length -gt $Umbral} | Format-Table -Property Name,Directory,Length,LastWriteTime >> $OutputFileName

#Escribimos el mismo resultado generado en el archivo
    Get-Content -Path $OutputFileName

#FIN
