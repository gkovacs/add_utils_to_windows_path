# run as admin
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  $arguments = "& '" + $myinvocation.mycommand.definition + "'"
  Start-Process powershell -Verb runAs -ArgumentList $arguments
  Break
}

function getcallbat($source) {
  return "@CALL `"$source`" %*"
}

function mkbatfile($source, $targetname) {
  $target = "c:\windows\system32\$targetname.bat"
  if ((get-command "$targetname").path.length -gt 0) {
    echo "$targetname already in path"
  } elseif (test-path "$target") {
    echo "$target already exists"
  } else {
    if (test-path "$source") {
      echo (getcallbat "$source") | out-file -encoding ASCII "$target"
    } else {
      echo "$source not found"
    }
  }
}

function addpathifneeded($source, $targetname) {
  if ((get-command "$targetname").path.length -gt 0) {
    echo "$targetname already in path"
    return
  }
  if (-not (test-path "$source")) {
    echo "$source not found"
    return
  }
  $dirpath = (get-childitem $source).directory.fullname
  $profiledir = (get-childitem $source).directory.fullname
  if (-not (test-path "$profiledir")) {
    mkdir "$profiledir"
  }
  $env:Path += ";$dirpath"
  echo "`$env:Path += `"`;$dirpath`"" | out-file -encoding ASCII -append "$profile"
  # $profile # is the file pointing to the profile
  # add to it the line
  # $env:Path += ";C:\path\to\somepath\bin"
  # or
  # $env:Path = $env:Path + ";C:\path\to\somepath\bin"
}

mkbatfile "c:\program files\sublime text 3\subl.exe" "subl"
#mkbatfile "c:\program files\git\bin\git.exe" "git"
#mkbatfile "c:\program files\git\bin\ssh.exe" "ssh"
#mkbatfile "c:\program files\git\bin\bash.exe" "bash"
#mkbatfile "c:\mingw\msys\1.0\bin\rsync.exe" "rsync"
addpathifneeded "c:\mingw\msys\1.0\bin\rsync.exe" "rsync"
addpathifneeded "c:\mingw\msys\1.0\bin\ssh.exe" "ssh"
addpathifneeded "c:\program files\git\bin\git.exe" "git"
addpathifneeded "c:\program files\git\bin\ssh.exe" "ssh"
addpathifneeded "c:\program files\git\bin\bash.exe" "bash"
pause