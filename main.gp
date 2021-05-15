encodegln(s,n)={
  my(v);
  v=[if(x==32,0,x-96)|x<-Vec(Vecsmall(s))];
  if(#v>n^2,warning("string truncated to length ",n^2));
  v = Vec(v,n^2);
  matrix(n,n,i,j,v[(i-1)*n+j]);
}

\\ Fonction de décodage 
\\ M - matrice

decodegln(M,n)={
	my(v);
	v=vector(n^2);
	k=1;
	\\ ASCII
	for(i=1,n,
	for(j=1,n,
		l=lift(M[i,j]);
		v[k]=if(l==0,32,l+96);
		k=k+1)
		);		
	v=Vec(v,143); 
  	return(Strchr(v));
}

ExpoMat(M,n) = {
	if(n==0,return( mathid(matsize(M)[1])));
	if(n== 1,return (M));
	if(n%2==0,return (ExpoMat(M^2,n/2)), return (M*ExpoMat(M^2,(n-1)/2)));
}

indiceId(M)={
	idMod=Mod(matid(12),27);
	k=1;
	P=M;
	while(P!=idMod,P=P*M;k++);
	return(k);
}

\\ On récupère le texte du fichier

text=readstr("input.txt")[1];

\\ On encode, mtext est une matrice contenant les lettres chiffrées

mtext=encodegln(text,12);

mtextmod=Mod(mtext,27);

\\ On récupère l'exposant minimal de la matrice

d=indiceId(mtext);

inv=gcdext(65537,d)[1];
mtext=ExpoMat(mtextmod,inv);

\\ il reste à déchiffrer 

m=decodegln(mtext,12);
print(m);
