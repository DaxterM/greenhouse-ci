$ErrorActionPreference = "Stop";
trap { $host.SetShouldExit(1) }

$Error.Clear()
Configuration CFWindows {
  Node "localhost" {

    WindowsFeature IISWebServer {
      Ensure = "Present"
        Name = "Web-Webserver"
    }
  }
}

Install-WindowsFeature DSC-Service
CFWindows
Start-DscConfiguration -Wait -Path .\CFWindows -Force -Verbose

if ($Error) {
  Write-Host "Error summary:"
  foreach($ErrorMessage in $Error)
  {
    Write-Host $ErrorMessage
  }
  Write-Error "Setup failed. The above errors occurred."
} else {
  Write-Host "Setup completed successfully."
}
