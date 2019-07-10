.data
	initMessage: 		.asciiz "Bem vindo ao campo minado!!\n\n"
	difficultyMessage:	.asciiz "a)5x5   b)7x7   c)9x9\nEscolha entre uma dificuldade acima: "
	difficultyMessageError: .asciiz "\n\n\n\nESCOLHA UMA OPCAO VALIDA!!\n"
	difficultyData:		.space 5			## Utilizado para leitura da dificuldade
	startMessage:		.asciiz "\nComeco do jogo:\n"
	lineMessage:		.asciiz "Escolha uma linha(a linha precisa ser valida de acordo com a dificuldade): "
	columnMessage:		.asciiz "Agora escolha a coluna(a coluna precisa ser valida de acordo com a dificuldade): "
	getLineColumnMessage:	.asciiz "\n\nInsira uma opcao valida!!\n"
	alreadyChoseMessage:	.asciiz "\nVoce ja escolheu essa posicao!!\n"
	newMoveMessage:		.asciiz "\nNova jogada!!\n\n"
	explosionMessage:	.asciiz "\nUma bomba explodiu!!\n\n"
	endGameMessage:		.asciiz "\nFim de jogo"
	semente:		.asciiz		"\nEntre com a semente da funcao Rand: "
	espaco:			.asciiz		" "
	nova_linha:		.asciiz		"\n"
	posicao:		.asciiz		"\nPosicao: "
	salva_S0:		.word		0
	salva_ra:		.word		0
	salva_ra1:		.word		0

	openFields:		.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0

	campo:			.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0
				.word 0 0 0 0 0 0 0 0 0

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

	goBack:
		li $v0, 4
		la $a0, difficultyMessageError
		syscall
		j difficulty								## Volta pra leitura da dificuldade, pois a inserida foi invalida.

	check:										## Verifica se o que foi digitado tem um \n na sequencia
		addi $s0, $s0, 1
		lb $t1, ($s0)
		la $t0, '\n'
		beq $t0, $t1, game

	game:
		li $v0, 4
		la $a0, startMessage
		syscall
		
		la $a0, campo
		move $a1, $s7
		jal INSERE_BOMBA
		la $a0, campo								## Carrega endereco de campo em $a0
		move $a1, $s7								## Coloca a ordem da matriz campo em $a1
		jal calcula_bombas
		j getLineColumn

	lineColumnMessageError:
		li $v0, 4
		la $a0, getLineColumnMessage
		syscall
		j getLineColumn
	lineColumnAlreadyChose:
		li $v0, 4
		la $a0, alreadyChoseMessage
		syscall
	getLineColumn:
		li $v0, 4
		la $a0, lineMessage
		syscall
		li $v0, 5
		syscall									## Lï¿½ i
		move $t0, $v0
		li $v0, 4
		la $a0, columnMessage
		syscall									## Lï¿½ j
		li $v0, 5
		syscall
		move $t1, $v0
											## Verifica se i e j sco validos de acordo com a dificuldade
		addi $t6, $s7, 1
		slt $t5, $zero, $t0
		beq $zero, $t5, lineColumnMessageError
		slt $t5, $zero, $t1
		beq $zero, $t5, lineColumnMessageError
		slt $t5, $t0, $t6
		beq $zero, $t5, lineColumnMessageError
		slt $t5, $t1, $t6
		beq $zero, $t5, lineColumnMessageError
		
		addi $t0, $t0, -1
		addi $t1, $t1, -1
		mul $t0, $t0, 36
		mul $t1, $t1, 4
		add $t3, $t0, $t1							## Offset de [i][j] na matriz
		
		
		la $t0, campo
		la $t1, openFields
		add $t4, $t1, $t3
		lw $t5, ($t4)
		bne $t5, $zero, lineColumnAlreadyChose					## Volta para leitura de i, j pois esse campo ja foi escolhido
		li $t5, 1
		sw $t5, ($t4)								## Seta openFields[i][j] para 1
		add $t4, $t0, $t3
		lw $t5, ($t4)
		beq $t5, 9, fim
		
		li $v0, 4
		la $a0, newMoveMessage							## Mensagem para realizar outra jogada
		syscall
		
		move $a0, $t0								## Carrega endereco de campo em $a0
		move $a1, $t1								## Carrega endereco de openFields em $a1
		move $a2, $s7								## Coloca a ordem da matriz campo em $a2
		jal mostra_campo
		j getLineColumn
		
	

	fim:
		li $v0, 4
		la $a0, explosionMessage
		syscall
		move $a0, $t0								## Carrega endereco de campo em $a0
		move $a1, $t1								## Carrega endereco de openFields em $a1
		move $a2, $s7								## Coloca a ordem da matriz campo em $a2
		jal mostra_campo
		li $v0, 4
		la $a0, endGameMessage
		syscall
		
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
				addi $t7, $t2, -40					## $t7 tem endereco de campo[i-1][j-1]
				lw $t5, ($t7)						## $t7 = campo[i-1][j-1]
				seq $t7, $t5, 9						## $t7 = 1 se campo[i-1][j-1] = 9 senao 0
				add $t6, $t6, $t7					## $t6 += $t7

				_menos36:						## campo[i-1][j]
				addi $t7, $t2, -36					## $t7 tem endereco de campo[i-1][j]
				lw $t5, ($t7)						## $t7 = campo[i-1][j]
				seq $t7, $t5, 9						## $t7 = 1 se campo[i-1][j] = 9 senao 0
				add $t6, $t6, $t7					## $t6 += $t7

											## campo[i-1][j+1]
				beq $t4, $t7, _menos4					## se j = n, pula para campo[i][j-1]
				addi $t7, $t2, -32					## $t7 tem endereco de campo[i-1][j+1]
				lw $t5, ($t7)						## $t7 = campo[i-1][j+1]
				seq $t7, $t5, 9						## $t7 = 1 se campo[i-1][j+1] = 9 senao 0
				add $t6, $t6, $t7					## $t6 += $t7

				_menos4:						## campo[i][j-1]
				beq $t4, $zero, _4					## se j = 0 pula para campo[i][j+1]
				addi $t7, $t2, -4					## $t7 tem endereco de campo[i][j-1]
				lw $t5, ($t7)						## $t7 = campo[i][j-1]
				seq $t7, $t5, 9						## $t7 = 1 se campo[i][j-1] = 9 senao 0
				add $t6, $t6, $t7					## $t6 += $t7

				_4:							## campo[i][j+1]
				beq $t4, $t1, _32					## se j = n, pula para campo[i+1][j-1]
				addi $t7, $t2, 4					## $t7 tem endereco de campo[i][j+1]
				lw $t5, ($t7)						## $t7 = campo[i][j+1]
				seq $t7, $t5, 9						## $t7 = 1 se campo[i][j+1] = 9 senao 0
				add $t6, $t6, $t7					## $t6 += $t7

				_32:							## campo[i+1][j-1]
				beq $t3, $t1, setBombs					## se i = n, pula para setBombs
				addi $t7, $t2, 32					## $t7 tem endereco de campo[i+1][j-1]
				lw $t5, ($t7)						## $t7 = campo[i+1][j-1]
				seq $t7, $t5, 9						## $t7 = 1 se campo[i+1][j-1] = 9 senao 0
				add $t6, $t6, $t7					## $t6 += $t7

											## campo[i+1][j]
				addi $t7, $t2, 36					## $t7 tem endereco de campo[i+1][j]
				lw $t5, ($t7)						## $t7 = campo[i+1][j]
				seq $t7, $t5, 9						## $t7 = 1 se campo[i+1][j] = 9 senao 0
				add $t6, $t6, $t7					## $t6 += $t7

											## campo[i+1][j+1]
				beq $t4, $t1, setBombs					## se j = n, pula para setBombs
				addi $t7, $t2, 40					## $t7 tem endereco de campo[i+1][j+1]
				lw $t5, ($t7)						## $t7 = campo[i+1][j+1]
				seq $t7, $t5, 9						## $t7 = 1 se campo[i+1][j+1] = 9 senao 0
				add $t6, $t6, $t7					## $t6 += $t7

				setBombs:						## Adiciona o valor calculado das bombas ao redor de i, j em campo[i][j]
				sw $t6, ($t2)
				isBomb:

				addi $t2, $t2, 4					## offset += 4
				addi $t4, $t4, 1					## j += 1
				j loop_j
			fimLoop_j:
			
			mul $t5, $t3, 36						## $t5 = offset em linhas
			add $t2, $t5, $t0						## $t2 += endereco campo, atualiza offset na matriz
			addi $t3, $t3, 1
			j loop_i
		fimLoop_i:	
	jr $ra
	
	mostra_campo:
		move $t0, $a0								## $t0 = endereco da matriz campo
		move $t1, $a1								## $t1 = endereÃ§o da matriz openFields
		li $t2, 0								## Offset geral setado pra 0
		li $t3, 0								## $t3 -> i = 0
		loop_i_:
			beq $a2, $t3, fimLoop_i_
			li $t4, 0							## $t4 -> j = 0
			loop_j_:
				beq $a2, $t4, fimLoop_j_
				add $t5, $t0, $t2					## Offset em campo setado em $t5
				add $t6, $t1, $t2					## Offset em openFields setado em $t6
				lw $a0, ($t6)						## Carrega openFields[i][j] em $t7
				beq $a0, $zero, print					## se openField[i][j] for 0 vai para print
				lw $a0, ($t5)						## Carrega campo[i][j] em $t7
				li $v0, 1
				syscall
				j printSpace
				print:
				li $v0 11
				li $a0 '_'
				syscall
				printSpace:
				li $v0 11
				li $a0, ' '
				syscall
				addi $t4, $t4, 1
				addi $t2, $t2, 4
				j loop_j_
			fimLoop_j_:
			li $a0, '\n'
			syscall
			addi $t3, $t3, 1
			mul $t2, $t3, 36
			j loop_i_		
		fimLoop_i_:
	jr $ra

#########################
#     Insere Bomba      #
#########################			
#
#Le Numero de bombas (x)
#Le semente (a)
#while (bombas < x) 
#   sorteia linha
#   sorteia coluna
#   le posição pos = (L X tam + C) * 4
#   if(pos != 9)
#    	grava posicao pos = 9
#   bombas++  
#	
INSERE_BOMBA:
		la	$t0, salva_S0
		sw  $s0, 0($t0)		# salva conteudo de s0 na memoria
		la	$t0, salva_ra
		sw  $ra, 0($t0)		# salva conteudo de ra na memoria
		
		add $t0, $zero, $a0	# salva a0 em t0
		add $t1, $zero, $a1	# salva a1 em t1

		li	$v0, 1
		add $a0, $zero, $a1 #
		syscall		
		
		li	$v0, 4			# 
		la	$a0, nova_linha
		syscall			

verifica_menor_que_5:
		slti $t3, $t1, 5
		beq	 $t3, $0, verifica_maior_que_9
		addi $t1, $0, 5			#se tamanho do campo menor que 5 atribui 5
		add  $a1, $0, $t1
verifica_maior_que_9:
		slti $t3, $t1, 9
		bne	 $t3, $0, testa_5
		addi $t1, $0, 9			
		add  $a1, $0, $t1
testa_5:
		addi $t3, $0, 5
		bne  $t1, $t3, testa_7
		addi $t2, $0, 10 # 10 bombas no campo 5x5
		j	 pega_semente
testa_7:
		addi $t3, $0, 7
		bne  $t1, $t3, testa_9
		addi $t2, $0, 20 # 20 bombas no campo 7x7
		j	 pega_semente
testa_9:
		addi $t3, $0, 9
		bne  $t1, $t3, else_qtd_bombas
		addi $t2, $0, 40 # 40 bombas no campo 9x9
		j	 pega_semente
else_qtd_bombas:
		addi $t2, $0, 25 # seta para 25 bomas no else		
pega_semente:
		jal SEED
		add $t3, $zero, $zero # inicia contador de bombas com 0
INICIO_LACO:
		beq $t2, $t3, FIM_LACO
		
		add $a0, $zero, $t1 # carrega limite para %
		jal PSEUDO_RAND
		add $t4, $zero, $v0	# pega linha sorteada e coloca em t4
   		jal PSEUDO_RAND
		add $t5, $zero, $v0	# pega coluna sorteada e coloca em t5

################ imprime valores na tela (para debug somente)
	
#		li	$v0, 4			# mostra linha sorteada
#		la	$a0, posicao
#		syscall
#		li	$v0, 1
#		add $a0, $zero, $t4 #linha
#		syscall
#
#		add $a0, $zero, $t5 #coluna
#		syscall
#		
#		li	$v0, 4			# mostra coluna sorteada
#		la	$a0, espaco
#		syscall
#		li	$v0, 1		
#		add $a0, $zero, $t3 #linha
#		syscall
		
#######################	
	
		mult $t4, $t1
		mflo $t4
		add  $t4, $t4, $t5  # calcula (L * tam) + C
		add  $t4, $t4, $t4  # multtiplica por 2
		add  $t4, $t4, $t4  # multtiplica por 4
		add	 $t4, $t4, $t0	# calcula Base + deslocamento
		lw	$t5, 0($t4)		# Le posicao de memoria LxC

		
		addi $t6, $zero, 9	
		beq  $t5, $t6, PULA_ATRIB
		sw   $t6, 0($t4)
		addi $t3, $t3, 1		
PULA_ATRIB:
		j	INICIO_LACO
FIM_LACO:


#		la   $a0, campo
#		addi $a1, $zero, 7
#		jal MOSTRA_CAMPO	
		
		la	$t0, salva_S0
		lw  $s0, 0($t0)		# recupera conteudo de s0 da memória
		la	$t0, salva_ra
		lw  $ra, 0($t0)		# recupera conteudo de ra da memória		
		jr $ra
		



SEED:
	li	$v0, 4			# lendo semente da funcao rand
	la	$a0, semente
	syscall
	li	$v0, 5		#
	syscall
	add	$a0, $zero, $v0	# coloca semente de bombas em a0
	bne  $a0, $zero, DESVIA
	lui  $s0,  1		# carrega semente 100001
 	ori $s0, $s0, 34465	# 
	jr $ra	
DESVIA:
	add	$s0, $zero, $a0		# carrega semente passada em a0
	jr $ra
	


#
#função que gera um número randomico
#
 #int rand1(int lim) {
 # static long a = 100001; 
 #a = (a * 125) % 2796203; 
 #return ((a % lim) + 1); 
 #} // 
  
PSEUDO_RAND:
	addi $t6, $zero, 125  	# carrega 125
	lui  $t5,  42			# carrega fator: 2796203
	ori $t5, $t5, 43691 	#-
	
	mult  $s0, $t6			# a * 125
	mflo $s0				# a = (a * 125)
	div  $s0, $t5			# a % 2796203
	mfhi $s0				# a = (a % 2796203)
	div  $s0, $a0			# a % lim
	mfhi $v0                # v0 = a % lim
	jr $ra
	
	