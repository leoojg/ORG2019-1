.data
	initMessage: 		.asciiz "Bem vindo ao campo minado!!\n\n"
	difficultyMessage:	.asciiz "a)5x5   b)7x7   c)9x9\nEscolha entre uma dificuldade acima: "
	difficultyMessageError: .asciiz "\n\n\n\nESCOLHA UMA OPCAO VALIDA!!\n"
	difficultyData:		.space 5			## Utilizado para leitura da dificuldade
	startMessage:		.asciiz "\n\n\n\n\nComeco do jogo:\n"
	lineMessage:		.asciiz "Escolha uma linha para começar(a linha precisa ser valida de acordo com a dificuldade): "
	columnMessage:		.asciiz "Agora escolha a coluna(a coluna precisa ser valida de acordo com a dificuldade): "
	
	
	barran:			.asciiz "\n"

	explosionMessage:	.asciiz "Uma bomb explodiu!!\n\n\nFim de jogo"

	campo:			.word 0 0 9 0 9 0 0 0 0
				.word 0 0 0 0 9 0 0 0 0
				.word 9 0 0 0 0 0 9 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 9 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 9 0 9 0 0 0
				.word 0 0 9 9 0 0 0 0 0
.text

	main:							###  Inicio do programa
		li $v0, 4
		la $a0, initMessage
		syscall

	difficulty:						## Escolha da dificuldade
		la $a0, difficultyMessage
		syscall

		li $v0, 8
		la $a0, difficultyData
		li $a1, 5
		syscall						## Leitura da dificuldade

		la $s0, difficultyData
		lb $t1, ($s0)
		la $t0, 'a'
		li $s7, 5
		beq $t0, $t1, check

		la $t0, 'b'
		li $s7, 7
		beq $t0, $t1, check

		la $t0, 'c'
		li $s7, 9
		beq $t0, $t1, check

	check:										## Verifica se o que foi digitado tem um \n na sequencia
		addi $s0, $s0, 1
		lb $t1, ($s0)
		la $t0, '\n'
		beq $t0, $t1, game

	goBack:
		li $v0, 4
		la $a0, difficultyMessageError
		syscall
		j difficulty								## Volta pra leitura da dificuldade, pois a inserida foi invalida.

	game:
		li $v0, 4
		la $a0, startMessage
		syscall
		
		la $a0, campo
		move $a1, $s7
		jal calcula_bombas
				

	fim:
		
	## Fim da main
	li $v0, 10
	syscall

	calcula_bombas:
	
		move $t0, $a0								## $t0 = endereco da matriz campo
		move $t1, $a1								## $t1 = ordem da matriz campo
		move $t2, $t0								## $t2 -> offset na matriz
		li $t3, 0								## $t3 -> i = 0

		loop_i:
			beq $t1, $t3, fimLoop_i
			li $t4, 0							## $t4 -> j = 0

			loop_j:
				beq $t1, $t4, fimLoop_j
				lw $t5, ($t2)						## Carrega campo[i][j] em $t5
				beq $t5, 9, isBomb					## Se campo[i][j] for bomba, pula isBomb
				li $t6, 0						## $t6 -> Quantidade de bombas ao redor de campo[i][j], no momento 0

				## Calcula a quantidade de bombas ao redor de i, j
											## campo[i-1][j-1]
				beq $t3, $zero, _menos4					## se i = 0 pula para campo[i][j-1]
				beq $t4, $zero, _menos36				## se j = 0 pula para campo[i-1][j]
				addi $t7, $t2, -40					## $t7 tem endereço de campo[i-1][j-1]
				lw $t5, ($t7)						## $t7 = campo[i-1][j-1]
				seq $t7, $t5, 9						## $t7 = 1 se campo[i-1][j-1] = 9 senao 0
				add $t6, $t6, $t7					## $t6 += $t7

				_menos36:						## campo[i-1][j]
				addi $t7, $t2, -36					## $t7 tem endereço de campo[i-1][j]
				lw $t5, ($t7)						## $t7 = campo[i-1][j]
				seq $t7, $t5, 9						## $t7 = 1 se campo[i-1][j] = 9 senao 0
				add $t6, $t6, $t7					## $t6 += $t7

											## campo[i-1][j+1]
				beq $t4, $t7, _menos4					## se j = n, pula para campo[i][j-1]
				addi $t7, $t2, -32					## $t7 tem endereço de campo[i-1][j+1]
				lw $t5, ($t7)						## $t7 = campo[i-1][j+1]
				seq $t7, $t5, 9						## $t7 = 1 se campo[i-1][j+1] = 9 senao 0
				add $t6, $t6, $t7					## $t6 += $t7

				_menos4:						## campo[i][j-1]
				beq $t4, $zero, _4					## se j = 0 pula para campo[i][j+1]
				addi $t7, $t2, -4					## $t7 tem endereço de campo[i][j-1]
				lw $t5, ($t7)						## $t7 = campo[i][j-1]
				seq $t7, $t5, 9						## $t7 = 1 se campo[i][j-1] = 9 senao 0
				add $t6, $t6, $t7					## $t6 += $t7

				_4:							## campo[i][j+1]
				beq $t4, $t1, _32					## se j = n, pula para campo[i+1][j-1]
				addi $t7, $t2, 4					## $t7 tem endereço de campo[i][j+1]
				lw $t5, ($t7)						## $t7 = campo[i][j+1]
				seq $t7, $t5, 9						## $t7 = 1 se campo[i][j+1] = 9 senao 0
				add $t6, $t6, $t7					## $t6 += $t7

				_32:							## campo[i+1][j-1]
				beq $t3, $t1, setBombs					## se i = n, pula para setBombs
				addi $t7, $t2, 32					## $t7 tem endereço de campo[i+1][j-1]
				lw $t5, ($t7)						## $t7 = campo[i+1][j-1]
				seq $t7, $t5, 9						## $t7 = 1 se campo[i+1][j-1] = 9 senao 0
				add $t6, $t6, $t7					## $t6 += $t7

											## campo[i+1][j]
				addi $t7, $t2, 36					## $t7 tem endereço de campo[i+1][j]
				lw $t5, ($t7)						## $t7 = campo[i+1][j]
				seq $t7, $t5, 9						## $t7 = 1 se campo[i+1][j] = 9 senao 0
				add $t6, $t6, $t7					## $t6 += $t7

											## campo[i+1][j+1]
				beq $t4, $t1, setBombs					## se j = n, pula para setBombs
				addi $t7, $t2, 40					## $t7 tem endereço de campo[i+1][j+1]
				lw $t5, ($t7)						## $t7 = campo[i+1][j+1]
				seq $t7, $t5, 9						## $t7 = 1 se campo[i+1][j+1] = 9 senao 0
				add $t6, $t6, $t7					## $t6 += $t7

				setBombs:						## Adiciona o valor calculado das bombas ao redor de i, j em campo[i][j]
				sw $t6, ($t2)
				isBomb:

				lw $t5, ($t2)
				li $v0, 1
				move $a0, $t5
				syscall

				addi $t2, $t2, 4					## offset += 4
				addi $t4, $t4, 1					## j += 1
				j loop_j
			fimLoop_j:

			li $v0, 4
			la $a0, barran
			syscall
			
			mul $t5, $t3, 36
			add $t5, $t5, $t0
			move $t2, $t5
			addi $t3, $t3, 1
			j loop_i
		fimLoop_i:	
	jr $ra
