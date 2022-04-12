Function Get-FileName($initialDirectory){#open file selector window
 [System.Reflection.Assembly]::LoadWithPartialName(“System.windows.forms”) |
 Out-Null
 $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
 $OpenFileDialog.initialDirectory = $initialDirectory
 $OpenFileDialog.filter = "All files(*.*)|*.*"
 $OpenFileDialog.ShowDialog() | Out-Null
 $OpenFileDialog.FileName
}
$file = Get-FileName
if ($file -Match "\\Data\\Reddit\\"){
    $dest=$file
    do{#find settings
        $dest = (new-object system.io.directoryinfo $dest).parent.FullName
	}while((Test-Path -Path $dest"\settings")-eq $false)#test if found settings
	$dest+='\settings\'
	$dest+=(get-childitem -Path $dest -filter "*_data*" ).name#get xml file

	$id=([xml](Get-Content $dest)).SelectNodes("//MediaData[@File='"+(Split-Path $file -leaf)+"']").ID.Substring(3)#get id of post

	echo ("https://reddit.com"+(((iwr reddit.com/comments/$id.json).content) | ConvertFrom-Json)[0].data.children[0].data.permalink)#get reddit post from api with ID
}else{
throw 'Not a Redit post'
}