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
    Reconocer las etiquetas HTML utilizados en la página web que no contengan ningún atributo aria.

.PARAMETER Aria
    [Requerido] Path absoluto o relativo del archivo que contiene la lista de atributos aria.

.PARAMETER Tags
    [Requerido] Path absoluto o relativo del archivo que contiene la lista de etiquetas a analizar.

.PARAMETER Web
    [Requerido] Path absoluto o relativo del archivo HTML a evaluar.

.PARAMETER Out
    [Requerido] Path absoluto o relativo del archivo de salida.
    

.EXAMPLE
.\APL2Ejercicio5.ps1 -Aria "C:\Users\natal\OneDrive\Desktop\SistemasOperativos\Repositorio\powershell\APL2Ejercicio5\files\fileArias.txt" -Tags "C:\Users\natal\OneDrive\Desktop\SistemasOperativos\Repositorio\powershell\APL2Ejercicio5\files\fileTags.txt" -Web "C:\Users\natal\OneDrive\Desktop\SistemasOperativos\Repositorio\powershell\APL2Ejercicio5\files\fileHTML.txt" -Out "C:\Users\natal\OneDrive\Desktop\SistemasOperativos\Repositorio\powershell\APL2Ejercicio5\files\"

#>

param([parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
                     if(-Not ($_ | Test-Path) ){
                        throw "No existe el directorio o el File especificado";
                        }
                     return $true 
                     })]
    [string]$Aria,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
                     if(-Not ($_ | Test-Path) ){
                        throw "No existe el directorio o el File especificado";
                        }
                     return $true 
                     })]
    [string]$Tags,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
                     if(-Not ($_ | Test-Path) ){
                        throw "No existe el directorio o el File especificado";
                        }
                     return $true 
                     })]
    [string]$Web,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
                     if(-Not ($_ | Test-Path) ){
                        throw "No existe el directorio o el File especificado";
                        }
                     return $true 
                     })]
    [string]$Out
)

$FileHTML = Get-Content $Web

$FileArias = Get-Content $Aria

$FileTags = Get-Content $Tags

[int]$i = 1

$Array = @{}

foreach($linea in $FileHTML){
    $Array[$i] = $linea
    $i ++
}


#$Array |Format-Table -property Name,Value| Where-Object Value -in "div"

#$Array|where{$_.Value -like "*div*"}

$prueba = {$Array.Value -like "*div*"}