.equ BOTPAK ,    0x00280000    // bootpackのロード先
.equ DSKCAC ,    0x00100000    // ディスクキャッシュの場所
.equ DSKCAC0,    0x00008000    // ディスクキャッシュの場所（リアルモード）

// boot_info関係
.equ CYLS ,     0x0ff0      // ブートセクタが設定する
.equ LEDS ,     0x0ff1
.equ VMODE,     0x0ff2      // 色数に関する情報。何ビットカラーか？
.equ SCRNX,     0x0ff4      // 解像度のx
.equ SCRNY,     0x0ff6      // 解像度のy
.equ VRAM ,     0x0ff8      // グラフィックバッファの開始番地

.text
.code16
head:
// 画面モードを設定
    movb    $0x13, %al     // vgaグラフィックス、320x200x8bitカラー
    movb    $0x00, %ah
    int     $0x10

// 画面モードをメモする（c言語が参照する）
    movb    $8         , (VMODE)  
    movw    $320       , (SCRNX)
    movw    $200       , (SCRNY)
    movl    $0x000a0000, (VRAM)

// キーボードのled状態をbiosに教えてもらう
    movb    $0x02, %ah
    int     $0x16
    movb    %al  ,  (LEDS)

// picが一切の割り込みを受け付けないようにする
//  at互換機の仕様では、picの初期化をするなら、
//  こいつをcli前にやっておかないと、たまにハングアップする
//  picの初期化はあとでやる

    movb    $0xff, %al
    outb    %al  , $0x21
    nop            // out命令を連続させるとうまくいかない機種があるらしいので
    outb    %al  , $0xa1 

    cli            // さらにcpuレベルでも割り込み禁止

// cpuから1mb以上のメモリにアクセスできるように、a20gateを設定

    call    waitkbdout
    movb    $0xd1, %al
    outb    %al  , $0x64
    call    waitkbdout
    movb    $0xdf, %al     // enable a20
    outb    %al  , $0x60
    call    waitkbdout

.arch i486            # 32bitネイティブコード
// プロテクトモード移行
    lgdtl   (gdtr0)      // 暫定gdtを設定
    movl    %cr0       , %eax
    andl    $0x7fffffff, %eax  // bit31を0にする（ページング禁止のため）
    orl     $0x00000001, %eax  // bit0を1にする（プロテクトモード移行のため）
    movl    %eax       , %cr0
    jmp     pipelineflush

pipelineflush:
// セグメントレジスタの設定(CS以外)
    movw    $8 , %ax     //  読み書き可能セグメント32bit
    movw    %ax, %ds
    movw    %ax, %es
    movw    %ax, %fs
    movw    %ax, %gs
    movw    %ax, %ss


 // bootpackの転送
    movl  $bootpack,  %esi  // 転送元
    movl  $BOTPAK  ,  %edi  // 転送先
    movl  $131072  ,  %ecx 
    call  memcpy

// ついでにディスクデータも本来の位置へ転送
//// まずはブートセクタから
//
//    movl  $0x7c00, %esi    // 転送元
//    movl  $DSKCAC, %edi    // 転送先
//    movl  $128   , %ecx
//    call  memcpy
//
//// 残り全部
//    movl  $DSKCAC0+512, %esi // 転送元
//    movl  $DSKCAC +512, %edi // 転送先
//    movl  $0          , %ecx 
//    movb  (CYLS)      , %cl 
//    imull $4608       , %ecx // シリンダ数からバイト数/4に変換
//    subl  $128        , %ecx // iplの分だけ差し引く
//    call  memcpy

//// bootpackの起動
//    movl  $BOTPAK , %ebx
//    movl  16(%ebx), %ecx
//    addl  $3      , %ecx  // ecx += 3//
//    shrl  $2      , %ecx  // ecx /= 4//
//    jz    skip            // 転送するべきものがない movl  20(%ebx), %esi  // 転送元
//    addl  %ebx    , %esi  
//    movl  12(%ebx), %edi  // 転送先
//    call  memcpy

skip:
    movl   $BOTPAK, %esp  // スタック初期値
    ljmpl  $16, $0x0

waitkbdout:
    inb    $0x64, %al
    andb   $0x02, %al 
	  inb    $0x60, %al
    jnz    waitkbdout    // andの結果が0でなければwaitkbdoutへ
    ret

memcpy:
    movl   (%esi), %eax   
    addl   $4    , %esi  
    movl   %eax  , (%edi)
    addl   $4    , %edi  
    subl   $1    , %ecx   
    jnz    memcpy      // 引き算した結果が0でなければmemcpyへ
    ret
// memcpyはアドレスサイズプリフィクスを入れ忘れなければ、ストリング命令でも書ける

.align  16
gdt0:
.skip 8, 0x00
.word 0xffff, 0x0000, 0x9200, 0x00cf  // 読み書き可能
.word 0xffff, 0x0000, 0x9a28, 0x0047  // 実行可能

gdtr0:
.word 8*3-1
.int  gdt0

.align 16
bootpack:
