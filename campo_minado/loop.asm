.data
	campo:			.word 0 0 0 0 0 0 0 0 0
				.word 0 1 0 0 0 0 0 0 0
				.word 0 0 2 0 0 0 0 0 0
				.word 0 0 0 3 0 0 0 0 0
				.word 0 0 0 0 4 0 0 0 0
				.word 0 0 0 0 0 3 0 0 0
				.word 0 0 0 0 0 0 2 0 0
				.word 0 0 0 0 0 0 0 1 0
				.word 0 0 0 0 0 0 0 0 0
	
	openFields:		.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
.text
	main:
				la $t0, campo
		li $t1, 9
		li $t2, 0
		loop_icampo:
			beq $t1, $t2, fimLoop_icampo
			li $t3, 0
			loop_jcampo:
				beq $t1, $t3, fimLoop_jcampo
				li $v0, 1
				lw $a0, ($t0)
				syscall
				addi $t0, $t0, 4
				addi $t3, $t3, 1
				j loop_jcampo
			fimLoop_jcampo:
			li $v0, 11
			li $a0, '\n'
			syscall
			addi $t2, $t2, 1
			j loop_icampo
		fimLoop_icampo:
		syscall
		syscall
		la $t0, openFields
		li $t1, 9
		li $t2, 0
		loop_if:
			beq $t1, $t2, fimLoop_if
			li $t3, 0
			loop_jf:
				beq $t1, $t3, fimLoop_jf
				li $v0, 1
				lw $a0, ($t0)
				syscall
				addi $t0, $t0, 4
				addi $t3, $t3, 1
				j loop_jf
			fimLoop_jf:
			li $v0, 11
			li $a0, '\n'
			syscall
			addi $t2, $t2, 1
			j loop_if
		fimLoop_if
	fim:
	li $v0, 10
	syscall
