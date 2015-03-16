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

mkbatfile "c:\program files\sublime text 3\subl.exe" "subl"
mkbatfile "c:\program files\git\bin\git.exe" "git"
mkbatfile "c:\program files\git\bin\ssh.exe" "ssh"
mkbatfile "c:\mingw\msys\1.0\bin\rsync.exe" "rsync"
pause