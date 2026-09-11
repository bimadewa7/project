@echo off
title Bima Arya Dewa - Portfolio Server
echo ==========================================================
echo   BIMA ARYA DEWA - EDITORIAL PORTFOLIO SERVER
echo   Music Box plays nonstop audio seamlessly across pages!
echo ==========================================================
echo.
echo Launching http://localhost:8000/bio.html in default browser...
start http://localhost:8000/bio.html
echo.
echo Server running at http://localhost:8000/ (Press Ctrl+C to stop)
python -m http.server 8000
pause
