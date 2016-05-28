#Converts a folder directory structure to a Json file to be used by D3.js Drag and Drop, Zoomable, Panning, Collapsible Tree with auto-sizing by Rob Schmuecker

#enter folder path
$folderpath = "D:\Folder Name"

$root =@{}
#name the root folder
$root["name"] = "Folder Name"

$dataraw = Get-ChildItem $folderpath -Recurse | ?{ $_.PSIsContainer } | Select-Object Name,Parent,FullName

$datamap = @{}
$datamap[$folderpath] = $root
foreach($child in $dataraw) {
    $datamap[$child.FullName] = @{"name"= $child.name; "size"= 1337; "children"=@()}
}


foreach($object in $dataraw)  {
    $parent = $datamap[$object.parent.FullName]
    if($parent) {
        if(!$parent["children"]) {
            $parent["children"] = @()
        }

        $parent["children"] += $datamap[$object.FullName]
    }
}

$datajson = ConvertTo-Json -depth 999 $root

#enter path where the Json file will be stored
$datajson | Out-File "D:\flare.json"