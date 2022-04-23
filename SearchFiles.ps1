function Search-Image-In-Files {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, HelpMessage = "Enter the folder where you have your images.")]
        [string]$MediaFolder,

        [Parameter(Mandatory, HelpMessage = "Enter the folder where you have your content/text files.")]
        [string]$ContentFolder,

        [Parameter(Mandatory, HelpMessage = "Enter your image extension (default is .png).")]
        [string]$MediaFileType,

        [Parameter(Mandatory, HelpMessage = "Enter your content extension (default is .md).")]
        [string]$ContentFileType,

        [Parameter(Mandatory, HelpMessage = "Enter the results path.")]
        [string]$Results,

        [string[]]$UsedImages
    )

    #Check each media file from folder
    Get-ChildItem -Path $MediaFolder -Include $MediaFileType -Recurse | ForEach-Object {
        #Media file name
        $mediaFileName = $_.Name;

        #Check each .md file from folder
        Get-ChildItem -Path $ContentFolder -Include $ContentFileType -Recurse | ForEach-Object {
            #.md file name
            $contentFile = Get-Content -Path $_.FullName;
        
            $containsImage = $contentFile | ForEach-Object { $_ -match $mediaFileName }

            #if the image is used in the .md file add it to the list
            if ($containsImage -contains $true -and $UsedImages -notcontains $mediaFileName) {
                $UsedImages += $mediaFileName;
            } 
        }
    }

    Get-ChildItem -Path $MediaFolder -Include $MediaFileType -Recurse | ForEach-Object {
        $FileName = $_.Name;
        $exists = $FileName -In $UsedImages

        if ($exists) {
            Add-Content -Path $Results\UsedImages.txt -Value $FileName
        }
        else {
            Add-Content -Path $Results\UnsedImages.txt -Value $FileName
        }
    }
}