# Hexadecimal conversion
# Code was originaly copied from 
# https://stackoverflow.com/questions/26182289/convert-from-decimal-to-hexadecimal-in-cmake
cmake_minimum_required (VERSION 2.6.4)

macro(HEXCHAR2DEC VAR VAL)
    if (${VAL} MATCHES "[0-9]")
        set(${VAR} ${VAL})
    elseif(${VAL} MATCHES "[aA]")
        set(${VAR} 10)
    elseif(${VAL} MATCHES "[bB]")
        set(${VAR} 11)
    elseif(${VAL} MATCHES "[cC]")
        set(${VAR} 12)
    elseif(${VAL} MATCHES "[dD]")
        set(${VAR} 13)
    elseif(${VAL} MATCHES "[eE]")
        set(${VAR} 14)
    elseif(${VAL} MATCHES "[fF]")
        set(${VAR} 15)
    else()
        message(FATAL_ERROR "Invalid format for hexidecimal character")
    endif()
endmacro(HEXCHAR2DEC)

macro(HEX2DEC VAR VAL)
    set(${VAR} 0)
    set(__curindex 0)
    string(LENGTH "${VAL}" __curlength)
    while (__curindex LESS  __curlength)
        string(SUBSTRING "${VAL}" ${__curindex} 1 __char)
        hexchar2dec(__char ${__char})
        math(EXPR __powah "(1<<((${__curlength}-${__curindex}-1)*4))")
        math(EXPR __char "(${__char}*${__powah})")
        math(EXPR ${VAR} "${${VAR}}+${__char}")
        math(EXPR __curindex "${__curindex}+1")
    endwhile()

    set(__curindex)
    set(__curlength)
    set(__powah)
    set(__char)
endmacro(HEX2DEC)

macro(DECCHAR2HEX VAR VAL)
    if (${VAL} LESS 10)
        set(${VAR} ${VAL})
    elseif(${VAL} EQUAL 10)
        set(${VAR} "A")
    elseif(${VAL} EQUAL 11)
        set(${VAR} "B")
    elseif(${VAL} EQUAL 12)
        set(${VAR} "C")
    elseif(${VAL} EQUAL 13)
        set(${VAR} "D")
    elseif(${VAL} EQUAL 14)
        set(${VAR} "E")
    elseif(${VAL} EQUAL 15)
        set(${VAR} "F")
    else()
        message(FATAL_ERROR "Invalid format for hexidecimal character")
    endif()
endmacro(DECCHAR2HEX)

macro(DEC2HEX VAR VAL)
    if(${VAL} EQUAL 0)
        set(${VAR} 0)
    else()
        set(__val ${VAL})
        set(${VAR} "")

        while(${__val} GREATER 0)
            math(EXPR __valchar "(${__val}&15)")
            decchar2hex(__valchar ${__valchar})
            set(${VAR} "${__valchar}${${VAR}}")
            math(EXPR __val "${__val} >> 4")
        endwhile()
    endif()
    
    unset(__valchar)
    unset(__val)
endmacro(DEC2HEX)

