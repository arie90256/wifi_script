@echo off
color 0a
:matrix
setlocal EnableDelayedExpansion
:: Set the width of the console
mode con: cols=120 lines=40
:: Infinite loop for continuous rain effect
:loop
cls
for /L %%i in (1,1,40) do (
    set "line="
    for /L %%j in (1,1,120) do (
        set /A "value=!random! %% 3"
        if !value! == 0 (
            set "char= "
        ) else (
            set /A "char=!random! %% 2"
        )
        set "line=!line!!char!"
    )
    echo !line!
)
:: Shorter delay for smoother rain effect
timeout /t 0 /nobreak >nul
goto loop
