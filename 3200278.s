#	Computer Systems Organization
#	Winter Semester 2021-2022
#	1st Assignment
#
# 	Pseudocode by MARIA TOGANTZH (mst@aueb.gr)
#
# 	MIPS Code by Georgios Bilias, p3200278@aueb.gr, 3200278 
# 	(Please note your name, e-mail and student id number)


	.text
	.globl __start		

# ------------------- Read and Validate Data ------------------------------

__start:	
  	
      lw $t0,counter                  	 	# counter = 4
						#
loop: 	

      beqz $t0, exit_loop	 			# while counter != 0 do
						#
      li $v0, 12
      syscall					#	Read hex character in $v0
						# 		
     blt $v0,'0',exit_on_error
     bge $v0,'0',l1              
 l1: ble $v0,'9',isHex
     bge $v0,'A',l2
 l2: ble $v0,'F',isHex				# 	if charakter is not ('0'..'9') and is not ('A'..'F') then
						# 			goto exit_on_error
						# 		else 	
     j exit_on_error				# 			goto isHex
						#		
						#
isHex:					# 	shift left $t1
						# 	pack $v0 to $t1 
     sll $t1,$t1,8  			        
     or $t1,$v0,$t1                              
     sub $t0,$t0,1 
     j loop					# 	counter = counter - 1
						#
						# goto loop
		
# ------------------- Calculate Decimal Number -----------------------------		

exit_loop:					# print '\n'
						#
  li $v0,4
  la $a0, space
  syscall
 
                           			
  addi $t3,$0,0 
  lw $t4,counter 
  addi $t5,$0,1					# result = 0
						#
						# counter = 4
						# 
  addi $s1,$0,255
 
        					# power = 1
						# 
					        # $s1 = 255 (mask = 11111111)					
					        #
loop2:					# while counter != 0 do
						# 	
  beqz $t4,exit_loop2  
   		
   and $t2,$t1,$s1                    # 	$t2 =  least significant byte from $t1 (unpack)        
   srl $t1,$t1,8                   	# 	shift right $t1 	
   
   blt $t2,'A',l3                        # 	if $t2 is letter A..F then
   ble $t2,'F',l4                        # 		$t2 = $t2 - 55
 l3: sub $t2,$t2,48                       # 	else 
  j l5
 l4: sub $t2,$t2,55                       #		$t2 = $t2 - 48
 						
						
 l5: mul $t2,$t2,$t5											
 mul $t5,$t5,16						
 sub $t4,$t4,1					
 add $t3,$t3,$t2         			
						
 j loop2					#
						# 	$t2 = $t2 * power
						# 	power = power * 16
						# 	counter = counter - 1
						# 	result = result + $t2
						#
						# goto loop2

# ------------------- Print Results ------------------------------------		

exit_loop2:				# print result

   la $a0,($t3)
   li $v0,1
   syscall					#
   
   j exit					# goto exit
						#
exit_on_error:			#
						# 
 li $v0,4                                     # print '\n'					
 la $a0, space                                #
 syscall
 						
 li $v0,4                                      # print error message						
 la $a0, error                                #
 syscall					
						#
						#
exit:					
						# print '\n'
 li $v0,4
 la $a0, space
 syscall            				
 									
 li $v0,10
 syscall					# exit
         					#

	.data

counter: .word 4
space: .asciiz "\n"
error: .asciiz "Wrong Hex Number ..." 
