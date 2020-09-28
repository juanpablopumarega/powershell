Param (
 [Parameter(Position = 1, Mandatory = $false)]
 [String] $ryta = ".\"
)

$resultados = Get-ChildItem -Path $ruta -File -Recurse 
$archivos = @{}

foreach($resultado in $resultados){
    
    if($archivos.ContainsKey($resultado.Name) -eq $false){
        $dataArchivo = @{}
        $dataArchivo['directorio'] = $resultado.FullName #trae toda la ruta completa
        $dataArchivo['cantidad'] = 1
        $dataArchivo['tam'] = $resultado.Length #trae el tamaño del archivo
        $dataArchivo['modificado'] = $resultado.LastWriteTime #trae la fecha últma de modificacion
    
        $archivos[$resultado.Name] = $dataArchivo
    }else{
        $archivos[$resultado.Name]['cantidad'] = $archivos[$resultado.Name]['cantidad'] + 1
    }

}


foreach($archivoKey in $archivos.Keys){
    
    if($archivos[$archivoKey]['cantidad'] -gt 1){
       Write-Host $archivoKey  $archivos[$archivoKey]['directorio'] $archivos[$archivoKey]['modificado']
    }
}