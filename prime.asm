# MARS MIPS
# Author: Danilo C. Fuchs
# Equivalent of program at ROM

	.data
array:	.space	128
	.text
addi	$t2,$zero,32
addi	$t3,$zero,1
seed:	sb	$t3,array($t3)
	addi 	$t3,$t3,1
	slt	$t4,$t3,$t2
	beq	$t4,1,seed

	addi	$t1,$zero,0
	
	addi	$t3,$zero,4
rm2:	sb	$t1,array($t3)
	addi 	$t3,$t3,2
	slt	$t4,$t3,$t2
	beq	$t4,1,rm2

	addi	$t3,$zero,9
rm3:	sb	$t1,array($t3)
	addi 	$t3,$t3,3
	slt	$t4,$t3,$t2
	beq	$t4,1,rm3

	addi	$t3,$zero,25
rm5:	sb	$t1,array($t3)
	addi 	$t3,$t3,5
	slt	$t4,$t3,$t2
	beq	$t4,1,rm5
	
	addi	$t3,$zero,1
	addi	$t5,$zero,127
print:	addi	$t3,$t3,1
	lb	$t1,array($t3)
	sb	$t1,array($t5)
	beq	$t3,$t2,end
	j	print
	
end:	nop