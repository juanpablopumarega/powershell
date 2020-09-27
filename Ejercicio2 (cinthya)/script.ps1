Param (
 [Parameter(Position = 1, Mandatory = $false)]
 [String] $stopWords = ".\stopWords.txt ",
 [String] $resultado = ".\resultado.txt",
 [String] $entrada = ".\entrada.txt"
)
$existeEntrada = Test-Path $entrada

if ($existeEntrada -eq $true) {

    $existeStopWords = Test-Path $stopWords

    if ($existeStopWords -eq $true) {
        
        $data = @{}
    
        foreach($lineaSw in Get-Content $stopWords) {
           foreach($wordSw in $lineaSw.Split()){
                   $data[$wordSw] = 1
           }
        }

        $array = @{}

        foreach($line in Get-Content $entrada) {
           foreach($word in $line.Split()){
          
            if($data.ContainsKey($word) -eq $false){
               $word = $word.ToUpper()

               if($array.ContainsKey($word) -eq $true){
                    $array[$word] = $array[$word] + 1
               }else{
                $array[$word] = 1
               }
            }

           }
        }

        #Sort-Object $array

        $array.Keys | % { "$_," + $array.Item($_) }
        

    }else{
        Write-Host "El path de stopwords no existe"
    }

} else {
 Write-Host "El path de entrada no existe"
}