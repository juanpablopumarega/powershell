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
    Determinar la existencia de archivos duplicados en el File System y cuáles archivos superan en tamaño un umbral determinado.

.PARAMETER Path
    [Requerido] Path absoluto o relativo a analizar.

.PARAMETER Resultado
    [Opcional] Path absoluto o relativo del directorio donde se generará el archivo de salida. Si no se informa se generará en el directorio de ejecución

.PARAMETER Umbral
    [Opcional] Tamaño definido en KB para definir el umbral a analizar. Opcional. Si no es indicado, se considerará como umbral el promedio de peso de los archivos inspeccionados

.EXAMPLE
    .\APL2Ejercicio3.ps1 -Path "C:\powershell\APL2Ejercicio3\files\" -Resultado "C:\powershell\APL2Ejercicio3\files\" -Umbral "1"

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
    [String]$Umbral="-1",

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

#Calculamos el promedio de los files
    if($Umbral.Equals("-1")){
        $Umbral=Get-ChildItem -Path $Path -File -Recurse | Measure-Object -Average Length | Select-Object -ExpandProperty average
    }

#Impresiones en pantalla de ejemplo
    #Write-Output ("El parametro -Path contiene $Path")
    #Write-Output ("El parametro -Umbral contiene $Umbral")
    #Write-Output ("El parametro -Resultado contiene $Resultado")

#Creamos el nombre de la variable de salida
    [string]$OutputFileName=$Resultado + "resultado" + "_" + (Get-Date -Format yyyy-mm-dd_hhmmss) + ".out";

#Armo el listado de los archivos a analizar
$ResultadoBusqueda=Get-ChildItem -Path $Path -File -Recurse -Name
$ResultadoBusqueda

#Generamos un array con la cantidad de ocurrencias por palabra
    $files=@{};

    foreach($PathfileName in $ResultadoBusqueda) {
    
        $fileName=[System.IO.Path]::GetFileName($PathfileName)

        if($files.ContainsKey($fileName)){
            $files[$fileName] = $files[$fileName] + 1;
        } else {
            $files[$fileName]=1;
        }

    }

$files





#FIN