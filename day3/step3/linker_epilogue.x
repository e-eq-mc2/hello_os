OUTPUT_FORMAT(binary)
OUTPUT_ARCH(i386)

SECTIONS
{
  . = 0x0;
  .text : {*(.text)}
  .data : {*(.data)}
}
