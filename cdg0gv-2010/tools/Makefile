#PC=	ppc386
PC=	ppcx64

CDGDIR=        ..
INCLDIR=        $(CDGDIR)/include
UNITDIR=        $(CDGDIR)/units
TOOLDIR=        $(CDGDIR)/tools

PFLAGS=		-So -Fu../units -I../include

%:		%.p 
		$(PC) $(PFLAGS)  $<

tools:		
		$(PC) $(PFLAGS) pldv.p
		rm -f *~ *.o 

clean:
		rm -f *~ *.o pldv



