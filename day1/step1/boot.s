.byte 0xeb, 0x4e, 0x90 

// 以下は標準的なFAT12フォーマットフロッピーディスクのための記述
.ascii "HELLOIPL"           // ブートセクタの名前を自由に書いてよい(8バイト)             
.word 512                   // 1セクタの大きさ(512にしなければいけない)                  
.byte 1                     // クラスタの大きさ(1セクタにしなければいけない)             
.word 1                     // FATがどこから始まるか(普通は1セクタ目からにする)          
.byte 2                     // FATの個数(2にしなければいけない)                          
.word 224                   // ルートディレクトリ領域の大きさ(普通は224エントリにする)   
.word 2880                  // このドライブの大きさ(2880セクタにしなければいけない)      
.byte 0xf0                  // メディアのタイプ(0xf0にしなければいけない)                
.word 9                     // FAT領域の長さ(9セクタにしなければいけない)                
.word 18                    // 1トラックにいくつのセクタがあるか(18にしなければいけない) 
.word 2                     // ヘッドの数(2にしなければいけない)                         
.int 0                      // パーティションを使ってないのでここは必ず0                 
.int 2880                   // このドライブの大きさをもう一度書く                        
.byte 0, 0, 0x29            // よく分からないけどこの値にしておくといいらしい            
.int 0xffffffff             // たぶんボリュームシリアル番号                              
.ascii "HELLO-OS   "        // ディスクの名前(11バイト)                                  
.ascii "FAT12   "           // フォーマットの名前(8バイト)                               
.org . + 18                 // とりあえず18バイトあけておく                              


/* https://sourceware.org/binutils/docs/as/i386_002dVariations.html#i386_002dVariations
---
In AT&T syntax the size of memory operands is determined from the last character of the instruction mnemonic. Mnemonic suffixes of ‘b’, ‘w’, ‘l’ and ‘q’ specify byte (8-bit), word (16-bit), long (32-bit) and quadruple word (64-bit) memory references. Intel syntax accomplishes this by prefixing memory operands (not the instruction mnemonics) with ‘byte ptr’, ‘word ptr’, ‘dword ptr’ and ‘qword ptr’. Thus, Intel ‘mov al, byte ptr foo’ is ‘movb foo, %al’ in AT&T syntax.
---
*/

// プログラム本体

.byte 0xb8, 0x00, 0x00, 0x8e, 0xd0, 0xbc, 0x00, 0x7c
.byte 0x8e, 0xd8, 0x8e, 0xc0, 0xbe, 0x74, 0x7c, 0x8a
.byte 0x04, 0x83, 0xc6, 0x01, 0x3c, 0x00, 0x74, 0x09
.byte 0xb4, 0x0e, 0xbb, 0x0f, 0x00, 0xcd, 0x10, 0xeb
.byte 0xee, 0xf4, 0xeb, 0xfd

// メッセージ部分
.byte 0x0a, 0x0a            // 改行を2つ
.ascii "hello, world"
.byte 0x0a                  // 改行
.byte 0

.org 510
.byte 0x55, 0xaa

// 以下はブートセクタ以外の部分の記述
.byte 0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
.org 512 * 10
.byte 0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
.org 1440 * 1024
