@echo off
SETLOCAL

IF NOT EXIST builds mkdir builds
cd builds

IF EXIST "%2_html" rmdir /s /q "%2_html"
..\..\pico8.exe ..\%1 -export "-w -f %2.html"

7z a -tzip .\%2_html\%2.zip .\%2_html\%2.js .\%2_html\%2.wasm .\%2_html\index.html