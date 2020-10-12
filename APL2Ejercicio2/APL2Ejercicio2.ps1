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
    .\APL2Ejercicio2.ps1 -StopWords ".\files\StopWords.txt" -Entrada ".\files\Entrada.txt" -Resultado ".\files\"

#>
Param(
    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
                     if(-Not ($_ | Test-Path -PathType Leaf) ){
                        throw "El parametro debe contener el nombre del file junto con el path";
                        }
                    return $true 
                     })]
    [string]$StopWords,

    [parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript({
                     if(-Not ($_ | Test-Path -PathType Leaf) ){
                        throw "El parametro debe contener el nombre del file junto con el path";
                        }
                    return $true 
                     })]
    [string]$Entrada,

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


#Creamos un file temporal del fie de Entrada (si es que no esta vacio ya que da error en tal caso) en el directorio donde esta alojado el file a analizar pero convertido a mayuscula
    if ((Get-Content -Path "$Entrada").length -ne $Null) {
        (Get-Content "$Entrada" -Raw).ToUpper() | Out-File "$Entrada.mayus"
    } else {
        Write-Output "El archivo $Entrada esta vacio"
        exit 1
        }

#Creamos un file temporal del file de StopWords(si es que no esta vacio ya que da error en tal caso) en el directorio donde esta alojado el file a analizar pero convertido a mayuscula
    if ((Get-Content -Path "$StopWords").length -ne $Null) {
        (Get-Content "$StopWords" -Raw).ToUpper() | Out-File "$StopWords.mayus"
    } else {
        Write-Output "El archivo $StopWords esta vacio"
        }

#Eliminamos las StopWords del file de Entrada.mayus (temporal)
    foreach ($item in (Get-Content "$StopWords")){
      (Get-Content -path "$Entrada.mayus" -Raw) -replace "\b$item\b",'' | Set-Content "$Entrada.mayus"  
    }
    
#Generamos un array con la cantidad de ocurrencias por palabra
    $palabras=@{};

    foreach ($word in (-split (Get-Content -path "$Entrada.mayus"))){
        if($word -ne ""){ #Descarto las lineas vacias
            if($palabras[$word] -eq $Null){
                $palabras[$word]=1;
            } else {
                $palabras[$word] = $palabras[$word] + 1;
               }
        }
    }

#Creamos el nombre de la variable de salida
    [string]$OutputFileName=$Resultado + "frecuencias_" + [System.IO.Path]::GetFileNameWithoutExtension($Entrada) + "_" + (Get-Date -Format yyyy-mm-dd_hhmmss) + ".out";

#Ordeno el contenido del hash y lo exporto a CSV
    $palabras.GetEnumerator() | sort -Property Value -Descending | Select-Object -Property @{N='Palabra';E={$_.Key}},@{N='Ocurrencias';E={$_.Value}} | Export-Csv -Path $OutputFileName -Delimiter "," -NoTypeInformation -Encoding Unicode

#Muestro por pantalla los primeros 5 (incluyendo el titulo)
    Get-Content "$OutputFileName" | Select -first 6

#Removiendo los archivos temporales creados
    Remove-Item -Path "$StopWords.mayus";
    Remove-Item -Path "$Entrada.mayus";

#FIN
