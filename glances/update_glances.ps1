Stop-Service -Name "glances"
pip install --upgrade glances
Start-Service -Name "glances"
