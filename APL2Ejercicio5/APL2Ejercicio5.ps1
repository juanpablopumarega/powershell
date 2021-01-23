<#
.SYNOPSIS
    Actividad Práctica de Laboratorio Nro: 2 - Primera Entrega    
    
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
.\APL2Ejercicio5.ps1 -Aria ".\files\fileArias.txt" -Tags ".\files\fileTags.txt" -Web ".\files\fileHTML.txt" -Out ".\files"

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


$FileHTML = Get-Content $web;
$FileArias = Get-Content $Aria;
$FileTags = Get-Content $Tags;
#Creamos el nombre de la variable de salida
[string]$OutputFileName=$Out + "\accessibilityTest_" + (Get-Date -Format "{yyyy-MM-dd_HH-mm-ss}") + ".out";



$miClase = @{
    tag = "";
    array = @{};
    cantidad =0;
    }

$obj = [pscustomobject]::new($miClase);

$cont = 0;
foreach($tag in (-split "$FileTags")){
    $cont++;
}

$flagChange = 0;

$limitCont = $cont;

"{" >> $OutputFileName;
"`t["  >> $OutputFileName;

foreach($tag in (-split "$FileTags")){
    
    if($tag -ne ""){
    
        $FileHTML2 = $FileHTML | Select-String -pattern "<$tag" | Select-Object Linenumber, Line;

        foreach($arias in (-split $FileArias)){

            if($arias -ne ""){

                $FileHTML2 = $FileHTML2 | Where Line -NotMatch $arias | Select-Object Linenumber, Line;
                }
            }

        $obj.tag = $tag;
        $obj.array = $FileHTML2.LineNumber;
        $obj.cantidad = $FileHTML2.LineNumber.Length;

        if ($obj.cantidad -gt 0){
            $flagChange = 1;
        }
    

        $p = ConvertTo-Json $obj; 
        
        if($cont -ne 0 -and $cont -ne $limitCont){
            "`t`t," >> $OutputFileName;
        }
    
        "`t`t" + $p >> $OutputFileName;
        $cont--;
        }
    }

"`t]" >> $OutputFileName;
"}" >> $OutputFileName;

Write-Output "El proceso finalizó.";
if($flagChange -gt 0){
    Write-Output "Se deben realizar cambios.";
}else{
    Write-Output "No es necesario realizar cambios.";
}


#FIN
