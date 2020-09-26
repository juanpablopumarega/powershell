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
    Se contabilizan las palabras contenidas dentro del archivo Entrada sin tener en cuenta las palabras que aloja el archivo StopWords. 
    Se generará una archivo ordenado de mayor a menor concurrencia de palabras encontradas.

.PARAMETER StopWords
    [Requerido] Path absoluto o relativo del archivo con los stopwords.

.PARAMETER Entrada
    [Requerido] Path absoluto o relativo del archivo de texto a analizar.

.PARAMETER Resultado
    [Opcional] Path absoluto o relativo del directorio donde se generará el archivo de salida. Si no se informa se generará en el directorio de ejecución.

.EXAMPLE
    .\APL2Ejercicio2.ps1 -StopWords "C:\powershell\APL2Ejercicio2\files\StopWords.txt" -Entrada "C:\powershell\APL2Ejercicio2\files\Entrada.txt" -Resultado "C:\powershell\APL2Ejercicio2\files\"

#>
Param(
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
                     if(-Not ($_ | Test-Path) ){
                        throw "No existe el directorio o el File especificado";
                        }
                     if(-Not ($_ | Test-Path -PathType Leaf) ){
                        throw "El parametro debe contener el nombre del file junto con el path";
                        }
                    return $true 
                     })]
    [string]$StopWords,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
                     if(-Not ($_ | Test-Path) ){
                        throw "No existe el directorio o el File especificado";
                        }
                     if(-Not ($_ | Test-Path -PathType Leaf) ){
                        throw "El parametro debe contener el nombre del file junto con el path";
                        }
                    return $true 
                     })]
    [string]$Entrada,

    [parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [string]$Resultado
)


Write-Output ("El parametro -StopWords contiene $StopWords")
Write-Output ("El parametro -Entrada contiene $Entrada")
Write-Output ("El parametro -Resultado contiene $Resultado")

