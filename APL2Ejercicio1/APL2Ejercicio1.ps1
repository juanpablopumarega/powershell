Param (
    [Parameter(Position = 1, Mandatory = $false)]
    [String] $pathSalida = ".\procesos.txt",
    [int] $cantidad = 3
)
    $existe = Test-Path $pathSalida
    
    if ($existe -eq $true) {
    
        $procesos = Get-Process | Where-Object { $_.WorkingSet -gt 100MB }
        $procesos | Format-List -Property Id,Name >> $pathSalida
        
        for ($i = 0; $i -lt $cantidad ; $i++) {
            Write-Host $procesos[$i].Id - $procesos[$i].Name
            }

    } else {
        Write-Host "El path no existe"
    }

<#
Responder:
1. ¿Cuál es el objetivo del script?
    *Listar los procesos del sistema operativo Windows que consumen mas de 100MB de Memoria.
    *También se muestra por pantalla 3 de estos procesos (ajustable por parametro dicha cantidad).

2. ¿Agregaría alguna otra validación a los parámetros?
    *Se podría validar que el parametro cantidad sea un entero postivo.
    *Se podría agregar una ayuda (Get-Help) para facilitar el entendimiento del script.

3. ¿Qué sucede si se ejecuta el script sin ningún parámetro?
    *En el caso de no tener el archivo ".\procesos.txt" creado. Se imprime por pantalla un mensaje que dice "El path no existe"
    *Si existe el archivo, por defecto te lista por pantalla, los primeros 3 procesos encontrados.

#>