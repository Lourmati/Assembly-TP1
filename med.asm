;;; Programme Assembleur TP1
;;; Auteur: Oussama Lourhmati


segment	.data	
msg1:	db "Entrez le nom du fichier(txt) a editer: "
len_msg1: equ $-msg1

erreur:	db "La taille maximale pour le nom de fichier est de 16 caracreteres "
len_erreur: equ $-msg_erreur
	

segment	.bss

descripteur:	resd 1
lentexte:	resb 4
compteur:	resb 1	
nomfichier:	resb 17
tampon:		resb 1
texte:		resb 81

	
segment .text
	global _start	
_start:
	
;; Affichage message d'invite 1
	 mov eax, 4
	 mov ebx, 1
	 mov ecx, msg1
	 mov edx, len_msg1
	 int 0x80

;;; Saisie du nom de fichier
saisie:	 mov eax, 3
	 mov ebx, 0
	 mov ecx, nomfichier
	 mov edx, 17
	 int 0x80

;;; Si l'utilisateur entre chaine vide, on sort
	 cmp eax,1
	 je quitter

;;; Verifier si il rentre plus de caractere que requis
	 add ecx,eax
	 dec ecx
	 cmp byte [ecx], 0x0A
	 jne vider

	 mov byte [ecx],0
	 jmp creer

;;; Vider tampon
vider:	 mov eax,3
	 mov ebx,0
	 mov ecx,tampon
	 mov edx,1
	 int 0x80

	 cmp byte [tampon],0x0A
	 jne vider
	 jmp msg_erreur

;;; Affichage du message d'erreur
msg_erreur:
	 mov eax,4
	 mov ebx,2
	 mov ecx, erreur
	 mov ecx, len_erreur
	 int 0x80
	 jmp saisie


;;; Ouverture du fichier	
creer:	 mov eax,5
	 mov ebx,nomfichier
	 mov ecx,101o
	 mov edx,644o
	 int 0x80
	
	 mov [descripteur], eax

	 ;; Mettre compteur a 0
	 mov byte [compteur],0
	
;;; Saisir le texte a mettre dans le fichier
saisie_texte:	
	 mov eax,3
	 mov ebx,0
	 mov ecx,texte
	 mov edx,81
	 int 0x80
	
	 cmp byte [ecx],1
	 je incrementer
	
incrementer:
	 cmp byte [compteur],2
	 je quitter
	 inc byte[compteur] 
	 jmp saisie_texte


;;; On fait le stockage dans la longueur reelle
	 mov dword[lentexte],eax

;;; On verifie si il y a debordement de 80 caractere
	 add ecx,eax
	 dec ecx
         cmp byte [ecx],0x0A
	 jne vider2

;;; Vider tampon (deuxieme fois)
vider2:	 mov eax,3
	 mov ebx,0
	 mov ecx,tampon
	 mov edx,1
	 int 0x80

	 cmp byte [tampon],10
	 jne vider2
	 jmp saisie_texte


;;; Ecriture dans le fichier
	 mov eax,4
	 mov ebx, [descripteur]
	 mov ecx,texte
	 mov edx, [lentexte]
	 int 0x80

	 jmp saisie_texte

;;; Fermeture de fichier
	 mov eax,6
	 int 0x80
	
;;; Sort du programme	
quitter: mov ebx, 0
	 mov eax, 1
	 int 0x80
